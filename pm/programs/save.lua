local console = require("includes/console")
local input = require("includes/input")
local copy = require("includes/copy")
local driveUtils = require("includes/driveUtils")

local function main()
  local drives = driveUtils.getDrivesWithDisk()

  if #drives == 0 then
    console.error("No drives connected")
    return
  end

  if #drives ~= 1 then
    drives = driveUtils.getPmDrives()
    if #drives ~= 1 then
      console.error("You have multiple drives connected")
      if not input.confirm("Write data to all disks?") then
        console.log("Disconnect unnecessary drives and repeat...")
        return
      end
    end
  end

  for _, drive in ipairs(drives) do
    local mountPath = drive.getMountPath()
    copy("pm", fs.combine(mountPath, "pm"))
    drive.setDiskLabel("pm")
  end

  console.log("Complete!")
end

return main