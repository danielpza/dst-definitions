---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@type table
GlobalMapIconsDB = {}

function CalledFrom() end

function GetWorld() end

function GetPlayer() end

---@param inst? ds.entityscript
---@param radius any
---@param fn function
---@param musttags any
---@param canttags any
---@param mustoneoftags any
function FindEntity(inst, radius, fn, musttags, canttags, mustoneoftags) end

---@param inst? ds.entityscript
---@param radius any
---@param ignoreheight any
---@param musttags any
---@param canttags any
---@param mustoneoftags any
---@param fn function
function FindClosestEntity(inst, radius, ignoreheight, musttags, canttags, mustoneoftags, fn) end

---@param x number
---@param y number
---@param z number
---@param rangesq any
---@param isalive any
function FindClosestPlayerInRangeSq(x, y, z, rangesq, isalive) end

---@param x number
---@param y number
---@param z number
---@param range any
---@param isalive any
function FindClosestPlayerInRange(x, y, z, range, isalive) end

---@param x number
---@param y number
---@param z number
---@param isalive any
function FindClosestPlayer(x, y, z, isalive) end

---@param inst ds.entityscript
---@param range any
---@param isalive any
function FindClosestPlayerToInst(inst, range, isalive) end

---@param x number
---@param y number
---@param z number
---@param rangesq any
---@param isalive any
function FindClosestPlayerOnLandInRangeSq(x, y, z, rangesq, isalive) end

---@param inst ds.entityscript
---@param range any
---@param isalive any
function FindClosestPlayerToInstOnLand(inst, range, isalive) end

---@param x number
---@param y number
---@param z number
---@param rangesq any
---@param isalive any
function FindPlayersInRangeSqSortedByDistance(x, y, z, rangesq, isalive) end

---@param x number
---@param y number
---@param z number
---@param range any
---@param isalive any
function FindPlayersInRangeSortedByDistance(x, y, z, range, isalive) end

---@param x number
---@param y number
---@param z number
---@param rangesq any
---@param isalive any
function FindPlayersInRangeSq(x, y, z, rangesq, isalive) end

---@param x number
---@param y number
---@param z number
---@param range any
---@param isalive any
function FindPlayersInRange(x, y, z, range, isalive) end

---@param x number
---@param y number
---@param z number
---@param rangesq any
---@param isalive any
function IsAnyPlayerInRangeSq(x, y, z, rangesq, isalive) end

---@param x number
---@param y number
---@param z number
---@param range any
---@param isalive any
function IsAnyPlayerInRange(x, y, z, range, isalive) end

---@param inst ds.entityscript
---@param rangesq any
---@param isalive any
function IsAnyOtherPlayerNearInst(inst, rangesq, isalive) end

---@param x? number
---@param y number
---@param z? number
function FindSafeSpawnLocation(x, y, z) end

---@param position any
---@param range any
function FindNearbyLand(position, range) end

---@param position any
---@param range any
function FindNearbyOcean(position, range) end

---@param tag any
---@param inst ds.entityscript
---@param radius any
function GetRandomInstWithTag(tag, inst, radius) end

---@param tag any
---@param inst ds.entityscript
---@param radius any
function GetClosestInstWithTag(tag, inst, radius) end

---@param tag any
---@param inst ds.entityscript
---@param radius any
function DeleteCloseEntsWithTag(tag, inst, radius) end

---@param item any
---@param total_time any
---@param start_scale any
---@param end_scale any
function AnimateUIScale(item, total_time, start_scale, end_scale) end

---@param mode any
---@param duration any
---@param speed any
---@param scale number
---@param source_or_pt any
---@param maxDist any
function ShakeAllCameras(mode, duration, speed, scale, source_or_pt, maxDist) end

---@param filterfn function
---@param mode any
---@param duration any
---@param speed any
---@param scale number
---@param source_or_pt any
---@param maxDist any
function ShakeAllCamerasWithFilter(filterfn, mode, duration, speed, scale, source_or_pt, maxDist) end

---@param mode any
---@param duration any
---@param speed any
---@param scale number
---@param platform? any
function ShakeAllCamerasOnPlatform(mode, duration, speed, scale, platform) end

---@param start_angle any
---@param radius any
---@param attempts? any
---@param test_fn function
function FindValidPositionByFan(start_angle, radius, attempts, test_fn) end

