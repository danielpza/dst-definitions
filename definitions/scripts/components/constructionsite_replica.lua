---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.replicas.constructionsite
---@field inst any
---@field _enabled any
---@field classified any
---@field ondetachclassified function
---@overload fun(inst?: ds.entityscript): ds.replicas.constructionsite
local ConstructionSite = function(inst) end

function ConstructionSite:OnRemoveEntity() end

---@param classified any
function ConstructionSite:AttachClassified(classified) end

function ConstructionSite:DetachClassified() end

---@param enabled boolean
function ConstructionSite:SetEnabled(enabled) end

---@param builder any
function ConstructionSite:SetBuilder(builder) end

---@param slot ds.equipslot
---@param num any
function ConstructionSite:SetSlotCount(slot, num) end

function ConstructionSite:IsEnabled() end

---@param guy any
function ConstructionSite:IsBuilder(guy) end

---@param slot ds.equipslot
function ConstructionSite:GetSlotCount(slot) end

function ConstructionSite:GetIngredients() end

return ConstructionSite
