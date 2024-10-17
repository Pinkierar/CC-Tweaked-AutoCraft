local drivesUtils = require("libs/includes/drivesUtils")
local file = require("libs/includes/file")

--- @param path string
local function saveFromPath(path)
  local pmPath = fs.combine(path, "pm");

  if not fs.exists(pmPath) then
    error("There is no \"pm\" folder on the disk")
    return
  end

  if fs.exists("pm") then
    fs.delete("pm")
  end

  fs.copy(pmPath, "pm")

  file.write("/pm.lua", "require(\"/pm/init\")")
end

local drives = drivesUtils.getPmDrives()
if #drives ~= 1 then
  error("Duplicates pm disks")
  return
end

local drive = drives[1]
local mountPath = drive.getMountPath()
saveFromPath(mountPath)

print("Installation complete!")