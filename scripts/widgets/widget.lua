---@meta

---@class ds.widget
---@field name string
---@field enabled boolean
---@field shown boolean
---@field focus boolean
---@overload fun(name: string): ds.widget
local Widget = function(name) end

---@param anchor ds.vanchor
function Widget:SetVAnchor(anchor) end

---@param anchor ds.hanchor
function Widget:SetHAnchor(anchor) end

function Widget:MoveToFront() end

function Widget:MoveToBack() end

---@param pos integer
---@param y integer
---@param z integer
function Widget:SetPosition(pos, y, z) end

---@param pos integer
---@param y? integer
---@param z? integer
function Widget:SetScale(pos, y, z) end

---@param child ds.widget
---@return ds.widget
function Widget:AddChild(child) end

return Widget
