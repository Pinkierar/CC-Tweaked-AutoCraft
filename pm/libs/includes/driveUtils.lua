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

local function getPmDrives()
  local pmDrives = {}

  local drives = getDrivesWithDisk()
  for _, drive in ipairs(drives) do
    if drive.getDiskLabel() == "pm" then
      table.insert(pmDrives, drive)
    end
  end

  return pmDrives
end

local driveUtils = {
  getDrives = getDrives,
  getDrivesWithDisk = getDrivesWithDisk,
  getPmDrives = getPmDrives,
}

return driveUtils
