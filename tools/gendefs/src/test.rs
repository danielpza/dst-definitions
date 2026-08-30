#[cfg(test)]
mod tests {
    use crate::config::Config;
    use crate::emit::emit_unit;
    use crate::infer::InferenceEngine;
    use crate::plugins::{ExtractContext, PluginRegistry};
    use crate::resolver::NamingResolver;

    fn parse_and_extract(code: &str, rel_path: &str) -> Option<crate::model::Unit> {
        let config = Config::default_embedded();
        let resolver = NamingResolver::new(config.plugins.naming.clone());
        let infer = InferenceEngine::new(&config, &resolver);
        let plugins = PluginRegistry::default_plugins();
        let ast = full_moon::parse(code).unwrap();
        let ctx = ExtractContext {
            ast: &ast,
            rel_path,
            resolver: &resolver,
            infer: &infer,
            config: &config,
        };
        plugins.extract(&ctx)
    }

    #[test]
    fn test_extract_widget() {
        let code = r#"
local Widget = Class(function(self, name)
    name = name or "widget"
    self.name = name
    self.enabled = true
    self.shown = true
    self.focus = false
end)

function Widget:SetVAnchor(anchor)
end

function Widget:SetPosition(pos, y, z)
end

function Widget:AddChild(child)
    return child
end

return Widget
"#;
        let unit = parse_and_extract(code, "widgets/widget.lua").expect("Should extract widget");
        let emitted = emit_unit(&unit);
        println!("EMITTED:\n{}", emitted);
        assert_eq!(unit.classes.len(), 1);
        let cls = &unit.classes[0];
        assert_eq!(cls.lua_name, "Widget");
        assert_eq!(cls.class_name, "ds.widgets.widget");
        assert!(cls.fields.contains_key("name"));
        assert!(cls.fields.contains_key("enabled"));
        assert_eq!(cls.methods.len(), 3);
    }

    #[test]
    fn test_extract_subclass_and_child() {
        let code = r#"
local Widget = require "widgets/widget"
local Text = require "widgets/text"

local Button = Class(Widget, function(self)
    Widget._ctor(self, "BUTTON")
    self.text = self:AddChild(Text(self.font, 40))
    self.selected = false
    self.clickoffset = Vector3(0,-3,0)
end)

function Button:SetControl(ctrl)
end

return Button
"#;
        let unit = parse_and_extract(code, "widgets/button.lua").expect("Should extract button");
        let emitted = emit_unit(&unit);
        println!("EMITTED BUTTON:\n{}", emitted);
        assert_eq!(unit.classes.len(), 1);
        let cls = &unit.classes[0];
        assert_eq!(cls.lua_name, "Button");
        assert_eq!(cls.class_name, "ds.widgets.button");
        assert_eq!(cls.parent_class_name.as_deref(), Some("ds.widgets.widget"));
        assert_eq!(cls.fields.get("text").unwrap().ty, "ds.widgets.text");
        assert_eq!(cls.fields.get("selected").unwrap().ty, "boolean");
        assert_eq!(cls.fields.get("clickoffset").unwrap().ty, "ds.vector3");
    }

    #[test]
    fn test_nested_path_class_name() {
        let code = r#"
local Widget = require "widgets/widget"
local Chat = Class(Widget, function(self) end)
return Chat
"#;
        let unit = parse_and_extract(code, "widgets/redux/chat.lua").expect("Should extract chat");
        let cls = &unit.classes[0];
        assert_eq!(cls.class_name, "ds.widgets.redux.chat");
    }

    #[test]
    fn test_actions_plugin() {
        let code = r#"
local Action = Class(function(self) end)

ACTIONS = {
    REPAIR = Action(),
    READ = Action(),
}

return Action
"#;
        let unit = parse_and_extract(code, "actions.lua").expect("Should extract actions");
        assert_eq!(unit.globals.len(), 1);
        let global = &unit.globals[0];
        assert_eq!(global.name, "ACTIONS");
        assert_eq!(global.ty, "table<string, ds.actions.action>");
        assert_eq!(
            global.entries.as_ref().unwrap(),
            &vec!["REPAIR".to_string(), "READ".to_string()]
        );
    }

    #[test]
    fn test_file_filter() {
        use crate::filter::FileFilter;

        // Exact files, directories, globs, and negation
        let mut filter = FileFilter::new();
        filter.add_pattern("actions.lua");
        filter.add_pattern("widgets/");
        filter.add_pattern("components/*.lua");
        filter.add_pattern("!widgets/ignored.lua");

        assert!(filter.should_process("actions.lua"));
        assert!(filter.should_process("widgets/button.lua"));
        assert!(filter.should_process("widgets/image.lua"));
        assert!(!filter.should_process("widgets/ignored.lua")); // Excluded
        assert!(filter.should_process("components/container.lua"));
        assert!(!filter.should_process("screens/mainscreen.lua")); // Not in list

        // Match all "."
        let mut all_filter = FileFilter::new();
        all_filter.add_pattern(".");
        assert!(all_filter.should_process("any/arbitrary/file.lua"));
    }

