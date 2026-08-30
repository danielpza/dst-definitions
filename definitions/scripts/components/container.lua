---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.components.container
---@field numslots any
---@field opencount number
---@field currentuser any
---@field ignoresound boolean
---@field ignoreoverstacked boolean
---@field readonlycontainer_addedpreserver boolean
local Container = {}

---@param prefab string
---@param data any
function Container:WidgetSetup(prefab, data) end

function Container:GetWidget() end

function Container:NumItems() end

function Container:IsFull() end

function Container:IsEmpty() end

---@param numslots any
function Container:SetNumSlots(numslots) end

---@param slot? ds.equipslot
---@param drop_pos? ds.vector3
---@param keepoverstacked any
function Container:DropItemBySlot(slot, drop_pos, keepoverstacked) end

---@param tag any
---@param drop_pos any
---@param keepoverstacked any
function Container:DropEverythingWithTag(tag, drop_pos, keepoverstacked) end

---@param filterfn function
function Container:DropEverythingByFilter(filterfn) end

---@param drop_pos any
---@param keepoverstacked any
function Container:DropEverything(drop_pos, keepoverstacked) end

---@param maxstacks any
---@param drop_pos any
function Container:DropEverythingUpToMaxStacks(maxstacks, drop_pos) end

---@param itemtodrop any
function Container:DropItem(itemtodrop) end

---@param item any
function Container:DropOverstackedExcess(item) end

---@param itemtodrop? any
---@param x number
---@param y number
---@param z number
function Container:DropItemAt(itemtodrop, x, y, z) end

---@param item? any
---@param slot? ds.equipslot
function Container:CanTakeItemInSlot(item, slot) end

---@param item any
function Container:GetSpecificSlotForItem(item) end

---@param item any
function Container:ShouldPrioritizeContainer(item) end

function Container:AcceptsStacks() end

function Container:IsSideWidget() end

---@param onpredestroyitemcallbackfn function
function Container:DestroyContents(onpredestroyitemcallbackfn) end

---@param filterfn? function
---@param onpredestroyitemcallbackfn function
function Container:DestroyContentsConditionally(filterfn, onpredestroyitemcallbackfn) end

---@param item any
---@param maxcount any
function Container:CanAcceptCount(item, maxcount) end

---@param item? any
---@param slot? ds.equipslot
---@param src_pos any
---@param drop_on_fail any
function Container:GiveItem(item, slot, src_pos, drop_on_fail) end

---@param slot? ds.equipslot
---@param keepoverstacked any
function Container:RemoveItemBySlot(slot, keepoverstacked) end

function Container:RemoveAllItems() end

function Container:GetNumSlots() end

---@param slot? ds.equipslot
function Container:GetItemInSlot(slot) end

---@param item any
function Container:GetItemSlot(item) end

function Container:GetAllItems() end

---@param doer? any
function Container:Open(doer) end

---@param doer? any
function Container:Close(doer) end

function Container:IsOpen() end

---@param guy any
function Container:IsOpenedBy(guy) end

---@param guy any
function Container:IsOpenedByOthers(guy) end

function Container:CanOpen() end

function Container:GetOpeners() end

---@param item any
---@param checkcontainer any
function Container:IsHolding(item, checkcontainer) end

---@param fn function
function Container:FindItem(fn) end

---@param fn function
function Container:FindItems(fn) end

---@param fn function
function Container:ForEachItem(fn, ...) end

function Container:GetSpecializedContainers() end

---@param container any
function Container:IsSpecializedContainer(container) end

---@param item any
---@param amount any
---@param iscrafting any
function Container:Has(item, amount, iscrafting) end

---@param fn function
---@param amount any
function Container:HasItemThatMatches(fn, amount) end

---@param tag any
---@param amount any
function Container:HasItemWithTag(tag, amount) end

---@param tag any
function Container:GetItemsWithTag(tag) end

---@param item any
---@param amount any
function Container:GetItemByName(item, amount) end

---@param item any
---@param amount any
---@param reverse_search_order any
function Container:GetCraftingIngredient(item, amount, reverse_search_order) end

---@param item any
---@param amount any
function Container:ConsumeByName(item, amount) end

function Container:OnSave() end

---@param data any
---@param newents any
function Container:OnLoad(data, newents) end

---@param item? any
---@param wholestack any
---@param _checkallcontainers_ any
---@param keepoverstacked any
function Container:RemoveItem(item, wholestack, _checkallcontainers_, keepoverstacked) end

---@param item any
---@param slot ds.equipslot
---@param wholestack? any
---@param keepoverstacked? any
function Container:RemoveItem_Internal(item, slot, wholestack, keepoverstacked) end

---@param dt number
function Container:OnUpdate(dt) end

---@param slot ds.equipslot
---@param opener any
function Container:PutOneOfActiveItemInSlot(slot, opener) end

---@param slot ds.equipslot
---@param opener any
function Container:PutAllOfActiveItemInSlot(slot, opener) end

---@param slot ds.equipslot
---@param opener any
function Container:TakeActiveItemFromHalfOfSlot(slot, opener) end

---@param slot ds.equipslot
---@param count any
---@param opener any
function Container:TakeActiveItemFromCountOfSlot(slot, count, opener) end

---@param slot ds.equipslot
---@param opener any
function Container:TakeActiveItemFromAllOfSlot(slot, opener) end

---@param slot ds.equipslot
---@param opener any
function Container:AddOneOfActiveItemToSlot(slot, opener) end

---@param slot ds.equipslot
---@param opener any
function Container:AddAllOfActiveItemToSlot(slot, opener) end

---@param slot ds.equipslot
---@param opener any
function Container:SwapActiveItemWithSlot(slot, opener) end

---@param slot ds.equipslot
---@param opener any
function Container:SwapOneOfActiveItemWithSlot(slot, opener) end

---@param slot ds.equipslot
---@param container? any
---@param opener any
function Container:MoveItemFromAllOfSlot(slot, container, opener) end

---@param slot ds.equipslot
---@param container? any
---@param opener any
function Container:MoveItemFromHalfOfSlot(slot, container, opener) end

---@param slot ds.equipslot
---@param container? any
---@param count any
---@param opener any
function Container:MoveItemFromCountOfSlot(slot, container, count, opener) end

function Container:ReferenceAllItems() end

---@param enable? any
function Container:EnableInfiniteStackSize(enable) end

---@param enable? any
function Container:EnableReadOnlyContainer(enable) end

---@param target any
function Container:IsRestricted(target) end

function Container:IsThiefProof() end

return Container
