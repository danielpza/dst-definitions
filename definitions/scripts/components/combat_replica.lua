---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.replicas.combat
---@field inst any
---@field _target any
---@field _ispanic any
---@field _attackrange any
---@field _laststartattacktime any
---@field classified any
---@field ondetachclassified function
---@overload fun(inst?: ds.entityscript): ds.replicas.combat
local Combat = function(inst) end

---@param classified any
function Combat:AttachClassified(classified) end

function Combat:DetachClassified() end

---@param target any
function Combat:SetTarget(target) end

function Combat:GetTarget() end

---@param target any
function Combat:SetLastTarget(target) end

---@param target? any
function Combat:IsRecentTarget(target) end

---@param ispanic any
function Combat:SetIsPanic(ispanic) end

---@param attackrange any
function Combat:SetAttackRange(attackrange) end

function Combat:GetAttackRangeWithWeapon() end

function Combat:GetWeaponAttackRange() end

function Combat:GetWeapon() end

---@param minattackperiod any
function Combat:SetMinAttackPeriod(minattackperiod) end

function Combat:MinAttackPeriod() end

---@param canattack any
function Combat:SetCanAttack(canattack) end

function Combat:StartAttack() end

function Combat:CancelAttack() end

function Combat:InCooldown() end

---@param target any
function Combat:CanAttack(target) end

---@param reached_dest? boolean
---@param target any
function Combat:LocomotorCanAttack(reached_dest, target) end

---@param target any
---@param weapon any
function Combat:CanExtinguishTarget(target, weapon) end

---@param target any
---@param weapon any
function Combat:CanLightTarget(target, weapon) end

---@param target? any
function Combat:CanHitTarget(target) end

---@param target? any
function Combat:IsValidTarget(target) end

---@param target any
function Combat:CanTarget(target) end

---@param guy any
function Combat:CanBeAlly(guy) end

---@param guy any
function Combat:IsAlly(guy) end

---@param target any
function Combat:TargetHasFriendlyLeader(target) end

---@param attacker? any
function Combat:CanBeAttacked(attacker) end

return Combat