    #[test]
    fn test_class_and_method_overrides() {
        let toml_cfg = r#"
[overrides.classes."ds.components.container"]
super = "ds.entityscript"
fields = { "slots" = "table<integer, ds.entityscript>", "numslots" = "integer" }

[overrides.classes."ds.components.container".methods."GiveItem"]
params = { item = "ds.entityscript", slot = "integer?", drop_on_fail = "boolean?" }
return = "boolean"

[overrides.classes."ds.components.container".methods."SetPosition"]
overloads = [
    "fun(pos: ds.vector3)",
    "fun(x: number, y: number, z?: number)"
]

[plugins.inference.patterns]
"ds.components.*.target" = "ds.entityscript"
"#;
        let mut config = Config::default_embedded();
        let custom_config: Config = toml::from_str(toml_cfg).unwrap();
        config.merge(custom_config);

        let code = r#"
local Container = Class(function(self)
    self.numslots = 0
end)

function Container:GiveItem(item, slot, drop_on_fail)
end

function Container:SetPosition(pos, y, z)
end

function Container:InteractWith(target)
end

return Container
"#;
        let resolver = NamingResolver::new(config.plugins.naming.clone());
        let infer = InferenceEngine::new(&config, &resolver);
        let plugins = PluginRegistry::default_plugins();
        let ast = full_moon::parse(code).unwrap();
        let ctx = ExtractContext {
            ast: &ast,
            rel_path: "components/container.lua",
            resolver: &resolver,
            infer: &infer,
            config: &config,
        };
        let unit = plugins.extract(&ctx).expect("Should extract container");
        let emitted = emit_unit(&unit);
        println!("EMITTED CONTAINER:\n{}", emitted);

        assert_eq!(unit.classes.len(), 1);
        let cls = &unit.classes[0];
        assert_eq!(cls.parent_class_name.as_deref(), Some("ds.entityscript"));
        assert_eq!(cls.fields.get("slots").unwrap().ty, "table<integer, ds.entityscript>");
        assert_eq!(cls.fields.get("numslots").unwrap().ty, "integer");

        // GiveItem
        let give_item = cls.methods.iter().find(|m| m.name == "GiveItem").unwrap();
        assert_eq!(give_item.returns, vec!["boolean".to_string()]);
        let item_p = give_item.params.iter().find(|p| p.name == "item").unwrap();
        assert_eq!(item_p.ty, "ds.entityscript");
        let slot_p = give_item.params.iter().find(|p| p.name == "slot").unwrap();
        assert_eq!(slot_p.ty, "integer");
        assert!(slot_p.optional);

        // SetPosition overloads
        let set_pos = cls.methods.iter().find(|m| m.name == "SetPosition").unwrap();
        assert_eq!(set_pos.overloads.len(), 2);

        // Pattern match: target -> ds.entityscript
        let interact = cls.methods.iter().find(|m| m.name == "InteractWith").unwrap();
        let target_p = interact.params.iter().find(|p| p.name == "target").unwrap();
        assert_eq!(target_p.ty, "ds.entityscript");

        assert!(emitted.contains("---@class ds.components.container: ds.entityscript"));
        assert!(emitted.contains("---@field slots table<integer, ds.entityscript>"));
        assert!(emitted.contains("---@overload fun(pos: ds.vector3)"));
        assert!(emitted.contains("---@param slot? integer"));
    }

    #[test]
    fn test_generate_config_paths() {
        use std::path::PathBuf;

        // Defaults
        let default_cfg = Config::default_embedded();
        assert_eq!(
            default_cfg.generate.src(),
            PathBuf::from("dst-scripts-original/scripts")
        );
        assert_eq!(default_cfg.generate.out(), PathBuf::from("definitions/scripts"));

        // Custom config using src and out
        let toml_src_out = r#"
[generate]
src = "custom/source"
out = "custom/dest"
files = ["a.lua"]
"#;
        let mut cfg: Config = toml::from_str(toml_src_out).unwrap();
        assert_eq!(cfg.generate.src(), PathBuf::from("custom/source"));
        assert_eq!(cfg.generate.out(), PathBuf::from("custom/dest"));

        // Custom config using input and output aliases
        let toml_aliases = r#"
[generate]
input = "alt/input"
output = "alt/output"
"#;
        let alt_cfg: Config = toml::from_str(toml_aliases).unwrap();
        assert_eq!(alt_cfg.generate.src(), PathBuf::from("alt/input"));
        assert_eq!(alt_cfg.generate.out(), PathBuf::from("alt/output"));

        // Merge overrides
        cfg.merge(alt_cfg);
        assert_eq!(cfg.generate.src(), PathBuf::from("alt/input"));
        assert_eq!(cfg.generate.out(), PathBuf::from("alt/output"));
        assert_eq!(cfg.generate.files, vec!["a.lua".to_string()]);
    }

    #[test]
    fn test_param_inference_not_shadowed_by_reassignment() {
        let code = r#"
local Container = Class(function(self) end)

function Container:GiveItem(item, slot, src_pos, drop_on_fail)
    slot = slot or self:GetSpecificSlotForItem(item)
end

return Container
"#;
        let unit = parse_and_extract(code, "components/container.lua").expect("Should extract container");
        let cls = &unit.classes[0];
        let give_item = cls.methods.iter().find(|m| m.name == "GiveItem").unwrap();
        let slot_p = give_item.params.iter().find(|p| p.name == "slot").unwrap();
        assert_eq!(slot_p.ty, "ds.equipslot");
    }

