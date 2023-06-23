local addon = select(2,...)
local lib = addon.midsummer.TomCatsLibs.Colors
local colors = {}
setmetatable(lib,{
    __index = function(table, key)
        local color = colors[string.upper(key)]
        if (color) then
            return
            {
                (bit.band(bit.rshift(color,16),0xFF)) / 255,
                (bit.band(bit.rshift(color,8),0xFF)) / 255,
                (bit.band(color,0xFF)) / 255
            }
        else
            return
        end
    end,
    __newindex = function(table, key, value)
        colors[string.upper(key)] = value
    end
})
lib["BLACK"] = 0x000000
lib["NAVY"] = 0x000080
lib["BLUE"] = 0x0000FF
lib["GREEN"] = 0x008000
lib["TEAL"] = 0x008080
lib["LIME"] = 0x00FF00
lib["AQUA"] = 0x00FFFF
lib["MAROON"] = 0x800000
lib["PURPLE"] = 0x800080
lib["OLIVE"] = 0x808000
lib["GRAY"] = 0x808080
lib["SILVER"] = 0xC0C0C0
lib["RED"] = 0xFF0000
lib["FUCHSIA"] = 0xFF00FF
lib["YELLOW"] = 0xFFFF00
lib["WHITE"] = 0xFFFFFF
lib["ORANGERED"] = 0xFF4000
