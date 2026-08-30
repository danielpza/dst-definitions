---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.replicas.inventory
---@field inst any
---@field opentask any
---@field classified any
---@field ondetachclassified function
---@overload fun(inst?: ds.entityscript): ds.replicas.inventory
local Inventory = function(inst) end

function Inventory:OnRemoveEntity() end

---@param classified any
function Inventory:AttachClassified(classified) end

function Inventory:DetachClassified() end

function Inventory:OnOpen() end

function Inventory:OnClose() end

function Inventory:OnShow() end

function Inventory:OnHide() end

---@param heavylifting any
function Inventory:SetHeavyLifting(heavylifting) end

---@param floaterheld any
function Inventory:SetFloaterHeld(floaterheld) end

function Inventory:GetNumSlots() end

---@param item? any
---@param slot? ds.equipslot
function Inventory:CanTakeItemInSlot(item, slot) end

function Inventory:AcceptsStacks() end

function Inventory:IgnoresCanGoInContainer() end

---@param tag any
function Inventory:EquipHasTag(tag) end

function Inventory:IsHeavyLifting() end

function Inventory:IsFloaterHeld() end

function Inventory:IsVisible() end

---@param guy any
function Inventory:IsOpenedBy(guy) end

---@param item any
---@param checkcontainer any
function Inventory:IsHolding(item, checkcontainer) end

---@param fn function
function Inventory:FindItem(fn) end

function Inventory:GetActiveItem() end

---@param slot ds.equipslot
function Inventory:GetItemInSlot(slot) end

---@param eslot any
function Inventory:GetEquippedItem(eslot) end

---@return ds.entityscript[]
function Inventory:GetItems() end

---@return ds.entityscript[]
function Inventory:GetEquips() end

function Inventory:GetOpenContainers() end

function Inventory:GetOverflowContainer() end

function Inventory:IsFull() end

---@param prefab string
---@param amount any
---@param checkallcontainers any
function Inventory:Has(prefab, amount, checkallcontainers) end

---@param tag any
---@param amount any
function Inventory:HasItemWithTag(tag, amount) end

function Inventory:ReturnActiveItem() end

---@param slot ds.equipslot
function Inventory:PutOneOfActiveItemInSlot(slot) end

---@param slot ds.equipslot
function Inventory:PutAllOfActiveItemInSlot(slot) end

---@param slot ds.equipslot
function Inventory:TakeActiveItemFromHalfOfSlot(slot) end

---@param slot ds.equipslot
function Inventory:TakeActiveItemFromCountOfSlot(slot) end

---@param slot ds.equipslot
function Inventory:TakeActiveItemFromAllOfSlot(slot) end

---@param slot ds.equipslot
function Inventory:AddOneOfActiveItemToSlot(slot) end

---@param slot ds.equipslot
function Inventory:AddAllOfActiveItemToSlot(slot) end

---@param slot ds.equipslot
function Inventory:SwapActiveItemWithSlot(slot) end

---@param item? any
function Inventory:UseItemFromInvTile(item) end

---@param item? any
---@param active_item? any
function Inventory:ControllerUseItemOnItemFromInvTile(item, active_item) end

---@param item? any
function Inventory:ControllerUseItemOnSelfFromInvTile(item) end

---@param item? any
function Inventory:ControllerUseItemOnSceneFromInvTile(item) end

---@param item? any
function Inventory:InspectItemFromInvTile(item) end

---@param item? any
---@param single any
function Inventory:DropItemFromInvTile(item, single) end

---@param item? any
function Inventory:CastSpellBookFromInv(item) end

function Inventory:EquipActiveItem() end

---@param item any
function Inventory:EquipActionItem(item) end

function Inventory:SwapEquipWithActiveItem() end

---@param eslot any
function Inventory:TakeActiveItemFromEquipSlot(eslot) end

---@param slot ds.equipslot
---@param container any
function Inventory:MoveItemFromAllOfSlot(slot, container) end

---@param slot ds.equipslot
---@param container any
function Inventory:MoveItemFromHalfOfSlot(slot, container) end

---@param slot ds.equipslot
---@param container any
---@param count any
function Inventory:MoveItemFromCountOfSlot(slot, container, count) end

return Inventory
