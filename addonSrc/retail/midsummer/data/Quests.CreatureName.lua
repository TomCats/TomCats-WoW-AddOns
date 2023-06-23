local _, addon = ...
if (not addon.midsummer.IsEventActive()) then return end

local D = addon.midsummer.TomCatsLibs.Data
local dataMineTooltipName = ("%sDatamineTooltip"):format(addon.name)
local dataMineTooltip = _G.CreateFrame("GameTooltip", dataMineTooltipName, UIParent, "GameTooltipTemplate")
local dataMineTitleText = _G[("%sDatamineTooltipTextLeft1"):format(addon.name)]
local isCreatureNamesLoaded
function addon.midsummer.getCreatureNameByQuestID(questID)
    local quest = D["Quests"][questID]
    if (not quest) then return end
    if (not D["Quests"][questID]["Name"]) then
        dataMineTooltip:SetOwner(UIParent, "ANCHOR_NONE")
        dataMineTooltip:SetHyperlink(("unit:Creature-0-0-0-0-%d"):format(quest["Creature ID"]))
        local name = dataMineTitleText:GetText()
        if (name) then
            quest["Creature Name"] = name
            return name
        end
        return "LOADING"
    end
    return quest["Creature Name"]
end
function isCreatureNamesLoaded()
    if(addon.creatureNamesLoaded) then return true end
    for _, quest in pairs(D["Quests"].records) do
        if (not quest["Creature Name"]) then
            return false
        end
    end
    addon.creatureNamesLoaded = true
    return true
end
function addon.loadCreatureNames()
    for k in pairs(D["Quests"].records) do
        addon.midsummer.getCreatureNameByQuestID(k)
    end
    return isCreatureNamesLoaded()
end
addon.loadCreatureNames()