    #[test]
    fn test_entity_replica_extraction() {
        let code = r#"
local REPLICATABLE_COMPONENTS =
{
    builder = true,
    container = true,
    inventory = true,
}

function EntityScript:ValidateReplicaComponent(name, cmp)
    return self:HasTag("_"..name) and cmp or nil
end

function EntityScript:ReplicateComponent(name)
end
"#;
        let unit = parse_and_extract(code, "entityreplica.lua").expect("Should extract entityreplica");
        assert_eq!(unit.classes.len(), 2);

        let replica_cls = unit
            .classes
            .iter()
            .find(|c| c.class_name == "ds.entityreplica")
            .unwrap();
        assert_eq!(
            replica_cls.fields.get("container").unwrap().ty,
            "ds.replicas.container"
        );
        assert!(replica_cls.fields.get("container").unwrap().optional);

        let entityscript_cls = unit
            .classes
            .iter()
            .find(|c| c.class_name == "ds.entityscript")
            .unwrap();
        assert!(entityscript_cls.is_extension);
        assert!(entityscript_cls
            .methods
            .iter()
            .any(|m| m.name == "ValidateReplicaComponent"));
    }

    #[test]
    fn test_the_world_extraction() {
        let code = r#"
local function PostInit(inst)
end

local function OnRemoveEntity(inst)
end

local function CreateTilePhysics(inst)
end

local function SetPocketDimensionContainer(world, name, containerinst)
    world.PocketDimensionContainers[name] = containerinst
end

local function GetPocketDimensionContainer(world, name)
    return world.PocketDimensionContainers[name]
end

local function CanFlyingCrossBarriers(world)
    return world.has_ocean or world.cancrossbarriers_flying
end

function MakeWorld(name, customprefabs, customassets, common_postinit, master_postinit, tags, custom_data)
    local function fn()
        local inst = CreateEntity()
        TheWorld = inst

        inst.ismastersim = TheNet:GetIsMasterSimulation()
        inst.ismastershard = inst.ismastersim and not TheShard:IsSecondary()

        inst.entity:AddTransform()
        inst.entity:AddMap()
        inst.entity:AddPathfinder()
        inst.entity:AddGroundCreep()
        inst.entity:AddSoundEmitter()

        inst:AddComponent("worldsettings")
        inst:AddComponent("worldstate")
        inst.state = inst.components.worldstate.data

        inst.PostInit = PostInit
        inst.OnRemoveEntity = OnRemoveEntity
        inst.CreateTilePhysics = CreateTilePhysics
        inst.CanFlyingCrossBarriers = CanFlyingCrossBarriers

        inst.minimap = SpawnPrefab("minimap")

        inst.PocketDimensionContainers = {}
        inst.SetPocketDimensionContainer = SetPocketDimensionContainer
        inst.GetPocketDimensionContainer = GetPocketDimensionContainer

        return inst
    end

    return Prefab(name, fn, customassets, worldprefabs)
end

return MakeWorld("world", prefabs, assets)
"#;
        let unit = parse_and_extract(code, "prefabs/world.lua").expect("Should extract world");
        let emitted = emit_unit(&unit);
        println!("EMITTED WORLD:\n{}", emitted);
        assert_eq!(unit.classes.len(), 1);
        let world_cls = &unit.classes[0];
        assert_eq!(world_cls.lua_name, "TheWorld");
        assert_eq!(world_cls.class_name, "ds.prefabs.world");
        assert_eq!(world_cls.parent_class_name.as_deref(), Some("ds.entityscript"));
        assert!(world_cls.fields.contains_key("ismastersim"));
        assert!(world_cls.fields.contains_key("ismastershard"));
        assert!(world_cls.fields.contains_key("state"));
        assert!(world_cls.fields.contains_key("Map"));
        assert!(world_cls.fields.contains_key("Transform"));
        assert!(world_cls.fields.contains_key("PocketDimensionContainers"));
        assert!(world_cls.methods.iter().any(|m| m.name == "PostInit"));
        assert!(world_cls.methods.iter().any(|m| m.name == "CanFlyingCrossBarriers"));
        assert!(world_cls.methods.iter().any(|m| m.name == "SetPocketDimensionContainer"));
        assert!(world_cls.methods.iter().any(|m| m.name == "GetPocketDimensionContainer"));
    }

    #[test]
    fn test_anonymous_class_return() {
        let code = r#"
return Class(function(self, inst)
    self.inst = inst
    self.data = {}
end)
"#;
        let unit = parse_and_extract(code, "components/worldstate.lua").expect("Should extract worldstate");
        let emitted = emit_unit(&unit);
        println!("EMITTED WORLDSTATE:\n{}", emitted);
        assert_eq!(unit.classes.len(), 1);
        let cls = &unit.classes[0];
        assert_eq!(cls.class_name, "ds.components.worldstate");
        assert!(cls.fields.contains_key("inst"));
        assert!(cls.fields.contains_key("data"));
    }

