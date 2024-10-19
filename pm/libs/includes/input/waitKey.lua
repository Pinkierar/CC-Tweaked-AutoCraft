local includes = require("includes/includes")
local console = require("includes/console")

---@param possibleKeys table<number, string>
---@return string
---@nodiscard
local function waitKey(possibleKeys)
  local currentKey

  repeat
    local _, code = os.pullEvent("key")
    currentKey = keys.getName(code)
    console.log(currentKey)
  until includes(possibleKeys, currentKey)

  return currentKey
end

---@return string
---@nodiscard
local function waitAnyKey()
  local _, code = os.pullEvent("key")
  return keys.getName(code)
end

return {
  waitKey = waitKey,
  waitAnyKey = waitAnyKey
}
