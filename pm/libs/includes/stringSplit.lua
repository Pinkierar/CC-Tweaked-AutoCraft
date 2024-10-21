local function stringSplit(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end

  local split = {}

  for item in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(split, item)
  end

  return split
end

return stringSplit
