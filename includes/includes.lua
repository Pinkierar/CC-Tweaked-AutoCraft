--- @generic Value
--- @param list table<number, Value>
--- @param value Value
--- @return boolean
local function includes(list, value)
  for _, item in pairs(list) do
    if item == value then
      return true
    end
  end

  return false
end

return includes