    #[test]
    fn test_the_player_extraction() {
        let code = r#"
local function GetTemperature(inst)
    return 30
end

local function IsFreezing(inst)
    return false
end

local fns = {}
fns.IsInMiasma = function(inst)
    return false
end

local function SetInstanceFunctions(inst)
    inst.GetTemperature = GetTemperature
    inst.IsFreezing = IsFreezing
    inst.IsInMiasma = fns.IsInMiasma
end

local function MakePlayerCharacter(name, customprefabs, customassets, common_postinit, master_postinit, starting_inventory)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddDynamicShadow()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()

        inst.userid = "OU_12345"
        inst.prefab = "wilson"

        SetInstanceFunctions(inst)

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

return MakePlayerCharacter("wilson", prefabs, assets)
"#;
        let unit = parse_and_extract(code, "prefabs/player_common.lua").expect("Should extract player");
        let emitted = emit_unit(&unit);
        println!("EMITTED PLAYER:\n{}", emitted);
        assert_eq!(unit.classes.len(), 1);
        let player_cls = &unit.classes[0];
        assert_eq!(player_cls.lua_name, "ThePlayer");
        assert_eq!(player_cls.class_name, "ds.prefabs.player_common");
        assert_eq!(player_cls.parent_class_name.as_deref(), Some("ds.entityscript"));
        assert!(player_cls.fields.contains_key("HUD"));
        assert!(player_cls.fields.contains_key("player_classified"));
        assert!(player_cls.fields.contains_key("userid"));
        assert!(player_cls.fields.contains_key("prefab"));
        assert!(player_cls.fields.contains_key("Transform"));
        assert!(player_cls.fields.contains_key("AnimState"));
        assert!(player_cls.methods.iter().any(|m| m.name == "GetTemperature"));
        assert!(player_cls.methods.iter().any(|m| m.name == "IsFreezing"));
        assert!(player_cls.methods.iter().any(|m| m.name == "IsInMiasma"));
    }

    #[test]
    fn test_extract_modutil_functions_and_env() {
        let code = r#"
function ModInfoname(name)
    return name
end

ReleaseID = {
    IDs = {},
    Current = nil,
}

CurrentRelease = {}
CurrentRelease.GreaterOrEqualTo = function(rhs)
    return true
end

local function AddModCharacter(name, gender, modes)
end

local function InsertPostInitFunctions(env, isworldgen, isfrontend)
    env.AddComponentPostInit = function(component, fn)
    end

    env.AddModCharacter = AddModCharacter
end

return {
    InsertPostInitFunctions = InsertPostInitFunctions,
}
"#;
        let unit = parse_and_extract(code, "modutil.lua").expect("Should extract modutil");
        let emitted = emit_unit(&unit);
        println!("EMITTED MODUTIL:\n{}", emitted);
        assert!(unit.functions.iter().any(|f| f.name == "ModInfoname"));
        assert!(unit.functions.iter().any(|f| f.name == "CurrentRelease.GreaterOrEqualTo"));
        assert!(unit.functions.iter().any(|f| f.name == "AddComponentPostInit"));
        assert!(unit.functions.iter().any(|f| f.name == "AddModCharacter"));
        assert!(unit.globals.iter().any(|g| g.name == "ReleaseID"));
        assert!(unit.globals.iter().any(|g| g.name == "CurrentRelease"));
    }

    #[test]
    fn test_extract_mainfunctions_functions() {
        let code = r#"
function SavePersistentString(name, data, encode, callback)
end

function ErasePersistentString(name, callback)
end

function Print(msg_verbosity, ...)
end

PREFABDEFINITIONS = {}
"#;
        let unit = parse_and_extract(code, "mainfunctions.lua").expect("Should extract mainfunctions");
        let emitted = emit_unit(&unit);
        println!("EMITTED MAINFUNCTIONS:\n{}", emitted);
        assert!(unit.functions.iter().any(|f| f.name == "SavePersistentString"));
        assert!(unit.functions.iter().any(|f| f.name == "ErasePersistentString"));
        assert!(unit.functions.iter().any(|f| f.name == "Print"));
        assert!(unit.globals.iter().any(|g| g.name == "PREFABDEFINITIONS"));
    }

    #[test]
    fn test_module_table_plugin() {
        let code = r#"
local Widget = require "widgets/widget"
local Button = require "widgets/button"

local TEMPLATES = nil
TEMPLATES = {
    Button = function(text, cb)
        local b = Button()
        return b
    end,
    version = "1.0",
}

function TEMPLATES.NavBarButton(yPos, buttonText, onclick)
    return Button()
end

function TEMPLATES:SpecialMethod(arg1)
end

TEMPLATES.ExtraFn = function(opt)
end

return TEMPLATES
"#;
        let unit = parse_and_extract(code, "widgets/templates.lua").expect("Should extract module table");
        let emitted = emit_unit(&unit);
        println!("EMITTED MODULE TABLE:\n{}", emitted);
        assert_eq!(unit.classes.len(), 1);
        let cls = &unit.classes[0];
        assert_eq!(cls.lua_name, "TEMPLATES");
        assert_eq!(cls.class_name, "ds.widgets.templates");
        assert!(cls.ctor_params.is_empty());
        assert!(cls.ctor_overloads.is_empty());
        assert!(cls.fields.contains_key("version"));
        assert_eq!(cls.fields.get("version").unwrap().ty, "string");

        let method_names: Vec<_> = cls.methods.iter().map(|m| m.name.as_str()).collect();
        assert!(method_names.contains(&"Button"));
        assert!(method_names.contains(&"NavBarButton"));
        assert!(method_names.contains(&"SpecialMethod"));
        assert!(method_names.contains(&"ExtraFn"));

        let special = cls.methods.iter().find(|m| m.name == "SpecialMethod").unwrap();
        assert!(special.is_colon);
        assert_eq!(special.params.len(), 1);
        assert_eq!(special.params[0].name, "arg1");

        assert!(emitted.contains("---@class ds.widgets.templates"));
        assert!(emitted.contains("local TEMPLATES = {}"));
        assert!(emitted.contains("---@return ds.widgets.button\nfunction TEMPLATES.Button(text, cb) end"));
        assert!(emitted.contains("---@return ds.widgets.button\nfunction TEMPLATES.NavBarButton(yPos, buttonText, onclick) end"));
        assert!(emitted.contains("function TEMPLATES:SpecialMethod(arg1) end"));
        assert!(emitted.contains("function TEMPLATES.ExtraFn(opt) end"));
        assert!(emitted.contains("return TEMPLATES"));
    }

