---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.replicas.sheltered
---@field inst any
---@field _updating boolean
---@field _shade any
---@field _targetshade any
---@field _shelterspeed number
---@field _exposespeed number
---@field _issheltered any
---@field _task any
---@overload fun(inst?: ds.entityscript): ds.replicas.sheltered
local Sheltered = function(inst) end

---@param level any
function Sheltered:StartSheltered(level) end

function Sheltered:StopSheltered() end

function Sheltered:IsSheltered() end

function Sheltered:CheckShade() end

---@param dt number
function Sheltered:OnUpdate(dt) end

return Sheltered
