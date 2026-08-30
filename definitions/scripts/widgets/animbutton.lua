---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.widgets.animbutton: ds.widgets.button
---@field anim ds.widgets.uianim
---@field animstates any
---@overload fun(animname?: string, states?: any): ds.widgets.animbutton
local AnimButton = function(animname, states) end

function AnimButton:OnGainFocus() end

function AnimButton:OnLoseFocus() end

function AnimButton:Enable() end

function AnimButton:Disable() end

return AnimButton
