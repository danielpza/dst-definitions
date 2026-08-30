---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.bufferedaction
---@field doer any
---@field target any
---@field initialtargetowner any
---@field action any
---@field invobject any
---@field doerownsobject any
---@field pos any
---@field rotation number
---@field onsuccess table
---@field onfail table
---@field recipe any
---@field options table
---@field distance any
---@field arrivedist any
---@field forced any
---@field autoequipped any
---@field skin any
---@field reason any
---@overload fun(doer?: any, target?: any, action?: any, invobject?: any, pos?: number|ds.vector3, recipe?: any, distance?: any, forced?: any, rotation?: any, arrivedist?: any): ds.bufferedaction
local BufferedAction = function(
   doer,
   target,
   action,
   invobject,
   pos,
   recipe,
   distance,
   forced,
   rotation,
   arrivedist
)
end

function BufferedAction:Do() end

function BufferedAction:IsValid() end

function BufferedAction:GetActionString() end

function BufferedAction:__tostring() end

---@param fn function
function BufferedAction:AddFailAction(fn) end

---@param fn function
function BufferedAction:AddSuccessAction(fn) end

function BufferedAction:Succeed() end

function BufferedAction:GetActionPoint() end

function BufferedAction:GetDynamicActionPoint() end

---@param pt any
function BufferedAction:SetActionPoint(pt) end

function BufferedAction:Fail() end

return BufferedAction
