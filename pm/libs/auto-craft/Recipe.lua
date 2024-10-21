local Slot        = require("auto-craft.Slot")
local Item        = require("auto-craft.Item")
local stringSplit = require("includes.stringSplit")


---@class (exact) Recipe
---@field name string
---@field type CraftingType
---@field slots SlotMatrix
---@field toContent fun(): string
---@field isResult fun(x: number, y: number): boolean


---@param name string
---@param type CraftingType
---@param slots SlotMatrix
---@return Recipe
---@nodiscard
local function new(name, type, slots)
  ---@return string
  ---@nodiscard
  local function toContent()
    ---@type string
    local content = name .. " " .. type

    ---@type table<string, number>
    local resources = {}
    local resourcesLength = 0
    slots.forEach(function(slot)
      local item = slot.item;
      if item.isEmpty() then
        return
      end

      local itemName = item.name
      local id = resourcesLength + 1

      if resources[itemName] == nil then
        resources[itemName] = id
        resourcesLength = resourcesLength + 1

        content = content .. "\n" .. id .. " " .. itemName
      end
    end)

    local prevY = 0
    slots.forEach(function(slot, x, y)
      if prevY ~= y then
        prevY = y

        content = content .. "\n"
      end

      if x > 1 then
        content = content .. " "
      end

      local item = slot.item
      if item.isEmpty() then
        content = content .. "-"
        return
      end

      local itemName = item.name
      local count = item.count
      local id = resources[itemName]

      content = content .. id .. "x" .. count
    end)

    return content
  end

  ---@param x number
  ---@param y number
  ---@return boolean
  ---@nodiscard
  local function isResult(x, y)
    if type == "workbench" then
      return x == 4 and y == 2
    else
      return x == 4
    end
  end

  return {
    name = name,
    type = type,
    slots = slots,
    toContent = toContent,
    isResult = isResult
  }
end

---@param content string
---@return Recipe
local function fromContent(content)
  ---@type string[]
  local lines = stringSplit(content, "\n")
  ---@type string, string
  local recipeName, type = table.unpack(stringSplit(lines[1], " "))

  ---@type table<string, string>
  local resources = {}
  for i = 2, #lines - 4 do
    local line = lines[i]
    ---@type string, string
    local id, name = table.unpack(stringSplit(line, " "))
    resources[id] = name
  end

  local slots = Slot.newMatrix(4, 4)
  for y = 1, 4 do
    local line = lines[#lines + y - 4]
    local lineSplit = stringSplit(line, " ")

    for x = 1, 4 do
      local lineSplitItem = lineSplit[x]
      local slotId = Slot.positionToSlotId(x, y)

      local item
      if lineSplitItem ~= "-" then
        ---@type string, string
        local id, countStr = table.unpack(stringSplit(lineSplitItem, "x"))
        local count = tonumber(countStr)
        local name = resources[id];

        item = Item.new(name, count)
      else
        item = Item.new()
      end

      slots.set(x, y, Slot.new(slotId, item))
    end
  end

  return new(recipeName, type, slots)
end


local Recipe = {
  new = new,
  fromContent = fromContent,
}

return Recipe
