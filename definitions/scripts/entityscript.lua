---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.entityscript
---@field entity any
---@field components table
---@field lower_components_shadow table
---@field GUID any
---@field spawntime any
---@field sleepstatepending boolean
---@field persists boolean
---@field inlimbo boolean
---@field name any
---@field data any
---@field listeners any
---@field updatecomponents any
---@field updatestaticcomponents any
---@field actioncomponents table
---@field inherentactions any
---@field inherentsceneaction any
---@field inherentscenealtaction any
---@field event_listeners any
---@field event_listening any
---@field worldstatewatching any
---@field pendingtasks any
---@field children any
---@field platformfollowers any
---@field actionreplica any
---@field replica ds.entityreplica
---@field _snapshot_platform any
---@field forcedoutoflimbo any
---@field wallupdatecomponents table
---@field skin_build_name any
---@field prefab any
---@field nameoverride any
---@field deploy_extra_spacing any
---@field deploy_smart_radius any
---@field terraform_extra_spacing any
---@field ground_target_blocker_radius any
---@field _brainstopped any
---@field brainfn any
---@field _braindisabled any
---@field brain any
---@field sg any
---@field physicsradiusoverride any
---@field bufferedaction any
---@field inventoryimageremapping table
---@field inLight boolean
---@overload fun(entity?: any): ds.entityscript
local EntityScript = function(entity) end

function EntityScript:GetSaveRecord() end

function EntityScript:Hide() end

function EntityScript:Show() end

---@param target any
function EntityScript:StackableSkinHack(target) end

function EntityScript:IsInLimbo() end

---@param state any
function EntityScript:ForceOutOfLimbo(state) end

function EntityScript:RemoveFromScene() end

function EntityScript:ReturnToScene() end

function EntityScript:__tostring() end

---@param act any
function EntityScript:AddInherentAction(act) end

---@param act any
function EntityScript:RemoveInherentAction(act) end

function EntityScript:GetTimeAlive() end

---@param cmp any
---@param do_static_update? any
function EntityScript:StartUpdatingComponent(cmp, do_static_update) end

---@param cmp any
function EntityScript:StopUpdatingComponent(cmp) end

---@param cmp any
function EntityScript:StopUpdatingComponent_Deferred(cmp) end

---@param cmp any
function EntityScript:StartWallUpdatingComponent(cmp) end

---@param cmp any
function EntityScript:StopWallUpdatingComponent(cmp) end

---@param cmp any
function EntityScript:GetComponentName(cmp) end

---@param tag any
function EntityScript:AddTag(tag) end

---@param tag any
function EntityScript:RemoveTag(tag) end

---@param tag any
---@param condition? any
function EntityScript:AddOrRemoveTag(tag, condition) end

---@param tag any
function EntityScript:HasTag(tag) end

function EntityScript:HasTags(...) end

function EntityScript:HasOneOfTags(...) end

---@param name string
function EntityScript:AddComponent(name) end

---@param name string
function EntityScript:RemoveComponent(name) end

function EntityScript:GetBasicDisplayName() end

function EntityScript:GetAdjectivedName() end

function EntityScript:GetDisplayName() end

function EntityScript:GetWetMultiplier() end

function EntityScript:GetIsWet() end

function EntityScript:IsAcidSizzling() end

function EntityScript:GetSkinBuild() end

function EntityScript:GetSkinName() end

---@param name string
function EntityScript:SetPrefabName(name) end

---@param nameoverride any
function EntityScript:SetPrefabNameOverride(nameoverride) end

---@param spacing? any
function EntityScript:SetDeployExtraSpacing(spacing) end

---@param radius? any
function EntityScript:SetDeploySmartRadius(radius) end

---@param spacing? any
function EntityScript:SetTerraformExtraSpacing(spacing) end

---@param radius? any
function EntityScript:SetGroundTargetBlockerRadius(radius) end

---@param name string
function EntityScript:SpawnChild(name) end

---@param child ds.widgets.widget
function EntityScript:RemoveChild(child) end

---@param child ds.widgets.widget
function EntityScript:AddChild(child) end

---@param child ds.widgets.widget
function EntityScript:RemovePlatformFollower(child) end

---@param child ds.widgets.widget
function EntityScript:AddPlatformFollower(child) end

function EntityScript:GetPlatformFollowers() end

function EntityScript:GetBrainString() end

function EntityScript:GetDebugString() end

function EntityScript:KillTasks() end

---@param fn function
function EntityScript:StartThread(fn) end

---@param name string
function EntityScript:RunScript(name) end

---@param reason? string
function EntityScript:RestartBrain(reason) end

---@param reason? string
function EntityScript:StopBrain(reason) end

---@param brainfn function
function EntityScript:SetBrain(brainfn) end

function EntityScript:_DisableBrain_Internal() end

function EntityScript:_EnableBrain_Internal() end

---@param name string
function EntityScript:SetStateGraph(name) end

function EntityScript:ClearStateGraph() end

---@param event any
---@param fn function
---@param source? any
function EntityScript:ListenForEvent(event, fn, source) end

---@param event any
---@param fn function
---@param source? any
function EntityScript:RemoveEventCallback(event, fn, source) end

function EntityScript:RemoveAllEventCallbacks() end

---@param var any
---@param fn function
function EntityScript:WatchWorldState(var, fn) end

---@param var any
---@param fn function
function EntityScript:StopWatchingWorldState(var, fn) end

function EntityScript:StopAllWatchingWorldStates() end

---@param event any
---@param data any
---@param immediate? any
function EntityScript:PushEvent_Internal(event, data, immediate) end

---@param event any
---@param data any
function EntityScript:PushEvent(event, data) end

---@param event any
---@param data any
function EntityScript:PushEventImmediate(event, data) end

