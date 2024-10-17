local Recipe = require("auto-craft/Recipe")
local Inventory = require("auto-craft/Inventory")
local console = require("includes/console")
local input = require("includes/input")

local function main()
  console.log("Welcome to Recipe Creator!")

  local name = input.prompt("Enter recipe name")

  local type = input.choice("Select crafter", {"workbench", "machine"})
  if type == nil then
    console.error("Wrong type")
    return
  end

  local inventory = Inventory.new()

  console.lineBreak()
  if type == "workbench" then
    console.log("Arrange the ingredients as in a workbench")
    console.log("Place the result in the selected cell")
    inventory.slots.get(4, 2).select()
  else
    console.log("Place ingredients in 1st, 2nd and 3rd columns")
    console.log("Place the result in the 4th column")
    inventory.slots.get(4, 1).select()
  end

  sleep(0.2)
  console.lineBreak()
  console.log("Save the recipe? ", true)
  if input.choice(nil, {"Yes", "No"}) ~= "Yes" then
    console.log("Save canceled")
    return
  end

  inventory.updateSlots()
  Recipe.new(name, type, inventory.slots).save(name)
  console.log("Recipe saved!")
end

main()
