local console = require("includes.console")

local function main(args)
  console.log(textutils.serialize(args))
end

return main
