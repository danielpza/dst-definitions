---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.widgets.textedit: ds.widgets.text
---@field limit any
---@field regionlimit boolean
---@field editing boolean
---@field editing_enter_down boolean
---@field allow_newline boolean
---@field enable_accept_control boolean
---@field validrawkeys table
---@field force_edit boolean
---@field pasting boolean
---@field pass_controls_to_screen table
---@field ignore_controls table
---@field idle_text_color table
---@field edit_text_color table
---@field idle_tint table
---@field hover_tint table
---@field selected_tint table
---@field edit_helptext any
---@field cancel_helptext any
---@field apply_helptext any
---@field conversions table
---@field format any
---@field nextTextEditWidget any
---@field focusimage any
---@field atlas any
---@field focusedtex any
---@field unfocusedtex any
---@field activetex any
---@field validchars any
---@field invalidchars any
---@field prediction_widget ds.widgets.wordpredictionwidget
---@field prompt ds.widgets.text
---@overload fun(font?: any, size?: number, text?: string, colour?: any): ds.widgets.textedit
local TextEdit = function(font, size, text, colour) end

---@param dbui any
---@param panel any
function TextEdit:DebugDraw_AddSection(dbui, panel) end

---@param force any
function TextEdit:SetForceEdit(force) end

---@param str string
function TextEdit:SetString(str) end

---@param allow_newline any
function TextEdit:SetAllowNewline(allow_newline) end

---@param editing? any
function TextEdit:SetEditing(editing) end

---@param button any
---@param down boolean
---@param x number
---@param y number
function TextEdit:OnMouseButton(button, down, x, y) end

---@param text string
function TextEdit:ValidateChar(text) end

---@param str string
function TextEdit:ValidatedString(str) end

---@param format? any
function TextEdit:SetFormat(format) end

---@param str string
function TextEdit:FormatString(str) end

---@param in_char any
---@param out_char any
function TextEdit:SetTextConversion(in_char, out_char) end

---@param text? string
function TextEdit:OnTextInput(text) end

function TextEdit:OnProcess() end

---@param texteditwidget? any
function TextEdit:SetOnTabGoToTextEditWidget(texteditwidget) end

function TextEdit:OnStopForceProcessTextInput() end

---@param key any
---@param down? boolean
function TextEdit:OnRawKey(key, down) end

---@param control any
---@param pass any
function TextEdit:SetPassControlToScreen(control, pass) end

---@param control any
---@param ignore any
function TextEdit:SetIgnoreControl(control, ignore) end

---@param control any
---@param down? boolean
function TextEdit:OnControl(control, down) end

---@param dir any
---@param down boolean
function TextEdit:OnFocusMove(dir, down) end

function TextEdit:OnGainFocus() end

function TextEdit:OnLoseFocus() end

function TextEdit:DoHoverImage() end

function TextEdit:DoSelectedImage() end

function TextEdit:DoIdleImage() end

---@param widget any
---@param atlas string
---@param unfocused any
---@param hovered any
---@param active any
function TextEdit:SetFocusedImage(widget, atlas, unfocused, hovered, active) end

---@param r number
---@param g number
---@param b number
---@param a number
function TextEdit:SetIdleTextColour(r, g, b, a) end

---@param r number
---@param g number
---@param b number
---@param a number
function TextEdit:SetEditTextColour(r, g, b, a) end

---@param r number
---@param g number
---@param b number
---@param a number
function TextEdit:SetEditCursorColour(r, g, b, a) end

---@param limit any
function TextEdit:SetTextLengthLimit(limit) end

---@param enable any
function TextEdit:EnableRegionSizeLimit(enable) end

---@param validchars any
function TextEdit:SetCharacterFilter(validchars) end

---@param invalidchars any
function TextEdit:SetInvalidCharacterFilter(invalidchars) end

function TextEdit:GetLineEditString() end

---@param to any
function TextEdit:SetPassword(to) end

---@param to any
function TextEdit:SetForceUpperCase(to) end

---@param enable any
function TextEdit:EnableScrollEditWindow(enable) end

---@param str? string
function TextEdit:SetHelpTextEdit(str) end

---@param str? string
function TextEdit:SetHelpTextCancel(str) end

---@param str? string
function TextEdit:SetHelpTextApply(str) end

function TextEdit:HasExclusiveHelpText() end

function TextEdit:GetHelpText() end

---@param layout any
---@param dictionary? any
function TextEdit:EnableWordPrediction(layout, dictionary) end

---@param dictionary any
function TextEdit:AddWordPredictionDictionary(dictionary) end

---@param prediction_index any
function TextEdit:ApplyWordPrediction(prediction_index) end

function TextEdit:Disable() end

---@param prompt_text any
---@param colour any
function TextEdit:SetTextPrompt(prompt_text, colour) end

function TextEdit:_TryUpdateTextPrompt() end

return TextEdit
