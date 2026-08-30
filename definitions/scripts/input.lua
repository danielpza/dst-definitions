---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.input
---@field onkey any
---@field onkeyup any
---@field onkeydown any
---@field onmousebutton any
---@field position any
---@field oncontrol any
---@field ontextinput any
---@field ongesture any
---@field hoverinst any
---@field enabledebugtoggle boolean
---@field mouse_enabled boolean
---@field overridepos any
---@field controllerid_cached any
---@field vk_text_widget any
---@field hovervalid boolean
---@field entitiesundermouse any
local Input = {}

function Input:DisableAllControllers() end

function Input:EnableAllControllers() end

---@param controller any
function Input:IsControllerLoggedIn(controller) end

---@param controller any
---@param cb function
function Input:LogUserAsync(controller, cb) end

---@param controller any
---@param cb function
function Input:LogSecondaryUserAsync(controller, cb) end

---@param enable any
function Input:EnableMouse(enable) end

function Input:ClearCachedController() end

function Input:CacheController() end

function Input:TryRecacheController() end

function Input:GetControllerID() end

function Input:ControllerAttached() end

function Input:ControllerConnected() end

function Input:GetInputDevices() end

---@param fn function
function Input:AddTextInputHandler(fn) end

---@param key any
---@param fn function
function Input:AddKeyUpHandler(key, fn) end

---@param key any
---@param fn function
function Input:AddKeyDownHandler(key, fn) end

---@param fn function
function Input:AddKeyHandler(fn) end

---@param fn function
function Input:AddMouseButtonHandler(fn) end

---@param fn function
function Input:AddMoveHandler(fn) end

---@param control any
---@param fn function
function Input:AddControlHandler(control, fn) end

---@param fn function
function Input:AddGeneralControlHandler(fn) end

---@param fn function
function Input:AddControlMappingHandler(fn) end

---@param gesture any
---@param fn function
function Input:AddGestureHandler(gesture, fn) end

---@param x number
---@param y number
function Input:UpdatePosition(x, y) end

---@param control any
---@param digitalvalue any
---@param analogvalue any
function Input:OnControl(control, digitalvalue, analogvalue) end

---@param x number
---@param y number
function Input:OnMouseMove(x, y) end

---@param button any
---@param down boolean
---@param x number
---@param y number
function Input:OnMouseButton(button, down, x, y) end

---@param key any
---@param down? boolean
function Input:OnRawKey(key, down) end

---@param text string
function Input:OnText(text) end

function Input:OnFloatingTextInputDismissed() end

---@param for_text_widget? any
function Input:AbortVirtualKeyboard(for_text_widget) end

---@param text_widget any
function Input:OpenVirtualKeyboard(text_widget) end

---@param gesture any
function Input:OnGesture(gesture) end

---@param deviceId any
---@param controlId any
---@param inputId any
---@param hasChanged any
function Input:OnControlMapped(deviceId, controlId, inputId, hasChanged) end

function Input:OnFrameStart() end

function Input:GetScreenPosition() end

function Input:GetWorldPosition() end

---@param height number
function Input:GetWorldXZWithHeight(height) end

function Input:GetAllEntitiesUnderMouse() end

function Input:GetWorldEntityUnderMouse() end

---@param enable any
function Input:EnableDebugToggle(enable) end

function Input:IsDebugToggleEnabled() end

function Input:GetHUDEntityUnderMouse() end

---@param button any
function Input:IsMouseDown(button) end

---@param key any
function Input:IsKeyDown(key) end

---@param control? any
function Input:ResolveVirtualControls(control) end

---@param control any
function Input:IsControlPressed(control) end

---@param control any
function Input:GetAnalogControlValue(control) end

---@param schemeId any
function Input:GetActiveControlScheme(schemeId) end

function Input:SupportsControllerFreeAiming() end

function Input:SupportsControllerFreeCamera() end

---@param key any
function Input:IsPasteKey(key) end

function Input:UpdateEntitiesUnderMouse() end

function Input:OnUpdate() end

---@param deviceId any
---@param controlId any
function Input:IsControlMapped(deviceId, controlId) end

---@param deviceId any
---@param controlId_1 any
---@param controlId_2 any
function Input:ControlsHaveSameMapping(deviceId, controlId_1, controlId_2) end

---@param deviceId any
---@param controlId any
---@param use_default_mapping any
---@param use_control_mapper any
function Input:GetLocalizedControl(deviceId, controlId, use_default_mapping, use_control_mapper) end

---@param deviceId any
---@param controlId number
---@param use_default_mapping any
---@param use_control_mapper any
function Input:GetLocalizedVirtualControl(deviceId, controlId, use_default_mapping, use_control_mapper) end

---@param deviceId any
---@param controlIdStr any
---@param modifierId any
---@param use_modifier? any
function Input:GetLocalizedVirtualDirectionalControl(deviceId, controlIdStr, modifierId, use_modifier) end

---@param controlId any
function Input:GetControlIsMouseWheel(controlId) end

---@param str string
function Input:GetStringIsButtonImage(str) end

function Input:PlatformUsesVirtualKeyboard() end

return Input
