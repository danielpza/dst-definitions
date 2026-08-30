---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.components.equippable
---@field onequipfn any
---@field onpocketfn any
---@field onunequipfn any
---@field dapperfn any
---@field onequiptomodelfn any
---@field isequipped boolean
---@field preventunequipping boolean
local Equippable = {}

function Equippable:OnRemoveFromEntity() end

function Equippable:IsInsulated() end

---@param fn function
function Equippable:SetOnEquip(fn) end

---@param fn function
function Equippable:SetOnPocket(fn) end

---@param fn function
function Equippable:SetOnUnequip(fn) end

---@param fn function
function Equippable:SetDappernessFn(fn) end

---@param fn function
function Equippable:SetOnEquipToModel(fn) end

function Equippable:IsEquipped() end

---@param owner ds.entityscript
---@param from_ground any
function Equippable:Equip(owner, from_ground) end

---@param owner ds.entityscript
function Equippable:ToPocket(owner) end

---@param owner ds.entityscript
function Equippable:Unequip(owner) end

function Equippable:GetWalkSpeedMult() end

---@param target any
function Equippable:IsRestricted(target) end

---@param target any
function Equippable:IsRestricted_FromLoad(target) end

function Equippable:ShouldPreventUnequipping() end

---@param shouldprevent? any
function Equippable:SetPreventUnequipping(shouldprevent) end

---@param owner? ds.entityscript
---@param ignore_wetness? any
function Equippable:GetDapperness(owner, ignore_wetness) end

function Equippable:GetEquippedMoisture() end

return Equippable
