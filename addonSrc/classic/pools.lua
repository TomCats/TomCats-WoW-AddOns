--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local allowedFramePools = {
	["MapCanvasDetailLayerTemplate"] = "TomCats_MapCanvasDetailLayerTemplate",
	["QuestLogHeaderTemplate"] = "TomCats_QuestLogHeaderTemplate",
	["QuestLogObjectiveTemplate"] = "TomCats_QuestLogObjectiveTemplate",
	["QuestLogTitleTemplate"] = "TomCats_QuestLogTitleTemplate",
}

function CreateFramePool(arg1, arg2, arg3, arg4)
	local allowedFramePool = allowedFramePools[arg3]
	if (allowedFramePool) then
		return getglobal("CreateFramePool")(arg1, arg2, arg3, arg4)
	end
	error(("Frame pool not allowed: %s"):format(arg3))
end
