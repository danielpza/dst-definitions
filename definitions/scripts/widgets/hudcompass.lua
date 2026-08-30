---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.widgets.hudcompass: ds.widgets.widget
---@field owner any
---@field isattached any
---@field bg ds.widgets.uianim
---@field needle ds.widgets.uianim
---@field displayheading number
---@field currentheading number
---@field offsetheading number
---@field forceperdegree number
---@field headingvel number
---@field damping number
---@field easein number
---@field isopen boolean
---@field istransitioning boolean
---@field wantstoclose boolean
---@field ontransout function
---@field ontransin function
---@overload fun(owner?: ds.entityscript, isattached?: any): ds.widgets.hudcompass
local HudCompass = function(owner, isattached) end

function HudCompass:SetMaster() end

function HudCompass:CopyMasterNeedle() end

function HudCompass:OpenCompass() end

function HudCompass:CloseCompass() end

function HudCompass:GetCompassHeading() end

---@param dt number
function HudCompass:OnUpdate(dt) end

return HudCompass
