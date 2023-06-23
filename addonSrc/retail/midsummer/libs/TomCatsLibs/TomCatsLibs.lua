local addonName, addon = ...
if (not addon.midsummer.IsEventActive()) then return end

local libs = { "Events", "BulletinBoard", "Copyright", "Holidays", "Tooltips", "SavedVariables", "Charms", "Data", "Arrows", "Colors", "UUID", "Locales", "Books" }
local libIndexes = {}
local TomCatsLibs = {}
for i = 1, #libs do libIndexes[libs[i]] = i libs[i] = {} end
addon.name = addonName
addon.params = {}
local function index(_, libname) return libs[libIndexes[libname]] end
local function newindex() end
setmetatable(TomCatsLibs, { __index = index, __newindex = newindex })
local function getTomCatsLibs(_, key)
    if (key == "TomCatsLibs") then
        local stack = debugstack(2, 1, 2)
        if (not string.find(stack, "TomCatsLibs")) then
            setmetatable(addon, {})
            addon.midsummer.TomCatsLibs = TomCatsLibs
            for i = 1, #libs do
                local lib = libs[i]
                if (lib.init) then lib.init() lib.init = nil end
            end
        end
        return TomCatsLibs
    else
        return rawget(addon, key)
    end
end
setmetatable(addon.midsummer, { __index = getTomCatsLibs })
