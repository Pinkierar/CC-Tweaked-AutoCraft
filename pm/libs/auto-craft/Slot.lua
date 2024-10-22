local Matrix = require("includes.Matrix")
local Item   = require("auto-craft.Item")


---@class (exact) Slot
---@field item Item
---@field id number
---@field select fun()
---@field clear fun(offSelectPrev?: boolean)

---@class (exact) SlotMatrix
---@field set fun(x: number, y: number, newSlot: Slot)
---@field get fun(x: number, y: number): Slot
---@field map fun(callback: fun(slot: Slot, x: number, y: number): any): Matrix
---@field forEach fun(callback: fun(slot: Slot, x: number, y: number))
---@field find fun(callback: fun(slot: Slot, x: number, y: number): boolean): Slot


---@param id number
---@param item Item
---@return Slot
---@nodiscard
local function new(id, item)
  local function select()
    turtle.select(id)
  end

  ---@param offSelectPrev boolean
  local function clear(offSelectPrev)
    local prevSelectedId
    if not offSelectPrev then
      prevSelectedId = turtle.getSelectedSlot()
    end

    select()
    turtle.drop()
    item.count = 0
    item.name = nil

    if not offSelectPrev then
      turtle.select(prevSelectedId)
    end
  end

  return {
    id = id,
    item = item,
    select = select,
    clear = clear,
  }
end

---@param x number
---@param y number
---@return number
---@nodiscard
local function positionToSlotId(x, y)
  return (y - 1) * 4 + x
end

---@param sizeX number
---@param sizeY number
---@return SlotMatrix
---@nodiscard
local function newMatrix(sizeX, sizeY)
  local matrix = Matrix.new(sizeX, sizeY) --[[@as SlotMatrix]]

  local slotMatrix = matrix.map(function(_, x, y)
    return new(positionToSlotId(x, y), Item.new())
  end) --[[@as SlotMatrix]]

  return slotMatrix
end


local Slot = {
  new = new,
  positionToSlotId = positionToSlotId,
  newMatrix = newMatrix,
}

return Slot
