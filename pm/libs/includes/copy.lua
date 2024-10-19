local console = require("includes/console")

---@param from string
---@param to string
local function copy(from, to)
  if not fs.exists(from) then
    console.error("\"" .. from .. "\" not exist")
    return
  end

  if fs.exists(to) then
    fs.delete(to)
  end

  fs.copy(from, to)
end

return copy
