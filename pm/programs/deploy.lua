local modemUtils = require "includes.modemUtils"
local console = require "includes.console"
local fsUtils = require "includes.fsUtils"

local externalPort = modemUtils.Port.crafter

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

  modemUtils.send(modem, nil, externalPort, { program = "deploy", args = { serialized } })
end

return main
