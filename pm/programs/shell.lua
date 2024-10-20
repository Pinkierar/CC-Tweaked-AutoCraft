local modemUtils = require("includes/modemUtils")
local console    = require("includes/console")

---@param error any
---@return string
local function errorToString(error)
  if error == nil then
    return "nil"
  end

  if type(error) == "string" then
    return error
  end

  if type(error) == "number" then
    return tostring(error)
  end

  if type(error) == "boolean" then
    if error then
      return "true"
    else
      return "false"
    end
  end

  if type(error) == "table" then
    if error.message ~= nil then
      return error.message
    end
  end

  return "unkown error"
end

---@param program string
---@param args string[]
---@param senderPort number
local function run(program, args, senderPort)
  local included, main = pcall(require, "sell/" .. program)

  if not included then
    console.error(errorToString(main))
    error("unkown program")
  end

  if type(main) ~= "function" then
    error("module must be function")
  end

  main(args, senderPort)
end

---@param payload any
---@return string, string[]
local function payloadToCommand(payload)
  if type(payload) ~= "table" then
    error("bad payload type")
  end

  local program = payload.program

  if type(program) ~= "string" then
    error("bad payload program")
  end

  if payload == nil then
    return program, {}
  end

  local args = payload.args

  if type(args) ~= "table" then
    error("bad payload args")
  end

  for i, arg in ipairs(args) do
    if type(arg) ~= "string" then
      error("bad payload args item " .. i)
    end
  end

  return program, args
end

---@param message ModemMessage
local function runByMessage(message)
  local payload = message.payload
  local senderPort = message.senderPort

  local program, args = payloadToCommand(payload)

  return run(program, args, senderPort)
end

local function main(args)
  local port = args[1] and tonumber(args[1]) or 1337
  local modem = modemUtils.getModem()

  ---@param message ModemMessage
  local function requestHandler(message)
    local success, result = pcall(runByMessage, message)

    if not success then
      local senderPort = message.senderPort
      local error = errorToString(result)

      console.error(error)

      modemUtils.send(modem, nil, senderPort, error)
    end
  end

  modemUtils.listen(modem, port, requestHandler)
end

return main
