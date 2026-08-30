---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.widgets.widget
---@field children table
---@field callbacks table
---@field name string
---@field inst any
---@field enabled boolean
---@field shown boolean
---@field focus boolean
---@field focus_target boolean
---@field can_fade_alpha boolean
---@field focus_flow table
---@field focus_flow_args table
---@field parent_scroll_list any
---@field parent_screen any
---@field tooltip any
---@field tooltip_pos ds.vector3
---@field tooltipcolour table
---@field followhandler any
---@field ongainfocusfn any
---@field onlosefocusfn any
---@field next_in_tab_order any
---@field hovertext_root any
---@field hovertext_bg any
---@field hovertext any
---@field hover any
---@field _OnGainFocus any
---@field _OnLoseFocus any
---@field OnGainFocus function
---@field OnLoseFocus function
---@overload fun(name?: string): ds.widgets.widget
local Widget = function(name) end

---@param update_while_paused? any
function Widget:UpdateWhilePaused(update_while_paused) end

function Widget:IsDeepestFocus() end

---@param button any
---@param down boolean
---@param x number
---@param y number
function Widget:OnMouseButton(button, down, x, y) end

function Widget:MoveToBack() end

function Widget:MoveToFront() end

---@param dir any
---@param down? boolean
function Widget:OnFocusMove(dir, down) end

function Widget:IsVisible() end

---@param key any
---@param down boolean
function Widget:OnRawKey(key, down) end

---@param text string
function Widget:OnTextInput(text) end

function Widget:OnStopForceProcessTextInput() end

---@param control any
---@param down boolean
function Widget:OnControl(control, down) end

---@param list any
function Widget:SetParentScrollList(list) end

function Widget:IsEditing() end

---@param run_complete_fn function
function Widget:CancelScaleTo(run_complete_fn) end

---@param from any
---@param to any
---@param time number
---@param fn function
function Widget:ScaleTo(from, to, time, fn) end

---@param run_complete_fn function
function Widget:CancelMoveTo(run_complete_fn) end

---@param from any
---@param to any
---@param time number
---@param fn function
function Widget:MoveTo(from, to, time, fn) end

---@param run_complete_fn function
function Widget:CancelRotateTo(run_complete_fn) end

---@param from any
---@param to any
---@param time number
---@param fn function
---@param infinite any
function Widget:RotateTo(from, to, time, fn, infinite) end

---@param run_complete_fn function
function Widget:CancelTintTo(run_complete_fn) end

---@param from any
---@param to any
---@param time number
---@param fn function
function Widget:TintTo(from, to, time, fn) end

function Widget:ForceStartWallUpdating() end

function Widget:ForceStopWallUpdating() end

function Widget:IsEnabled() end

function Widget:GetParent() end

function Widget:GetParentScreen() end

function Widget:GetChildren() end

function Widget:Enable() end

function Widget:Disable() end

function Widget:OnEnable() end

function Widget:OnDisable() end

---@param child? ds.widgets.widget
function Widget:RemoveChild(child) end

function Widget:KillAllChildren() end

---@param child ds.widgets.widget
function Widget:AddChild(child) end

function Widget:Hide() end

function Widget:Show() end

function Widget:Kill() end

function Widget:GetWorldPosition() end

function Widget:GetPosition() end

function Widget:GetPositionXYZ() end

function Widget:GetWorldScale() end

---@param offset any
function Widget:Nudge(offset) end

function Widget:GetLocalPosition() end

---@param pos number|ds.vector3
---@param y number
---@param z number
function Widget:SetPosition(pos, y, z) end

---@param angle number
function Widget:SetRotation(angle) end

function Widget:GetRotation() end

---@param val any
function Widget:SetMaxPropUpscale(val) end

---@param mode any
function Widget:SetScaleMode(mode) end

---@param pos number|ds.vector3
---@param y? number
---@param z? number
function Widget:SetScale(pos, y, z) end

---@param event any
function Widget:HasCallback(event) end

---@param event any
---@param fn function
function Widget:HookCallback(event, fn) end

---@param event any
function Widget:UnhookCallback(event) end

---@param anchor ds.vanchor|ds.hanchor
function Widget:SetVAnchor(anchor) end

---@param anchor ds.vanchor|ds.hanchor
function Widget:SetHAnchor(anchor) end

---@param was_hidden any
function Widget:OnShow(was_hidden) end

---@param was_visible any
function Widget:OnHide(was_visible) end

---@param str string
function Widget:SetTooltip(str) end

---@param pos number|ds.vector3
---@param pos_y any
---@param pos_z any
function Widget:SetTooltipPos(pos, pos_y, pos_z) end

---@param r number
---@param g number
---@param b number
---@param a number
function Widget:SetTooltipColour(r, g, b, a) end

function Widget:GetTooltipColour() end

function Widget:GetTooltip() end

function Widget:GetTooltipPos() end

function Widget:StartUpdating() end

function Widget:StopUpdating() end

---@param alpha number
---@param skipChildren? any
function Widget:SetFadeAlpha(alpha, skipChildren) end

---@param fade any
---@param skipChildren? any
function Widget:SetCanFadeAlpha(fade, skipChildren) end

---@param val any
function Widget:SetClickable(val) end

---@param x number
---@param y number
function Widget:UpdatePosition(x, y) end

function Widget:FollowMouse() end

function Widget:StopFollowMouse() end

function Widget:GetScale() end

function Widget:GetLooseScale() end

function Widget:OnGainFocus() end

function Widget:OnLoseFocus() end

---@param fn function
function Widget:SetOnGainFocus(fn) end

---@param fn function
function Widget:SetOnLoseFocus(fn) end

function Widget:ClearFocusDirs() end

---@param dir any
---@param widget any
function Widget:SetFocusChangeDir(dir, widget, ...) end

function Widget:GetDeepestFocus() end

function Widget:GetFocusChild() end

function Widget:ClearFocus() end

---@param from_child any
function Widget:SetFocusFromChild(from_child) end

function Widget:SetFocus() end

---@param indent? number
function Widget:GetStr(indent) end

function Widget:__tostring() end

---@param text? string
---@param params? table
function Widget:SetHoverText(text, params) end

function Widget:ClearHoverText() end

---@param x number
---@param y number
---@param w number
---@param h number
function Widget:SetScissor(x, y, w, h) end

return Widget
