---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.replicas.equippable
---@field inst any
---@field _equipslot any
---@field _preventunequipping any
---@overload fun(inst?: ds.entityscript): ds.replicas.equippable
local Equippable = function(inst) end

---@param eslot any
function Equippable:SetEquipSlot(eslot) end

function Equippable:EquipSlot() end

function Equippable:IsEquipped() end

---@param target any
function Equippable:IsRestricted(target) end

function Equippable:ShouldPreventUnequipping() end

---@param shouldprevent any
function Equippable:SetPreventUnequipping(shouldprevent) end

return Equippable
