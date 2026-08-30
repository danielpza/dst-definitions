---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.scheduler.task
---@field guid any
---@field param any
---@field id any
---@field fn any
---@field co any
---@field list any
---@overload fun(fn?: function, id?: any, param?: any): ds.scheduler.task
local Task = function(fn, id, param) end

function Task:__tostring() end

---@param list? any
function Task:SetList(list) end

---@class ds.scheduler.periodic
---@field fn any
---@field id any
---@field period any
---@field limit any
---@field nexttick any
---@field list any
---@field onfinish any
---@field arg any
---@overload fun(fn?: function, period?: any, limit?: any, id?: any, nexttick?: any): ds.scheduler.periodic
local Periodic = function(fn, period, limit, id, nexttick) end

function Periodic:Cancel() end

function Periodic:NextTime() end

function Periodic:Cleanup() end

function Periodic:__tostring() end

---@class ds.scheduler
---@field tasks table
---@field running table
---@field waitingfortick table
---@field waking table
---@field hibernating table
---@field attime table
---@field isstatic any
---@overload fun(isstatic?: any): ds.scheduler
local Scheduler = function(isstatic) end

function Scheduler:__tostring() end

---@param task any
function Scheduler:KillTask(task) end

---@param fn function
---@param id any
---@param param any
function Scheduler:AddTask(fn, id, param) end

---@param tick any
function Scheduler:OnTick(tick) end

function Scheduler:Run() end

function Scheduler:KillAll() end

---@param timefromnow any
---@param fn function
---@param id any
function Scheduler:ExecuteInTime(timefromnow, fn, id, ...) end

---@param dt number
function Scheduler:GetListForTimeFromNow(dt) end

---@param period any
---@param fn function
---@param limit any
---@param initialdelay any
---@param id any
function Scheduler:ExecutePeriodic(period, fn, limit, initialdelay, id, ...) end

---@param id any
function Scheduler:KillTasksWithID(id) end

function Scheduler:GetCurrentTask() end

return Task
