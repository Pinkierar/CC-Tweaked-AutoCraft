local includes = require "includes.includes"


---@class (exact) File
---@field name string
---@field content string

---@class (exact) DirContent
---@field dirs Dir[]
---@field files File[]

---@class (exact) Dir: DirContent
---@field name string


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
  if fs.exists(path) then
    if not fs.isDir(path) then
      fs.delete(path)
    end
  end

  local file = fs.open(path, "w")
  if type(file) ~= "table" then
    if type(file) == "string" then
      error(file)
    else
      error("cannot be open")
    end
  end

  file.write(content)
end

---@param path string
---@param exclude string[]
---@return DirContent
local function getDirContent(path, exclude)
  table.insert(exclude, "rom")

  --- @type Dir[]
  local dirs = {}
  --- @type File[]
  local files = {}

  --- @type string[]
  local names = fs.list(path)
  for _, name in ipairs(names) do
    local nestedPath = fs.combine(path, name)

    if not includes(exclude, nestedPath) then
      if fs.isDir(nestedPath) then
        local dirContent = getDirContent(nestedPath, exclude)

        table.insert(dirs, {
          name = name,
          dirs = dirContent.dirs,
          files = dirContent.files,
        })
      else
        local fileContent = read(nestedPath)

        table.insert(files, {
          name = name,
          content = fileContent,
        })
      end
    end
  end

  return {
    dirs = dirs,
    files = files,
  }
end

---@param from string
---@param to string
local function copy(from, to)
  if not fs.exists(from) then
    error("\"" .. from .. "\" not exist")
  end

  if fs.exists(to) then
    fs.delete(to)
  end

  fs.copy(from, to)
end

local fsUtils = {
  read = read,
  write = write,
  getDirContent = getDirContent,
  copy = copy,
}

return fsUtils
