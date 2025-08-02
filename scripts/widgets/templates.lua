---@meta

local TEMPLATES = {}

-----------------
-----------------
-- ICON BUTTON --
-----------------
-----------------
-- For making a square button that has a custom icon on it and has a text label
-- Text label offset can be specified, as well as whether or not it always shows

---@param iconAtlas string
---@param iconTexture string
---@param labelText string
---@param sideLabel? string
---@param alwaysShowLabel? boolean
---@return ds.widget
function TEMPLATES.IconButton(
   iconAtlas,
   iconTexture,
   labelText,
   sideLabel,
   alwaysShowLabel,
   onclick,
   textinfo,
   defaultTexture
)
end

return TEMPLATES
