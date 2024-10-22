local modemUtils = require "includes.modemUtils"
local fsUtils    = require "includes.fsUtils"

local function main(args, senderPort)
  local modem = modemUtils.getModem()

  local serialized = args[1]
  if type(serialized) ~= "string" then
    error("args[1] should be string")
  end

  local dirContent = textutils.unserialize(serialized)

  if type(dirContent) ~= "table" then
    error("cannot unserialize")
  end

  fsUtils.injectDirContent(dirContent)

  modemUtils.send(modem, nil, senderPort, {
    program = "log",
    args = {
      tostring(os.getComputerID()),
      "success",
      "successfully deployed",
    }
  })

  os.reboot()
end

return main
