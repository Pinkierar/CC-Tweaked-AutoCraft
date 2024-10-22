local console = require("includes.console")
local includes = require("includes.includes")


---@class (exact) ModemMessage
---@field senderPort Port
---@field payload any
---@field distance number


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

---@param isWired? boolean
---@param name string
---@return Modem | nil
local function getModemByName(isWired, name)
  if peripheral.getType(name) ~= "modem" then
    return nil
  end

  local modem = peripheral.wrap(name)
  local isWireless = modem.isWireless()

  if modem == nil then
    return nil
  end

  if isWired == true and not isWireless then
    return modem
  end

  if isWired ~= true and isWireless then
    return modem
  end

  return nil
end

---@param isWired? boolean
---@return Modem | nil
local function getModemByPeripheral(isWired)
  local names = peripheral.getNames()

  for _, name in ipairs(names) do
    local modem = getModemByName(isWired, name)

    if modem ~= nil then
      return modem
    end
  end

  return nil
end

---@param name? string
---@param isWired? boolean
---@return Modem | nil
local function getModem(name, isWired)
  if name == nil then
    return getModemByPeripheral(isWired)
  else
    return getModemByName(isWired, name)
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

---@enum Port
local Port = {
  center = 1,
  crafter = 2,
  request = 3,
  storage = 4,
  logs = 5,
}

---@param port number
---@param exclude Port[]
---@return boolean
local function isValidPort(port, exclude)
  if includes(exclude, port) then
    return false
  end

  if includes(Port, port) then
    return true
  end

  return false
end

local modemUtils = {
  getModem = getModem,
  listen = listen,
  send = send,
  Port = Port,
  isValidPort = isValidPort,
}

return modemUtils
