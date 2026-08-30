---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.replicas.hunger
---@field inst any
---@field classified any
---@field ondetachclassified function
---@overload fun(inst?: ds.entityscript): ds.replicas.hunger
local Hunger = function(inst) end

---@param classified any
function Hunger:AttachClassified(classified) end

function Hunger:DetachClassified() end

---@param current any
function Hunger:SetCurrent(current) end

---@param max number
function Hunger:SetMax(max) end

function Hunger:Max() end

function Hunger:GetPercent() end

function Hunger:GetCurrent() end

function Hunger:IsStarving() end

return Hunger
