---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.prefabs.player_common: ds.entityscript
---@field HUD? any
---@field player_classified? ds.entityscript
---@field userid string
---@field prefab string
---@field playercolour? table
---@field ghostenabled? boolean
---@field isplayer? boolean
---@field _isrezattuned? boolean
---@field hasStartedFire? boolean
---@field hasAttackedPlayer? any
---@field hasKilledPlayer? boolean
---@field hasRevivedPlayer? any
---@field _PICKUPSOUNDS? any
---@field activatetask? any
---@field isseamlessswapsource? any
---@field isseamlessswaptarget? any
---@field jointask? any
---@field _setpredictionrpctask? any
---@field _serverpauseddirtyfn? any
---@field name? any
---@field delayclientdespawn? boolean
---@field delayclientdespawn_attempted? boolean
---@field loadingprotection? boolean
---@field ondetachclassified? any
---@field migration? any
---@field migrationpets? table
---@field OnNewSpawn? any
---@field _OnNewSpawn? any
---@field starting_inventory? any
---@field last_death_position? ds.vector3
---@field last_death_shardid? any
---@field _sleepinghandsitem? any
---@field _sleepingactiveitem? any
---@field sleepingbag? any
---@field _freezingeffectblock? any
---@field _overheatingeffectblock? any
---@field CanExamine? any
---@field ActionStringOverride? any
---@field EnableTargetLocking? any
---@field CanSeeTileOnMiniMap? any
---@field CanSeePointOnMiniMap? any
---@field GetSeeableTilePercent? any
---@field MakeGenericCommander? any
---@field CommandWheelAllowsGameplay? any
---@field Transform any
---@field AnimState any
---@field SoundEmitter any
---@field DynamicShadow any
---@field MiniMapEntity any
---@field Light any
---@field LightWatcher any
---@field Network any
---@field footstepoverridefn? any
---@field foleyoverridefn? any
---@field foleysound? any
---@field _sharksoundparam? any
---@field _winters_feast_music? any
---@field _hermit_music? any
---@field _underleafcanopy? any
---@field _lunarportalmax? any
---@field _shadowportalmax? any
---@field _skilltreeactivatedany? any
---@field _wormdigestionsound? any
---@field _parasiteoverlay? any
---@field _blackout? any
---@field _buffsymbol? any
---@field yotb_skins_sets? any
---@field _piratemusicstate? any
---@field PostActivateHandshake? any
---@field OnPostActivateHandshake_Client? any
---@field _PostActivateHandshakeState_Client? any
---@field SetClientAuthoritativeSetting? any
---@field SynchronizeOneClientAuthoritativeSetting? any
---@field cameradistancebonuses? any
---@field OnPostActivateHandshake_Server? any
---@field _PostActivateHandshakeState_Server? any
---@field persists? boolean
---@field SwapAllCharacteristics? any
---@field _scalesource? any
---@field skeleton_prefab? string
---@field _OnSave? any
---@field _OnPreLoad? any
---@field _OnLoad? any
---@field _OnDespawn? any
---@field ChangeToMonkey? any
---@field ChangeFromMonkey? any
---@field IsActing? any
local ThePlayer = {}

function ThePlayer:_serverpauseddirtyfn() end

function ThePlayer:ondetachclassified() end

---@param classified any
function ThePlayer:AttachClassified(classified) end

function ThePlayer:DetachClassified() end

function ThePlayer:OnRemoveEntity() end

---@param touchstone any
function ThePlayer:CanUseTouchStone(touchstone) end

function ThePlayer:GetTemperature() end

function ThePlayer:IsFreezing() end

function ThePlayer:IsOverheating() end

function ThePlayer:GetMoisture() end

function ThePlayer:GetMaxMoisture() end

function ThePlayer:GetMoistureRateScale() end

---@param stormtype any
function ThePlayer:GetStormLevel(stormtype) end

function ThePlayer:IsInMiasma() end

