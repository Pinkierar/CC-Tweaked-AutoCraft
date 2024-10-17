--- @class Matrix
--- @generic T
--- @field set fun(x: number, y: number, value: T): void
--- @field get fun(x: number, y: number): T
--- @field map fun(callback: fun(item: T, x: number, y: number): boolean): Matrix
--- @field forEach fun(callback: fun(item: T, x: number, y: number): void): void
--- @field find fun(callback: fun(item: T, x: number, y: number): boolean): T

--- @class MatrixStatic
--- @field new fun(sizeX: number, sizeY: number): Matrix

--- @type MatrixStatic
local Matrix

--- @param sizeX number
--- @param sizeY number
--- @return Matrix
local function new(sizeX, sizeY)
  --- @generic T
  --- @type table<number, table<number, T>>
  local matrix = {}
  for y = 1, 4 do
    matrix[y] = {}
  end

  --- @generic T
  --- @param x number
  --- @param y number
  --- @param value T
  local function set(x, y, value)
    if 0 >= x or x > sizeX or 0 >= y or y > sizeY then
      return
    end

    matrix[y][x] = value
  end

  --- @generic T
  --- @param x number
  --- @param y number
  --- @return T
  local function get(x, y)
    return matrix[y][x]
  end

  --- @generic T
  --- @param callback fun(item: T, x: number, y: number): boolean
  --- @return T
  local function find(callback)
    for y = 1, sizeY do
      for x = 1, sizeX do
        local item = get(x, y)

        if callback(item, x, y) == true then
          return item
        end
      end
    end
  end

  --- @generic T, K
  --- @param callback fun(item: T, x: number, y: number): K
  --- @return Matrix
  local function map(callback)
    local newMatrix = Matrix.new(sizeX, sizeY)

    find(function(item, x, y)
      local newValue = callback(item, x, y)

      newMatrix.set(x, y, newValue)
    end)

    return newMatrix
  end

  --- @generic T
  --- @param callback fun(item: T, x: number, y: number): void
  local function forEach(callback)
    find(function(item, x, y)
      callback(item, x, y)
    end)
  end

  return {
    set = set,
    get = get,
    find = find,
    map = map,
    forEach = forEach,
  }
end

Matrix = {
  new = new
}

return Matrix