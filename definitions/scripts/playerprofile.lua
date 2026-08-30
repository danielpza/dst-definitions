---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.playerprofile
---@field persistdata table
---@field dirty boolean
local PlayerProfile = {}

function PlayerProfile:Reset() end

function PlayerProfile:SoftReset() end

function PlayerProfile:GetSkins() end

---@param prefab string
function PlayerProfile:GetSkinsForPrefab(prefab) end

---@param type any
function PlayerProfile:GetClothingOptionsForType(type) end

function PlayerProfile:GetLastSelectedCharacter() end

---@param character any
function PlayerProfile:SetLastSelectedCharacter(character) end

---@param character any
---@param preset_index any
function PlayerProfile:GetSkinPresetForCharacter(character, preset_index) end

---@param character any
---@param preset_index any
---@param skin_list any
function PlayerProfile:SetSkinPresetForCharacter(character, preset_index, skin_list) end

---@param character any
function PlayerProfile:GetSkinsForCharacter(character) end

---@param character any
---@param skinList any
function PlayerProfile:SetSkinsForCharacter(character, skinList) end

---@param customization_type any
---@param item_key any
---@param is_active? any
function PlayerProfile:SetCustomizationItemState(customization_type, item_key, is_active) end

---@param customization_type any
---@param item_key any
function PlayerProfile:GetCustomizationItemState(customization_type, item_key) end

---@param customization_type any
function PlayerProfile:GetCustomizationItemsForType(customization_type) end

function PlayerProfile:GetStoredCustomizationItemTypes() end

---@param sort_mode any
function PlayerProfile:SetItemSortMode(sort_mode) end

function PlayerProfile:GetItemSortMode() end

---@param sort_mode any
function PlayerProfile:SetServerSortMode(sort_mode) end

function PlayerProfile:GetServerSortMode() end

---@param customize_screen any
---@param customize_filter any
---@param filter_state any
function PlayerProfile:SetCustomizationFilterState(customize_screen, customize_filter, filter_state) end

---@param customize_screen any
---@param customize_filter any
function PlayerProfile:GetCustomizationFilterState(customize_screen, customize_filter) end

---@param time number
function PlayerProfile:SetCollectionTimestamp(time) end

function PlayerProfile:GetCollectionTimestamp() end

---@param _hash any
function PlayerProfile:SetShopHash(_hash) end

function PlayerProfile:GetShopHash() end

---@param recipe any
---@param time number
function PlayerProfile:SetRecipeTimestamp(recipe, time) end

---@param recipe any
function PlayerProfile:GetRecipeTimestamp(recipe) end

---@param item any
function PlayerProfile:GetLastUsedSkinForItem(item) end

---@param item any
---@param skin any
function PlayerProfile:SetLastUsedSkinForItem(item, skin) end

---@param name string
function PlayerProfile:SetCollectionName(name) end

function PlayerProfile:GetCollectionName() end

---@param modname any
---@param favorite any
function PlayerProfile:SetModFavorited(modname, favorite) end

---@param modname any
function PlayerProfile:IsModFavorited(modname) end

---@param name string
---@param value any
function PlayerProfile:SetValue(name, value) end

---@param name string
function PlayerProfile:GetValue(name) end

---@param ambient any
---@param sfx any
---@param music any
function PlayerProfile:SetVolume(ambient, sfx, music) end

---@param value any
function PlayerProfile:SetMuteOnFocusLost(value) end

---@param value any
function PlayerProfile:SetScreenFlash(value) end

function PlayerProfile:GetScreenFlash() end

---@param enabled boolean
function PlayerProfile:SetBloomEnabled(enabled) end

function PlayerProfile:GetBloomEnabled() end

---@param size number
function PlayerProfile:SetHUDSize(size) end

function PlayerProfile:GetHUDSize() end

---@param size number
function PlayerProfile:SetCraftingMenuSize(size) end

function PlayerProfile:GetCraftingMenuSize() end

---@param size number
function PlayerProfile:SetCraftingMenuNumPinPages(size) end

function PlayerProfile:GetCraftingNumPinnedPages() end

function PlayerProfile:GetScrapbookHudDisplay() end

---@param enabled boolean
function PlayerProfile:SetScrapbookHudDisplay(enabled) end

