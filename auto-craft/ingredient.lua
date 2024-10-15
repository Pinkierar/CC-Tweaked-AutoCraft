--- @class Ingredient
--- @field get fun(): string, number
--- @field set fun(id: string, count: number): void
--- @field toString fun(offCount: boolean): string
--- @field toContent fun(): string
--- @field isEmpty fun(): boolean

--- @return Ingredient
local function newIngredient()
  local ingredientId
  local ingredientCount = 0

  --- @return string, number
  local function get()
    return ingredientId, ingredientCount
  end

  --- @param id string
  --- @param count number
  --- @return void
  local function set(id, count)
    if count == nil then
      count = 1
    end

    if id == nil then
      count = 0
    end

    ingredientId = id
    ingredientCount = count
  end

  --- @return boolean
  local function isEmpty()
    return ingredientId == nil or ingredientCount == 0
  end

  --- @param offCount boolean
  --- @return string
  local function toString(offCount)
    if isEmpty() then
      return "-"
    end

    if offCount then
      return ingredientId
    end

    return ingredientId .. " (x" .. ingredientCount .. ")"
  end

  --- @return string
  local function toContent()
    if isEmpty() then
      return ""
    end

    return ingredientId .. " " .. ingredientCount
  end

  return {
    get = get,
    set = set,
    isEmpty = isEmpty,
    toString = toString,
    toContent = toContent
  }
end

return newIngredient