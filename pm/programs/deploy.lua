local modemUtils = require "includes.modemUtils"
local console = require "includes.console"
local fsUtils = require "includes.fsUtils"

local function main()
  local modem = modemUtils.getModem()

  local data = fsUtils.getDirContent("/", {
    ".idea",
    ".vscode",
    ".git",
    ".gitignore",
    "test.lua",
    "pm/programs/test.lua",
  })

  local serialized = textutils.serialize(data)
  console.log("Sending " .. string.len(serialized) .. " bytes")

  local payload = { program = "deploy", args = { serialized } }

  modemUtils.send(modem, nil, modemUtils.Port.logs, payload)
  sleep(1)
  for _, port in pairs(modemUtils.Port) do
    if port ~= modemUtils.Port.center and port ~= modemUtils.Port.logs then
      modemUtils.send(modem, modemUtils.Port.logs, port, payload)
    end
  end
end

return main
