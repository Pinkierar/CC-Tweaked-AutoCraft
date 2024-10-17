local activation = require("auto-craft/activation")
local crafting = require("auto-craft/crafting")
local inventory = require("auto-craft/inventory")

--- @param recipe Recipe
local function getIngredients(recipe)
  -- todo: запросить ингредиенты из соседних инвентарей
end

--- @param recipe Recipe
--- @return Filter
local function createFilter(recipe)
  return function(x, y)
    -- todo: из рецепта проверить клетки
  end
end

local function initAsWorkbench(recipe)
  local filter = createFilter(recipe)

  while true do
    activation.waitRedstone()

    inventory.clean(filter)
    getIngredients(recipe)
    crafting.workbenchCraft()
  end
end

local function initialize(type, recipe)
  if type == "workbench" then
    initAsWorkbench(recipe)
  end
end

return {
  initialize = initialize
}