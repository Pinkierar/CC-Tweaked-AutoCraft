local completion = require("cc.completion")
local includes = require("includes/includes")
local console = require("includes/console")

--- @param message string
--- @param variants table<number, string>
--- @param offLn boolean
--- @return string
local function choice(message, variants, offLn)
  if message ~= nil then
    console.log(message .. ": ", true)
  end

  local x, y = console.getCursorPos()

  local value
  repeat
    console.setCursorPos(x, y)

    value = read(nil, nil, function(text)
      return completion.choice(text, variants)
    end)
  until includes(variants, value)

  if offLn == true then
    console.setCursorPos(x + string.len(value), y - 1)
  end

  return value
end

return choice