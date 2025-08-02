---@meta

---@class ds.replicas.container
local Container = {}

---@param item ds.entity
---@param slot integer
---@return boolean
function Container:CanTakeItemInSlot(item, slot) end

---@param item ds.entity
---@return integer
function Container:GetSpecificSlotForItem(item) end

---@param item ds.entity
---@return boolean
function Container:ShouldPrioritizeContainer(item) end

---@param fn fun(item: ds.entity): boolean
---@return ds.entity
function Container:FindItem(fn) end

---@param slot integer
---@return ds.entity|nil
function Container:GetItemInSlot(slot) end

---@return ds.entity[]
function Container:GetItems() end

---@return boolean
function Container:IsEmpty() end

---@return boolean
function Container:IsFull() end

---@param prefab ds.entity
---@param amount integer
---@param iscrafting boolean
---@return boolean
function Container:Has(prefab, amount, iscrafting) end

---@param tag string
---@param amount integer
---@return boolean
function Container:HasItemWithTag(tag, amount) end

---@return boolean
function Container:IsBusy() end
