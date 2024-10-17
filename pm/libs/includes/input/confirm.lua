local choice = require("includes/input/choice")
local console = require("includes/console")

--- @param message string
--- @param offLn boolean
--- @return boolean
local function confirm(message, offLn)
  console.log(message .. " ", true)
  local answer = choice(nil, {"Yes", "No"}, offLn);

  return answer == "Yes"
end

return confirm