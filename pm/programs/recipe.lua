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
    console.log("Arrange the ingredients " ..
      "as on the workbench in the upper left corner, " ..
      "and place the result in the cell with a frame")
    inventory.slots.get(4, 2).select()
  else
    console.log("Place the ingredients " ..
      "in the 1st, 2nd and 3rd columns " ..
      "and place the result in the 4th column")
    inventory.slots.get(4, 1).select()
  end

  sleep(0.2)
  console.lineBreak()
  if input.confirm("Save the recipe?") then
    inventory.updateSlots()
    Recipe.new(name, type, inventory.slots).save()
    console.log("Recipe saved!")
  else
    console.log("Save canceled")
  end

  inventory.slots.get(1, 1).select()
end

return main
