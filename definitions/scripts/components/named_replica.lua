---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.replicas.named
---@field inst any
---@field _name any
---@field _author_netid any
---@overload fun(inst?: ds.entityscript): ds.replicas.named
local Named = function(inst) end

---@param name string
---@param author any
function Named:SetName(name, author) end

return Named
