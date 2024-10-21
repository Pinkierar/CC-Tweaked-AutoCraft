local fsUtils = require "includes.fsUtils"

local function main()
  fsUtils.write("/startup/shell.lua", [[shell.run("pm shell")]])
  os.reboot()
end

return main
