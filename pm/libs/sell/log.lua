local console = require("includes.console")

local function main(args)
  console.log(table.concat(args, " "))
end

return main
