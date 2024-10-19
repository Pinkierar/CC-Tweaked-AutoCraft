local fileUtils = require("includes/fileUtils")


---@class (exact) Recipe
---@field name string
---@field type CraftingType
---@field slots SlotMatrix
---@field toString fun(): string
---@field save fun()


---@param name string
---@param type CraftingType
---@param slots SlotMatrix
---@return Recipe
---@nodiscard
local function new(name, type, slots)
  ---@return string
  ---@nodiscard
  local function toString()
    ---@type string
    local content = name .. " " .. type

    ---@type table<string, number>
    local resources = {}
    slots.forEach(function(slot)
      local item = slot.item;
      if item.isEmpty() then
        return
      end

      local name = item.name
      local id = #resources + 1

      if resources[name] == nil then
        resources[name] = id

        content = content .. "\n" .. id .. " " .. name
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

      local name = item.name
      local count = item.count
      local id = resources[name]

      content = content .. id .. "x" .. count
    end)

    return content
  end

  local function save()
    local path = "recipes/" .. name .. ".recipe"

    fileUtils.write(path, toString())
  end

  return {
    type = type,
    slots = slots,
    toString = toString,
    save = save,
  }
end


local Recipe = {
  new = new
}

return Recipe
