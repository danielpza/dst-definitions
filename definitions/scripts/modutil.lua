---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@type table
ReleaseID = {}

---@type table
CurrentRelease = {}

---@param name string
function ModInfoname(name) end

---@param name string
function AddModReleaseID(name) end

---@param rhs any
function CurrentRelease.GreaterOrEqualTo(rhs) end

function CurrentRelease.PrintID() end

---@param optionname any
---@param modname any
---@param get_local_config? any
---@return any
function GetModConfigData(optionname, modname, get_local_config) end

---@param message any
---@param level? any
function moderror(message, level) end

---@param test? any
---@param message any
function modassert(test, message) end

function modprint(...) end

function ReloadFrontEndAssets() end

function ReloadPreloadAssets() end

---@param category any
---@param name string
---@param text string
---@param desc any
---@param atlas string
---@param order any
function AddCustomizeGroup(category, name, text, desc, atlas, order) end

---@param category any
---@param name string
function RemoveCustomizeGroup(category, name) end

---@param category any
---@param group any
---@param name string
---@param itemsettings any
function AddCustomizeItem(category, group, name, itemsettings) end

---@param category any
---@param name string
function RemoveCustomizeItem(category, name) end

---@param description any
function GetCustomizeDescription(description) end

---@param levelid any
---@param fn function
function AddLevelPreInit(levelid, fn) end

---@param fn function
function AddLevelPreInitAny(fn) end

---@param tasksetname any
---@param fn function
function AddTaskSetPreInit(tasksetname, fn) end

---@param fn function
function AddTaskSetPreInitAny(fn) end

---@param taskname any
---@param fn function
function AddTaskPreInit(taskname, fn) end

---@param roomname any
---@param fn function
function AddRoomPreInit(roomname, fn) end

---@param arg1 any
function AddLocation(arg1, ...) end

---@param arg1 any
---@param arg2 any
function AddLevel(arg1, arg2, ...) end

---@param arg1 any
function AddTaskSet(arg1, ...) end

---@param arg1 any
function AddTask(arg1, ...) end

---@param arg1 any
function AddRoom(arg1, ...) end

---@param arg1 any
function AddStartLocation(arg1, ...) end

---@param game_mode any
---@param game_mode_text any
function AddGameMode(game_mode, game_mode_text) end

---@param optionname any
---@param get_local_config any
---@return any
function GetModConfigData(optionname, get_local_config) end

---@param fn function
function AddGamePostInit(fn) end

---@param fn function
function AddSimPostInit(fn) end

---@param package any
---@param classname any
---@param fn function
function AddGlobalClassPostConstruct(package, classname, fn) end

---@param package any
---@param fn function
function AddClassPostConstruct(package, fn) end

---@param range_name any
---@param range_start any
---@param range_end any
function RegisterTileRange(range_name, range_start, range_end) end

---@param tile_name any
---@param tile_range any
---@param tile_data any
---@param ground_tile_def any
---@param minimap_tile_def any
---@param turf_def any
function AddTile(tile_name, tile_range, tile_data, ground_tile_def, minimap_tile_def, turf_def) end

---@param tile_id any
---@param target_tile_id any
---@param moveafter any
function ChangeTileRenderOrder(tile_id, target_tile_id, moveafter) end

---@param tile_id any
---@param propertyname any
---@param value any
function SetTileProperty(tile_id, propertyname, value) end

---@param tile_id any
---@param target_tile_id any
---@param moveafter any
function ChangeMiniMapTileRenderOrder(tile_id, target_tile_id, moveafter) end

---@param tile_id any
---@param propertyname any
---@param value any
function SetMiniMapTileProperty(tile_id, propertyname, value) end

---@param falloff_id any
---@param falloff_def any
function AddFalloffTexture(falloff_id, falloff_def) end

---@param falloff_id any
---@param falloff_id_id any
---@param moveafter any
function ChangeFalloffRenderOrder(falloff_id, falloff_id_id, moveafter) end

---@param falloff_id any
---@param propertyname any
---@param value any
function SetFalloffProperty(falloff_id, propertyname, value) end

---@param id string|ds.actions.action
---@param str? string
---@param fn? (fun(act: ds.bufferedaction): boolean)
---@return ds.actions.action
function AddAction(id, str, fn) end

---@param actiontype "SCENE"|"USEITEM"|"POINT"|"EQUIPPED"|"INVENTORY"
---@param component string
---@param fn fun(inst: ds.entityscript, ...: any, actions: ds.actions.action[], ...: any)
function AddComponentAction(actiontype, component, fn) end

---@param id any
function AddPopup(id) end

---@param atlaspath any
function AddMinimapAtlas(atlaspath) end

---@param stategraph any
---@param handler any
function AddStategraphActionHandler(stategraph, handler) end

---@param stategraph any
---@param state any
function AddStategraphState(stategraph, state) end

---@param stategraph any
---@param event any
function AddStategraphEvent(stategraph, event) end

---@param fn function
function AddModShadersInit(fn) end

---@param fn function
function AddModShadersSortAndEnable(fn) end

---@param stategraph any
---@param fn function
function AddStategraphPostInit(stategraph, fn) end