function PlayerProfile:GetPOIDisplay() end

---@param enabled boolean
function PlayerProfile:SetPOIDisplay(enabled) end

function PlayerProfile:GetScrapbookColumnsSetting() end

---@param setting any
function PlayerProfile:SetScrapbookColumnsSetting(setting) end

---@param sensitivity any
function PlayerProfile:SetCraftingMenuSensitivity(sensitivity) end

function PlayerProfile:GetCraftingMenuSensitivity() end

---@param sensitivity any
function PlayerProfile:SetInventorySensitivity(sensitivity) end

function PlayerProfile:GetInventorySensitivity() end

---@param sensitivity any
function PlayerProfile:SetMiniMapZoomSensitivity(sensitivity) end

function PlayerProfile:GetMiniMapZoomSensitivity() end

function PlayerProfile:GetBoatHopDelay() end

---@param delay any
function PlayerProfile:SetBoatHopDelay(delay) end

---@param enabled boolean
function PlayerProfile:SetDistortionEnabled(enabled) end

function PlayerProfile:GetDistortionEnabled() end

---@param modifier any
function PlayerProfile:SetDistortionModifier(modifier) end

function PlayerProfile:GetDistortionModifier() end

---@param enabled boolean
function PlayerProfile:SetScreenShakeEnabled(enabled) end

function PlayerProfile:IsScreenShakeEnabled() end

---@param enabled boolean
function PlayerProfile:SetWathgrithrFontEnabled(enabled) end

function PlayerProfile:IsWathgrithrFontEnabled() end

---@param enabled boolean
function PlayerProfile:SetInvertCameraRotation(enabled) end

function PlayerProfile:GetInvertCameraRotation() end

---@param enabled boolean
function PlayerProfile:SetBoatCameraEnabled(enabled) end

function PlayerProfile:IsBoatCameraEnabled() end

---@param enabled boolean
function PlayerProfile:SetCampfireStoryCameraEnabled(enabled) end

function PlayerProfile:IsCampfireStoryCameraEnabled() end

---@param enabled boolean
function PlayerProfile:SetMinimapZoomCursorEnabled(enabled) end

function PlayerProfile:IsMinimapZoomCursorFollowing() end

function PlayerProfile:SetHaveWarnedDifficultyRoG() end

function PlayerProfile:HaveWarnedDifficultyRoG() end

---@param enabled boolean
function PlayerProfile:SetVibrationEnabled(enabled) end

function PlayerProfile:GetVibrationEnabled() end

---@param enabled boolean
function PlayerProfile:SetShowPasswordEnabled(enabled) end

function PlayerProfile:GetShowPasswordEnabled() end

---@param enabled boolean
function PlayerProfile:SetMovementPredictionEnabled(enabled) end

---@param enabled boolean
function PlayerProfile:SetTextureStreamingEnabled(enabled) end

---@param enabled boolean
function PlayerProfile:SetThreadedRenderEnabled(enabled) end

---@param enabled boolean
function PlayerProfile:SetDynamicTreeShadowsEnabled(enabled) end

---@param enabled boolean
function PlayerProfile:SetAutopauseEnabled(enabled) end

---@param enabled boolean
function PlayerProfile:SetConsoleAutopauseEnabled(enabled) end

---@param enabled boolean
function PlayerProfile:SetCraftingAutopauseEnabled(enabled) end

function PlayerProfile:GetCraftingAutopauseEnabled() end

---@param enabled boolean
function PlayerProfile:SetCraftingMenuBufferedBuildAutoClose(enabled) end

function PlayerProfile:GetCraftingMenuBufferedBuildAutoClose() end

---@param enabled boolean
function PlayerProfile:SetCraftingHintAllRecipesEnabled(enabled) end

function PlayerProfile:GetCraftingHintAllRecipesEnabled() end

---@param setting any
function PlayerProfile:SetLoadingTipsOption(setting) end

---@param enabled boolean
function PlayerProfile:SetDefaultCloudSaves(enabled) end

---@param enabled boolean
function PlayerProfile:SetUseZipFileForNormalSaves(enabled) end

---@param hide any
function PlayerProfile:SetHidePauseUnderlay(hide) end