    #[test]
    fn test_constants_plugin() {
        let code = r#"
PI = math.pi
PI2 = PI*2
IGNORED_CONST = 999
ANCHOR_MIDDLE = 0
ANCHOR_LEFT = 1
ANCHOR_RIGHT = 2
ANCHOR_TOP = 1
ANCHOR_BOTTOM = 2

EQUIPSLOTS = {
    HANDS = "hands",
    HEAD = "head",
    BODY = "body",
    BEARD = "beard",
}

IGNORED_TABLE = {
    FOO = "bar",
}

function RGB(r, g, b)
    return { r / 255, g / 255, b / 255, 1 }
end

function IsSpecialEventActive(event)
    return true
end
"#;
        let unit = parse_and_extract(code, "constants.lua").expect("Should extract constants");
        let emitted = emit_unit(&unit);
        println!("EMITTED CONSTANTS:\n{}", emitted);

        // Check aliases
        assert!(unit.aliases.iter().any(|a| a.name == "ds.hanchor"));
        assert!(unit.aliases.iter().any(|a| a.name == "ds.vanchor"));

        // Check allowed constants
        assert!(unit.constants.iter().any(|c| c.name == "PI"));
        assert!(unit.constants.iter().any(|c| c.name == "ANCHOR_MIDDLE" && c.value == "0"));
        // Check filtered-out constants
        assert!(!unit.constants.iter().any(|c| c.name == "IGNORED_CONST"));

        // Check enum
        let equipslots = unit.enums.iter().find(|e| e.name == "EQUIPSLOTS").unwrap();
        assert_eq!(equipslots.enum_type.as_deref(), Some("ds.equipslot"));
        assert_eq!(equipslots.fields.len(), 4);
        assert_eq!(equipslots.fields[0].key, "HANDS");
        assert_eq!(equipslots.fields[0].value, "\"hands\"");
        assert!(!unit.enums.iter().any(|e| e.name == "IGNORED_TABLE"));

        // Functions are not in default allowlist, so filtered out
        assert!(!unit.functions.iter().any(|f| f.name == "RGB"));

        // Check emitted output
        assert!(emitted.contains("---@alias ds.hanchor `ANCHOR_MIDDLE` | `ANCHOR_LEFT` | `ANCHOR_RIGHT`"));
        assert!(emitted.contains("---@alias ds.vanchor `ANCHOR_MIDDLE` | `ANCHOR_TOP` | `ANCHOR_BOTTOM`"));
        assert!(emitted.contains("PI = math.pi"));
        assert!(emitted.contains("ANCHOR_MIDDLE = 0"));
        assert!(!emitted.contains("IGNORED_CONST"));
        assert!(emitted.contains("---@enum ds.equipslot\nEQUIPSLOTS = {"));
        assert!(emitted.contains("HANDS = \"hands\","));
        assert!(!emitted.contains("IGNORED_TABLE"));
    }

    #[test]
    fn test_constants_patterns() {
        let code = r#"
CONTROL_PRIMARY = 0
CONTROL_SECONDARY = 1
CONTROL_INV_1 = 15
KEY_A = 97
KEY_B = 98
IGNORED_CONST = 999
"#;
        let mut config = Config::default_embedded();
        config.plugins.constants.patterns = vec!["CONTROL_*".to_string(), "KEY_*".to_string()];
        let resolver = NamingResolver::new(config.plugins.naming.clone());
        let infer = InferenceEngine::new(&config, &resolver);
        let plugins = PluginRegistry::default_plugins();
        let ast = full_moon::parse(code).unwrap();
        let ctx = ExtractContext {
            ast: &ast,
            rel_path: "constants.lua",
            resolver: &resolver,
            infer: &infer,
            config: &config,
        };
        let unit = plugins.extract(&ctx).expect("Should extract unit");

        assert!(unit.constants.iter().any(|c| c.name == "CONTROL_PRIMARY" && c.value == "0"));
        assert!(unit.constants.iter().any(|c| c.name == "CONTROL_SECONDARY" && c.value == "1"));
        assert!(unit.constants.iter().any(|c| c.name == "CONTROL_INV_1" && c.value == "15"));
        assert!(unit.constants.iter().any(|c| c.name == "KEY_A" && c.value == "97"));
        assert!(unit.constants.iter().any(|c| c.name == "KEY_B" && c.value == "98"));
        assert!(!unit.constants.iter().any(|c| c.name == "IGNORED_CONST"));
    }

