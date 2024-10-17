local r = require("cc.require")
local env = setmetatable({}, {__index = _ENV})
env.require, env.package = r.make(env, "/pm/libs")
require = env.require

local console = require("includes/console")
local includes = require("includes/includes")

--- @type string
local program = arg[1]

--- @type table<string, string>
local commands = {
  help = "-h",
  list = "-l"
}
--- @type table<string, string>
local commandsMap = {
  [commands.help] = "Show this message",
  [commands.list] = "Show list of available commands",
}

if program == nil or program == commands.help then
  console.log("Usage:")

  for name, label in pairs(commandsMap) do
    console.log("  \"pm " .. name .. "\" - " .. label)
  end

  console.log("  \"pm <program>\" - Run the program")

  return
end

--- @type table<number, string>
local programs = {}
--- @type table<number, string>
local files = fs.list("/pm/programs")
for _, file in ipairs(files) do
  local program = string.gsub(file, ".lua", "");
  table.insert(programs, program)
end

if program == commands.list then
  console.log("Programs:")
  for _, program in ipairs(programs) do
    console.log("  " .. program)
  end

  return
end

if includes(programs, program) then
  local main = require("/pm/programs/" .. program)

  main()

  return
end

console.error("Unknown command or program!\n" ..
  "Use \"pm " .. commands.help .. "\" for help...")