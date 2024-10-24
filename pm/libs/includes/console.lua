local includes = require "includes.includes"

---@return number, number
---@nodiscard
local function getCursorPos()
  return term.getCursorPos()
end

---@param x number
---@param y number
local function setCursorPos(x, y)
  term.setCursorPos(x, y)
end

---@param message string
---@param offLn? boolean
local function log(message, offLn)
  if offLn == true then
    term.write(message)
  else
    print(message)
  end
end

---@param e string | PortError
local function error(e)
  if type(e) ~= "table" then
    printError(e)
    return
  end

  if not includes({ "table", "string", "number", "boolean" }, type(e.info)) then
    printError(e.message)
    return
  end

  printError(e.message, textutils.serialize(e.info))
end

local function clear()
  term.clear()
  setCursorPos(1, 1)
end

local function clearLine()
  local _, y = getCursorPos()
  term.clearLine()
  setCursorPos(1, y)
end

---@param count number
local function clearLines(count)
  local _, y = getCursorPos()

  if y < count then
    return clear()
  end

  for i = 1, count do
    clearLine()
    setCursorPos(1, y - i)
  end
end

local function lineBreak()
  log("")
end

local console = {
  log = log,
  lineBreak = lineBreak,
  error = error,
  clear = clear,
  clearLine = clearLine,
  clearLines = clearLines,
  setCursorPos = setCursorPos,
  getCursorPos = getCursorPos
}

return console
