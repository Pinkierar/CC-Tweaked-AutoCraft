--- @class ItemDetail
--- @field name string
--- @field count number

--- @class Item
--- @field name string
--- @field count number
--- @field isEmpty fun(): boolean

--- @class ItemStatic
--- @field new fun(name: string, count: number): Item
--- @field newFromDetail fun(detail: ItemDetail): Item


--- @type ItemStatic
local Item

--- @param name string
--- @param count number
--- @return Item
local function new(name, count)
  if count == nil then
    if name == nil then
      count = 0
    else
      count = 1
    end
  end

  --- @return boolean
  local function isEmpty()
    return name == nil or count == 0
  end

  return {
    name = name,
    count = count,
    isEmpty = isEmpty,
  }
end

--- @param detail ItemDetail
--- @return Item
local function newFromDetail(detail)
  if detail == nil then
    return Item.new()
  end

  return Item.new(detail.name, detail.count)
end

Item = {
  new = new,
  newFromDetail = newFromDetail,
}

return Item