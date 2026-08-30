---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.replicas.stackable
---@field inst any
---@field _stacksize any
---@field _stacksizeupper any
---@field _ignoremaxsize any
---@field _maxsize any
---@field _previewstacksize table
---@field _previewtimeouttask any
---@overload fun(inst?: ds.entityscript): ds.replicas.stackable
local Stackable = function(inst) end

---@param stacksize number
function Stackable:SetStackSize(stacksize) end

---@param stacksize any
---@param context any
---@param timeout any
function Stackable:SetPreviewStackSize(stacksize, context, timeout) end

function Stackable:ClearPreviewStackSize() end

function Stackable:GetPreviewStackSize() end

---@param maxsize any
function Stackable:SetMaxSize(maxsize) end

---@param ignoremaxsize any
function Stackable:SetIgnoreMaxSize(ignoremaxsize) end

function Stackable:StackSize() end

function Stackable:MaxSize() end

function Stackable:OriginalMaxSize() end

function Stackable:IsStack() end

function Stackable:IsFull() end

function Stackable:IsOverStacked() end

---@param item any
function Stackable:CanStackWith(item) end

return Stackable
