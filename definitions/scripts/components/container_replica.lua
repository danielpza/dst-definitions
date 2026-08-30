---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.replicas.container
---@field inst any
---@field _cannotbeopened any
---@field _skipopensnd any
---@field _skipclosesnd any
---@field _isopen boolean
---@field _numslots number
---@field acceptsstacks boolean
---@field usespecificslotsforitems boolean
---@field issidewidget boolean
---@field type any
---@field widget any
---@field itemtestfn any
---@field priorityfn any
---@field opentask any
---@field openers table
---@field opener any
---@field classified any
---@field _onitemget function
---@field _onitemlose function
---@field ondetachclassified function
---@field ondetachopener function
---@field _owner any
---@field _ondropped function
---@field _onputininventory function
---@overload fun(inst?: ds.entityscript): ds.replicas.container
local Container = function(inst) end

function Container:OnRemoveEntity() end

---@param classified any
function Container:AttachClassified(classified) end

function Container:DetachClassified() end

---@param opener any
function Container:AttachOpener(opener) end

function Container:DetachOpener() end

---@param opener any
function Container:AddOpener(opener) end

---@param opener any
function Container:RemoveOpener(opener) end

---@param prefab string
---@param data any
function Container:WidgetSetup(prefab, data) end

function Container:GetWidget() end

---@param numslots any
function Container:SetNumSlots(numslots) end

function Container:GetNumSlots() end

---@param canbeopened any
function Container:SetCanBeOpened(canbeopened) end

function Container:CanBeOpened() end

---@param skipopensnd any
function Container:SetSkipOpenSnd(skipopensnd) end

function Container:ShouldSkipOpenSnd() end

---@param skipclosesnd any
function Container:SetSkipCloseSnd(skipclosesnd) end

function Container:ShouldSkipCloseSnd() end

---@param enable any
function Container:EnableInfiniteStackSize(enable) end

function Container:IsInfiniteStackSize() end

---@param enable any
function Container:EnableReadOnlyContainer(enable) end

function Container:IsReadOnlyContainer() end

---@param item? any
---@param slot? ds.equipslot
function Container:CanTakeItemInSlot(item, slot) end

---@param item any
function Container:GetSpecificSlotForItem(item) end

---@param item any
function Container:ShouldPrioritizeContainer(item) end

function Container:AcceptsStacks() end

function Container:IsSideWidget() end

---@param guy any
function Container:IsOpenedBy(guy) end

---@param item any
---@param checkcontainer any
function Container:IsHolding(item, checkcontainer) end

---@param fn function
function Container:FindItem(fn) end

---@param slot ds.equipslot
function Container:GetItemInSlot(slot) end

function Container:GetItems() end

function Container:IsEmpty() end

function Container:IsFull() end

---@param prefab string
---@param amount any
---@param iscrafting any
function Container:Has(prefab, amount, iscrafting) end

---@param tag any
---@param amount any
function Container:HasItemWithTag(tag, amount) end

---@param doer? any
function Container:Open(doer) end

function Container:Close() end

function Container:IsBusy() end

---@param slot ds.equipslot
function Container:PutOneOfActiveItemInSlot(slot) end

---@param slot ds.equipslot
function Container:PutAllOfActiveItemInSlot(slot) end

---@param slot ds.equipslot
function Container:TakeActiveItemFromHalfOfSlot(slot) end

---@param slot ds.equipslot
---@param count any
function Container:TakeActiveItemFromCountOfSlot(slot, count) end

---@param slot ds.equipslot
function Container:TakeActiveItemFromAllOfSlot(slot) end

---@param slot ds.equipslot
function Container:AddOneOfActiveItemToSlot(slot) end

---@param slot ds.equipslot
function Container:AddAllOfActiveItemToSlot(slot) end

---@param slot ds.equipslot
function Container:SwapActiveItemWithSlot(slot) end

---@param slot ds.equipslot
function Container:SwapOneOfActiveItemWithSlot(slot) end

---@param slot ds.equipslot
---@param container any
function Container:MoveItemFromAllOfSlot(slot, container) end

---@param slot ds.equipslot
---@param container any
function Container:MoveItemFromHalfOfSlot(slot, container) end

---@param slot ds.equipslot
---@param container any
---@param count any
function Container:MoveItemFromCountOfSlot(slot, container, count) end

return Container
