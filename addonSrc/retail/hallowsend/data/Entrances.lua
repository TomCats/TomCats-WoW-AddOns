local _, addon = ...
if (not addon.hallowsend.IsEventActive()) then return end

local Coords = CreateVector2D
local TYPE_NONE = 0
local TYPE_ENTRANCE = 1
local TYPE_DUNGEON = 2
local TYPE_PORTAL_ALLIANCE = 3
local TYPE_PORTAL_HORDE = 4
select(2, ...).TomCatsLibs.Data.loadData(
    "Entrances",
    { "Entrance ID", "Quest IDs", "Area ID", "UIMap ID", "Location", "Type", "Add to Parent UIMaps" },
    {
        --{ 1, {8676}, 978, 71, Coords(0.3921, 0.2131), TYPE_DUNGEON, true }, -- Zul'Farrak (instance entrance)
        --{ 2, {8635}, 607, 66, Coords(0.2910, 0.6255), TYPE_DUNGEON, true }, -- Valley of Spears (Maraudon entry cavern) Elder Splotrock
        --{ 3, {8635}, 607, 67, Coords(0.3004, 0.4271), TYPE_ENTRANCE, false }, -- The Wicket Grotto is the floor in the map, Zaetar's Choice shows over the minimap, then Earth Song Gate
        --{ 4, {8635}, 607, 68, Coords(0.4425, 0.7707), TYPE_DUNGEON, false }, -- The Wicked Tunnel / Portal to Inner Maraudon - dungeon entrance
        --{ 5, {8727}, 2279, 23, Coords(0.2765, 0.1159), TYPE_DUNGEON, true }, -- Stratholme
        --{ 6, {13017}, 206, 117, Coords(0.5729, 0.4677), TYPE_DUNGEON, true }, -- Utgarde Keep
        --{ 7, {13067}, 1196, 117, Coords(0.5726, 0.4666), TYPE_DUNGEON, true }, -- Utgarde Pinnacle
        --{ 8, {13065}, 4416, 121, Coords(0.7617, 0.2103), TYPE_DUNGEON, true }, -- Gundrak
        --{ 9, {13023}, 4196, 121, Coords(0.2856, 0.8692), TYPE_DUNGEON, true }, -- Drak'Tharon Keep
        --{ 10, {8619, 8644}, 254, 36, Coords(0.2018, 0.1766), TYPE_ENTRANCE, false }, -- Blackrock Mountain
        --{ 11, {8619, 8644}, 1957, 32, Coords(0.3467, 0.8374), TYPE_ENTRANCE, false }, -- Blackchar Cave
        --{ 12, {8619, 8644}, 254, 36, Coords(0.2108, 0.3825), TYPE_DUNGEON, true }, -- Blackrock Mountain
        --{ 13, {8644}, 254, 33, Coords(0.6346, 0.4408), TYPE_ENTRANCE, false }, --  Blackrock Spire entry from molten span
        --{ 14, {8644}, 254, 33, Coords(0.8040, 0.4068), TYPE_DUNGEON, false }, --  Lower Blackrock Spire instance entrance
        --{ 15, {8644}, 254, 251, Coords(0.6169, 0.3959), TYPE_NONE, false }, --  Elder Stonefort extra icon
        --{ 16, {8644}, 254, 253, Coords(0.6169, 0.3959), TYPE_NONE, false }, --  Elder Stonefort extra icon
        --{ 17, {8619}, 254, 33, Coords(0.3941, 0.4101), TYPE_ENTRANCE, false }, --  Entryway toward Elder Morndeep in Blackrock Depths
        --{ 18, {8619}, 254, 35, Coords(0.3889, 0.1825), TYPE_DUNGEON, false }, --  Blackrock Depths Instance Entrance
        --{ 19, {8713}, 1477, 51, Coords(0.6966, 0.5348), TYPE_ENTRANCE, false }, --  Elder Starsong / Sunken Temple
        --{ 20, {13021}, 4265, 114, Coords(0.275, 0.2602), TYPE_DUNGEON, true }, --  Elder Igasho / The Nexus
        --{ 21, {13022}, 4277, 115, Coords(0.26, 0.5083), TYPE_DUNGEON, true }, --  Elder Nurgen / Azjol-Nerub
        --{ 22, {13066}, 4264, 120, Coords(0.3956, 0.2691), TYPE_DUNGEON, true }, --  Elder Yurauk / Halls of Stone
        --{ 23, {29734, 29735, 29736, 29737, 29738, 29739, 29740, 29741, 29742}, 1637, 84, Coords(0.7448, 0.1846), TYPE_PORTAL_ALLIANCE, true}, -- Cataclysm portals to Cataclysm elders - Alliance
        --{ 24, {29734, 29735, 29736, 29737, 29738, 29739, 29740, 29741, 29742}, 1519, 85, Coords(0.5008, 0.3783), TYPE_PORTAL_HORDE, true}, -- Cataclysm portals to Cataclysm elders - Horde
        --{ 25, {8678}, 1638, 7, Coords(0.4493, 0.2322), TYPE_NONE, false }, --  Elder Ezra Wheathoof - extra map pin
        --{ 26, {8678}, 1638, 7, Coords(0.4493, 0.2322), TYPE_NONE, false }, --  Elder Ezra Wheathoof - extra map pin
        --{ 27, {13023}, 4210, 116, Coords(0.1748, 0.27), TYPE_ENTRANCE, false }, --  Drak'Tharon Keep alternate entrance via Grizzly Hills
        --{ 28, {13023}, 4210, 121, Coords(0.2899, 0.8378), TYPE_ENTRANCE, false }, --  Drak'Tharon Keep main entrance via Zul'Drak
        --{ 29, {13065}, 4416, 121, Coords(0.8127, 0.2896), TYPE_DUNGEON, false }, -- Gundrak alternative entrance
        --{ 30, {13022}, 4277, 159, Coords(0.6901, 0.2596), TYPE_ENTRANCE, false }, --  Elder Nurgen / Azjol-Nerub 3rd floor to 2nd floor
        --{ 31, {13022}, 4277, 158, Coords(0.4849, 0.6018), TYPE_ENTRANCE, false }, --  Elder Nurgen / Azjol-Nerub 2rd floor to 1st floor
        --{ 32, {13020}, 4543, 120, Coords(0.3059, 0.3697), TYPE_ENTRANCE, false }, --  Elder Stonebeard / The Storm Peaks structure entrance
        --{ 33, {13067}, 1196, 137, Coords(0.3572, 0.7525), TYPE_ENTRANCE, false }, --  Utgarde Pinnacle / Upper level to Lower Level
        --{ 34, {13067}, 1196, 136, Coords(0.4576, 0.822), TYPE_ENTRANCE, false }, --  Utgarde Pinnacle / Lower level back to Upper Level
        --{ 35, {13067}, 1196, 137, Coords(0.5997, 0.3479), TYPE_ENTRANCE, false }, --  Utgarde Pinnacle / Upper level back to Lower Level
        --{ 36, {13017}, 206, 117, Coords(0.5802, 0.5014), TYPE_ENTRANCE, false }, -- Entrance leading to Utgarde Keep
        --{ 37, {8718, 8715}, 702, 57, Coords(0.5509, 0.8824), TYPE_ENTRANCE, false }, -- Entrance leading to Darnassus / Teldrassil
        --{ 38, {8718}, 702, 57, Coords(0.2810, 0.4367), TYPE_ENTRANCE, false }, -- Extra map icon for the Darnassus elder
        --{ 39, {8648}, 1497, 18, Coords(0.6184, 0.7017), TYPE_ENTRANCE, false }, -- Entrance toward Elder Darkcore / Undercity
        --{ 40, {8648}, 1497, 90, Coords(0.6604, 0.3235), TYPE_ENTRANCE, false }, -- Next entrance toward Elder Darkcore / Undercity
        --{ 41, {8722}, 28, 22, Coords(0.6507, 0.3874), TYPE_ENTRANCE, false }, -- Cave entrance for Elder Meadowrun
        --{ 42, {8866}, 1537, 27, Coords(0.6043, 0.3337), TYPE_ENTRANCE, false }, -- Cave entrance for Elder Meadowrun
        --{ 43, {8713}, 1477, 51, Coords(0.76, 0.4522), TYPE_DUNGEON, true }, --  Elder Starsong / Sunken Temple
        --{ 44, {29741}, 5034, 249, Coords(0.3158, 0.6299), TYPE_NONE, false }, --  Elder Sekhemi - extra map pin
        --{ 45, {29742}, 5034, 249, Coords(0.6551, 0.1868), TYPE_NONE, false }, --  Elder Menkhaf - extra map pin
    }
)
