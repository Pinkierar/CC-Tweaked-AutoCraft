local console = require("includes/console")
local input = require("includes/input")
local copy = require("includes/copy")
local drivesUtils = require("includes/drivesUtils")

local function main()
  local drives = drivesUtils.getDrivesWithDisk()

  if #drives ~= 1 then
    drives = drivesUtils.getPmDrives()
    if #drives ~= 1 then
      console.error("You have multiple drives connected")
      if not input.confirm("Write data to all disks?") then
        console.log("Disconnect unnecessary drives and repeat...")
        return
      end
    end
  end

  if #drives == 0 then
    console.error("No drives connected")
    return
  end

  for _, drive in ipairs(drives) do
    local mountPath = drive.getMountPath()
    copy("pm", fs.combine(mountPath, "pm"))
    drive.setDiskLabel("pm")
  end

  console.log("Complete!")
end

return main