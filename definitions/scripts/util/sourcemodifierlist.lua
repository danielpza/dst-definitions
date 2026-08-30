---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.util.sourcemodifierlist
---@field inst any
---@field _modifiers table
---@field _modifier any
---@field _base any
---@field _fn any
---@field _dirtycb any
---@overload fun(inst?: ds.entityscript, base_value?: any, fn?: function, dirtycb?: function): ds.util.sourcemodifierlist
local SourceModifierList = function(inst, base_value, fn, dirtycb) end

function SourceModifierList:Get() end

function SourceModifierList:IsEmpty() end

function SourceModifierList:RecalculateModifier() end

---@param source? any
---@param m? any
---@param key? string
function SourceModifierList:SetModifier(source, m, key) end

---@param source any
---@param key? any
function SourceModifierList:RemoveModifier(source, key) end

function SourceModifierList:Reset() end

---@param source any
---@param key? any
function SourceModifierList:CalculateModifierFromSource(source, key) end

---@param key any
function SourceModifierList:CalculateModifierFromKey(key) end

---@param source any
---@param key? string
function SourceModifierList:HasModifier(source, key) end

function SourceModifierList:HasAnyModifiers() end

return SourceModifierList
