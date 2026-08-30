---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.widgets.wordpredictionwidget: ds.widgets.widget
---@field word_predictor ds.util.wordpredictor
---@field text_edit any
---@field enter_complete boolean
---@field tab_complete boolean
---@field sizey number
---@field max_width number
---@field backing ds.widgets.image
---@field prediction_root ds.widgets.widget
---@field starting_offset_x number
---@field start_index number
---@field scrollleft_btn ds.widgets.imagebutton
---@field scrollright_btn ds.widgets.imagebutton
---@field expand_btn ds.widgets.imagebutton
---@field expanded boolean
---@field active_prediction_btn any
---@field prediction_btns table
---@overload fun(text_edit?: any, max_width?: any, mode?: any): ds.widgets.wordpredictionwidget
local WordPredictionWidget = function(text_edit, max_width, mode) end

function WordPredictionWidget:IsMouseOnly() end

---@param key any
---@param down? boolean
function WordPredictionWidget:OnRawKey(key, down) end

---@param control any
---@param down? boolean
function WordPredictionWidget:OnControl(control, down) end

---@param text string
function WordPredictionWidget:OnTextInput(text) end

---@param prediction_index any
function WordPredictionWidget:ResolvePrediction(prediction_index) end

function WordPredictionWidget:Dismiss() end

---@param reset? any
function WordPredictionWidget:RefreshPredictions(reset) end

return WordPredictionWidget
