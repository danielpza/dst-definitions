---@meta

---@class ds.replicas.inventory
local Inventory = {}

---@param slot ds.equipslot
---@return ds.entity | nil
function Inventory:GetEquippedItem(slot) end

---@return ds.entity[]
function Inventory:GetItems() end

---@return ds.entity | nil
function Inventory:GetActiveItem() end

---@return { [ds.equipslot]: ds.entity }
function Inventory:GetEquips() end

---@return ds.components.container | nil # Returns backpack container component
function Inventory:GetOverflowContainer() end

---@param item ds.entity
function Inventory:UseItemFromInvTile(item) end

return Inventory
