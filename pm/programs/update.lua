local console = require("includes.console")
local driveUtils = require("includes.driveUtils")
local fsUtils = require("includes.fsUtils")

local function main()
  local drives = driveUtils.getDrivesWithDisk()

  if #drives ~= 1 then
    drives = driveUtils.getPmDrives()
    if #drives ~= 1 then
      console.error("You have multiple drives connected")
      console.log("Disconnect unnecessary drives and repeat...")
    end
  end

  if #drives == 0 then
    console.error("No drives connected")
    return
  end

  local drive = drives[1]

  local mountPath = drive.getMountPath()
  fsUtils.copy(fs.combine(mountPath, "pm"), "pm")
  fsUtils.write("/pm.lua", [[require("pm.init")]])

  console.log("Complete!")
end

return main