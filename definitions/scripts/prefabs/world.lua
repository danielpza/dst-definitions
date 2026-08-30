---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.prefabs.world: ds.entityscript
---@field ismastersim boolean
---@field ismastershard boolean
---@field isdeactivated? boolean
---@field state table<string, any>
---@field net? ds.entityscript
---@field shard? ds.entityscript
---@field minimap ds.entityscript
---@field topology? table
---@field generated? table
---@field meta? table
---@field PocketDimensionContainers table<string, ds.entityscript>
---@field game_data_task? any
---@field persists? boolean
---@field Transform any
---@field Map any
---@field Pathfinder any
---@field GroundCreep any
---@field SoundEmitter any
---@field tile_physics_init? fun(inst: ds.prefabs.world)
---@field cancrossbarriers_flying? boolean
local TheWorld = {}

function TheWorld:CanFlyingCrossBarriers() end

function TheWorld:PostInit() end

function TheWorld:OnRemoveEntity() end

function TheWorld:CreateTilePhysics() end

---@param name string
---@param containerinst any
function TheWorld:SetPocketDimensionContainer(name, containerinst) end

---@param name string
function TheWorld:GetPocketDimensionContainer(name) end

return TheWorld
