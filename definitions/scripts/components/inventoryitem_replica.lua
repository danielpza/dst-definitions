---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.replicas.inventoryitem
---@field inst any
---@field _cannotbepickedup any
---@field _iswet any
---@field _isacidsizzling any
---@field _grabbableoverridetag any
---@field classified any
---@field ondetachclassified function
---@field overrideimage string
---@overload fun(inst?: ds.entityscript): ds.replicas.inventoryitem
local InventoryItem = function(inst) end

function InventoryItem:OnRemoveEntity() end

---@param classified any
function InventoryItem:AttachClassified(classified) end

function InventoryItem:DetachClassified() end

---@param canbepickedup any
function InventoryItem:SetCanBePickedUp(canbepickedup) end

---@param doer? any
function InventoryItem:CanBePickedUp(doer) end

---@param cangoincontainer any
function InventoryItem:SetCanGoInContainer(cangoincontainer) end

function InventoryItem:CanGoInContainer() end

---@param canonlygoinpocket any
function InventoryItem:SetCanOnlyGoInPocket(canonlygoinpocket) end

---@param canonlygoinpocketorpocketcontainers any
function InventoryItem:SetCanOnlyGoInPocketOrPocketContainers(canonlygoinpocketorpocketcontainers) end

function InventoryItem:CanOnlyGoInPocket() end

function InventoryItem:CanOnlyGoInPocketOrPocketContainers() end

---@param locked any
function InventoryItem:SetIsLockedInSlot(locked) end

function InventoryItem:IsLockedInSlot() end

---@param imagename any
function InventoryItem:SetImage(imagename) end

---@param imagename any
function InventoryItem:OverrideImage(imagename) end

function InventoryItem:GetImage() end

---@param atlasname any
function InventoryItem:SetAtlas(atlasname) end

function InventoryItem:GetAtlas() end

---@param owner? ds.entityscript
function InventoryItem:SetOwner(owner) end

function InventoryItem:IsHeld() end

---@param guy any
function InventoryItem:IsHeldBy(guy) end

---@param guy any
function InventoryItem:IsGrandOwner(guy) end

---@param pos? number|ds.vector3
function InventoryItem:SetPickupPos(pos) end

function InventoryItem:GetPickupPos() end

function InventoryItem:SerializeUsage() end

function InventoryItem:DeserializeUsage() end

---@param t any
function InventoryItem:SetChargeTime(t) end

---@param deploymode any
function InventoryItem:SetDeployMode(deploymode) end

function InventoryItem:GetDeployMode() end

---@param deployer? any
function InventoryItem:IsDeployable(deployer) end

---@param deployspacing any
function InventoryItem:SetDeploySpacing(deployspacing) end

function InventoryItem:DeploySpacingRadius() end

---@param restrictedtag any
function InventoryItem:SetDeployRestrictedTag(restrictedtag) end

---@param pt any
---@param mouseover any
---@param deployer any
---@param rot any
function InventoryItem:CanDeploy(pt, mouseover, deployer, rot) end

---@param usegridplacer any
function InventoryItem:SetUseGridPlacer(usegridplacer) end

function InventoryItem:GetDeployPlacerName() end

---@param attackrange any
function InventoryItem:SetAttackRange(attackrange) end

function InventoryItem:AttackRange() end

function InventoryItem:IsWeapon() end

---@param walkspeedmult? any
function InventoryItem:SetWalkSpeedMult(walkspeedmult) end

function InventoryItem:GetWalkSpeedMult() end

---@param restrictedtag any
function InventoryItem:SetEquipRestrictedTag(restrictedtag) end

function InventoryItem:GetEquipRestrictedTag() end

---@param moisture any
function InventoryItem:SetMoistureLevel(moisture) end

function InventoryItem:GetMoisture() end

function InventoryItem:GetMoisturePercent() end

---@param iswet any
function InventoryItem:SetIsWet(iswet) end

function InventoryItem:IsWet() end

---@param isacidsizzling any
function InventoryItem:SetIsAcidSizzling(isacidsizzling) end

function InventoryItem:IsAcidSizzling() end

---@param tag any
function InventoryItem:SetGrabbableOverrideTag(tag) end

---@param temperature any
function InventoryItem:SetTemperature(temperature) end

function InventoryItem:GetTemperature() end

return InventoryItem
