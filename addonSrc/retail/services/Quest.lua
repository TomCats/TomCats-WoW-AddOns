local _, addon = ...

addon.services = addon.services or { }
addon.services.QuestService = { }
local QuestService = addon.services.QuestService

local questTitleCache = { }
local questQueue = { }

function QuestService.GetQuestTitle(questID)
    local questTitle = questTitleCache[questID]
    if (not questTitle) then
        questTitle = C_QuestLog.GetTitleForQuestID(questID)
        questTitleCache[questID] = questTitle
    end
    if (not questTitle) then
        questQueue[questID] = true
       -- C_QuestLog.RequestLoadQuestByID(questID)
    end
    return questTitle
end

local eventFrame = CreateFrame("Frame")

eventFrame:SetScript("OnEvent", function(_, _, questID, success)
    if (success and questQueue[questID]) then
        questTitleCache[questID] = C_QuestLog.GetTitleForQuestID(questID)
        questQueue[questID] = nil
    end
end)

eventFrame:RegisterEvent("QUEST_DATA_LOAD_RESULT")
