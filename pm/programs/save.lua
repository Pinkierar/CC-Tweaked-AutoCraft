local console = require("includes/console")
local input = require("includes/input")
local drivesUtils = require("includes/drivesUtils")

--- @param path string
local function saveToPath(path)
  local pmPath = fs.combine(path, "pm");

  if not fs.exists("pm") then
    error("There is no \"pm\" folder on this computer")
    return
  end

  if fs.exists(pmPath) then
    fs.delete(pmPath)
  end

  fs.copy("pm", pmPath)
end

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

  for _, drive in ipairs(drives) do
    local mountPath = drive.getMountPath()
    saveToPath(mountPath)
    drive.setDiskLabel("pm")
  end

  console.log("Saving complete!")
end

return main