---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.replicas.sanity
---@field inst any
---@field _oldissane boolean
---@field _oldisinsanitymode boolean
---@field _issane any
---@field _isinsanitymode any
---@field classified any
---@field ondetachclassified function
---@overload fun(inst?: ds.entityscript): ds.replicas.sanity
local Sanity = function(inst) end

---@param classified any
function Sanity:AttachClassified(classified) end

function Sanity:DetachClassified() end

---@param current any
function Sanity:SetCurrent(current) end

---@param max number
function Sanity:SetMax(max) end

---@param penalty any
function Sanity:SetPenalty(penalty) end

function Sanity:Max() end

function Sanity:MaxWithPenalty() end

function Sanity:GetPercent() end

function Sanity:GetPercentNetworked() end

function Sanity:GetCurrent() end

function Sanity:GetPercentWithPenalty() end

function Sanity:GetPenaltyPercent() end

---@param ratescale any
function Sanity:SetRateScale(ratescale) end

function Sanity:GetRateScale() end

---@param mode any
function Sanity:SetSanityMode(mode) end

---@param sane any
function Sanity:SetIsSane(sane) end

function Sanity:IsSane() end

function Sanity:IsInsane() end

function Sanity:IsEnlightened() end

function Sanity:IsCrazy() end

function Sanity:GetSanityMode() end

function Sanity:IsInsanityMode() end

function Sanity:IsLunacyMode() end

---@param ghostdrainmult any
function Sanity:SetGhostDrainMult(ghostdrainmult) end

function Sanity:IsGhostDrain() end

return Sanity
