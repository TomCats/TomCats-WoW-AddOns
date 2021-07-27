--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local selectedQuestID
local abandonQuest

QuestInfoCache = { }

QuestLogIDCache = { }

C_QuestLog = CreateFromMixins(getglobal("C_QuestLog"))

function C_QuestLog.AddQuestWatch(questID, questWatchType)
	local questIndex = QuestLogIDCache[questID]
	if (questIndex) then
		if ( GetNumQuestLeaderBoards(questIndex) == 0 ) then
			UIErrorsFrame:AddMessage(QUEST_WATCH_NO_OBJECTIVES, 1.0, 0.1, 0.1, 1.0)
			return
		end
		-- Set an error message if trying to show too many quests
		if ( GetNumQuestWatches() >= MAX_WATCHABLE_QUESTS ) then
			UIErrorsFrame:AddMessage(format(QUEST_WATCH_TOO_MANY, MAX_WATCHABLE_QUESTS), 1.0, 0.1, 0.1, 1.0)
			return
		end
		AutoQuestWatch_Insert(questIndex, QUEST_WATCH_NO_EXPIRE);
		QuestWatch_Update()
	end
end

function C_QuestLog.CanAbandonQuest(questID)
	--todo: unclear if any quests cannot be abandoned in TBC - always return true until proven otherwise
	return true
end

function C_QuestLog.GetAbandonQuest()
	return abandonQuest
end

function C_QuestLog.GetInfo(questLogIndex)
	local questLogTitleText, level, questTag, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isBounty, isStory, isHidden, isScaling = GetQuestLogTitle(questLogIndex);
	QuestLogIDCache[questID] = questLogIndex
	local questInfo = {
		title = questLogTitleText,
		questLogIndex = questLogIndex,
		questID = questID,
		level = level,
		difficultyLevel = 1,
		suggestedGroup = 0,
		frequency = frequency,
		isHeader = isHeader,
		isCollapsed = isCollapsed,
		startEvent = startEvent,
		isTask = isTask,
		isBounty = isBounty,
		isStory = isStory,
		isScaling = isScaling,
		isOnMap = isOnMap,
		hasLocalPOI = hasLocalPOI,
		isHidden = isHidden,
		isAutoComplete = isComplete,
		overridesSortOrder = false,
		readyForTranslation = false,
		shouldDisplay = isHeader
	}
	QuestInfoCache[questID] = questInfo
	return questInfo
end

function C_QuestLog.GetNextWaypoint(questID)
	-- todo: implement with quest database
end

function C_QuestLog.GetNextWaypointText(questID)
	-- todo: implement with quest database
	return QuestInfoCache[questID] and QuestInfoCache[questID].title or ""
end

function C_QuestLog.GetNumQuestLogEntries()
	return GetNumQuestLogEntries()
end

function C_QuestLog.GetQuestDetailsTheme(questID)
	-- todo: implement with quest database (nil = default theme)
end

function C_QuestLog.GetLogIndexForQuestID(questID)
	return QuestLogIDCache[questID]
end

function C_QuestLog.GetQuestTagInfo(questID)
	-- todo: implement with quest database
	return nil
end

function C_QuestLog.GetQuestWatchType(questID)
	local questIndex = QuestLogIDCache[questID]
	if (questIndex and IsQuestWatched(questIndex)) then
		return Enum.QuestWatchType.Manual
	end
end

function C_QuestLog.GetRequiredMoney(questID)
	-- todo: implement with quest database
	return 0
end

function C_QuestLog.GetSelectedQuest()
	return selectedQuestID
end

function C_QuestLog.GetSuggestedGroupSize(questID)
	-- todo: implement with quest database
	return QuestInfoCache[questID] and QuestInfoCache[questID].suggestedGroup
end

function C_QuestLog.GetTitleForQuestID(questID)
	return QuestInfoCache[questID] and QuestInfoCache[questID].title
end

function C_QuestLog.GetZoneStoryInfo()
	-- there is no zone story info in TBC - always return nil
end

function C_QuestLog.IsComplete(questID)
	return C_QuestLog.IsQuestFlaggedCompleted(questID)
end

function C_QuestLog.IsFailed(questID)
	local questInfo = QuestInfoCache[questID]
	return questInfo and questInfo.isAutoComplete and questInfo.isAutoComplete < 0
end

function C_QuestLog.IsPushableQuest()
	--todo: determine how the share quest button is setup in TBC
	return true
end

function C_QuestLog.IsQuestCalling(questID)
	-- there are no calling quests in TBC
	return false
end

function C_QuestLog.IsQuestDisabledForSession()
	-- quest session management is not enabled in TBC
	return false
end

function C_QuestLog.IsQuestReplayable()
	-- not applicable to TBC
	return false
end

function C_QuestLog.IsUnitOnQuest(unit, questID)
	local questIndex = QuestLogIDCache[questID]
	if (questIndex) then
		return IsUnitOnQuest(questIndex, unit)
	end
	return false
end

function C_QuestLog.QuestHasQuestSessionBonus(questID)
	-- quest session is not active in TBC
	return false
end

function C_QuestLog.RequestLoadQuestByID(questID)
	-- todo: implement with quest database
	if (QuestInfoCache[questID]) then
		local callback = QuestEventListener:GetScript("OnEvent")
		C_Timer.NewTimer(0, function()
			callback(QuestEventListener, "QUEST_DATA_LOAD_RESULT", questID, true)
		end)
	end
end

function C_QuestLog.SetMapForQuestPOIs()
	-- todo: implement with quest database
end

function C_QuestLog.SetAbandonQuest()
	SetAbandonQuest()
	abandonQuest = selectedQuestID
end

function C_QuestLog.SetSelectedQuest(questID)
	selectedQuestID = questID
	local idx = QuestLogIDCache[questID]
	if (idx) then
		SelectQuestLogEntry(idx)
	end
end

function GetNumQuestLogRewardCurrencies()
	return 0
end

function GetQuestLogRewardSkillPoints()
	-- todo: implement with quest database
	return 0
end

function GetQuestLogRewardXP()
	-- todo: implement with quest database
	return 0
end

function GetQuestLogCriteriaSpell()
	-- todo: implement with quest database
	return GetCriteriaSpell()
end

function GetQuestLogRewardCurrencyInfo(idx, questID)
	-- todo: implement with quest database if needed
end

function GetQuestUiMapID(questID, ignoreWaypoints)
	-- todo: implement with quest database
	return WorldMapFrame:GetMapID()
end

-- temporarily implemented in lieu of full retail objective tracker implementation
function QuestObjectiveTracker_UntrackQuest(dropdownButton, questID)
	for index, value in ipairs(QUEST_WATCH_LIST) do
		if ( value.id == questID ) then
			tremove(QUEST_WATCH_LIST, index)
		end
	end
	local questIndex = QuestLogIDCache[questID]
	if (questIndex) then
		RemoveQuestWatch(questIndex)
	end
	QuestWatch_Update()
end

getglobal("hooksecurefunc")("AbandonQuest", function()
	QuestMapFrame_ReturnFromQuestDetails()
end)
