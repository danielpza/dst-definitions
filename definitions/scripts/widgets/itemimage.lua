---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.widgets.itemimage: ds.widgets.widget
---@field screen any
---@field type any
---@field name any
---@field item_id any
---@field clickFn any
---@field frame ds.widgets.uianim
---@field new_tag ds.widgets.text
---@field warning boolean
---@field warn_marker ds.widgets.image
---@field disable_selecting boolean
---@field rarity string
---@field clicked boolean
---@overload fun(screen?: any, type?: any, name?: string, item_id?: any, timestamp?: any, clickFn?: function): ds.widgets.itemimage
local ItemImage = function(screen, type, name, item_id, timestamp, clickFn) end

---@param name string
---@param pushdefault? any
function ItemImage:PlaySpecialAnimation(name, pushdefault) end

function ItemImage:PlayDefaultAnim() end

function ItemImage:DisableSelecting() end

---@param type? any
---@param name? string
---@param item_id any
---@param timestamp? any
function ItemImage:SetItem(type, name, item_id, timestamp) end

function ItemImage:ClearFrame() end

---@param rarity any
function ItemImage:SetItemRarity(rarity) end

---@param value any
function ItemImage:Mark(value) end

function ItemImage:OnGainFocus() end

function ItemImage:OnLoseFocus() end

function ItemImage:OnEnable() end

function ItemImage:OnDisable() end

function ItemImage:Embiggen() end

function ItemImage:Shrink() end

---@param control any
---@param down? boolean
function ItemImage:OnControl(control, down) end

function ItemImage:Select() end

function ItemImage:Unselect() end

return ItemImage
