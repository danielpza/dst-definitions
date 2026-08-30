---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.replicas.health
---@field inst any
---@field classified any
---@field ondetachclassified function
---@overload fun(inst?: ds.entityscript): ds.replicas.health
local Health = function(inst) end

---@param classified any
function Health:AttachClassified(classified) end

function Health:DetachClassified() end

---@param current any
function Health:SetCurrent(current) end

---@param max number
function Health:SetMax(max) end

---@param penalty any
function Health:SetPenalty(penalty) end

function Health:Max() end

function Health:MaxWithPenalty() end

function Health:GetPercent() end

function Health:GetCurrent() end

function Health:GetPenaltyPercent() end

function Health:IsHurt() end

---@param isdead? any
function Health:SetIsDead(isdead) end

function Health:IsDead() end

---@param istakingfiredamage any
function Health:SetIsTakingFireDamage(istakingfiredamage) end

function Health:IsTakingFireDamage() end

---@param istakingfiredamagelow any
function Health:SetIsTakingFireDamageLow(istakingfiredamagelow) end

function Health:IsTakingFireDamageLow() end

function Health:IsTakingFireDamageFull() end

---@param flags any
function Health:SetLunarBurnFlags(flags) end

function Health:GetLunarBurnFlags() end

---@param canheal? any
function Health:SetCanHeal(canheal) end

function Health:CanHeal() end

---@param canmurder? any
function Health:SetCanMurder(canmurder) end

function Health:CanMurder() end

return Health
