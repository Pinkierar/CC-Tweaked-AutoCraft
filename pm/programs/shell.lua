local modemUtils = require("includes.modemUtils")
local console    = require("includes.console")

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
---@param senderPort Port
local function run(program, args, senderPort)
  local included, main = pcall(require, "sell." .. program)

  if not included then
    console.error(errorToString(main))
    error("unknown program")
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

local function main()
  local port = modemUtils.Port.crafter
  local modem = modemUtils.getModem()

  modemUtils.listen(modem, port, function(message)
    local payload = message.payload
    local senderPort = message.senderPort

    local success, result = pcall(function()
      local program, args = payloadToCommand(payload)
    
      return run(program, args, senderPort)
    end)

    if not success then
      local error = errorToString(result)

      console.error(error)

      modemUtils.send(modem, nil, senderPort, error)
    end
  end)
end

return main
