---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.widgets.inventorybar.inv: ds.widgets.widget
---@field owner any
---@field out_pos ds.vector3
---@field in_pos ds.vector3
---@field base_scale number
---@field selected_scale number
---@field inv ds.widgets.invslot[]
---@field backpackinv table
---@field equip table
---@field equipslotinfo table
---@field root ds.widgets.widget
---@field hudcompass ds.widgets.hudcompass
---@field hand_inv ds.widgets.widget
---@field bg ds.widgets.image
---@field bgcover ds.widgets.widget
---@field hovertile any
---@field cursortile any
---@field repeat_time number
---@field reps number
---@field actionstring ds.widgets.widget
---@field actionstringtitle ds.widgets.text
---@field actionstringbody ds.widgets.text
---@field hovertile_hide_sources ds.util.sourcemodifierlist
---@field hover_tile_visibility boolean
---@field actionstringtime any
---@field openhint ds.widgets.text
---@field hint_update_check any
---@field controller_build any
---@field integrated_backpack any
---@field force_single_drop boolean
---@field autopaused boolean
---@field autopause_delay number
---@field rebuild_pending boolean
---@field cursor any
---@field inspectcontrol any
---@field toprow ds.widgets.widget
---@field toprow_inv ds.widgets.widget
---@field bottomrow ds.widgets.widget
---@field rebuild_snapping any
---@field current_list any
---@field open boolean
---@field pin_nav boolean
---@field active_slot any
---@overload fun(owner?: ds.entityscript): ds.widgets.inventorybar.inv
local Inv = function(owner) end

---@param slot ds.equipslot
---@param atlas string
---@param image any
---@param sortkey? any
function Inv:AddEquipSlot(slot, atlas, image, sortkey) end

function Inv:Rebuild() end

---@param control any
function Inv:RefreshRepeatDelay(control) end

---@param dt number
function Inv:OnUpdate(dt) end

---@param offset any
---@param val? any
---@param minval any
---@param maxval any
---@param slot_is_valid_fn function
function Inv:OffsetCursor(offset, val, minval, maxval, slot_is_valid_fn) end

---@param select_pin? any
function Inv:PinBarNav(select_pin) end

---@param same_container_only? any
function Inv:GetInventoryLists(same_container_only) end

---@param dir any
---@param same_container_only any
function Inv:CursorNav(dir, same_container_only) end

function Inv:CursorLeft() end

function Inv:CursorRight() end

function Inv:CursorUp() end

function Inv:CursorDown() end

---@param lists any
---@param pos number|ds.vector3
---@param dir any
function Inv:GetClosestWidget(lists, pos, dir) end

function Inv:GetCursorItem() end

function Inv:GetCursorSlot() end

---@param control any
---@param down? boolean
function Inv:OnControl(control, down) end

---@param pause any
function Inv:SetAutopausedInternal(pause) end

function Inv:OpenControllerInventory() end

---@param containerwidg any
function Inv:OnNewContainerWidget(containerwidg) end

function Inv:OnEnable() end

function Inv:OnDisable() end

function Inv:CloseControllerInventory() end

---@param item? any
function Inv:GetDescriptionString(item) end

---@param r number
---@param g number
---@param b number
---@param a number
function Inv:SetTooltipColour(r, g, b, a) end

function Inv:UpdateCursorText() end

---@param slot? ds.equipslot
function Inv:SelectSlot(slot) end

function Inv:SelectDefaultSlot() end

function Inv:UpdateCursor() end

---@param skipbackpack? any
function Inv:Refresh(skipbackpack) end

function Inv:RefreshIntegratedContainer() end

---@param source any
---@param hidden any
---@param key any
function Inv:SetHoverTileHideModifier(source, hidden, key) end

---@param placer_shown any
function Inv:OnPlacerChanged(placer_shown) end

---@param enable? any
function Inv:EnableHoverTileVisibility(enable) end

function Inv:Cancel() end

---@param slot? ds.equipslot
function Inv:OnItemLose(slot) end

function Inv:OnBuild() end

---@param item? any
function Inv:OnNewActiveItem(item) end

---@param item any
---@param slot? ds.equipslot
---@param source_pos? any
---@param ignore_stacksize_anim any
function Inv:OnItemGet(item, slot, source_pos, ignore_stacksize_anim) end

---@param item any
---@param slot? ds.equipslot
function Inv:OnItemEquip(item, slot) end

---@param item any
---@param slot? ds.equipslot
function Inv:OnItemUnequip(item, slot) end

function Inv:UpdatePosition() end

function Inv:OnShow() end

function Inv:OnHide() end

function Inv:OnCraftingHidden() end

return Inv