    #[test]
    fn test_clean_output_dir() {
        let temp_dir = std::env::temp_dir().join("gendefs_test_clean_output");
        let _ = std::fs::remove_dir_all(&temp_dir);
        std::fs::create_dir_all(temp_dir.join("subdir")).unwrap();

        let generated_file = temp_dir.join("subdir/generated.lua");
        let manual_file = temp_dir.join("subdir/manual.lua");
        let other_file = temp_dir.join("other.txt");

        std::fs::write(&generated_file, "---@meta\nlocal G = {}").unwrap();
        std::fs::write(&manual_file, "---@meta\n-- @manual\nlocal M = {}").unwrap();
        std::fs::write(&other_file, "some notes").unwrap();

        let (removed, preserved) = crate::clean_output_dir(&temp_dir, false).unwrap();
        assert_eq!(removed, 2);
        assert_eq!(preserved, 1);
        assert!(!generated_file.exists());
        assert!(!other_file.exists());
        assert!(manual_file.exists());

        let _ = std::fs::remove_dir_all(&temp_dir);
    }

    #[test]
    fn test_config_new_plugins_and_merge() {
        let toml_str = r#"
[plugins.inference.identifiers]
CustomType = "ds.custom_type"

[plugins.inference.passthrough_calls]
WrapWidget = 1

[plugins.constants]
files = ["custom_constants.lua"]

[plugins.functions]
files = ["custom_functions.lua"]

[plugins.functions.env_exporters."custom_functions.lua"]
env_var = "custom_env"
functions = ["ExportCustom"]

[plugins.entity_replica."custom_replica.lua"]
table = "MY_COMPONENTS"
class_name = "ds.my_replica"
field_namespace = "ds.my_replicas"
extend_class = "ds.my_entity"

[plugins.actions."custom_actions.lua"]
global_name = "CUSTOM_ACTIONS"
value_type = "ds.actions.custom_action"

[plugins.prefabs."prefabs/custom.lua"]
lua_name = "TheCustom"
class_name = "ds.prefabs.custom"
parent_class = "ds.custom_parent"
component_namespace = "ds.custom_components"
target_names = ["inst"]
receiver_names = ["self"]
default_fields = {}
"#;
        let mut base_cfg = Config::default_embedded();
        let custom_cfg: Config = toml::from_str(toml_str).unwrap();
        base_cfg.merge(custom_cfg);

        assert_eq!(
            base_cfg.plugins.inference.identifiers.get("Vector3").unwrap(),
            "ds.vector3"
        );
        assert_eq!(
            base_cfg.plugins.inference.identifiers.get("CustomType").unwrap(),
            "ds.custom_type"
        );
        assert_eq!(
            *base_cfg.plugins.inference.passthrough_calls.get("AddChild").unwrap(),
            0
        );
        assert_eq!(
            *base_cfg.plugins.inference.passthrough_calls.get("WrapWidget").unwrap(),
            1
        );
        assert_eq!(base_cfg.plugins.constants.files, vec!["custom_constants.lua"]);
        assert_eq!(base_cfg.plugins.functions.files, vec!["custom_functions.lua"]);
        let exporter = base_cfg
            .plugins
            .functions
            .env_exporters
            .get("custom_functions.lua")
            .unwrap();
        assert_eq!(exporter.env_var, "custom_env");
        assert_eq!(exporter.functions, vec!["ExportCustom"]);

        let replica_cfg = base_cfg
            .plugins
            .entity_replica
            .get("custom_replica.lua")
            .unwrap();
        assert_eq!(replica_cfg.table, "MY_COMPONENTS");
        assert_eq!(replica_cfg.class_name, "ds.my_replica");
        assert_eq!(replica_cfg.field_namespace, "ds.my_replicas");
        assert_eq!(replica_cfg.extend_class.as_deref(), Some("ds.my_entity"));

        let action_cfg = base_cfg
            .plugins
            .actions
            .get("custom_actions.lua")
            .unwrap();
        assert_eq!(action_cfg.global_name, "CUSTOM_ACTIONS");
        assert_eq!(
            action_cfg.value_type.as_deref(),
            Some("ds.actions.custom_action")
        );

        let prefab_cfg = base_cfg
            .plugins
            .prefabs
            .get("prefabs/custom.lua")
            .unwrap();
        assert_eq!(prefab_cfg.parent_class.as_deref(), Some("ds.custom_parent"));
        assert_eq!(
            prefab_cfg.component_namespace.as_deref(),
            Some("ds.custom_components")
        );
    }

