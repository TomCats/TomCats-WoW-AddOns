--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

C_QuestLog = CreateFromMixins(getglobal("C_QuestLog"))

--todo: fully implement these functions
function C_QuestLog.SetMapForQuestPOIs()
--	print("C_QuestLog.SetMapForQuestPOIs not implemented")
end

--local GetQuestLogTitle = GetQuestLogTitle
--local GetNumQuestLogEntries = GetNumQuestLogEntries

--function C_QuestLog.CanAbandonQuest(questID)
--	print("C_QuestLog.CanAbandonQuest not overridden")
--end

--local GetMaxNumQuests = C_QuestLog.GetMaxNumQuests
--function C_QuestLog.GetMaxNumQuests()
--	print("C_QuestLog.GetMaxNumQuests not overridden")
--	return GetMaxNumQuests()
--end

--local GetMaxNumQuestsCanAccept = C_QuestLog.GetMaxNumQuestsCanAccept
--function C_QuestLog.GetMaxNumQuestsCanAccept()
--	print("C_QuestLog.GetMaxNumQuests not implemented")
--	return GetMaxNumQuestsCanAccept()
--end

--function C_QuestLog.GetInfo(questLogIndex)
--	local questLogTitleText, level, questTag, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isBounty, isStory, isHidden, isScaling = GetQuestLogTitle(questLogIndex);
--	return {
--		title = questLogTitleText,
--		questLogIndex = questLogIndex,
--		questID = questID,
--		level = level,
--		difficultyLevel = 1,
--		suggestedGroup = 1,
--		frequency = frequency,
--		isHeader = isHeader,
--		isCollapsed = isCollapsed,
--		startEvent = startEvent,
--		isTask = isTask,
--		isBounty = isBounty,
--		isStory = isStory,
--		isScaling = isScaling,
--		isOnMap = isOnMap,
--		hasLocalPOI = hasLocalPOI,
--		isHidden = isHidden,
--		isAutoComplete = isComplete,
--		overridesSortOrder = false,
--		readyForTranslation = false
--	}
--end

--function C_QuestLog.GetNumQuestLogEntries()
--	return GetNumQuestLogEntries()
--end

--local GetQuestObjectives = C_QuestLog.GetQuestObjectives
--function C_QuestLog.GetQuestObjectives(questID)
--	print("C_QuestLog.GetQuestObjectives not implemented")
--	return GetQuestObjectives(questID)
--end

--function C_QuestLog.GetQuestWatchType(questID)
--	print("C_QuestLog.GetQuestWatchType not implemented")
--	return nil
--end

function C_QuestLog.GetSelectedQuest()
--	print("C_QuestLog.GetSelectedQuest not implemented")
	return 1
end

function C_QuestLog.IsQuestDisabledForSession()
--	print("C_QuestLog.IsQuestDisabledForSession not implemented")
	return false
end

function C_QuestLog.CanAbandonQuest()
	return true
end

function C_QuestLog.GetQuestWatchType()
	return ""
end

function C_QuestLog.IsPushableQuest()
--	print("C_QuestLog.IsPushableQuest not implemented")
	return true
end

function C_QuestLog.GetNumQuestLogEntries()
	return 0
end

function C_QuestLog.GetZoneStoryInfo()
--	print("C_QuestLog.GetZoneStoryInfo not implemented")
end

--local IsOnQuest = C_QuestLog.IsOnQuest
--function C_QuestLog.IsOnQuest(...)
--	print("C_QuestLog.IsOnQuest not implemented")
--	return IsOnQuest(...)
--end

--function C_QuestLog.IsPushableQuest(questID)
--	print("C_QuestLog.IsPushableQuest not implemented")
--	return false
--end

--function C_QuestLog.IsQuestCalling(questID)
--	print("C_QuestLog.IsQuestCalling not implemented")
--	return false
--end

--local IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted
--function C_QuestLog.IsQuestFlaggedCompleted(...)
--	print("C_QuestLog.IsQuestFlaggedCompleted not implemented")
--	return IsQuestFlaggedCompleted(...)
--end

--local ShouldShowQuestRewards = C_QuestLog.ShouldShowQuestRewards
--function C_QuestLog.ShouldShowQuestRewards(...)
--	print("C_QuestLog.ShouldShowQuestRewards not implemented")
--	return ShouldShowQuestRewards(...)
--end
