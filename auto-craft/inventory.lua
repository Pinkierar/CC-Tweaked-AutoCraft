--- @param x number
--- @param y number
--- @return number
local function getSlotId(x, y)
  return (y - 1) * 4 + x
end

--- @param x number
--- @param y number
local function clearSlot(x, y)
  local id = getSlotId(x, y)

  turtle.select(id)
  turtle.drop()
end

--- @param filter Filter
local function clean(filter)
  for x = 1, 4 do
    for y = 1, 4 do
      if y == 4 or x == 4 or filter(x, y) then
        clearSlot(x, y)
      end
    end
  end
end

return {
  clearSlot = clearSlot,
  clean = clean,
  getSlotId = getSlotId
}