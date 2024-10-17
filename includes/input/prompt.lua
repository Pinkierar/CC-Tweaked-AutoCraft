local console = require("includes/console")

--- @param message string
--- @param offLn boolean
--- @return string
local function prompt(message, offLn)
  if message ~= nil then
    console.log(message .. ": ", true)
  end

  local x, y = console.getCursorPos()

  local value
  repeat
    console.setCursorPos(x, y)
    value = read()
  until value ~= nil and value ~= ""

  if offLn == true then
    console.setCursorPos(x + string.len(value), y - 1)
  end

  return value
end

return prompt