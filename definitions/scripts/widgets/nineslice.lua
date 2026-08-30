---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.widgets.nineslice: ds.widgets.widget
---@field atlas any
---@field mid_center ds.widgets.image
---@field elements table
---@field tail any
---@overload fun(atlas?: string, top_left?: string, top_center?: string, top_right?: string, mid_left?: string, mid_center?: string, mid_right?: string, bottom_left?: string, bottom_center?: string, bottom_right?: string): ds.widgets.nineslice
local NineSlice = function(
   atlas,
   top_left,
   top_center,
   top_right,
   mid_left,
   mid_center,
   mid_right,
   bottom_left,
   bottom_center,
   bottom_right
)
end

---@param dbui any
---@param panel any
function NineSlice:DebugDraw_AddSection(dbui, panel) end

---@param w number
---@param h number
function NineSlice:SetScale(w, h) end

---@param w number
---@param h number
function NineSlice:SetSize(w, h) end

function NineSlice:GetSize() end

---@param image any
---@param hanchor any
---@param vanchor any
---@param offsetX any
---@param offsetY any
function NineSlice:AddCrown(image, hanchor, vanchor, offsetX, offsetY) end

---@param image any
---@param hanchor any
---@param vanchor any
---@param offsetX any
---@param offsetY any
function NineSlice:AddTail(image, hanchor, vanchor, offsetX, offsetY) end

---@param hanchor any
---@param vanchor any
---@param offsetX any
---@param offsetY any
function NineSlice:UpdateTail(hanchor, vanchor, offsetX, offsetY) end

---@param r number
---@param g number
---@param b number
---@param a number
function NineSlice:SetTint(r, g, b, a) end

return NineSlice
