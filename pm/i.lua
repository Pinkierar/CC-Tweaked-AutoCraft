local r = require("cc.require")

local pmPath = fs.find("/*/pm")[1]
if pmPath == nil then
  error("Folder \"pm\" not found on disk")
end

local env = setmetatable({}, {__index = _ENV})
env.require, env.package = r.make(env, pmPath .. "/libs")
require = env.require

local update = require("/" .. pmPath .. "/programs/update")

update()