local C_QuestLog = CreateFromMixins(C_QuestLog)

--todo: fully implement these functions
function C_QuestLog.SetMapForQuestPOIs()

end

function C_QuestLog.GetSelectedQuest()
	return 1
end

function C_QuestLog.IsQuestDisabledForSession()
	return false
end

function C_QuestLog.CanAbandonQuest()
	return true
end

function C_QuestLog.GetQuestWatchType()
	return ""
end

function C_QuestLog.IsPushableQuest()
	return true
end

function C_QuestLog.GetNumQuestLogEntries()
	return 0
end

function C_QuestLog.GetZoneStoryInfo()

end

TomCats_C_QuestLog = C_QuestLog
