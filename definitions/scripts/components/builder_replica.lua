---@meta
---@diagnostic disable: unused-local, missing-return, undefined-field, undefined-global

---@class ds.replicas.builder
---@field inst any
---@field classified any
---@field ondetachclassified function
---@overload fun(inst?: ds.entityscript): ds.replicas.builder
local Builder = function(inst) end

---@param classified any
function Builder:AttachClassified(classified) end

function Builder:DetachClassified() end

function Builder:GetTechBonuses() end

---@param tech any
---@param bonus any
function Builder:SetTechBonus(tech, bonus) end

---@param tech any
---@param bonus any
function Builder:SetTempTechBonus(tech, bonus) end

---@param ingredientmod any
function Builder:SetIngredientMod(ingredientmod) end

function Builder:IngredientMod() end

---@param isfreebuildmode any
function Builder:SetIsFreeBuildMode(isfreebuildmode) end

function Builder:IsFreeBuildMode() end

---@param prototyper any
function Builder:SetCurrentPrototyper(prototyper) end

function Builder:GetCurrentPrototyper() end

function Builder:OpenCraftingMenu() end

---@param techlevels any
function Builder:SetTechTrees(techlevels) end

function Builder:GetTechTrees() end

function Builder:GetTechTreesNoTemp() end

---@param recipename any
function Builder:AddRecipe(recipename) end

---@param recipename any
function Builder:RemoveRecipe(recipename) end

---@param index any
---@param recipename any
---@param amount number
function Builder:SetRecipeCraftingLimit(index, recipename, amount) end

function Builder:GetAllRecipeCraftingLimits() end

---@param recipename any
function Builder:BufferBuild(recipename) end

---@param recipename any
---@param isbuildbuffered any
function Builder:SetIsBuildBuffered(recipename, isbuildbuffered) end

---@param recipename any
function Builder:IsBuildBuffered(recipename) end

---@param ingredient any
function Builder:HasCharacterIngredient(ingredient) end

---@param ingredient any
function Builder:HasTechIngredient(ingredient) end

---@param recipe? any
---@param ignore_tempbonus any
---@param cached_tech_trees? any
function Builder:KnowsRecipe(recipe, ignore_tempbonus, cached_tech_trees) end

---@param recipe? any
function Builder:HasIngredients(recipe) end

---@param recipe_name any
function Builder:CanBuild(recipe_name) end

---@param recipename any
function Builder:CanLearn(recipename) end

---@param pt any
---@param recipe any
---@param rot any
function Builder:CanBuildAtPoint(pt, recipe, rot) end

---@param recipe any
---@param skin any
function Builder:MakeRecipeFromMenu(recipe, skin) end

---@param recipe any
---@param pt any
---@param rot any
---@param skin any
function Builder:MakeRecipeAtPoint(recipe, pt, rot, skin) end

function Builder:IsBusy() end

return Builder
