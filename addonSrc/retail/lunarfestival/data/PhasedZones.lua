local _, addon = ...
if (not addon.lunarfestival.IsEventActive()) then return end

local D = addon.lunarfestival.TomCatsLibs.Data
D.loadData(
    "Phased Zones",
    { "UIMap ID", "Quest IDs", "Timewalking NPC POI ID", "Visible UIMap IDs", "Timewalking Map Art ID" },
    {
        { 62, { 8721, 8715, 8718 }, 5760, { 12 }, 67 },
        { 81, { 8654, 8719 }, 5561, { 12 }, 86 },
        { 18, { 8652, 8648}, 5757, { 13 },  19 },
        { 17, { 8647 }, 5562, { 13 }, 18 },
        { 1527, { 29741, 29742 }, 6548, { 12 }, 289 }
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
