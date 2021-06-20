local _, addon = ...
if (not addon.lunarfestival.IsEventActive()) then return end

local D = addon.TomCatsLibs.Data
local Coords = CreateVector2D
D.loadData(
    "Pathways",
    { "Pathway ID", "Quest ID", "UIMap ID", "Path" },
    {
        { 1, 8635, 281, {
            Coords(0.2805, 0.3512),
            Coords(0.2805, 0.4372),
            Coords(0.2998, 0.4916),
            Coords(0.3292, 0.6073),
            Coords(0.3508, 0.6005),
            Coords(0.3610, 0.5648),
            Coords(0.4301, 0.6039),
            Coords(0.4596, 0.5852),
            Coords(0.4483, 0.5409),
            Coords(0.4664, 0.5018),
            Coords(0.5367, 0.5434),
            Coords(0.5027, 0.6709),
            Coords(0.4845, 0.6675),
            Coords(0.4721, 0.6352),
            Coords(0.4528, 0.6991),
            Coords(0.4176, 0.6549),
            Coords(0.4018, 0.7348),
            Coords(0.4449, 0.7875),
            Coords(0.4562, 0.9014),
            Coords(0.5140, 0.9371),
        }}, -- Maraudon
        { 2, 8644, 33, {
            Coords(0.6346, 0.4408),
            Coords(0.6799, 0.4054),
            Coords(0.8040, 0.4068)
        }}, -- Lower Blackrock Spire Entry
        { 3, 8644, 251, {
            Coords(0.3780, 0.4209), --
            Coords(0.3802, 0.4787), --
            Coords(0.404, 0.4804), --
            Coords(0.4074, 0.4515), --
            Coords(0.4505, 0.4508), --
            Coords(0.5242, 0.3767), --
            Coords(0.5832, 0.4270), --
            Coords(0.6455, 0.4236), --
            Coords(0.633, 0.3913), --
            Coords(0.6169, 0.3959), --
        }}, -- Lower Blackrock Spire / Skitterweb Tunnels
        { 4, 8644, 252, {
            Coords(0.3780, 0.4209), --
            Coords(0.3802, 0.4787), --
            Coords(0.404, 0.4804), --
            Coords(0.4074, 0.4515), --
            Coords(0.4505, 0.4508), --
            Coords(0.5242, 0.3767), --
            Coords(0.5832, 0.4270), --
            Coords(0.6455, 0.4236), --
            Coords(0.633, 0.3913), --
            Coords(0.6169, 0.3959), --
        }}, -- Lower Blackrock Spire / Hordemar City
        { 5, 8644, 253, {
            Coords(0.3780, 0.4209), --
            Coords(0.3802, 0.4787), --
            Coords(0.404, 0.4804), --
            Coords(0.4074, 0.4515), --
            Coords(0.4505, 0.4508), --
            Coords(0.5242, 0.3767), --
            Coords(0.5832, 0.4270), --
            Coords(0.6455, 0.4236), --
            Coords(0.633, 0.3913), --
            Coords(0.6169, 0.3959), --
        }}, -- Lower Blackrock Spire / Hall of Blackhand
        { 6, 8619, 242, {
            Coords(0.3496, 0.7746), --
            Coords(0.5163, 0.7049), --
            Coords(0.505, 0.63)
        }}, -- Blackrock Depths
        { 7, 13023, 160, {
            Coords(0.2955, 0.8063), --
            Coords(0.3371, 0.7847), --
            Coords(0.4017, 0.8644), --
            Coords(0.4562, 0.8493), --
            Coords(0.4734, 0.7955), --
            Coords(0.4748, 0.4469), --
            Coords(0.5638, 0.3091), --
            Coords(0.5775, 0.1792), --
            Coords(0.6743, 0.18), --
            Coords(0.6499, 0.279), --
            Coords(0.6312, 0.3134), --
            Coords(0.7030, 0.4727), --
            Coords(0.6714, 0.5588), --
            Coords(0.6542, 0.5738), --
            Coords(0.5552, 0.5846), --
            Coords(0.5538, 0.7783), --
            Coords(0.6857, 0.7869), --
        }}, -- Drak'Tharon Keep
        { 8, 13065, 154, {
            Coords(0.5882, 0.307), --
            Coords(0.5853, 0.3737), --
            Coords(0.5853, 0.4318), --
            Coords(0.5882, 0.4791), --
            Coords(0.5078, 0.4727), --
            Coords(0.4691, 0.5071), --
            Coords(0.4447, 0.5157), --
            Coords(0.4677, 0.5329), --
            Coords(0.4748, 0.6147), --
            Coords(0.4548, 0.6126), --
        }}, -- Gundrak 1
        { 9, 13065, 154, {
            Coords(0.3428, 0.312), --
            Coords(0.3414, 0.3758), --
            Coords(0.3443, 0.4835), --
            Coords(0.4246, 0.5007), --
            Coords(0.4605, 0.5416), --
            Coords(0.4548, 0.6126), --
        }}, -- Gundrak 2
        { 10, 13021, 129, {
            Coords(0.3615, 0.8758), --
            Coords(0.3615, 0.8113), --
            Coords(0.4533, 0.6714), --
            Coords(0.4964, 0.6714), --
            Coords(0.5251, 0.6068), --
            Coords(0.5595, 0.5229), --
            Coords(0.6413, 0.52), --
            Coords(0.6441, 0.6104), --
            Coords(0.5796, 0.6492), --
            Coords(0.5523, 0.647), --
        }}, -- The Nexus
        { 11, 13022, 159, {
            Coords(0.0918, 0.9296), --
            Coords(0.2051, 0.6563), --
            Coords(0.2496, 0.3572), --
            Coords(0.5667, 0.439), --
            Coords(0.8866, 0.4454), --
            Coords(0.7345, 0.3744), --
            Coords(0.6901, 0.2596), --
        }}, -- Azjol-Nerub 3rd Floor
        { 12, 13022, 158, {
            Coords(0.4347, 0.2015), --
            Coords(0.5609, 0.1571), --
            Coords(0.5997, 0.4842), --
            Coords(0.4835, 0.6707), --
            Coords(0.4849, 0.6018), --
        }}, -- Azjol-Nerub 2rd Floor
        { 13, 13022, 157, {
            Coords(0.2352, 0.5186), --
            Coords(0.2166, 0.4325), --
        }}, -- Azjol-Nerub 1st Floor
        { 14, 13066, 140, {
            Coords(0.3443, 0.3586), --
            Coords(0.4662, 0.3629), --
            Coords(0.5007, 0.4296), --
            Coords(0.5007, 0.5286), --
            Coords(0.3959, 0.5329), --
            Coords(0.3385, 0.5007), --
            Coords(0.3055, 0.5609), --
            Coords(0.2926, 0.6169), --
        }}, -- Halls of Stone
        { 15, 13067, 137, {
            Coords(0.4433, 0.1571), --
            Coords(0.439, 0.3314), --
            Coords(0.4002, 0.3572), --
            Coords(0.3371, 0.3572), --
            Coords(0.3486, 0.6843), --
            Coords(0.3974, 0.6886), --
            Coords(0.3974, 0.7682), --
            Coords(0.3572, 0.7525), --
        }}, -- Utgarde Pinnacle Upper Level part 1
        { 16, 13067, 136, {
            Coords(0.3572, 0.7525), --
            Coords(0.3572, 0.8601), --
            Coords(0.4562, 0.8565), --
            Coords(0.4576, 0.822), --
        }}, -- Utgarde Pinnacle Lower Level part 1
        { 17, 13067, 137, {
            Coords(0.5408, 0.7941), --
            Coords(0.5351, 0.7575), --
            Coords(0.5164, 0.7532), --
            Coords(0.5164, 0.8364), --
            Coords(0.6154, 0.8364), --
            Coords(0.6105, 0.7059), --
            Coords(0.6886, 0.6908), --
            Coords(0.6963, 0.3574), --
            Coords(0.5595, 0.3715), --
            Coords(0.5595, 0.3457), --
            Coords(0.5997, 0.3479), --
        }}, -- Utgarde Pinnacle Upper Level part 2
        { 18, 13067, 136, {
            Coords(0.5566, 0.1865), --
            Coords(0.4863, 0.2295), --
        }}, -- Utgarde Pinnacle Lower Level part 2
        { 19, 13017, 133, {
            Coords(0.6915, 0.7274), --
            Coords(0.6255, 0.3981), --
            Coords(0.6628, 0.2754), --
            Coords(0.5007, 0.284), --
            Coords(0.4433, 0.2711), --
            Coords(0.2338, 0.3852), --
            Coords(0.2682, 0.5329), --
            Coords(0.2137, 0.7596), --
            Coords(0.2697, 0.878), --
            Coords(0.4002, 0.8586), --
            Coords(0.4748, 0.6951), --
        }}, -- Utgarde Pinnacle Lower Level part 2
        { 20, 8676, 219, {
            Coords(0.5656, 0.9089), --
            Coords(0.5966, 0.6306), --
            Coords(0.5174, 0.4029), --
            Coords(0.464, 0.498), --
            Coords(0.396, 0.5148), --
            Coords(0.3353, 0.4386), --
            Coords(0.3445, 0.392), --
        }}, -- Zul'Farrak
        { 21, 8635, 67, {
            Coords(0.2472, 0.435),
            Coords(0.2151, 0.4389),
            Coords(0.2176, 0.5493),
            Coords(0.175, 0.5576),
            Coords(0.1415, 0.4709),
            Coords(0.1545, 0.4538),
            Coords(0.1786, 0.4012),
            Coords(0.185, 0.4404),
            Coords(0.261, 0.4155),
            Coords(0.3004, 0.4271)
        }}, -- Maraudon Entranceway 1
        { 22, 8635, 68, {
            Coords(0.47, 0.8831),
            Coords(0.5369, 0.8965),
            Coords(0.5365, 0.8213),
            Coords(0.4828, 0.7087),
            Coords(0.4425, 0.7707)
        }}, -- Maraudon Entranceway 2
        { 23, 8648, 90, {
            Coords(0.6604, 0.3235),
            Coords(0.6598, 0.3696),
            Coords(0.6661, 0.3819)
        }}, -- Undercity back pathway
        { 24, 8727, 317, {
            Coords(0.68, 0.8823), --
            Coords(0.6642, 0.8672), --
            Coords(0.6685, 0.5659), --
            Coords(0.5982, 0.5143), --
            Coords(0.6046, 0.3336), --
            Coords(0.769, 0.1872), --
            Coords(0.7876, 0.2238), --
        }}, -- Stratholme
        { 25, 8866, 87, {
            Coords(0.152, 0.8558), --
            Coords(0.2855, 0.6922), --
            Coords(0.2381, 0.5738), --
            Coords(0.2195, 0.4103), --
            Coords(0.251, 0.307), --
            Coords(0.2654, 0.2166), --
            Coords(0.2923, 0.1704)
        }}, -- Ironforge
        { 26, 8713, 220, {
            Coords(0.4992, 0.1563), --
            Coords(0.5021, 0.3479), --
            Coords(0.5781, 0.3845), --
            Coords(0.6298, 0.3436), --
        }}, -- Ironforge
    }
)
D["Pathways by UIMap ID Lookup"] = {}
D["Pathways by Quest ID Lookup"] = {}
for _, pathway in pairs(D["Pathways"].records) do
    local uiMapID = pathway["UIMap ID"]
    D["Pathways by UIMap ID Lookup"][uiMapID] = D["Pathways by UIMap ID Lookup"][uiMapID] or {}
    table.insert(D["Pathways by UIMap ID Lookup"][uiMapID], pathway)
    local questID = pathway["Quest ID"]
    D["Pathways by Quest ID Lookup"][questID] = D["Pathways by Quest ID Lookup"][questID] or {}
    table.insert(D["Pathways by Quest ID Lookup"][questID], pathway)
end
