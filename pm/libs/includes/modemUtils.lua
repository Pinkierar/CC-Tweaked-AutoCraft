local console = require("includes.console")


---@class (exact) ModemMessage
---@field senderPort Port
---@field payload any
---@field distance number


---@enum Port
local Port = {
  center = 1,
  crafter = 2,
  request = 3,
  storage = 4,
}

---@param modem Modem | nil
---@return Modem
local function validateModem(modem)
  if modem == nil then
    error("no modem")
  end

  if not modem.isWireless() then
    error("modem is not wireless")
  end

  return modem
end

---@param name string
---@return Modem | nil
local function getModemByName(name)
  if peripheral.getType(name) == "modem" then
    local modem = peripheral.wrap(name)

    if modem.isWireless() then
      return modem
    end
  end

  return nil
end

---@param onlyOne? boolean
---@return table<number, Modem>
local function getModems(onlyOne)
  local names = peripheral.getNames()

  ---@type table<number, Modem>
  local modems = {}

  for _, name in ipairs(names) do
    local modem = getModemByName(name)

    if modem ~= nil then
      table.insert(modems, modem)

      if onlyOne == true then
        return modems
      end
    end
  end

  return modems
end

---@param name? string
---@return Modem | nil
local function getModem(name)
  if name == nil then
    return getModems(true)[1]
  else
    return getModemByName(name)
  end
end

---@param modem Modem | nil
---@param port Port
local function open(modem, port)
  modem = validateModem(modem)

  if not modem.isOpen(port) then
    modem.open(port)
  end
end

---@async
---@param modem Modem | nil
---@param port Port
---@param handler fun(message: ModemMessage)
local function waitMessage(modem, port, handler)
  modem = validateModem(modem)

  if not modem.isOpen(port) then
    error("port " .. port .. " is not open")
  end

  local _, _, targetPort, senderPort, payload, distance = os.pullEvent("modem_message")

  if targetPort == port then
    handler({
      senderPort = senderPort,
      payload = payload,
      distance = distance,
    })
  end
end

---@async
---@param modem Modem | nil
---@param port Port
---@param handler fun(message: ModemMessage)
local function listen(modem, port, handler)
  open(modem, port)

  console.log("Port " .. port .. " is listening on computer " .. os.getComputerID())

  while true do
    waitMessage(modem, port, handler)
  end
end

---@param modem Modem | nil
---@param senderPort Port | nil
---@param targetPort Port
---@param payload? any
---@param handler? fun(message: ModemMessage)
local function send(modem, senderPort, targetPort, payload, handler)
  modem = validateModem(modem)

  parallel.waitForAll(
    function()
      if senderPort == nil or handler == nil then
        return
      end

      open(modem, senderPort)

      waitMessage(modem, senderPort, handler)
    end,
    function()
      modem.transmit(targetPort, senderPort or 0, payload)
    end
  )
end

local modemUtils = {
  getModem = getModem,
  listen = listen,
  send = send,
  Port = Port,
}

return modemUtils
