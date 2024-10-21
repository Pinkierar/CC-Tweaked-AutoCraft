---@meta

---@alias FilterFun fun(x: number, y: number): boolean
---@alias Filter table<number, table<number, FilterFun>>
---@alias CraftingType '"workbench"' | '"machine"'

---@class Vector
---@field x number
---@field y number
---@field z number

---@class Modem
---@field open fun(port: number)
---@field isOpen fun(port: number): boolean
---@field isWireless fun(): boolean
---@field close fun(port: number)
---@field transmit fun(targetPort: number, senderPort: number, payload: any)

---@class Drive
---@field getMountPath fun(): string
---@field isDiskPresent fun(): boolean
---@field setDiskLabel fun(label: string)
