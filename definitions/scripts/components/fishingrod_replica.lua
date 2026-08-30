---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.replicas.fishingrod
---@field inst any
---@field _target any
---@field _hashookedfish any
---@field _hascaughtfish any
---@overload fun(inst?: ds.entityscript): ds.replicas.fishingrod
local FishingRod = function(inst) end

---@param target any
function FishingRod:SetTarget(target) end

function FishingRod:GetTarget() end

---@param hookedfish any
function FishingRod:SetHookedFish(hookedfish) end

function FishingRod:HasHookedFish() end

---@param caughtfish any
function FishingRod:SetCaughtFish(caughtfish) end

function FishingRod:HasCaughtFish() end

return FishingRod
