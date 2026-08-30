---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@type table
PREFABDEFINITIONS = {}

---@type table
Settings = {}

---@type table
Purchases = {}

---@type table
OnAccountEventListeners = {}

---@type table
LoadingStates = {}

---@param name string
---@param data any
---@param encode any
---@param callback function
function SavePersistentString(name, data, encode, callback) end

---@param name string
---@param callback function
function ErasePersistentString(name, callback) end

---@param msg_verbosity any
function Print(msg_verbosity, ...) end

---@param total_seconds any
function SecondsToTimeString(total_seconds) end

---@param filename any
---@param assettype any
function ShouldIgnoreResolve(filename, assettype) end

---@param prefab string
---@param resolve_fn function
function RegisterPrefabsImpl(prefab, resolve_fn) end

function RegisterPrefabs(...) end

---@param prefab string
function RegisterSinglePrefab(prefab) end

---@param filename any
---@param async_batch_validation any
---@param search_asset_first_path any
function LoadPrefabFile(filename, async_batch_validation, search_asset_first_path) end

---@param modname? any
function ModUnloadFrontEndAssets(modname) end

---@param assets? any
---@param modname any
function ModReloadFrontEndAssets(assets, modname) end

---@param modname? any
function ModUnloadPreloadAssets(modname) end

---@param assets? any
---@param modname any
function ModPreloadAssets(assets, modname) end

---@param achievements any
function RegisterAchievements(achievements) end

---@param filename any
function LoadAchievements(filename) end

---@param filename any
function LoadHapticEffects(filename) end

---@param name string
function AwardFrontendAchievement(name) end

---@param name string
---@param player? any
function AwardPlayerAchievement(name, player) end

---@param name string
---@param value any
---@param player? any
function NotifyPlayerProgress(name, value, player) end

---@param name string
---@param level any
---@param days any
---@param player? any
function NotifyPlayerPresence(name, level, days, player) end

---@param name string
---@param pos number|ds.vector3
---@param radius any
function AwardRadialAchievement(name, pos, radius) end

---@param name string
function SpawnPrefabFromSim(name) end

---@param name string
function PrefabExists(name) end

---@param name string
---@param skin? any
---@param skin_id any
---@param creator any
---@param skin_custom any
---@return ds.entityscript
function SpawnPrefab(name, skin, skin_id, creator, skin_custom) end

---@param original_inst any
---@param name string
---@param skin any
---@param skin_id any
---@param creator any
function ReplacePrefab(original_inst, name, skin, skin_id, creator) end

---@param saved any
---@param newents? any
function SpawnSaveRecord(saved, newents) end

---@param name? string
function CreateEntity(name) end

---@param entityguid any
function OnRemoveEntity(entityguid) end

---@param guid any
function RemoveEntity(guid) end

---@param guid any
---@param event any
---@param data any
function PushEntityEvent(guid, event, data) end

---@param guid any
function GetEntityDisplayName(guid) end

function GetTickTime() end

function GetTime() end

function GetStaticTime() end

function GetTick() end

function GetStaticTick() end

function GetTimeReal() end

function GetTimeRealSeconds() end

---@param filename any
function LoadScript(filename) end

---@param filename any
function RunScript(filename) end

---@param guid any
function GetEntityString(guid) end

function GetExtendedDebugString() end

function GetDebugString() end

function GetDebugEntity() end

---@param inst? ds.entityscript
function SetDebugEntity(inst) end

function GetDebugTable() end

---@param tbl any
function SetDebugTable(tbl) end

---@param guid any
function OnEntitySleep(guid) end

---@param guid any
function OnEntityWake(guid) end

---@param guid any
function OnPhysicsWake(guid) end

---@param guid any
function OnPhysicsSleep(guid) end

---@param pause? any
---@param autopause? any
---@param gameautopause? any
---@param source any
function OnServerPauseDirty(pause, autopause, gameautopause, source) end

---@param guid any
function ReplicateEntity(guid) end

---@param guid any
function DisableLoadingProtection(guid) end

