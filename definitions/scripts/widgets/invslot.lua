---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.widgets.invslot: ds.widgets.itemslot
---@field owner any
---@field container any
---@field num any
---@field highlight_scale number
---@field base_scale number
---@overload fun(num?: any, atlas?: string, bgim?: any, owner?: ds.entityscript, container?: any): ds.widgets.invslot
local InvSlot = function(num, atlas, bgim, owner, container) end

---@param control any
---@param down? boolean
function InvSlot:OnControl(control, down) end

---@param stack_mod? any
function InvSlot:Click(stack_mod) end

---@param stack_mod? any
function InvSlot:CanTradeItem(stack_mod) end

---@param stack_mod? any
function InvSlot:TradeItem(stack_mod) end

---@param single any
function InvSlot:DropItem(single) end

function InvSlot:UseItem() end

function InvSlot:Inspect() end

---@param ingredient? any
---@param amount any
function InvSlot:ConvertToConstructionSlot(ingredient, amount) end

return InvSlot
