local console = require("includes.console")


---@class ReadOptions
---@field replaceChar? string
---@field history? table<number, string>
---@field completeFn? fun(partial: string): table<number, string>
---@field default? string


---@param isFinish fun(value: string): boolean
---@param options? ReadOptions
---@return string
---@nodiscard
local function readUntil(isFinish, options)
  if options == nil then
    options = {}
  end

  local replaceChar = options.replaceChar
  local history = options.history
  local completeFn = options.completeFn
  local default = options.default

  local originalX, y = console.getCursorPos()

  ---@type string
  local value
  repeat
    console.setCursorPos(originalX, y)

    value = read(replaceChar, history, completeFn, default)

    local _, newY = console.getCursorPos()
    y = newY - 1
  until isFinish(value)

  console.setCursorPos(originalX + string.len(value), y)

  return value
end

return readUntil