---@param position any
---@param start_angle any
---@param radius any
---@param attempts any
---@param check_los any
---@param ignore_walls any
---@param customcheckfn function
---@param allow_water any
---@param allow_boats any
---@param ignore_teleportchecks? any
function FindWalkableOffset(
   position,
   start_angle,
   radius,
   attempts,
   check_los,
   ignore_walls,
   customcheckfn,
   allow_water,
   allow_boats,
   ignore_teleportchecks
)
end

---@param position any
---@param start_angle any
---@param radius any
---@param attempts any
---@param check_los any
---@param ignore_walls any
---@param customcheckfn function
---@param allow_boats any
function FindSwimmableOffset(
   position,
   start_angle,
   radius,
   attempts,
   check_los,
   ignore_walls,
   customcheckfn,
   allow_boats
)
end

---@param inst ds.entityscript
function FindCharlieRezSpotFor(inst) end

---@param owner? ds.entityscript
---@param radius any
---@param furthestfirst? any
---@param positionoverride? any
---@param ignorethese any
---@param onlytheseprefabs any
---@param allowpickables any
---@param worker any
---@param extra_filter any
---@param inventoryoverride any
function FindPickupableItem(
   owner,
   radius,
   furthestfirst,
   positionoverride,
   ignorethese,
   onlytheseprefabs,
   allowpickables,
   worker,
   extra_filter,
   inventoryoverride
)
end

---@param inst ds.entityscript
function CanEntitySeeInDark(inst) end

---@param inst ds.entityscript
function CanEntitySeeInStorm(inst) end

---@param inst ds.entityscript
---@param x number
---@param y number
---@param z number
function CanEntitySeePoint(inst, x, y, z) end

---@param inst ds.entityscript
---@param target? any
function CanEntitySeeTarget(inst, target) end

---@param amount any
---@param forced any
function SpringCombatMod(amount, forced) end

---@param amount any
---@param forced any
function SpringGrowthMod(amount, forced) end

---@param obj any
---@param time number
function TemporarilyRemovePhysics(obj, time) end

---@param inst ds.entityscript
---@param erode_time? any
function ErodeAway(inst, erode_time) end

---@param inst ds.entityscript
---@param erode_time? any
---@param cb function
---@param restore any
function ErodeCB(inst, erode_time, cb, restore) end

---@param event? any
function ApplySpecialEvent(event) end

---@param event? any
function ApplyExtraEvent(event) end

---@param atlas? string
---@param imagename? any
function RegisterInventoryItemAtlas(atlas, imagename) end

---@param imagename any
---@param no_fallback any
function GetInventoryItemAtlas_Internal(imagename, no_fallback) end

---@param imagename any
---@param no_fallback any
function GetInventoryItemAtlas(imagename, no_fallback) end

---@param imagename any
function GetMinimapAtlas_Internal(imagename) end

---@param imagename any
function GetMinimapAtlas(imagename) end

---@param atlas? string
---@param imagename? any
function RegisterScrapbookIconAtlas(atlas, imagename) end

---@param imagename any
function GetScrapbookIconAtlas_Internal(imagename) end

---@param imagename any
function GetScrapbookIconAtlas(imagename) end

---@param atlas? string
---@param imagename? any
function RegisterSkilltreeBGAtlas(atlas, imagename) end

---@param imagename any
function GetSkilltreeBG_Internal(imagename) end

---@param imagename any
function GetSkilltreeBG(imagename) end

---@param atlas? string
---@param imagename? any
function RegisterSkilltreeIconsAtlas(atlas, imagename) end

---@param imagename any
function GetSkilltreeIconAtlas_Internal(imagename) end

---@param imagename any
function GetSkilltreeIconAtlas(imagename) end

---@param inst ds.entityscript
function UnregisterGlobalMapIcon(inst) end

---@param inst ds.entityscript
---@param name? string
function RegisterGlobalMapIcon(inst, name) end

---@param name string
---@param x number
---@param y number
---@param z number
---@param rangesq any
---@param restricted_doer any
function FindClosestMapIconInRangeSq(name, x, y, z, rangesq, restricted_doer) end

---@param name string
---@param x number
---@param y number
---@param z number
---@param range any
---@param restricted_doer any
function FindClosestMapIconInRange(name, x, y, z, range, restricted_doer) end

---@param name string
---@param x number
---@param y number
---@param z number
---@param restricted_doer any
function FindClosestMapIcon(name, x, y, z, restricted_doer) end

---@param recipename any
function DeclareLimitedCraftingRecipe(recipename) end
