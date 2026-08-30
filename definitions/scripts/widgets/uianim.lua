---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.widgets.uianim: ds.widgets.widget
local UIAnim = {}

function UIAnim:GetAnimState() end

---@param dir any
function UIAnim:SetFacing(dir) end

function UIAnim:GetBoundingBoxSize() end

function UIAnim:GetVisualBB() end

---@param dbui any
---@param panel any
function UIAnim:DebugDraw_AddSection(dbui, panel) end

return UIAnim
