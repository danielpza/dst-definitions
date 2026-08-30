---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.widgets.spinner: ds.widgets.widget
---@field width any
---@field height any
---@field lean any
---@field control_prev any
---@field control_next any
---@field atlas any
---@field textures any
---@field textinfo any
---@field editable boolean
---@field options any
---@field selectedIndex number
---@field textsize table
---@field arrow_scale number
---@field textcolour table
---@field background ds.widgets.image
---@field leftimage ds.widgets.imagebutton
---@field rightimage ds.widgets.imagebutton
---@field fgimage ds.widgets.image
---@field text any
---@field updating boolean
---@field changing boolean
---@field changed_image ds.widgets.image
---@field SetHasModification function
---@field mute_negative_sound any
---@field left_hint ds.widgets.text
---@field right_hint ds.widgets.text
---@field hints_enabled boolean
---@field virtual_hints_enabled_fn any
---@field onclick any
---@field onchangedfn any
---@field enableWrap any
---@overload fun(options?: any, width?: number, height?: number, textinfo?: any, editable?: any, atlas?: string, textures?: any, lean?: any, textwidth?: any, textheight?: any): ds.widgets.spinner
local Spinner = function(options, width, height, textinfo, editable, atlas, textures, lean, textwidth, textheight) end

---@param dbui any
---@param panel any
function Spinner:DebugDraw_AddSection(dbui, panel) end

function Spinner:EnablePendingModificationBackground() end

---@param dir any
---@param down? boolean
function Spinner:OnFocusMove(dir, down) end

function Spinner:OnGainFocus() end

function Spinner:GetHelpText() end

---@param control_prev any
---@param control_next any
---@param mute_negative_sound any
function Spinner:AddControllerHints(control_prev, control_next, mute_negative_sound) end

function Spinner:ShowHints() end

function Spinner:HideHints() end

function Spinner:OnLoseFocus() end

---@param control any
---@param down? boolean
function Spinner:OnControl(control, down) end

function Spinner:UpdateBG() end

---@param r number
---@param g number
---@param b number
---@param a number
function Spinner:SetTextColour(r, g, b, a) end

function Spinner:Enable() end

function Spinner:Disable() end

---@param font any
function Spinner:SetFont(font) end

---@param fn function
function Spinner:SetOnClick(fn) end

---@param sz any
function Spinner:SetTextSize(sz) end

function Spinner:GetWidth() end

function Spinner:Layout() end

---@param align any
function Spinner:SetTextHAlign(align) end

---@param align any
function Spinner:SetTextVAlign(align) end

---@param noclicksound? any
function Spinner:Next(noclicksound) end

---@param noclicksound? any
function Spinner:Prev(noclicksound) end

function Spinner:GetSelected() end

function Spinner:GetSelectedIndex() end

function Spinner:GetSelectedText() end

function Spinner:GetSelectedImage() end

function Spinner:GetSelectedData() end

---@param idx any
function Spinner:SetSelectedIndex(idx) end

---@param data any
function Spinner:SetSelected(data) end

---@param msg any
function Spinner:UpdateText(msg) end

function Spinner:GetText() end

function Spinner:OnNext() end

function Spinner:OnPrev() end

---@param oldSelection any
function Spinner:Changed(oldSelection) end

---@param fn function
function Spinner:SetOnChangedFn(fn) end

---@param selected boolean
---@param old any
function Spinner:OnChanged(selected, old) end

function Spinner:MinIndex() end

function Spinner:MaxIndex() end

---@param enable any
function Spinner:SetWrapEnabled(enable) end

---@param controller_mode? any
function Spinner:RefreshControllers(controller_mode) end

function Spinner:RefreshVirtualControllerHints() end

function Spinner:UpdateState() end

---@param options any
function Spinner:SetOptions(options) end

---@param dt number
function Spinner:OnUpdate(dt) end

return Spinner
