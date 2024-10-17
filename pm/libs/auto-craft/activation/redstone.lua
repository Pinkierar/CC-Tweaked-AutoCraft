local sidesEntries = ipairs(redstone.getSides())

local function hasRedstone()
  for _, side in sidesEntries do
    if redstone.getInput(side) then
      return true
    end
  end

  return false
end

local function waitRedstone()
  repeat
    os.pullEvent("redstone")
  until hasRedstone()
end

return {
  waitRedstone = waitRedstone
}