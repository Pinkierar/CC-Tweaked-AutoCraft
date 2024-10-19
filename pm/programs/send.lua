local modemUtils = require("includes/modemUtils")
local console = require("includes/console")

local currentPort = 3000

---@param args table<number, string>
local function main(args)
  local modem = modemUtils.getModem()
  if modem == nil then
    console.error("Modem not found")
    return
  end

  if not modemUtils.open(modem, currentPort) then
    return
  end

  ---@type string
  local message = args[1] or "ping"

  local function waitReply()
    modemUtils.waitMessage(modem, currentPort, function(message)
      console.log("[" .. message.distance .. "] " .. message.payload)
    end)
  end

  local function send()
    modemUtils.send(modem, currentPort, 5000, message)
  end

  parallel.waitForAll(waitReply, send)
end

return main
