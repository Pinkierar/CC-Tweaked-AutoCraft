local console = require("includes/console")
local readUntil = require("includes/input/readUntil")

--- @param message string
--- @param default string
--- @param offLn boolean
--- @return string
local function prompt(message, default, offLn)
  if message ~= nil then
    console.log(message .. ": ", true)
  end

  local value = readUntil(function(value)
    return value ~= nil and value ~= ""
  end, {
    default = default
  })

  if offLn ~= true then
    console.log("")
  end

  return value
end

return prompt