function PlayerProfile:GetMovementPredictionEnabled() end

---@param enabled boolean
function PlayerProfile:SetProfanityFilterServerNamesEanbled(enabled) end

function PlayerProfile:GetProfanityFilterServerNamesEnabled() end

---@param enabled boolean
function PlayerProfile:SetProfanityFilterChatEanbled(enabled) end

function PlayerProfile:GetProfanityFilterChatEnabled() end

---@param enabled boolean
function PlayerProfile:SetTargetLockingEnabled(enabled) end

function PlayerProfile:GetTargetLockingEnabled() end

---@param enabled boolean
function PlayerProfile:SetAutoSubscribeModsEnabled(enabled) end

function PlayerProfile:GetAutoSubscribeModsEnabled() end

---@param enabled boolean
function PlayerProfile:SetAutoLoginEnabled(enabled) end

function PlayerProfile:GetAutoLoginEnabled() end

function PlayerProfile:GetAxisAlignedPlacement() end

---@param enabled boolean
function PlayerProfile:SetAxisAlignedPlacement(enabled) end

function PlayerProfile:GetAxisAlignedPlacementIntervals() end

---@param intervals any
function PlayerProfile:SetAxisAlignedPlacementIntervals(intervals) end

---@param level any
function PlayerProfile:SetNPCChatLevel(level) end

function PlayerProfile:GetNPCChatLevel() end

function PlayerProfile:GetNPCChatEnabled() end

---@param enabled boolean
function PlayerProfile:SetAnimatedHeadsEnabled(enabled) end

function PlayerProfile:GetAnimatedHeadsEnabled() end

---@param enabled boolean
function PlayerProfile:SetAutoCavesEnabled(enabled) end

function PlayerProfile:GetAutoCavesEnabled() end

function PlayerProfile:SetCavesStateRemembered() end

function PlayerProfile:GetCavesStateRemembered() end

---@param enabled boolean
function PlayerProfile:SetModsWarning(enabled) end

function PlayerProfile:GetModsWarning() end

---@param mode any
function PlayerProfile:SetPresetMode(mode) end

function PlayerProfile:GetPresetMode() end

---@param enabled boolean
function PlayerProfile:SetIntegratedBackpack(enabled) end

function PlayerProfile:GetIntegratedBackpack() end

function PlayerProfile:GetTextureStreamingEnabled() end

function PlayerProfile:GetThreadedRenderEnabled() end

function PlayerProfile:GetDynamicTreeShadowsEnabled() end

function PlayerProfile:GetAutopauseEnabled() end

function PlayerProfile:GetConsoleAutopauseEnabled() end

function PlayerProfile:GetLoadingTipsOption() end

function PlayerProfile:GetUseZipFileForNormalSaves() end

function PlayerProfile:GetDefaultCloudSaves() end

function PlayerProfile:GetHidePauseUnderlay() end

function PlayerProfile:GetConsoleAutocompleteMode() end

function PlayerProfile:GetChatAutocompleteMode() end

function PlayerProfile:GetWorldCustomizationPresets() end

---@param preset any
---@param index? any
function PlayerProfile:AddWorldCustomizationPreset(preset, index) end

function PlayerProfile:GetSavedFilters() end

---@param filters any
function PlayerProfile:SetFilters(filters) end

---@param filters any
function PlayerProfile:SaveFilters(filters) end

function PlayerProfile:GetSavedWorldProgressionFilters() end

---@param filters any
function PlayerProfile:SetWorldProgressionFilters(filters) end

function PlayerProfile:GetVolume() end

function PlayerProfile:GetMuteOnFocusLost() end

---@param quality any
function PlayerProfile:SetRenderQuality(quality) end

function PlayerProfile:GetRenderQuality() end

function PlayerProfile:GetInstallID() end

function PlayerProfile:GetPlayInstance() end

---@param area any
---@param item? any
function PlayerProfile:IsWorldGenUnlocked(area, item) end

---@param area any
---@param item any
function PlayerProfile:UnlockWorldGen(area, item) end

function PlayerProfile:GetUnlockedWorldGen() end

function PlayerProfile:GetSaveName() end

---@param callback? function
function PlayerProfile:Save(callback) end

