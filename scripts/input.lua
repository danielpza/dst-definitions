---@meta

---@class Input
---@overload fun(): Input
local Input = {
	-- -- all keys, down and up, with key param
	-- onkey = EventProcessor(),
	-- -- specific key up, no parameters
	-- onkeyup = EventProcessor(),
	-- -- specific key down, no parameters
	-- onkeydown = EventProcessor(),
	-- onmousebutton = EventProcessor(),

	-- position = EventProcessor(),
	-- oncontrol = EventProcessor(),
	-- ontextinput = EventProcessor(),
	-- ongesture = EventProcessor(),

	-- hoverinst = nil,
	-- enabledebugtoggle = false,

	-- mouse_enabled = false,

	-- overridepos = nil,
	-- controllerid_cached = nil,
}

function Input:DisableAllControllers() end

function Input:EnableAllControllers() end

function Input:IsControllerLoggedIn(controller) end

---@param cb fun(b: boolean)
function Input:LogUserAsync(controller, cb) end

---@param cb fun(b: boolean)
function Input:LogSecondaryUserAsync(controller, cb) end

---@param enable boolean
function Input:EnableMouse(enable) end

function Input:ClearCachedController() end

function Input:CacheController() end

function Input:TryRecacheController() end

function Input:GetControllerID() end

function Input:ControllerAttached() end

function Input:ControllerConnected() end

-- Get a list of connected input devices and their ids
function Input:GetInputDevices() end

---@param fn fun()
---@return EventHandler
function Input:AddTextInputHandler(fn) end

---@param key number
---@param fn fun()
---@return EventHandler
function Input:AddKeyUpHandler(key, fn) end

---@param key number
---@param fn fun()
---@return EventHandler
function Input:AddKeyDownHandler(key, fn) end

---@param fn fun()
---@return EventHandler
function Input:AddKeyHandler(fn) end

---@param fn fun()
---@return EventHandler
function Input:AddMouseButtonHandler(fn) end

---@param fn fun()
---@return EventHandler
function Input:AddMoveHandler(fn) end

---@param fn fun()
---@return EventHandler
function Input:AddControlHandler(control, fn) end

---@param fn fun()
---@return EventHandler
function Input:AddGeneralControlHandler(fn) end

---@param fn fun()
---@return EventHandler
function Input:AddControlMappingHandler(fn) end

---@param fn fun()
---@return EventHandler
function Input:AddGestureHandler(gesture, fn) end

-- Is for all the button devices (mouse, joystick (even the analog parts), keyboard as well, keyboard

---@return ds.vector3
function Input:GetScreenPosition() end

---@return ds.vector3
function Input:GetWorldPosition() end

---@return ds.entity[]
function Input:GetAllEntitiesUnderMouse() end

---@return ds.entity | nil
function Input:GetWorldEntityUnderMouse() end

-- function Input:EnableDebugToggle(enable) end

-- function Input:IsDebugToggleEnabled() end

-- function Input:GetHUDEntityUnderMouse() end

---@return boolean
function Input:IsMouseDown(button) end

---@param key number
---@return boolean
function Input:IsKeyDown(key) end

---@return boolean
function Input:IsControlPressed(control) end

---------------- Globals

TheInput = Input()

return Input
