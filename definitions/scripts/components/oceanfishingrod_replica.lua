---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.replicas.oceanfishingrod
---@field inst any
---@field _target any
---@field _line_tension any
---@field _max_cast_dist any
---@overload fun(inst?: ds.entityscript): ds.replicas.oceanfishingrod
local OceanFishingRod = function(inst) end

function OceanFishingRod:GetTarget() end

---@param target any
function OceanFishingRod:_SetTarget(target) end

---@param line_tension any
function OceanFishingRod:_SetLineTension(line_tension) end

function OceanFishingRod:IsLineTensionHigh() end

function OceanFishingRod:IsLineTensionGood() end

function OceanFishingRod:IsLineTensionLow() end

---@param dist any
function OceanFishingRod:SetClientMaxCastDistance(dist) end

function OceanFishingRod:GetMaxCastDist() end

function OceanFishingRod:GetDebugString() end

return OceanFishingRod
