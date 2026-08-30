---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.replicas.follower
---@field inst any
---@field _leader any
---@field _itemowner any
---@overload fun(inst?: ds.entityscript): ds.replicas.follower
local Follower = function(inst) end

---@param leader any
function Follower:SetLeader(leader) end

---@param owner ds.entityscript
function Follower:SetItemOwner(owner) end

function Follower:GetLeader() end

return Follower
