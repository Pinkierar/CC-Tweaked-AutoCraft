---@return Drive[]
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

---@return Drive[]
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

---@return Drive[]
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

---@return Drive[]
local function getRecipeDrives()
  local recipeDrives = {}

  local drives = getDrivesWithDisk()
  for _, drive in ipairs(drives) do
    if string.find(drive.getDiskLabel(), "^recipe: ") ~= nil then
      table.insert(recipeDrives, drive)
    end
  end

  return recipeDrives
end

local driveUtils = {
  getDrives = getDrives,
  getDrivesWithDisk = getDrivesWithDisk,
  getPmDrives = getPmDrives,
  getRecipeDrives = getRecipeDrives,
}

return driveUtils
