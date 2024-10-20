local console = require("includes/console")
local modemUtils = require("includes/modemUtils")

local currentPort = 5000

---@param cmd string
local function execute(cmd)
  shell.run("pm", "auto", cmd)
end

local function main()
  local modem = modemUtils.getModem()
  if modem == nil then
    console.error("Modem not found")
    return
  end

  modemUtils.listen(modem, currentPort, function(message)
    local senderPort = message.senderPort
    local payload = message.payload
    local distance = message.distance

    local info = "Received to port " .. currentPort
    if senderPort ~= 0 then
      info = info .. " from port " .. senderPort
    end
    info = info .. ". Distance: " .. distance .. "m"
    console.log(info)

    -- local isCommand = type(payload) == "string" and string.find(payload, "^pm")
    -- if isCommand then
    --   console.log("pm command... " .. payload)
    --
    -- else
    --   modemUtils.send(modem, nil, senderPort, "Use \"pm -h\"")
    -- end

    local isSuccess, result = pcall(execute, payload)
    if isSuccess then
      modemUtils.send(modem, nil, senderPort, "success")
    else
      modemUtils.send(modem, nil, senderPort, "fail")
    end
  end)
end

return main
