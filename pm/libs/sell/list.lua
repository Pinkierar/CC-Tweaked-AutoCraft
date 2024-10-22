local modemUtils = require("includes.modemUtils")

---@return string[]
local function getPrograms()
  ---@type string[]
  local programs = {}

  ---@type string[]
  local files = fs.list("/pm/libs/sell")
  for _, file in ipairs(files) do
    local program = string.gsub(file, ".lua", "");

    table.insert(programs, program)
  end

  return programs
end

local function main(_, senderPort)
  local modem = modemUtils.getModem()

  local programs = getPrograms()

  modemUtils.send(modem, nil, senderPort, {
    from = os.getComputerID(),
    type = "success",
    message = "list received",
    data = programs,
  })
end

return main
