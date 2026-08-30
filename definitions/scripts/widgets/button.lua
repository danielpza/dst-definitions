---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.widgets.button: ds.widgets.widget
---@field font any
---@field fontdisabled any
---@field textcolour table
---@field textfocuscolour table
---@field textdisabledcolour table
---@field textselectedcolour table
---@field text ds.widgets.text
---@field clickoffset ds.vector3
---@field selected boolean
---@field control any
---@field mouseonly boolean
---@field help_message any
---@field o_pos ds.vector3
---@field down boolean
---@field onclick any
---@field onselect any
---@field onunselect any
---@field ondown any
---@field whiledown any
---@field size any
---@field name string
---@field text_shadow ds.widgets.text
local Button = {}

---@param dbui any
---@param panel any
function Button:DebugDraw_AddSection(dbui, panel) end

---@param ctrl? any
function Button:SetControl(ctrl) end

---@param control any
---@param down? boolean
function Button:OnControl(control, down) end

---@param dt number
function Button:OnUpdate(dt) end

function Button:OnGainFocus() end

function Button:ResetPreClickPosition() end

function Button:OnLoseFocus() end

function Button:OnEnable() end

function Button:OnDisable() end

function Button:Select() end

function Button:Unselect() end

function Button:OnSelect() end

function Button:OnUnselect() end

function Button:IsSelected() end

function Button:IsDisabledState() end

function Button:IsFocusedState() end

function Button:IsNormalState() end

---@param fn function
function Button:SetOnClick(fn) end

---@param fn function
function Button:SetOnSelect(fn) end

---@param fn function
function Button:SetOnUnSelect(fn) end

---@param fn function
function Button:SetOnUnselect(fn) end

---@param fn function
function Button:SetOnDown(fn) end

---@param fn function
function Button:SetWhileDown(fn) end

---@param font any
function Button:SetFont(font) end

---@param font any
function Button:SetDisabledFont(font) end

---@param r number
---@param g number
---@param b number
---@param a number
function Button:SetTextColour(r, g, b, a) end

---@param r number
---@param g number
---@param b number
---@param a number
function Button:SetTextFocusColour(r, g, b, a) end

---@param r number
---@param g number
---@param b number
---@param a number
function Button:SetTextDisabledColour(r, g, b, a) end

---@param r number
---@param g number
---@param b number
---@param a number
function Button:SetTextSelectedColour(r, g, b, a) end

---@param sz any
function Button:SetTextSize(sz) end

function Button:GetText() end

---@param msg? any
---@param dropShadow? any
---@param dropShadowOffset? any
function Button:SetText(msg, dropShadow, dropShadowOffset) end

---@param str? string
function Button:SetHelpTextMessage(str) end

function Button:GetHelpText() end

return Button
