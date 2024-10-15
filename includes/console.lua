--- @return number, number
local function getCursorPos()
  return term.getCursorPos()
end

--- @param x number
--- @param y number
local function setCursorPos(x, y)
  term.setCursorPos(x, y)
end

--- @param message string
--- @param offLn boolean
local function log(message, offLn)
  if offLn == true then
    term.write(message)
  else
    print(message)
  end
end

--- @param message string
local function error(message)
  io.output(io.stderr)
  io.write("ERROR: " .. message .. "\n")
  io.output(io.stdout)
end

--- @param onlyCurrentLine boolean
local function clear(onlyCurrentLine)
  if onlyCurrentLine == true then
    local _, y = getCursorPos()
    term.clearLine()
    setCursorPos(0, y)
  else
    term.clear()
    setCursorPos(1, 1)
  end
end

return {
  log = log,
  error = error,
  clear = clear,
  setCursorPos = setCursorPos,
  getCursorPos = getCursorPos
}