---@param callback function
---@param minimal_load any
function PlayerProfile:Load(callback, minimal_load) end

---@param str? string
---@param callback? function
---@param minimal_load? any
function PlayerProfile:Set(str, callback, minimal_load) end

---@param dirty any
function PlayerProfile:SetDirty(dirty) end

---@param guid any
function PlayerProfile:GetControls(guid) end

---@param guid any
---@param data any
---@param enabled boolean
function PlayerProfile:SetControls(guid, data, enabled) end

---@param id any
---@param value any
function PlayerProfile:SetControlScheme(id, value) end

---@param id any
function PlayerProfile:GetControlScheme(id) end

function PlayerProfile:SawDisplayAdjustmentPopup() end

function PlayerProfile:ShowedDisplayAdjustmentPopup() end

function PlayerProfile:SawControllerPopup() end

function PlayerProfile:ShowedControllerPopup() end

function PlayerProfile:ShouldWarnModsEnabled() end

---@param do_warning any
function PlayerProfile:SetWarnModsEnabled(do_warning) end

---@param entitlement any
function PlayerProfile:IsEntitlementReceived(entitlement) end

---@param entitlement any
function PlayerProfile:SetEntitlementReceived(entitlement) end

function PlayerProfile:SawNewUserPopup() end

function PlayerProfile:ShowedNewUserPopup() end

function PlayerProfile:SawControlSchemePopup() end

function PlayerProfile:ShowedControlSchemePopup() end

function PlayerProfile:SawNewHostPicker() end

function PlayerProfile:ShowedNewHostPicker() end

---@param file any
---@param cipher any
function PlayerProfile:SaveKlumpCipher(file, cipher) end

---@param file any
function PlayerProfile:GetKlumpCipher(file) end

---@param score_version any
function PlayerProfile:GetRedbirdGameHighScore(score_version) end

---@param score any
---@param score_version any
function PlayerProfile:SetRedbirdGameHighScore(score, score_version) end

---@param score_version any
function PlayerProfile:GetSnowbirdGameHighScore(score_version) end

---@param score any
---@param score_version any
function PlayerProfile:SetSnowbirdGameHighScore(score, score_version) end

---@param score_version any
function PlayerProfile:GetCrowGameHighScore(score_version) end

---@param score any
---@param score_version any
function PlayerProfile:SetCrowGameHighScore(score, score_version) end

function PlayerProfile:GetKitSize() end

---@param size number
function PlayerProfile:SetKitSize(size) end

function PlayerProfile:GetKitBuild() end

---@param build any
function PlayerProfile:SetKitBuild(build) end

function PlayerProfile:GetKitLastTime() end

---@param last_time any
function PlayerProfile:SetKitLastTime(last_time) end

function PlayerProfile:GetKitHunger() end

---@param hunger any
function PlayerProfile:SetKitHunger(hunger) end

function PlayerProfile:GetKitHappiness() end

---@param happiness any
function PlayerProfile:SetKitHappiness(happiness) end

function PlayerProfile:GetKitBirthTime() end

---@param birth_time any
function PlayerProfile:SetKitBirthTime(birth_time) end

function PlayerProfile:GetKitName() end

---@param name string
function PlayerProfile:SetKitName(name) end

function PlayerProfile:GetKitPoops() end

---@param poops any
function PlayerProfile:SetKitPoops(poops) end

function PlayerProfile:GetKitAbandonedMessage() end

---@param abandoned any
function PlayerProfile:SetKitAbandonedMessage(abandoned) end

function PlayerProfile:GetKitIsHibernating() end

---@param hibernating any
function PlayerProfile:SetKitIsHibernating(hibernating) end

function PlayerProfile:GetKitHibernationStart() end

---@param time number
function PlayerProfile:SetKitHibernationStart(time) end

function PlayerProfile:GetLanguageID() end

---@param language_id any
---@param cb function
function PlayerProfile:SetLanguageID(language_id, cb) end

function PlayerProfile:GetWobyIsLocked() end

---@param locked any
function PlayerProfile:SetWobyIsLocked(locked) end

function PlayerProfile:GetCommandWheelAllowsGameplay() end

---@param enabled boolean
function PlayerProfile:SetCommandWheelAllowsGameplay(enabled) end

return PlayerProfile
