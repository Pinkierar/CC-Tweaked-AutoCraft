local Slot = require("auto-craft/Slot")
local Item = require("auto-craft/Item")

--- @class Inventory
--- @field slots SlotMatrix
--- @field updateSlots fun(): void

--- @class InventoryStatic
--- @field new fun(): Inventory


--- @type InventoryStatic
local Inventory

--- @return Inventory
local function new()
  local slots = Slot.newMatrix(4, 4)

  local function updateSlots()
    slots.forEach(function(_, x, y)
      local slotId = Slot.positionToSlotId(x, y)
      local detail = turtle.getItemDetail(slotId)
      local item = Item.newFromDetail(detail)
      local slot = Slot.new(slotId, item)

      slots.set(x, y, slot)
    end)
  end

  updateSlots()

  return {
    slots = slots,
    updateSlots = updateSlots,
  }
end

Inventory = {
  new = new,
}

return Inventory