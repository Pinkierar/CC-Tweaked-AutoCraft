local newIngredient = require("auto-craft/ingredient")
local ioFile = require("includes/file")

--- @class Recipe
--- @field getType fun(): RecipeType
--- @field setType fun(type: RecipeType): void
--- @field getIngredient fun(x: number, y: number): string, number
--- @field setIngredient fun(x: number, y: number, id: string, count: number): void
--- @field getResult fun(): string, number
--- @field setResult fun(id: string, count: number): void
--- @field toString fun(): string
--- @field save fun(): void

--- @return Recipe
local function newRecipe()
  --- @type RecipeType
  local type = "workbench"

  local recipeId = tostring(math.floor(math.random() * 100000))

  --- @type table<number, table<number, Ingredient>>
  local recipe = {}
  for y = 1, 3 do
    recipe[y] = {}
    for x = 1, 3 do
      recipe[y][x] = newIngredient()
    end
  end

  local result = newIngredient()

  --- @return RecipeType
  local function getType()
    return type
  end

  --- @param newType RecipeType
  local function setType(newType)
    type = newType
  end

  --- @param x number
  --- @param y number
  --- @return string, number
  local function getIngredient(x, y)
    return recipe[y][x].get()
  end

  --- @param x number
  --- @param y number
  --- @param id string
  --- @param count number
  local function setIngredient(x, y, id, count)
    recipe[y][x].set(id, count)
  end

  --- @param id string
  --- @param count number
  local function setResult(id, count)
    result.set(id, count)
  end

  --- @return string, number
  local function getResult()
    return result.get()
  end

  --- @param x number
  --- @param y number
  --- @return number
  local function pos2number(x, y)
    return (y - 1) * 3 + x
  end

  --- @return string
  local function toString()
    local recipeString = "Type: " .. type .. "\n"
      .. "[1][2][3]\n"
      .. "[4][5][6] > [R]\n"
      .. "[7][8][9]\n\n"

    for y = 1, 3 do
      for x = 1, 3 do
        local isWorkbench = type == "workbench"
        recipeString = recipeString
          .. "[" .. pos2number(x, y) .. "] "
          .. recipe[y][x].toString(isWorkbench) .. "\n"
      end
    end

    return recipeString .. "[R] " .. result.toString()
  end

  --- @return string
  local function toContent()
    local content = type .. "\n"

    for y = 1, 3 do
      for x = 1, 3 do
        content = content .. recipe[y][x].toContent() .. "\n"
      end
    end

    return content .. result.toContent()
  end

  local function save()
    local path = "recipes/" .. recipeId .. ".recipe"

    ioFile.write(path, toContent())
  end

  return {
    getType = getType,
    setType = setType,
    getIngredient = getIngredient,
    setIngredient = setIngredient,
    setResult = setResult,
    getResult = getResult,
    toString = toString,
    save = save
  }
end

return newRecipe