---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.widgets.text: ds.widgets.widget
---@field font any
---@field colour table
---@field size number
---@field string any
---@field original_size any
---@field target_font_size any
---@overload fun(font?: any, size?: number, text?: string, colour?: any): ds.widgets.text
local Text = function(font, size, text, colour) end

function Text:__tostring() end

---@param dbui any
---@param panel any
function Text:DebugDraw_AddSection(dbui, panel) end

---@param r number
---@param g number
---@param b number
---@param a number
function Text:SetColour(r, g, b, a) end

function Text:GetColour() end

---@param squeeze any
function Text:SetHorizontalSqueeze(squeeze) end

---@param a number
---@param skipChildren any
function Text:SetFadeAlpha(a, skipChildren) end

---@param a number
function Text:SetAlpha(a) end

---@param a number
function Text:UpdateAlpha(a) end

---@param font any
function Text:SetFont(font) end

---@param sz number
function Text:SetSize(sz) end

function Text:GetSize() end

---@param w number
---@param h number
function Text:SetRegionSize(w, h) end

function Text:GetRegionSize() end

function Text:ResetRegionSize() end

---@param str string
function Text:SetString(str) end

function Text:GetString() end

---@param str? string
---@param maxwidth? any
---@param maxchars? any
---@param ellipses? string
function Text:SetTruncatedString(str, maxwidth, maxchars, ellipses) end

---@param str? string
---@param maxlines any
---@param maxwidth? any
---@param maxcharsperline any
---@param ellipses any
---@param linebreak_string? any
function Text:SetMultilineTruncatedString_Impl(str, maxlines, maxwidth, maxcharsperline, ellipses, linebreak_string) end

function Text:UpdateOriginalSize() end

---@param str? string
---@param maxlines any
---@param maxwidth any
---@param maxcharsperline any
---@param ellipses any
---@param shrink_to_fit? any
---@param min_shrink_font_size any
---@param linebreak_string any
function Text:SetMultilineTruncatedString(
   str,
   maxlines,
   maxwidth,
   maxcharsperline,
   ellipses,
   shrink_to_fit,
   min_shrink_font_size,
   linebreak_string
)
end

---@param str string
---@param max_width any
---@param allow_scaling_up? any
function Text:SetAutoSizingString(str, max_width, allow_scaling_up) end

function Text:RemoveAutoSizing() end

---@param anchor ds.vanchor|ds.hanchor
function Text:SetVAlign(anchor) end

---@param anchor ds.vanchor|ds.hanchor
function Text:SetHAlign(anchor) end

---@param enable any
function Text:EnableWordWrap(enable) end

---@param enable any
function Text:EnableWhitespaceWrap(enable) end

return Text
