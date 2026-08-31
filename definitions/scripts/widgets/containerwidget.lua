---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.widgets.containerwidget: ds.widgets.widget
---@field open boolean
---@field inv table
---@field owner any
---@field slotsperrow number
---@field bganim ds.widgets.uianim
---@field bgimage any
---@field isopen boolean
---@field button ds.widgets.imagebutton
---@field onitemlosefn function
---@field onitemgetfn function
---@field onrefreshfn function
---@field container any
---@overload fun(owner?: ds.entityscript): ds.widgets.containerwidget
local ContainerWidget = function(owner) end

---@param container any
---@param doer? any
function ContainerWidget:Open(container, doer) end

function ContainerWidget:RefreshPosition() end

function ContainerWidget:Refresh() end

---@param data any
function ContainerWidget:OnItemGet(data) end

---@param data any
function ContainerWidget:OnItemLose(data) end

function ContainerWidget:Close() end

return ContainerWidget
