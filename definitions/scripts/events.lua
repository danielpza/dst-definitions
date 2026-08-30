---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.events.eventhandler
---@field event any
---@field fn any
---@field processor any
---@overload fun(event?: any, fn?: function, processor?: any): ds.events.eventhandler
local EventHandler = function(event, fn, processor) end

function EventHandler:Remove() end

---@class ds.events.eventprocessor
---@field events table
local EventProcessor = {}

---@param event any
---@param fn function
function EventProcessor:AddEventHandler(event, fn) end

---@param handler? any
function EventProcessor:RemoveHandler(handler) end

---@param event any
function EventProcessor:GetHandlersForEvent(event) end

---@param event any
function EventProcessor:HandleEvent(event, ...) end

return EventHandler
