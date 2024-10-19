local console = require("includes/console")
local modemUtils = require("includes/modemUtils")

-- todo: прослушивать запросы на запуск программ

local currentPort = 5000

local function main()
  local modem = modemUtils.getModem()
  if modem == nil then
    console.error("Modem not found")
    return
  end

  modemUtils.listen(modem, currentPort, function(message)
    modemUtils.send(modem, nil, message.senderPort, "pong")

    console.log("[" .. message.distance .. "] " .. message.payload)
  end)
end

return main