---@param component string
---@param fn fun(self: any, inst: ds.entityscript)
function AddComponentPostInit(component, fn) end

---@param fn function
function AddPrefabPostInitAny(fn) end

---@param fn fun(inst: ds.prefabs.player_common)
function AddPlayerPostInit(fn) end

---@param prefab string
---@param fn function
function AddPrefabPostInit(prefab, fn) end

---@param fn function
function AddRecipePostInitAny(fn) end

---@param recipename any
---@param fn function
function AddRecipePostInit(recipename, fn) end

---@param brain any
---@param fn function
function AddBrainPostInit(brain, fn) end

---@param names any
---@param tags any
---@param cancook any
---@param candry any
function AddIngredientValues(names, tags, cancook, candry) end

---@param cooker any
---@param recipe any
function AddCookerRecipe(cooker, recipe) end

---@param name string
---@param gender any
---@param modes any
function AddModCharacter(name, gender, modes) end

---@param name string
function RemoveDefaultCharacter(name) end

---@param prototyper_prefab? any
---@param data any
function AddPrototyperDef(prototyper_prefab, data) end

---@param filter_def? any
---@param index? any
function AddRecipeFilter(filter_def, index) end

---@param recipe_name any
---@param filter_name any
function AddRecipeToFilter(recipe_name, filter_name) end

---@param recipe_name any
---@param filter_name any
function RemoveRecipeFromFilter(recipe_name, filter_name) end

---@param name string
---@param ingredients any
---@param tech any
---@param config? any
---@param filters? any
---@return any
function AddRecipe2(name, ingredients, tech, config, filters) end

---@param name string
---@param ingredients any
---@param tech any
---@param config? any
---@param extra_filters? any
---@return any
function AddCharacterRecipe(name, ingredients, tech, config, extra_filters) end

---@param name string
---@param return_ingredients any
function AddDeconstructRecipe(name, return_ingredients) end

---@param arg1 any
function AddRecipe(arg1, ...) end

function Recipe(...) end

---@param rec_str any
---@param rec_sort any
---@param rec_atlas any
---@param rec_icon any
---@param rec_owner_tag any
---@param rec_crafting_station any
function AddRecipeTab(rec_str, rec_sort, rec_atlas, rec_icon, rec_owner_tag, rec_crafting_station) end

---@param path any
---@param lang any
function LoadPOFile(path, lang) end

---@param name string
---@param new_name any
function RemapSoundEvent(name, new_name) end

---@param name string
function RemoveRemapSoundEvent(name) end

---@param name string
function AddReplicableComponent(name) end

---@param namespace any
---@param name string
---@param fn fun(inst?: ds.prefabs.player_common, ...: any)
function AddModRPCHandler(namespace, name, fn) end

---@param namespace any
---@param name string
---@param fn function
function AddClientModRPCHandler(namespace, name, fn) end

---@param namespace any
---@param name string
---@param fn function
function AddShardModRPCHandler(namespace, name, fn) end

---@param namespace any
---@param name string
function GetModRPCHandler(namespace, name) end

---@param namespace any
---@param name string
function GetClientModRPCHandler(namespace, name) end

---@param namespace any
---@param name string
function GetShardModRPCHandler(namespace, name) end

---@param id_table any
function SendModRPCToServer(id_table, ...) end

---@param id_table any
function SendModRPCToClient(id_table, ...) end

---@param id_table any
function SendModRPCToShard(id_table, ...) end

---@param namespace any
---@param name string
---@return table<string, any>
function GetModRPC(namespace, name) end

---@param namespace any
---@param name string
---@return table<string, any>
function GetClientModRPC(namespace, name) end

---@param namespace any
---@param name string
---@return table<string, any>
function GetShardModRPC(namespace, name) end

---@param focusid any
---@param hasfocus any
function SetModHUDFocus(focusid, hasfocus) end

---@param command_name any
---@param data any
function AddUserCommand(command_name, data) end

---@param command_name any
---@param init_options_fn function
---@param process_result_fn function
---@param vote_timeout any
function AddVoteCommand(command_name, init_options_fn, process_result_fn, vote_timeout) end

---@param name string
---@param symbol any
function ExcludeClothingSymbolForModCharacter(name, symbol) end

---@param atlas string
---@param prefabname any
function RegisterInventoryItemAtlas(atlas, prefabname) end

---@param atlas string
---@param tex string
function RegisterScrapbookIconAtlas(atlas, tex) end

---@param atlas string
---@param charactername any
function RegisterSkilltreeBGForCharacter(atlas, charactername) end

---@param atlas string
---@param tex string
function RegisterSkilltreeIconsAtlas(atlas, tex) end

---@param stringtable? any
---@param id? any
---@param tipstring? any
---@param controltipdata? any
function AddLoadingTip(stringtable, id, tipstring, controltipdata) end

---@param stringtable? any
---@param id? any
function RemoveLoadingTip(stringtable, id) end

---@param weighttable any
---@param weightdata any
function SetLoadingTipCategoryWeights(weighttable, weightdata) end

---@param category any
---@param categoryatlas any
---@param categoryicon any
function SetLoadingTipCategoryIcon(category, categoryatlas, categoryicon) end
