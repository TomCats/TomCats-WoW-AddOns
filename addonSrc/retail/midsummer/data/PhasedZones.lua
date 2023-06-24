local _, addon = ...
if (not addon.midsummer.IsEventActive()) then return end

local D = addon.midsummer.TomCatsLibs.Data
D.loadData(
    "Phased Zones",
    { "UIMap ID", "Quest IDs", "Timewalking NPC POI IDs", "Visible UIMap IDs", "Timewalking Map Art ID", "Alt Phase Zone", "Phase Quest ID", "Phase Complete Status" },
    {
        { 14, { 11764, 11804, 11840, 11732 }, { 5989 }, { 13 }, 15 }, -- arathi highlands
        { 57, { 11824, 11753 }, { 5760 }, { 12 }, nil, 62, 54411, true }, -- teldrassil
        { 62, { 11811, 11740 }, { 5760 }, { 12 }, nil, nil, 54411, true }, -- darkshore
        { 81, { 11800, 11831, 11760, 11836 }, { 5561 }, { 12 }, 86 }, -- silithus
        { 18, { 11862, 11786 }, { 5757 }, { 13 }, nil, nil, 52758, true }, -- tirisfal glades
        { 90, { 9326 }, { 5757 }, { 13 }, nil, 18, 52758, true }, -- Undercity
        { 89, { 11935 }, { 5760 }, { 13 }, nil, 62, 54411, true }, -- Darnassus
        { 17, { 28917, 11808, 11737, 28930 }, { 5562 }, { 13 }, 18 }, -- blasted lands
        { 249, { 28948, 28950, 28947, 28949 }, { 6548, 6549 }, { 12 }, nil, 1527, 50659, true }, -- Uldum
        { 390, { 32496, 32510, 32503, 32509 }, { 6573, 6574 }, { 424 }, nil, 1530, 59024, true }, -- Vale of Eternal Blossom
    }
)
D["Phased Zone by Visible UIMap ID Lookup"] = {}
D["Phased Zone by Quest ID Lookup"] = {}
for _, phasedZone in pairs(D["Phased Zones"].records) do
    for i = 1, #phasedZone["Visible UIMap IDs"] do
        local uiMapID = phasedZone["Visible UIMap IDs"][i]
        D["Phased Zone by Visible UIMap ID Lookup"][uiMapID] = D["Phased Zone by Visible UIMap ID Lookup"][uiMapID] or {}
        table.insert(D["Phased Zone by Visible UIMap ID Lookup"][uiMapID], phasedZone)
    end
    for i = 1, #phasedZone["Quest IDs"] do
        D["Phased Zone by Quest ID Lookup"][phasedZone["Quest IDs"][i]] = phasedZone
    end
end
