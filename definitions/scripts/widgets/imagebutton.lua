---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.widgets.imagebutton: ds.widgets.button
---@field image ds.widgets.image
---@field scale_on_focus boolean
---@field move_on_click boolean
---@field focus_scale table
---@field normal_scale table
---@field focus_sound any
---@field size_x any
---@field size_y any
---@field atlas string
---@field image_normal string
---@field image_focus string
---@field image_disabled string
---@field image_down string
---@field image_selected string
---@field has_image_down boolean
---@field image_scale table
---@field image_offset table
---@field hover_overlay ds.widgets.image
---@field o_pos ds.vector3
---@field down boolean
---@field imagenormalcolour table
---@field imagefocuscolour table
---@field imagedisabledcolour table
---@field imageselectedcolour table
---@overload fun(atlas?: string, normal?: any, focus?: boolean, disabled?: any, down?: boolean, selected?: boolean, scale?: number, offset?: any): ds.widgets.imagebutton
local ImageButton = function(atlas, normal, focus, disabled, down, selected, scale, offset) end

---@param dbui any
---@param panel any
function ImageButton:DebugDraw_AddSection(dbui, panel) end

---@param x number
---@param y number
function ImageButton:ForceImageSize(x, y) end

---@param atlas? string
---@param normal? string
---@param focus? boolean
---@param disabled? string
---@param down? boolean
---@param selected? boolean
---@param image_scale any
---@param image_offset any
function ImageButton:SetTextures(atlas, normal, focus, disabled, down, selected, image_scale, image_offset) end

function ImageButton:_RefreshImageState() end

---@param focus_selected_texture any
function ImageButton:UseFocusOverlay(focus_selected_texture) end

function ImageButton:OnGainFocus() end

function ImageButton:OnLoseFocus() end

---@param control any
---@param down? boolean
function ImageButton:OnControl(control, down) end

function ImageButton:IsDisabledState() end

function ImageButton:IsFocusedState() end

function ImageButton:IsNormalState() end

function ImageButton:OnDisable() end

function ImageButton:OnSelect() end

function ImageButton:GetSize() end

---@param scaleX any
---@param scaleY any
---@param scaleZ any
function ImageButton:SetFocusScale(scaleX, scaleY, scaleZ) end

---@param scaleX any
---@param scaleY any
---@param scaleZ any
function ImageButton:SetNormalScale(scaleX, scaleY, scaleZ) end

---@param r number
---@param g number
---@param b number
---@param a number
function ImageButton:SetImageNormalColour(r, g, b, a) end

---@param r number
---@param g number
---@param b number
---@param a number
function ImageButton:SetImageFocusColour(r, g, b, a) end

---@param r number
---@param g number
---@param b number
---@param a number
function ImageButton:SetImageDisabledColour(r, g, b, a) end

---@param r number
---@param g number
---@param b number
---@param a number
function ImageButton:SetImageSelectedColour(r, g, b, a) end

---@param sound any
function ImageButton:SetFocusSound(sound) end

return ImageButton
