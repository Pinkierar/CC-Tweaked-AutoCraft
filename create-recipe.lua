local newRecipe = require("auto-craft/recipe")
local console = require("includes/console")
local prompt = require("includes/prompt")

--- @param x number
--- @param y number
local function logCurrentSlot(x, y)
  for cy = 1, 3 do
    local line = ""

    for cx = 1, 3 do
      local char
      if cx == x and cy == y then
        char = "[x]"
      else
        char = "[ ]"
      end

      line = line .. "" .. char
    end

    console.log(line)
  end
end

local function clear()
  console.clear()
  console.log("Welcome to Recipe Creator!")
end

local function main()
  local recipe = newRecipe()

  clear()
  local typeCode = prompt("Enter \"M\" to set the type to \"Machine\",\n"
    .. "or leave blank to set the type to \"Workbench\"")
  if typeCode == "M" then
    recipe.setType("machine")
  end

  for y = 1, 3 do
    for x = 1, 3 do
      clear()
      console.log("Enter Ingredient ID for this (x) slot:")
      logCurrentSlot(x, y)

      recipe.setIngredient(x, y, prompt("ID"))
    end
  end

  local resultId = prompt("Result ID")
  recipe.setResult(resultId)

  clear()
  console.log("Check your entry is correct")
  console.log(recipe.toString())

  if prompt("Enter \"Y\" to save or something else to exit.") == "Y" then
    recipe.save()
  end
end

main()
