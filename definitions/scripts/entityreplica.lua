---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.entityreplica
---@field builder? ds.replicas.builder
---@field combat? ds.replicas.combat
---@field container? ds.replicas.container
---@field constructionsite? ds.replicas.constructionsite
---@field equippable? ds.replicas.equippable
---@field fishingrod? ds.replicas.fishingrod
---@field follower? ds.replicas.follower
---@field health? ds.replicas.health
---@field hunger? ds.replicas.hunger
---@field inventory? ds.replicas.inventory
---@field inventoryitem? ds.replicas.inventoryitem
---@field moisture? ds.replicas.moisture
---@field named? ds.replicas.named
---@field oceanfishingrod? ds.replicas.oceanfishingrod
---@field rider? ds.replicas.rider
---@field sanity? ds.replicas.sanity
---@field sheltered? ds.replicas.sheltered
---@field stackable? ds.replicas.stackable
---@field writeable? ds.replicas.writeable
local EntityReplica = {}

local EntityScript = {}

---@param name string
---@param cmp any
function EntityScript:ValidateReplicaComponent(name, cmp) end

---@param name string
function EntityScript:ReplicateComponent(name) end

---@param name string
function EntityScript:UnreplicateComponent(name) end

---@param name string
function EntityScript:PrereplicateComponent(name) end

function EntityScript:ReplicateEntity() end

---@param classified any
---@param name string
function EntityScript:TryAttachClassifiedToReplicaComponent(classified, name) end

return EntityReplica
