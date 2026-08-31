---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.widgets.itemslot: ds.widgets.widget
---@field owner any
---@field bgimage ds.widgets.image
---@field tile any
---@field highlight_scale number
---@field base_scale number
---@field highlight boolean
---@field big boolean
---@field ontilechangedfn any
---@field bgimage2 ds.widgets.image
---@field label ds.widgets.text
---@field readonlyvisual ds.widgets.image
---@overload fun(atlas?: string, bgim?: any, owner?: ds.entityscript): ds.widgets.itemslot
local ItemSlot = function(atlas, bgim, owner) end

function ItemSlot:LockHighlight() end

function ItemSlot:UnlockHighlight() end

function ItemSlot:Highlight() end

function ItemSlot:DeHighlight() end

function ItemSlot:OnGainFocus() end

function ItemSlot:OnLoseFocus() end

---@param tile? any
function ItemSlot:SetTile(tile) end

---@param fn function
function ItemSlot:SetOnTileChangedFn(fn) end

---@param atlas? string
---@param img? any
---@param tint? any
function ItemSlot:SetBGImage2(atlas, img, tint) end

---@param msg? any
---@param colour any
function ItemSlot:SetLabel(msg, colour) end

---@param enabled? boolean
function ItemSlot:SetReadOnlyVisuals(enabled) end

return ItemSlot
