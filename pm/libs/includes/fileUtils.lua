---@param path string
---@return string
---@nodiscard
local function read(path)
  local file = fs.open(path, "r")
  if type(file) ~= "table" then
    if type(file) == "string" then
      error(file)
    else
      error("cannot be open")
    end
  end

  return file.readAll() or ""
end

---@param path string
---@param content string
local function write(path, content)
  local file = fs.open(path, "w+")
  if type(file) ~= "table" then
    if type(file) == "string" then
      error(file)
    else
      error("cannot be open")
    end
  end

  file.write(content)
end

local fileUtils = {
  read = read,
  write = write
}

return fileUtils
