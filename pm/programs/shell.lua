local modemUtils = require("includes.modemUtils")
local console    = require("includes.console")
local includes   = require("includes.includes")
local fsUtils    = require("includes.fsUtils")


---@class PortError
---@field message string
---@field info? any


---@param error any
---@return PortError
local function errorToPortError(error)
  if error == nil then
    return {message = "nil"}
  end

  if type(error) == "string" then
    return {message = error}
  end

  if type(error) == "number" then
    return {message = tostring(error)}
  end

  if type(error) == "boolean" then
    if error then
      return {message = "true"}
    else
      return {message = "false"}
    end
  end

  if type(error) == "table" then
    if type(error.message) == "string" then
      local message = error.message
      error.message = nil
      return {message = message, info = error}
    end
  end

  return {message = "unkown error", info = error}
end

---@param program string
---@param args string[]
---@param senderPort Port
local function run(program, args, senderPort)
  local included, main = pcall(require, "sell." .. program)

  if not included then
    console.error(errorToPortError(main))
    error("unknown program")
  end

  if type(main) ~= "function" then
    error("module must be function")
  end

  console.log("running " .. program)

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

local function main(args)
  if args[1] == "stop" then
    fs.delete("/startup/shell.lua")
    console.log("shell removed from startup")
    return
  end

  local port = tonumber(args[1]) --[[@as Port | nil]]
  if port == nil or not modemUtils.isValidPort(port, { modemUtils.Port.center }) then
    error("unknown port")
  end

  console.clear()
  console.log("Welcome to shell!")

  fsUtils.write(
    "/startup/shell.lua",
    string.format([[shell.run("pm shell %u")]], port)
  )

  local modem = modemUtils.getModem()

  modemUtils.listen(modem, port, function(message)
    local payload = message.payload
    local senderPort = message.senderPort

    local success, result = pcall(function()
      local program, commandArgs = payloadToCommand(payload)

      return run(program, commandArgs, senderPort)
    end)

    if not success then
      local error = errorToPortError(result)

      console.error(error)

      modemUtils.send(modem, nil, senderPort, {
        from = os.getComputerID(),
        type = "error",
        message = error,
      })
    end
  end)
end

return main
