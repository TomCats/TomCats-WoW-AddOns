--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local renamedVariablePattern = addonName .. "_%s"

local allowedFramePools = {
	["DungeonEntrancePinTemplate"] = renamedVariablePattern:format("DungeonEntrancePinTemplate"),
	["MapCanvasDetailLayerTemplate"] = renamedVariablePattern:format("MapCanvasDetailLayerTemplate"),
	["QuestLogHeaderTemplate"] = renamedVariablePattern:format("QuestLogHeaderTemplate"),
	["QuestLogObjectiveTemplate"] = renamedVariablePattern:format("QuestLogObjectiveTemplate"),
	["QuestLogTitleTemplate"] = renamedVariablePattern:format("QuestLogTitleTemplate"),
}

function CreateFramePool(arg1, arg2, arg3, arg4)
	local allowedFramePool = allowedFramePools[arg3]
	if (allowedFramePool) then
		return getglobal("CreateFramePool")(arg1, arg2, allowedFramePool, arg4)
	end
	error(("Frame pool not allowed: %s"):format(arg3))
end
