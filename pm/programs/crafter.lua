local fileUtils = require "includes.fileUtils"

local function main()
  fileUtils.write("/startup/shell.lua", [[shell.run("pm shell")]])
  os.reboot()
end

return main