    #[test]
    fn test_custom_identifier_and_passthrough_inference() {
        let toml_str = r#"
[plugins.inference.identifiers]
Matrix = "ds.matrix"

[plugins.inference.passthrough_calls]
WrapFirst = 0
WrapSecond = 1
"#;
        let mut config = Config::default_embedded();
        let custom_cfg: Config = toml::from_str(toml_str).unwrap();
        config.merge(custom_cfg);

        let code = r#"
local Text = require "widgets/text"

local CustomWidget = Class(function(self)
    self.transform_mat = Matrix()
    self.wrapped = self:WrapSecond(123, Text("test", 20))
end)

return CustomWidget
"#;
        let resolver = NamingResolver::new(config.plugins.naming.clone());
        let infer = InferenceEngine::new(&config, &resolver);
        let plugins = PluginRegistry::default_plugins();
        let ast = full_moon::parse(code).unwrap();
        let ctx = ExtractContext {
            ast: &ast,
            rel_path: "widgets/custom_widget.lua",
            resolver: &resolver,
            infer: &infer,
            config: &config,
        };
        let unit = plugins.extract(&ctx).expect("Should extract custom widget");
        let cls = &unit.classes[0];
        assert_eq!(cls.fields.get("transform_mat").unwrap().ty, "ds.matrix");
        assert_eq!(cls.fields.get("wrapped").unwrap().ty, "ds.widgets.text");
    }

    #[test]
    fn test_custom_plugin_configs_generic_extraction() {
        let toml_str = r#"
[plugins.constants]
files = ["custom_constants.lua"]
allowlist = ["MAGIC_NUMBER"]

[plugins.functions]
files = ["custom_mod.lua"]

[plugins.functions.env_exporters."custom_mod.lua"]
env_var = "custom_env"
functions = ["InitCustomEnv"]

[plugins.entity_replica."custom_replica.lua"]
table = "MY_REPLICAS"
class_name = "ds.customreplica"
field_namespace = "ds.replicas.custom"
extend_class = "ds.customentity"

[plugins.actions."custom_actions.lua"]
global_name = "MY_ACTIONS"
value_type = "ds.my_actions.action"

[plugins.prefabs."prefabs/custom_entity.lua"]
lua_name = "TheCustomEntity"
class_name = "ds.prefabs.custom_entity"
parent_class = "ds.custom_base"
component_namespace = "ds.components"
target_names = ["inst"]
receiver_names = ["inst"]
default_fields = {}
"#;
        let mut config = Config::default_embedded();
        let custom_cfg: Config = toml::from_str(toml_str).unwrap();
        config.merge(custom_cfg);
        let resolver = NamingResolver::new(config.plugins.naming.clone());
        let infer = InferenceEngine::new(&config, &resolver);
        let plugins = PluginRegistry::default_plugins();

        // 1. Generic actions extraction
        let actions_code = r#"
MY_ACTIONS = {
    CUSTOM_JUMP = 1,
    CUSTOM_SLASH = 2,
}
"#;
        let ast = full_moon::parse(actions_code).unwrap();
        let ctx = ExtractContext {
            ast: &ast,
            rel_path: "custom_actions.lua",
            resolver: &resolver,
            infer: &infer,
            config: &config,
        };
        let unit = plugins.extract(&ctx).expect("Should extract custom actions");
        assert_eq!(unit.globals.len(), 1);
        assert_eq!(unit.globals[0].name, "MY_ACTIONS");
        assert_eq!(unit.globals[0].ty, "table<string, ds.my_actions.action>");
        assert_eq!(
            unit.globals[0].entries.as_ref().unwrap(),
            &vec!["CUSTOM_JUMP".to_string(), "CUSTOM_SLASH".to_string()]
        );

        // 2. Generic replica extraction
        let replica_code = r#"
local MY_REPLICAS = {
    custom_comp = true,
}

function CustomEntity:DoSomething()
end
"#;
        let ast = full_moon::parse(replica_code).unwrap();
        let ctx = ExtractContext {
            ast: &ast,
            rel_path: "custom_replica.lua",
            resolver: &resolver,
            infer: &infer,
            config: &config,
        };
        let unit = plugins.extract(&ctx).expect("Should extract custom replica");
        let rep_cls = unit
            .classes
            .iter()
            .find(|c| c.class_name == "ds.customreplica")
            .unwrap();
        assert_eq!(
            rep_cls.fields.get("custom_comp").unwrap().ty,
            "ds.replicas.custom.custom_comp"
        );
        let ext_cls = unit
            .classes
            .iter()
            .find(|c| c.class_name == "ds.customentity")
            .unwrap();
        assert!(ext_cls.methods.iter().any(|m| m.name == "DoSomething"));

        // 3. Generic functions & env exporters
        let fn_code = r#"
local function InitCustomEnv(custom_env)
    custom_env.ExportedFunc = function(a, b) end
end
"#;
        let ast = full_moon::parse(fn_code).unwrap();
        let ctx = ExtractContext {
            ast: &ast,
            rel_path: "custom_mod.lua",
            resolver: &resolver,
            infer: &infer,
            config: &config,
        };
        let unit = plugins.extract(&ctx).expect("Should extract custom env functions");
        assert!(unit.functions.iter().any(|f| f.name == "ExportedFunc"));

        // 4. Generic prefab with component_namespace
        let prefab_code = r#"
function MakeEntity()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddCombat()
    return inst
end
"#;
        let ast = full_moon::parse(prefab_code).unwrap();
        let ctx = ExtractContext {
            ast: &ast,
            rel_path: "prefabs/custom_entity.lua",
            resolver: &resolver,
            infer: &infer,
            config: &config,
        };
        let unit = plugins.extract(&ctx).expect("Should extract custom prefab");
        let ent_cls = &unit.classes[0];
        assert_eq!(
            ent_cls.fields.get("Combat").unwrap().ty,
            "ds.components.Combat"
        );
    }

