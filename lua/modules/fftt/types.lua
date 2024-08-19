---@class WordRange
---@field offset Offset
---@field chars Char[]
---@field rare_char Char

---@class Char
---@field index number
---@field char string
---@field offset Offset
---@field frequency number?

---@class Offset
---@field start number
---@field ["end"] number

---@alias CharCounter table<string, number>
