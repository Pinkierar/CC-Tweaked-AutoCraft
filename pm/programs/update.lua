local console = require("includes/console")
local copy = require("includes/copy")
local drivesUtils = require("includes/drivesUtils")
local file = require("includes/file")

local function main()
  local drives = drivesUtils.getDrivesWithDisk()

  if #drives ~= 1 then
    drives = drivesUtils.getPmDrives()
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
  copy(fs.combine(mountPath, "pm"), "pm")
  file.write("/pm.lua", "require(\"/pm/init\")")

  console.log("Complete!")
end

return main