    #[test]
    fn test_infer_param_optionality() {
        let config = Config::default_embedded();
        let resolver = NamingResolver::new(config.plugins.naming.clone());
        let infer = InferenceEngine::new(&config, &resolver);
        let plugins = PluginRegistry::default_plugins();

        let code = r#"
local TEMPLATES = {}

function TEMPLATES.IconButton(iconAtlas, iconTexture, labelText, sideLabel, alwaysShowLabel, onclick, textinfo, defaultTexture)
    local btn = ImageButton("atlas", "tex")
    if not textinfo then
        textinfo = {}
    end
    if sideLabel then
        -- do something
    elseif alwaysShowLabel then
        -- do something
    end
    return btn
end

function TEMPLATES.OtherFunction(req_param, opt_or, opt_nil_check, opt_not_check)
    opt_or = opt_or or 10
    if opt_nil_check == nil then
        opt_nil_check = "default"
    end
    if not opt_not_check then
        opt_not_check = false
    end
    return req_param
end

return TEMPLATES
"#;
        let ast = full_moon::parse(code).unwrap();
        let ctx = ExtractContext {
            ast: &ast,
            rel_path: "widgets/templates.lua",
            resolver: &resolver,
            infer: &infer,
            config: &config,
        };
        let unit = plugins.extract(&ctx).expect("Should extract templates");
        let cls = &unit.classes[0];

        let icon_btn = cls.methods.iter().find(|m| m.name == "IconButton").unwrap();
        let p_atlas = icon_btn.params.iter().find(|p| p.name == "iconAtlas").unwrap();
        let p_textinfo = icon_btn.params.iter().find(|p| p.name == "textinfo").unwrap();
        let p_side = icon_btn.params.iter().find(|p| p.name == "sideLabel").unwrap();
        let p_always = icon_btn.params.iter().find(|p| p.name == "alwaysShowLabel").unwrap();

        assert!(!p_atlas.optional);
        assert!(p_textinfo.optional);
        assert!(p_side.optional);
        assert!(p_always.optional);

        let other_fn = cls.methods.iter().find(|m| m.name == "OtherFunction").unwrap();
        let p_req = other_fn.params.iter().find(|p| p.name == "req_param").unwrap();
        let p_opt_or = other_fn.params.iter().find(|p| p.name == "opt_or").unwrap();
        let p_opt_nil = other_fn.params.iter().find(|p| p.name == "opt_nil_check").unwrap();
        let p_opt_not = other_fn.params.iter().find(|p| p.name == "opt_not_check").unwrap();

        assert!(!p_req.optional);
        assert!(p_opt_or.optional);
        assert!(p_opt_nil.optional);
        assert!(p_opt_not.optional);
    }

    #[test]
    fn test_templates_iconbutton_overrides() {
        let config_toml = r#"
[overrides.classes."ds.widgets.templates.iconbutton"]
super = "ds.widgets.imagebutton"
fields = { icon = "ds.widgets.image", highlight = "ds.widgets.image", label = "ds.widgets.text?" }

[overrides.classes."ds.widgets.templates".methods."IconButton"]
return_type = "ds.widgets.templates.iconbutton"
"#;
        let config: Config = toml::from_str(config_toml).unwrap();
        let resolver = NamingResolver::new(config.plugins.naming.clone());
        let infer = InferenceEngine::new(&config, &resolver);
        let plugins = PluginRegistry::default_plugins();

        let code = r#"
local TEMPLATES = {}

function TEMPLATES.IconButton(iconAtlas, iconTexture, labelText, sideLabel, alwaysShowLabel, onclick, textinfo, defaultTexture)
    local btn = ImageButton("atlas", "tex")
    btn.icon = btn:AddChild(Image(iconAtlas, iconTexture, defaultTexture))
    btn.highlight = btn:AddChild(Image("images/frontend.xml", "button_square_highlight.tex"))
    if sideLabel then
        btn.label = btn:AddChild(Text("font", 25, labelText))
    end
    return btn
end

return TEMPLATES
"#;
        let ast = full_moon::parse(code).unwrap();
        let ctx = ExtractContext {
            ast: &ast,
            rel_path: "widgets/templates.lua",
            resolver: &resolver,
            infer: &infer,
            config: &config,
        };
        let unit = plugins.extract(&ctx).expect("Should extract templates");
        let emitted = emit_unit(&unit);
        println!("EMITTED ICONBUTTON TEST:\n{}", emitted);

        assert!(emitted.contains("---@class ds.widgets.templates.iconbutton: ds.widgets.imagebutton"));
        assert!(emitted.contains("---@field icon ds.widgets.image"));
        assert!(emitted.contains("---@field highlight ds.widgets.image"));
        assert!(emitted.contains("---@field label? ds.widgets.text"));
        assert!(emitted.contains("---@return ds.widgets.templates.iconbutton"));
        assert!(emitted.contains("return TEMPLATES"));
    }
}
