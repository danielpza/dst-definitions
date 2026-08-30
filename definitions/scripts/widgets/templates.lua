---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.widgets.templates.iconbutton: ds.widgets.imagebutton
---@field icon ds.widgets.image
---@field highlight ds.widgets.image
---@field label? ds.widgets.text

---@class ds.widgets.templates
local TEMPLATES = {}

---@return ds.widgets.widget
function TEMPLATES.NoPortalBackground() end

---@return ds.widgets.widget
function TEMPLATES.AnimatedPortalBackground() end

---@return ds.widgets.widget
function TEMPLATES.BackgroundPlate() end

---@return ds.widgets.uianim
function TEMPLATES.BackgroundSmoke() end

---@return ds.widgets.uianim
function TEMPLATES.BackgroundPortal() end

---@return ds.widgets.image
function TEMPLATES.BackgroundSpiral() end

---@return ds.widgets.image
function TEMPLATES.BackgroundVignette() end

---@param a? number
---@param rgb? ds.vector3|number[]
---@return ds.widgets.image
function TEMPLATES.BackgroundTint(a, rgb) end

---@return ds.widgets.widget
function TEMPLATES.LeftGradient() end

---@return ds.widgets.widget
function TEMPLATES.RightGradient() end

---@return ds.widgets.widget
function TEMPLATES.AnimatedPortalForeground() end

---@return ds.widgets.widget
function TEMPLATES.ForegroundPlate() end

---@return ds.widgets.uianim
function TEMPLATES.ForegroundSmokeWest() end

---@return ds.widgets.uianim
function TEMPLATES.ForegroundSmokeEast() end

---@return ds.widgets.uianim
function TEMPLATES.ForegroundSmokeSouth() end

---@return ds.widgets.uianim
function TEMPLATES.ForegroundSmokeInside() end

---@return ds.widgets.widget
function TEMPLATES.ForegroundTrees() end

---@return ds.widgets.widget
function TEMPLATES.ForegroundLetterbox() end

---@param back any
---@return ds.widgets.widget
function TEMPLATES.ForegroundPerdFront(back) end

---@return ds.widgets.widget
function TEMPLATES.ForegroundPerdBack() end

---@param sizeX any
---@param sizeY any
---@param scaleX any
---@param scaleY any
---@param topCrownOffset any
---@param bottomCrownOffset any
---@param xOffset any
---@return ds.widgets.nineslice
function TEMPLATES.CurlyWindow(sizeX, sizeY, scaleX, scaleY, topCrownOffset, bottomCrownOffset, xOffset) end

---@param frame_x_scale? number
---@param frame_y_scale? number
---@param skipPos? any
---@param x_size any
---@param y_size any
---@param topCrownOffset any
---@param bottomCrownOffset any
---@param bg_x_scale any
---@param bg_y_scale any
---@param bg_x_pos any
---@param bg_y_pos any
---@return ds.widgets.widget
function TEMPLATES.CenterPanel(
   frame_x_scale,
   frame_y_scale,
   skipPos,
   x_size,
   y_size,
   topCrownOffset,
   bottomCrownOffset,
   bg_x_scale,
   bg_y_scale,
   bg_x_pos,
   bg_y_pos
)
end

---@param x_scale? any
---@param y_scale? any
---@param skipPos? any
---@return ds.widgets.widget
function TEMPLATES.CenterPanelOld(x_scale, y_scale, skipPos) end

---@param title? any
---@param height? number
---@return ds.widgets.widget
function TEMPLATES.NavBarWithScreenTitle(title, height) end

---@param yPos any
---@param buttonText any
---@param onclick any
---@param truncate? any
---@return ds.widgets.button
function TEMPLATES.NavBarButton(yPos, buttonText, onclick, truncate) end

---@param xPos any
---@param yPos any
---@param buttonText any
---@param onclick any
---@param tabSize? any
---@return ds.widgets.imagebutton
function TEMPLATES.TabButton(xPos, yPos, buttonText, onclick, tabSize) end

---@param onclick any
---@param txt any
---@param txt_offset? ds.vector3|number[]
---@param shadow_offset? ds.vector3|number[]
---@param scale number
---@return ds.widgets.imagebutton
function TEMPLATES.BackButton(onclick, txt, txt_offset, shadow_offset, scale) end

