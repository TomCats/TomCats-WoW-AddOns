local _, addon = ...

local D = addon.TomCatsLibs.Data
local dataMineTooltipName = ("%sDatamineTooltip"):format(addon.name)
local dataMineTooltip = _G.CreateFrame("GameTooltip", dataMineTooltipName, UIParent, "GameTooltipTemplate")
local dataMineTitleText = _G[("%sDatamineTooltipTextLeft1"):format(addon.name)]
local isCreatureNamesLoaded
function addon.getCreatureNameByQuestID(achievementID)
	local IDNumber, Name, Points, Completed, Month, Day, Year, Description, Flags, Image, RewardText, isGuildAch = GetAchievementInfo(achievementID)
	return Name
--	return Name .. " " .. achievementID
end
function isCreatureNamesLoaded()
    --if(addon.creatureNamesLoaded) then return true end
    --for _, quest in pairs(D["Quests"].records) do
    --    if (not quest["Creature Name"]) then
    --        return false
    --    end
    --end
    --addon.creatureNamesLoaded = true
    return true
end
function addon.loadCreatureNames()
    --for k in pairs(D["Quests"].records) do
    --    addon.getCreatureNameByQuestID(k)
    --end
    --return isCreatureNamesLoaded()
end
addon.loadCreatureNames()
