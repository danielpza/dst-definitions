---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.components.tool
---@field inst any
---@field actions table
---@field tough boolean
---@overload fun(inst?: ds.entityscript): ds.components.tool
local Tool = function(inst) end

function Tool:OnRemoveFromEntity() end

---@param tough any
function Tool:EnableToughWork(tough) end

function Tool:CanDoToughWork() end

---@param action any
function Tool:GetEffectiveness(action) end

---@param action any
---@param effectiveness any
function Tool:SetAction(action, effectiveness) end

---@param action any
function Tool:CanDoAction(action) end

return Tool
