local _, addon = ...
if (not addon.midsummer.IsEventActive()) then return end

local Coords = CreateVector2D
local TYPE_NONE = 0
local TYPE_ENTRANCE = 1
local TYPE_PORTAL_ALLIANCE = 3
local TYPE_PORTAL_HORDE = 4
local TYPE_PHASED = 6

local PlayerFaction = UnitFactionGroup("player")

if (PlayerFaction == "Horde") then
    addon.midsummer.TomCatsLibs.Data.loadData(
            "Entrances",
            { "Entrance ID", "Quest IDs", "UIMap ID", "Location", "Type", "Add to Parent UIMaps" },
            {
                { 1, {11862}, 2070, Coords(0.5722,0.5175), TYPE_PHASED, false }, --TirisFal Glades alt phase work-around
                { 2, {9332}, 57, Coords(0.3501,0.4713), TYPE_NONE, false }, --Darnassus additional pin
                { 3, {11933}, 97, Coords(0.2465,0.4941), TYPE_ENTRANCE, false }, --The Exodar additional pin
                { 4, {28947}, 1527, Coords(0.534,0.32), TYPE_PHASED, false }, -- Uldum additional pin
                { 5, {28949}, 1527, Coords(0.53,0.34), TYPE_PHASED, false }, --Uldum additional pin
                { 6, {32503}, 1530, Coords(0.798,0.37), TYPE_PHASED, false }, -- Vale additional pin
                { 7, {32509}, 1530, Coords(0.778,0.331), TYPE_PHASED, false }, --Vale additional pin
                { 8, {9330}, 37, Coords(0.1937,0.3845), TYPE_NONE, false }, --Stormwind additional pin
                { 9, {9331}, 27, Coords(0.6058,0.3318), TYPE_ENTRANCE, false }, --Ironforge additional pin
                { 10, {9332, 11753}, 57, Coords(0.5479,0.8826), TYPE_PORTAL_ALLIANCE, true }, --Darnassus additional pin
                { 11, {11933,11735,11738}, 57, Coords(0.5232,0.8947), TYPE_PORTAL_ALLIANCE, true }, --Exodar/Azuremyst/Bloodmyst additional pin (portal)
            }
    )
else
    addon.midsummer.TomCatsLibs.Data.loadData(
            "Entrances",
            { "Entrance ID", "Quest IDs", "UIMap ID", "Location", "Type", "Add to Parent UIMaps" },
            {
                { 1, {11786}, 2070, Coords(0.5704,0.5182), TYPE_PHASED, false }, --TirisFal Glades alt phase work-around
                { 2, {9324}, 76, Coords(0.1693,0.9032), TYPE_NONE, false }, --Orgrimmar additional pin
                { 3, {9326}, 18, Coords(0.623,0.669), TYPE_NONE, false }, --Undercity additional pin
                { 4, {9326}, 2070, Coords(0.623,0.669), TYPE_PHASED, false }, --Undercity additional pin
                { 5, {9325}, 7, Coords(0.3529,0.2425), TYPE_NONE, false }, --Thunder Bluff additional pin
                { 6, {11935}, 94, Coords(0.5666,0.4958), TYPE_ENTRANCE, false }, --Silvermoon additional pin
                { 7, {28948}, 1527, Coords(0.53,0.344), TYPE_PHASED, false }, -- Uldum additional pin
                { 8, {28950}, 1527, Coords(0.53,0.32), TYPE_PHASED, false }, --Uldum additional pin
                { 9, {32496}, 1530, Coords(0.779,0.339), TYPE_PHASED, false }, -- Vale additional pin
                { 10, {32510}, 1530, Coords(0.796,0.372), TYPE_PHASED, false }, --Vale additional pin
                { 11, {11824}, 57, Coords(0.5479,0.8826), TYPE_PORTAL_ALLIANCE, true }, --Teldrassil additional pin
                { 12, {11806,11809}, 57, Coords(0.5232,0.8947), TYPE_PORTAL_ALLIANCE, true }, --Azuremyst/Bloodmyst additional pin (portal)
            }
    )
end
