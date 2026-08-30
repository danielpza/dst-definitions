---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.util.wordpredictor
---@field prediction any
---@field text string
---@field dictionaries table
---@field cursor_pos any
---@overload fun(text_edit?: any): ds.util.wordpredictor
local WordPredictor = function(text_edit) end

---@param dictionary any
function WordPredictor:AddDictionary(dictionary) end

---@param text string
---@param cursor_pos any
function WordPredictor:RefreshPredictions(text, cursor_pos) end

---@param prediction_index any
function WordPredictor:Apply(prediction_index) end

function WordPredictor:Clear() end

---@param prediction_index any
function WordPredictor:GetDisplayInfo(prediction_index) end

return WordPredictor
