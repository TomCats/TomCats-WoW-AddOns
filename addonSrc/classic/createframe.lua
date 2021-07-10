--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local renamedVariablePattern = addonName .. "_%s"

local mappedFrameNames = {

}

local matchedFrameNames = {
	--["^DropDownList[0-9]+.*$"] = renamedVariablePattern,
}

local mappedTemplateNames = {
	--["NavButtonTemplate"] = renamedVariablePattern:format("NavButtonTemplate"),
	--["UIDropDownMenuTemplate"] = renamedVariablePattern:format("UIDropDownMenuTemplate"),
	--["UIDropDownMenuButtonTemplate"] = renamedVariablePattern:format("UIDropDownMenuButtonTemplate"),
	["WorldMapFrameBorderFrameTemplate"] = renamedVariablePattern:format("WorldMapFrameBorderFrameTemplate")
}

local matchedTemplateNames = {
	--["^TomCats_.*$"] = "%s"
}

function CreateFrame(frameType, frameName, parentFrame, inheritsFrame)
	if (frameName) then
		local newName = mappedFrameNames[frameName]
		local matched = false;
		if (newName) then
			matched = true;
			frameName = newName
		else
			for k, v in pairs(matchedFrameNames) do
				if (string.match(frameName, k)) then
					matched = true
					frameName = v:format(frameName)
					break
				end
			end
		end
		if (not matched) then
			error(("Frame name not allowed: %s"):format(frameName))
		end
	end
	if (inheritsFrame) then
		local newName = mappedTemplateNames[inheritsFrame]
		local matched = false;
		if (newName) then
			matched = true;
			inheritsFrame = newName
		else
			for k, v in pairs(matchedTemplateNames) do
				if (string.match(inheritsFrame, k)) then
					matched = true
					inheritsFrame = v:format(inheritsFrame)
					break
				end
			end
		end
		if (not matched) then
			error(("Template not allowed: %s"):format(inheritsFrame))
		end
	end
	return getglobal("CreateFrame")(frameType, frameName, parentFrame, inheritsFrame)
end
