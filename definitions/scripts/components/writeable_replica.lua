---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.replicas.writeable
---@field inst any
---@field screen any
---@field opentask any
---@field classified any
---@field ondetachclassified function
---@overload fun(inst?: ds.entityscript): ds.replicas.writeable
local Writeable = function(inst) end

function Writeable:OnRemoveEntity() end

---@param classified any
function Writeable:AttachClassified(classified) end

function Writeable:DetachClassified() end

---@param doer? any
function Writeable:BeginWriting(doer) end

---@param doer any
---@param text? string
function Writeable:Write(doer, text) end

function Writeable:EndWriting() end

---@param writer any
function Writeable:SetWriter(writer) end

return Writeable
