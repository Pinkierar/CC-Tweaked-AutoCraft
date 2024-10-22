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

---@param dirContent any
---@return DirContent
local function validateDirContent(dirContent)
  if type(dirContent) ~= "table" then
    error("bad type of dirContent")
  end

  local dirs = dirContent.dirs
  local files = dirContent.files

  if type(dirs) ~= "table" then
    error("bad type of dirs")
  end

  if type(files) ~= "table" then
    error("bad type of files")
  end

  for index, dir in ipairs(dirs) do
    if type(dir) ~= "table" then
      error(string.format("bad type of dirs[%u]", index))
    end

    local name = dir.name
    local nestedDirContent = {
      dirs = dir.dirs,
      files = dir.files,
    }

    if type(name) ~= "string" then
      error(string.format("bad type of dirs[%u].name", index))
    end

    local valid, errorMessage = pcall(validateDirContent, nestedDirContent)

    if not valid then
      error(string.format("%s\nbad type of dirs[%u]", errorMessage, index))
    end
  end

  for index, file in ipairs(files) do
    local name = file.name
    local content = file.content

    if type(name) ~= "string" then
      error(string.format("bad type of files[%u].name", index))
    end

    if type(content) ~= "string" then
      error(string.format("bad type of files[%u].content", index))
    end
  end

  return {
    dirs = dirs,
    files = files,
  }
end

---@param path string
---@param dir DirContent
local function injectDirContentRecursive(path, dir)
  local dirs = dir.dirs
  local files = dir.files

  for _, nestedDir in ipairs(dirs) do
    local name = nestedDir.name
    local nestedPath = fs.combine(path, name)

    injectDirContentRecursive(nestedPath, nestedDir)
  end

  for _, file in ipairs(files) do
    write(fs.combine(path, file.name), file.content)
  end
end

---@param dirContent any
local function injectDirContent(dirContent)
  local validDirContent = validateDirContent(dirContent)

  injectDirContentRecursive("", {
    dirs = validDirContent.dirs,
    files = validDirContent.files,
  })
end

local fsUtils = {
  read = read,
  write = write,
  getDirContent = getDirContent,
  copy = copy,
  injectDirContent = injectDirContent,
}

return fsUtils
