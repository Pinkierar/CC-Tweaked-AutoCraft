local completion = require("cc.completion")
local includes = require("includes.includes")
local console = require("includes.console")
local readUntil = require("includes.input.readUntil")

---@param message string | nil
---@param variants table<number, string>
---@param offLn? boolean
---@return string
---@nodiscard
local function choice(message, variants, offLn)
  if message ~= nil then
    console.log(message .. ": ", true)
  end

  local value = readUntil(function(value)
    return includes(variants, value)
  end, {
    completeFn = function(text)
      return completion.choice(text, variants)
    end
  })

  if offLn ~= true then
    console.log("")
  end

  return value
end

return choice
