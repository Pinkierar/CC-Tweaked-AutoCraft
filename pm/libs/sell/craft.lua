local modemUtils   = require("includes.modemUtils")
local driveUtils   = require("includes.driveUtils")
local fsUtils      = require("includes.fsUtils")
local Recipe       = require("auto-craft.Recipe")
local Item         = require("auto-craft.Item")
local Inventory    = require("auto-craft.Inventory")
local storageUtils = require("includes.storageUtils")
local console      = require("includes.console")

---@return Recipe
local function getRecipe()
  local drives = driveUtils.getRecipeDrives()

  if #drives == 0 then
    error("drive not found")
  end

  if #drives ~= 1 then
    error("to many drives")
  end

  local drive = drives[1]
  local mountPath = drive.getMountPath()
  local recipePath = mountPath .. "/main.recipe"

  if not fs.exists(recipePath) then
    error("recipe file not found")
  end

  local recipeContent = fsUtils.read(recipePath)

  return Recipe.fromContent(recipeContent)
end

---@param args string[]
---@param senderPort Port
local function main(args, senderPort)
  local recipeName = args[1] or ""
  console.log(recipeName)
  ---@type number
  local count = args[2] and tonumber(args[2]) or 1
  local modem = modemUtils.getModem()
  local recipe = getRecipe()

  if recipe.type == "machine" then
    error("not implemented")
  end

  if recipe.name ~= recipeName then
    -- TODO: монтированный рецепт не относится к запрошенному рецепту
    error("not me")
  end

  local inventory = Inventory.new()

  inventory.slots.forEach(function(slot, x, y)
    if not recipe.isIngredient(x, y) then
      slot.clear(true)
    end
  end)

  local storage = storageUtils.byPeripheral()

  if storage == nil then
    error('storage not found')
  end

  local items = storageUtils.getItems(storage)

  ---@type table<string, number>
  local forRequest = {}
  ---@type table<string, number>
  local fromStorage = {}
  recipe.slots.forEach(function(recipeSlot, x, y)
    local recipeItem = recipeSlot.item
    local itemName = recipeItem.name
    local inventorySlot = inventory.slots.get(x, y)
    local inventoryItem = inventorySlot.item

    if recipeItem.isEmpty() then
      inventorySlot.clear(true)
      return
    end

    if recipe.isResult(x, y) then
      inventorySlot.clear(true)
      return
    end

    if inventoryItem.name ~= itemName then
      inventorySlot.clear(true)
    end

    local remains = recipeItem.count * count - inventoryItem.count

    if remains <= 0 then
      return
    end

    if fromStorage[itemName] == nil then
      fromStorage[itemName] = 0
    end

    fromStorage[itemName] = fromStorage[itemName] + remains

    --TODO: Использовать буферный сундук и получать актуальные items
    remains = remains - storageUtils.countOfItem(items, itemName)

    if remains <= 0 then
      return
    end

    if forRequest[itemName] == nil then
      forRequest[itemName] = 0
    end

    forRequest[itemName] = forRequest[itemName] + remains
  end)

  inventory.updateSlots()

  for name, count1 in pairs(fromStorage) do
    error({ message = "should get fromStorage", info = fromStorage })
  end

  for name, count2 in pairs(forRequest) do
    error({ message = "should get by forRequest", info = forRequest })
  end

  -- modemUtils.send(
  --   modem,
  --   nil and modemUtils.Port.storage,
  --   modemUtils.Port.request,
  --   { type = "request", data = forRequest },
  --   function(message)
  --   end
  -- )

  turtle.craft()

  modemUtils.send(modem, nil, senderPort, {
    from = os.getComputerID(),
    type = "success",
    message = "crafted",
  })
end

return main
