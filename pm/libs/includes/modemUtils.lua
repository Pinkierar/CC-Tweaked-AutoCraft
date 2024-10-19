local console = require("includes/console")
local input = require("includes/input")


---@class (exact) ModemMessage
---@field senderPort number
---@field payload any
---@field distance number
---@field position? Vector


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

---@param modem Modem
---@param port number
---@return boolean
local function open(modem, port)
  if modem.isOpen(port) then
    if input.confirm("The port is already open. Continue?") then
      modem.close(port)
    else
      return false
    end
  end

  modem.open(port)

  console.log("Port " .. port .. " is listening on computer " .. os.getComputerID())

  return true
end

---@async
---@param modem Modem
---@param port number
---@param handler fun(message: ModemMessage)
local function waitMessage(modem, port, handler)
  local _, _, targetPort, senderPort, payload, distance = os.pullEvent("modem_message")

  -- if targetPort == port then
  handler({
    senderPort = senderPort,
    payload = payload,
    distance = distance,
  })
  -- end
end

---@async
---@param modem Modem
---@param port number
---@param handler fun(message: ModemMessage)
local function listen(modem, port, handler)
  if open(modem, port) then
    while true do
      waitMessage(modem, port, handler)
    end
  end
end

---@param modem Modem
---@param senderPort number | nil
---@param targetPort number
---@param payload? any
local function send(modem, senderPort, targetPort, payload)
  if not modem.isWireless() then
    console.error("This is not a wireless modem")
    return
  end

  console.log("Sending to port " .. targetPort .. " from computer " .. os.getComputerID())

  modem.transmit(targetPort, senderPort or 0, payload)
end

local modemUtils = {
  getModemByName = getModemByName,
  getModems = getModems,
  getModem = getModem,
  open = open,
  waitMessage = waitMessage,
  listen = listen,
  send = send,
}

return modemUtils