---@param nisname any
---@param lines any
function PlayNIS(nisname, lines) end

function IsPaused() end

function IsSimPaused() end

---@param scale number
function SetDefaultTimeScale(scale) end

---@param val any
function SetSimPause(val) end

---@param pause? any
function SetServerPaused(pause) end

---@param autopause any
function SetAutopaused(autopause) end

---@param autopause any
function SetCraftingAutopaused(autopause) end

---@param autopause any
function SetConsoleAutopaused(autopause) end

function DoAutopause() end

function OnSimPaused() end

function OnSimUnpaused() end

---@param val? any
---@param reason any
function SetPause(val, reason) end

---@param settings any
function SetInstanceParameters(settings) end

---@param purchases any
function SetPurchases(purchases) end

---@param isshutdown? any
---@param cb? function
function SaveGame(isshutdown, cb) end

---@param message any
function ProcessJsonMessage(message) end

function LoadFonts() end

function UnloadFonts() end

function Start() end

function GlobalInit() end

---@param cb function
function DoLoadingPortal(cb) end

---@param map_name any
function LoadMapFile(map_name) end

function JapaneseOnPS4() end

---@param in_params? any
function StartNextInstance(in_params) end

function ForceAssetReset() end

---@param instanceparameters? any
function SimReset(instanceparameters) end

function RequestShutdown() end

function DoWorldOverseerShutdown() end

function Shutdown() end

---@param error any
function DisplayError(error) end

---@param pause? any
function SetPauseFromCode(pause) end

function InGamePlay() end

function IsMigrating() end

---@param save any
function DoRestart(save) end

function OnDynamicCloudSyncReload() end

function OnDynamicCloudSyncDelete() end

---@param player_guid? any
---@param expected any
function OnPlayerLeave(player_guid, expected) end

---@param message any
function OnPushPopupDialog(message) end

function OnDemoTimeout() end

---@param message any
---@param should_reset? any
---@param force_immediate_reset any
---@param details? any
---@param miscdata any
function OnNetworkDisconnect(message, should_reset, force_immediate_reset, details, miscdata) end

---@param listener any
function RegisterOnAccountEventListener(listener) end

---@param listener_to_remove any
function RemoveOnAccountEventListener(listener_to_remove) end

---@param success any
---@param event_code any
---@param custom_message any
function OnAccountEvent(success, event_code, custom_message) end

---@param bg any
function TintBackground(bg) end

function OnFocusLost() end

function OnFocusGained() end

---@param success? any
function ResumeRequestLoadComplete(success) end

---@param data any
function ParseUserSessionData(data) end

---@param data any
---@param guid any
function ResumeExistingUserSession(data, guid) end

---@param sessionid any
---@param userid any
function RestoreSnapshotUserSession(sessionid, userid) end

---@param fnstr any
---@param guid? any
---@param x number
---@param z number
function ExecuteConsoleCommand(fnstr, guid, x, z) end

---@param loading_state any
---@param match_results? any
function NotifyLoadingState(loading_state, match_results) end

---@param namespace any
---@param atlas string
function CreateWorldStateTag(namespace, atlas) end

---@param namespace any
function GetWorldStateTagObjectFromNamespace(namespace) end

---@param tag any
function GetWorldStateTagObjectFromTag(tag) end

---@param fn function
function ForEachWorldStateTagObject(fn, ...) end

---@param tagsTable any
function BuildTagsStringCommon(tagsTable) end

function SaveAndShutdown() end

function IsInFrontEnd() end

---@param repeat_time? any
---@param lowered_volume_percent? any
function CreateRepeatedSoundVolumeReduction(repeat_time, lowered_volume_percent) end

---@param notification any
function DisplayAntiAddictionNotification(notification) end

function ShowBadHashUI() end

---@param button any
function HookLoginButtonForDataBundleFileHashes(button) end

function BeginDataBundleFileHashes() end

---@param calculatedhashes any
function DataBundleFileHashes(calculatedhashes) end