---@param radius any
function EntityScript:SetPhysicsRadiusOverride(radius) end

---@param default any
function EntityScript:GetPhysicsRadius(default) end

function EntityScript:GetBoatIntersectingPhysics() end

function EntityScript:GetPosition() end

function EntityScript:GetRotation() end

---@param x? number
---@param y? number
---@param z? number
function EntityScript:GetAngleToPoint(x, y, z) end

---@param target? any
---@param distance any
function EntityScript:GetPositionAdjacentTo(target, distance) end

---@param x number
---@param y number
---@param z number
function EntityScript:ForceFacePoint(x, y, z) end

---@param x number
---@param y number
---@param z number
function EntityScript:FacePoint(x, y, z) end

---@param inst ds.entityscript
function EntityScript:GetDistanceSqToInst(inst) end

---@param otherinst any
---@param dist any
function EntityScript:IsNear(otherinst, dist) end

---@param x? number
---@param y? number
---@param z? number
function EntityScript:GetDistanceSqToPoint(x, y, z) end

---@param range any
---@param isalive any
function EntityScript:IsNearPlayer(range, isalive) end

---@param isalive any
function EntityScript:GetNearestPlayer(isalive) end

---@param isalive any
function EntityScript:GetDistanceSqToClosestPlayer(isalive) end

---@param dest any
---@param force? any
function EntityScript:FaceAwayFromPoint(dest, force) end

---@param otherinst any
---@param wholearcangle_degrees any
---@param max_dist? any
---@param circle_dist? any
function EntityScript:IsEntityInFrontConeSlice(otherinst, wholearcangle_degrees, max_dist, circle_dist) end

function EntityScript:IsAsleep() end

function EntityScript:CancelAllPendingTasks() end

---@param time number
---@param fn function
---@param initialdelay any
function EntityScript:DoStaticPeriodicTask(time, fn, initialdelay, ...) end

---@param time number
---@param fn function
function EntityScript:DoStaticTaskInTime(time, fn, ...) end

---@param time number
---@param fn function
---@param initialdelay any
function EntityScript:DoPeriodicTask(time, fn, initialdelay, ...) end

---@param time number
---@param fn function
function EntityScript:DoTaskInTime(time, fn, ...) end

---@param time number
---@param eventname any
---@param data any
function EntityScript:PushEventInTime(time, eventname, data) end

---@param time number
function EntityScript:GetTaskInfo(time) end

---@param taskinfo any
function EntityScript:TimeRemainingInTask(taskinfo) end

---@param time number
---@param fn function
function EntityScript:ResumeTask(time, fn, ...) end

function EntityScript:ClearBufferedAction() end

---@param bufferedaction? any
function EntityScript:PreviewBufferedAction(bufferedaction) end

function EntityScript:PerformPreviewBufferedAction() end

---@param bufferedaction? any
function EntityScript:PushBufferedAction(bufferedaction) end

function EntityScript:PerformBufferedAction() end

function EntityScript:GetBufferedAction() end

---@param builder any
function EntityScript:OnBuilt(builder) end

function EntityScript:Remove() end

function EntityScript:IsValid() end

---@param inst ds.entityscript
function EntityScript:CanInteractWith(inst) end

---@param action any
---@param doer any
---@param target any
function EntityScript:OnUsedAsItem(action, doer, target) end

---@param action any
function EntityScript:CanDoAction(action) end

function EntityScript:IsOnValidGround() end

---@param include_water any
---@param floating_platforms_are_not_passable any
function EntityScript:IsOnPassablePoint(include_water, floating_platforms_are_not_passable) end

---@param allow_boats any
function EntityScript:IsOnOcean(allow_boats) end

function EntityScript:GetCurrentPlatform() end

function EntityScript:GetCurrentTileType() end

---@param radius? number
function EntityScript:PutBackOnGround(radius) end

function EntityScript:GetPersistData() end

---@param newents any
---@param savedata? any
function EntityScript:LoadPostPass(newents, savedata) end

---@param data? any
---@param newents any
function EntityScript:SetPersistData(data, newents) end

function EntityScript:GetAdjective() end

---@param action any
function EntityScript:SetInherentSceneAction(action) end

---@param action any
function EntityScript:SetInherentSceneAltAction(action) end

---@param dt number
function EntityScript:LongUpdate(dt) end

---@param flagname any
---@param srcinventoryimage any
---@param destinventoryimage any
---@param destatlas any
function EntityScript:SetClientSideInventoryImageOverride(
   flagname,
   srcinventoryimage,
   destinventoryimage,
   destatlas
)
end

function EntityScript:HasClientSideInventoryImageOverrides() end

---@param imagenamehash any
function EntityScript:GetClientSideInventoryImageOverride(imagenamehash) end

---@param name string
---@param value boolean
function EntityScript:SetClientSideInventoryImageOverrideFlag(name, value) end

function EntityScript:IsInLight() end

---@param lightThresh any
function EntityScript:IsLightGreaterThan(lightThresh) end

function EntityScript:DebuffsEnabled() end

---@param name string
function EntityScript:HasDebuff(name) end

---@param name string
function EntityScript:GetDebuff(name) end

---@param name string
---@param prefab string
---@param data any
---@param skip_test? any
---@param pre_buff_fn? function
---@param buffer any
function EntityScript:AddDebuff(name, prefab, data, skip_test, pre_buff_fn, buffer) end

---@param name string
function EntityScript:RemoveDebuff(name) end

---@param num any
function EntityScript:SetDeathLootLevel(num) end

function EntityScript:GetDeathLootLevel() end

function EntityScript:DropDeathLoot() end

function EntityScript:GetDeathLoot() end

return EntityScript