---@param iconAtlas any
---@param iconTexture any
---@param bgColor? ds.vector3|number[]
---@param hoverText? any
---@param textinfo? table
---@param imgOffset? ds.vector3|number[]
---@param scaleX any
---@param scaleY any
---@return ds.widgets.widget
function TEMPLATES.ServerDetailIcon(iconAtlas, iconTexture, bgColor, hoverText, textinfo, imgOffset, scaleX, scaleY) end

---@param width number
---@param height number
---@param onclick any
---@param onfocus any
---@return ds.widgets.imagebutton
function TEMPLATES.InvisibleButton(width, height, onclick, onfocus) end

---@param iconAtlas any
---@param iconTexture any
---@param labelText any
---@param sideLabel? any
---@param alwaysShowLabel? any
---@param onclick any
---@param textinfo? table
---@param defaultTexture any
---@return ds.widgets.templates.iconbutton
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

---@param text string
---@param cb function
---@return ds.widgets.imagebutton
function TEMPLATES.Button(text, cb) end

---@param text string
---@param fontsize any
---@param scale number
---@param cb function
---@return ds.widgets.imagebutton
function TEMPLATES.SmallButton(text, fontsize, scale, cb) end

---@param animname string
---@param states any
---@param scale number
---@param cb function
---@param text string
---@param size number
---@return ds.widgets.animbutton
function TEMPLATES.AnimTextButton(animname, states, scale, cb, text, size) end

---@param text string
---@param onClickFn function
---@return ds.widgets.widget
function TEMPLATES.TextMenuItem(text, onClickFn) end

---@param modname? any
---@param modinfo? any
---@param modstatus any
---@param isenabled? any
---@return ds.widgets.widget
function TEMPLATES.ModListItem(modname, modinfo, modstatus, isenabled) end

---@param modname any
---@return ds.widgets.widget
function TEMPLATES.ModDLListItem(modname) end

---@param labeltext any
---@param fieldtext any
---@param width_label any
---@param width_field any
---@param height number
---@param spacing any
---@param font any
---@param font_size any
---@param horiz_offset? any
---@return ds.widgets.widget
function TEMPLATES.LabelTextbox(
   labeltext,
   fieldtext,
   width_label,
   width_field,
   height,
   spacing,
   font,
   font_size,
   horiz_offset
)
end

---@param labeltext any
---@param spinnerdata any
---@param width_label any
---@param width_spinner any
---@param height number
---@param spacing any
---@param font any
---@param font_size any
---@param horiz_offset? any
---@return ds.widgets.widget
function TEMPLATES.LabelSpinner(
   labeltext,
   spinnerdata,
   width_label,
   width_spinner,
   height,
   spacing,
   font,
   font_size,
   horiz_offset
)
end

---@param labeltext any
---@param buttontext any
---@param width_label any
---@param width_button any
---@param height number
---@param spacing any
---@param font any
---@param font_size any
---@param horiz_offset? any
---@return ds.widgets.widget
function TEMPLATES.LabelButton(
   labeltext,
   buttontext,
   width_label,
   width_button,
   height,
   spacing,
   font,
   font_size,
   horiz_offset
)
end

---@param name string
---@param slot_index any
---@param src_pos any
---@param dest_pos any
---@param start_scale any
---@param end_scale any
---@return ds.widgets.uianim
function TEMPLATES.MovingItem(name, slot_index, src_pos, dest_pos, start_scale, end_scale) end

---@param type any
---@param name string
---@param iconScale any
---@param font any
---@param textsize any
---@param string string
---@param colour? ds.vector3|number[]
---@param textwidth? number
---@param image_offset? ds.vector3|number[]
---@return ds.widgets.widget
function TEMPLATES.ItemImageText(type, name, iconScale, font, textsize, string, colour, textwidth, image_offset) end

---@param fade_y_threshold any
---@param snowflake_chance? number
---@param max_snowball_size? number
---@param max_snowflake_size? number
---@return ds.widgets.widget
function TEMPLATES.Snowfall(fade_y_threshold, snowflake_chance, max_snowball_size, max_snowflake_size) end

return TEMPLATES
