---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.vector3
---@field x number
---@field y number
---@field z number
---@overload fun(x?: number, y?: number, z?: number): ds.vector3
local Vector3 = function(x, y, z) end

---@param rhs any
function Vector3:__add(rhs) end

---@param rhs any
function Vector3:__sub(rhs) end

---@param rhs any
function Vector3:__mul(rhs) end

---@param rhs any
function Vector3:__div(rhs) end

function Vector3:__unm() end

---@param rhs any
function Vector3:Dot(rhs) end

---@param rhs any
function Vector3:Cross(rhs) end

function Vector3:__tostring() end

---@param rhs any
function Vector3:__eq(rhs) end

---@param other any
function Vector3:DistSq(other) end

---@param other any
function Vector3:Dist(other) end

function Vector3:LengthSq() end

function Vector3:Length() end

function Vector3:Normalize() end

function Vector3:GetNormalized() end

function Vector3:GetNormalizedAndLength() end

function Vector3:Get() end

function Vector3:IsVector3() end

return Vector3
