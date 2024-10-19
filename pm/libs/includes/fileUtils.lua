---@param path string
---@return string File content
---@nodiscard
local function read(path)
  local file = io.open(path, "r")

  io.output(file)
  local content = io.read()
  io.output(io.stdout)
  io.close(file)

  return content
end

---@param path string
---@param content string
local function write(path, content)
  local file = io.open(path, "w+")

  io.output(file)
  io.write(content)
  io.output(io.stdout)
  io.close(file)
end

local fileUtils = {
  read = read,
  write = write
}

return fileUtils
