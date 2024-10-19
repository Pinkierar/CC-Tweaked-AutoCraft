local choice = require("includes/input/choice")
local console = require("includes/console")

---@param message? string
---@param offLn? boolean
---@return boolean
---@nodiscard
local function confirm(message, offLn)
  if message ~= nil then
    console.log(message .. " ", true)
  end

  local answer = choice(nil, { "Yes", "No" }, offLn);

  return answer == "Yes"
end

return confirm