function ThePlayer:IsInAnyStormOrCloud() end

function ThePlayer:IsCarefulWalking() end

function ThePlayer:IsChannelCasting() end

function ThePlayer:IsChannelCastingItem() end

function ThePlayer:IsTeetering() end

---@param enable? any
function ThePlayer:EnableMovementPrediction(enable) end

---@param enable any
function ThePlayer:EnableBoatCamera(enable) end

---@param mode any
---@param duration any
---@param speed any
---@param scale number
---@param source_or_pt? any
---@param maxDist? any
function ThePlayer:ShakeCamera(mode, duration, speed, scale, source_or_pt, maxDist) end

---@param isghost? any
function ThePlayer:SetGhostMode(isghost) end

function ThePlayer:IsActionsVisible() end

---@param source any
---@param boolval any
---@param key any
function ThePlayer:SetFreezingEffectBlockModifier(source, boolval, key) end

---@param source any
---@param boolval any
---@param key any
function ThePlayer:SetOverheatingEffectBlockModifier(source, boolval, key) end

function ThePlayer:IsFreezingEffectBlocked() end

function ThePlayer:IsOverheatingEffectBlocked() end

---@param target any
function ThePlayer:TargetForceAttackOnly(target) end

function ThePlayer:ApplySkinOverrides() end

function ThePlayer:IsHUDVisible() end

---@param show any
function ThePlayer:ShowActions(show) end

---@param show any
function ThePlayer:ShowCrafting(show) end

---@param show any
function ThePlayer:ShowHUD(show) end

---@param popup any
---@param show any
function ThePlayer:ShowPopUp(popup, show, ...) end

function ThePlayer:ResetMinimapOffset() end

function ThePlayer:CloseMinimap() end

---@param distance any
function ThePlayer:SetCameraDistance(distance) end

---@param source any
---@param distance any
---@param key any
function ThePlayer:AddCameraExtraDistance(source, distance, key) end

---@param source any
---@param key any
function ThePlayer:RemoveCameraExtraDistance(source, key) end

---@param iszoomed any
function ThePlayer:SetCameraZoomed(iszoomed) end

---@param isaerial any
function ThePlayer:SetAerialCamera(isaerial) end

---@param resetrot any
function ThePlayer:SnapCamera(resetrot) end

---@param isfadein any
---@param time? number
---@param iswhite any
function ThePlayer:ScreenFade(isfadein, time, iswhite) end

---@param intensity any
function ThePlayer:ScreenFlash(intensity) end

---@param target any
function ThePlayer:SetBathingPoolCamera(target) end

---@param skinset any
function ThePlayer:YOTB_unlockskinset(skinset) end

---@param skinset any
function ThePlayer:YOTB_issetunlocked(skinset) end

---@param skin any
function ThePlayer:YOTB_isskinunlocked(skin) end

---@param hounded_ok? any
function ThePlayer:IsNearDanger(hounded_ok) end

function ThePlayer:SetGymStartState() end

function ThePlayer:SetGymStopState() end

---@param source? any
---@param scale? number
function ThePlayer:ApplyScale(source, scale) end

---@param source? any
---@param scale? number
function ThePlayer:ApplyAnimScale(source, scale) end

function ThePlayer:OnSleepIn() end

function ThePlayer:OnWakeUp() end

---@param data any
function ThePlayer:OnSave(data) end

---@param data any
function ThePlayer:OnPreLoad(data) end

---@param data? any
function ThePlayer:OnLoad(data) end

---@param starting_item_skins any
function ThePlayer:OnNewSpawn(starting_item_skins) end

---@param migrationdata? any
function ThePlayer:OnDespawn(migrationdata) end

function ThePlayer:SaveForReroll() end

---@param data any
function ThePlayer:LoadForReroll(data) end

function ThePlayer:EnableLoadingProtection() end

function ThePlayer:DisableLoadingProtection() end

return ThePlayer
