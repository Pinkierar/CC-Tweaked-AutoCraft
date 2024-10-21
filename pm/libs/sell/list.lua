local modemUtils = require("includes.modemUtils")

--- @return table<number, string>
local function getPrograms()
    --- @type table<number, string>
    local programs = {}

    --- @type table<number, string>
    local files = fs.list("/pm/libs/sell")
    for _, file in ipairs(files) do
        local program = string.gsub(file, ".lua", "");

        table.insert(programs, program)
    end

    return programs
end

local function main(_, senderPort)
    local modem = modemUtils.getModem()

    local programs = getPrograms()

    modemUtils.send(modem, nil, senderPort, programs)
end

return main
