---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.replicas.rider
---@field inst any
---@field _isriding any
---@field classified any
---@field _onmounthealthdelta function
---@field _onisriding function
---@field ondetachclassified function
---@overload fun(inst?: ds.entityscript): ds.replicas.rider
local Rider = function(inst) end

---@param classified any
function Rider:AttachClassified(classified) end

function Rider:DetachClassified() end

---@param riding? any
function Rider:SetActionFilter(riding) end

---@param riding any
function Rider:OnIsRiding(riding) end

---@param riding any
function Rider:SetRiding(riding) end

function Rider:IsRiding() end

---@param pct any
function Rider:OnMountHealth(pct) end

function Rider:IsMountHurt() end

---@param mount? any
function Rider:SetMount(mount) end

function Rider:GetMount() end

function Rider:GetMountRunSpeed() end

function Rider:GetMountFasterOnRoad() end

---@param saddle? any
function Rider:SetSaddle(saddle) end

function Rider:GetSaddle() end

return Rider
