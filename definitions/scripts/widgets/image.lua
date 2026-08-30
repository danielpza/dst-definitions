---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.widgets.image: ds.widgets.widget
---@field tint table
---@field region_preview any
---@field atlas any
---@field texture any
---@field mouseovertex any
---@field disabledtex any
---@overload fun(atlas?: string, tex?: string, default_tex?: any): ds.widgets.image
local Image = function(atlas, tex, default_tex) end

function Image:__tostring() end

---@param dbui any
---@param panel any
function Image:DebugDraw_AddSection(dbui, panel) end

---@param min number
---@param max number
function Image:SetAlphaRange(min, max) end

---@param atlas string
---@param tex string
---@param default_tex any
function Image:SetTexture(atlas, tex, default_tex) end

---@param atlas string
---@param tex string
function Image:SetMouseOverTexture(atlas, tex) end

---@param atlas string
---@param tex string
function Image:SetDisabledTexture(atlas, tex) end

---@param w number
---@param h number
function Image:SetSize(w, h) end

function Image:GetSize() end

function Image:GetScaledSize() end

---@param w number
---@param h number
function Image:ScaleToSize(w, h) end

---@param w number
---@param h number
function Image:ScaleToSizeIgnoreParent(w, h) end

---@param r number
---@param g number
---@param b number
---@param a number
function Image:SetTint(r, g, b, a) end

---@param a number
---@param skipChildren any
function Image:SetFadeAlpha(a, skipChildren) end

---@param anchor ds.vanchor|ds.hanchor
function Image:SetVRegPoint(anchor) end

---@param anchor ds.vanchor|ds.hanchor
function Image:SetHRegPoint(anchor) end

function Image:OnMouseOver() end

function Image:OnMouseOut() end

function Image:OnEnable() end

function Image:OnDisable() end

---@param filename any
function Image:SetEffect(filename) end

---@param param1 any
---@param param2 any
---@param param3 any
---@param param4 any
function Image:SetEffectParams(param1, param2, param3, param4) end

---@param param1 any
---@param param2 any
---@param param3 any
---@param param4 any
function Image:SetEffectParams2(param1, param2, param3, param4) end

---@param enabled boolean
function Image:EnableEffectParams(enabled) end

---@param enabled boolean
function Image:EnableEffectParams2(enabled) end

---@param xScale any
---@param yScale any
function Image:SetUVScale(xScale, yScale) end

---@param uvmode any
function Image:SetUVMode(uvmode) end

---@param mode any
function Image:SetBlendMode(mode) end

---@param radius any
function Image:SetRadiusForRayTraces(radius) end

return Image
