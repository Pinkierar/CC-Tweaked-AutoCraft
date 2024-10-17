local console = require("includes/console")
local input = require("includes/input")

local function getDrives()
  local drivers = {}

  local sides = peripheral.getNames()
  for _, side in ipairs(sides) do
    local device = peripheral.wrap(side)
    local type = peripheral.getType(device)

    if type == "drive" then
      table.insert(drivers, device)
    end
  end

  return drivers
end

local function getDrivesWithDisk()
  local drivesWithDisk = {}

  local drives = getDrives()
  for _, drive in ipairs(drives) do
    if drive.hasData() then
      table.insert(drivesWithDisk, drive)
    end
  end

  return drivesWithDisk
end

--- @param path string
local function saveToPath(path)
  local pmDisk = fs.combine(path, "pm");

  if fs.exists(pmDisk) then
    fs.delete(pmDisk)
  end

  fs.copy("pm", pmDisk)
end

local function main()
  local drives = getDrivesWithDisk()

  if #drives ~= 1 then
    console.error("You have multiple drives connected!")
    if not input.confirm("Write data to all disks?") then
      console.log("Disconnect unnecessary drives and repeat...")
      return
    end
  end

  for _, drive in ipairs(drives) do
    local mountPath = drive.getMountPath()
    saveToPath(mountPath)
    drive.setDiskLabel("pm")
  end
end

return main