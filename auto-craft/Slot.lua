local Matrix = require("includes/Matrix")


--- @class Slot
--- @field item Item
--- @field id number
--- @field select fun(): void
--- @field clear fun(offSelectPrev: boolean): void

--- @class SlotMatrix
--- @field set fun(x: number, y: number, newSlot: Slot): void
--- @field get fun(x: number, y: number): Slot
--- @field map fun(callback: fun(slot: Slot, x: number, y: number): boolean): Matrix
--- @field forEach fun(callback: fun(slot: Slot, x: number, y: number): void): void
--- @field find fun(callback: fun(slot: Slot, x: number, y: number): boolean): Slot

--- @class SlotStatic
--- @field new fun(id: number, item: Item): Slot
--- @field positionToSlotId fun(x: number, y: number): number
--- @field newMatrix fun(): SlotMatrix


--- @type SlotStatic
local Slot

--- @param id number
--- @param item Item
--- @return Slot
local function new(id, item)
  --local id =

  local function select()
    turtle.select(id)
  end

  --- @param offSelectPrev boolean
  local function clear(offSelectPrev)
    local prevSelectedId
    if not offSelectPrev then
      prevSelectedId = turtle.getSelectedSlot()
    end

    select()
    turtle.drop()

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

--- @param x number
--- @param y number
--- @return number
local function positionToSlotId(x, y)
  return (y - 1) * 4 + x
end

--- @param sizeX number
--- @param sizeY number
--- @return SlotMatrix
local function newMatrix(sizeX, sizeY)
  return Matrix.new(sizeX, sizeY)
end

Slot = {
  new = new,
  positionToSlotId = positionToSlotId,
  newMatrix = newMatrix,
}

return Slot