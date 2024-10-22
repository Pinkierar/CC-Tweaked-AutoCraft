---@class (exact) ItemDetail
---@field name string
---@field count number

---@class (exact) Item: ItemDetail
---@field isEmpty fun(): boolean


---@param name? string
---@param count? number
---@return Item
---@nodiscard
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

---@param detail ItemDetail | nil
---@return Item
---@nodiscard
local function newFromDetail(detail)
  if detail == nil then
    return new()
  end

  return new(detail.name, detail.count)
end


local Item = {
  new = new,
  newFromDetail = newFromDetail,
}

return Item