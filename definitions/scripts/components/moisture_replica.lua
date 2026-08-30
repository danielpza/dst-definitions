---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.replicas.moisture
---@field inst any
---@field _iswet any
---@overload fun(inst?: ds.entityscript): ds.replicas.moisture
local Moisture = function(inst) end

---@param iswet any
function Moisture:SetIsWet(iswet) end

function Moisture:IsWet() end

return Moisture
