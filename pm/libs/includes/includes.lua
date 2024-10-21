---@generic T
---@param list T[]
---@param value T
---@return boolean
---@nodiscard
local function includes(list, value)
  for _, item in pairs(list) do
    if item == value then
      return true
    end
  end

  return false
end

return includes


