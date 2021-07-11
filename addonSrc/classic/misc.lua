--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

--todo: implement when quest POIs are added to the map
QuestMapUpdateAllQuests = function() return 0  end
QuestPOIUpdateIcons = nop
ObjectiveTracker_UpdatePOIs = nop

-- todo: remove after QuestPOI.lua is imported
QuestPOI_HideUnusedButtons = nop
QuestPOI_ResetUsage = nop
QuestPOI_SelectButtonByQuestID = nop
