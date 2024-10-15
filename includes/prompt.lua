local console = require("includes/console")

--- @param message string
--- @param offLn boolean
--- @return string
local function prompt(message, offLn)
  local value

  if message ~= nil then
    console.log(message .. ": ", true)
  end

  local x, y = console.getCursorPos()

  value = io.read()

  if offLn == true then
    console.setCursorPos(x + string.len(value), y - 1)
  end

  if value == nil or value == "" then
    return nil
  end

  return value
end

return prompt