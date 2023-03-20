--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope()

Templates = Templates or { }

function Templates.CreateTimerRow(parentFrame, params)
	local frame = CreateFrame("Frame",nil, parentFrame)
	local texture = frame:CreateTexture()
	texture:SetAllPoints()
	frame.title = frame:CreateFontString(nil, "ARTWORK", "GameFontWhite")
	frame.title:SetJustifyH("LEFT")
	frame.title:SetText("The Waking Shores")
	frame.title:Show()
	frame.title:SetPoint("TOPLEFT", frame, "TOPLEFT", 22, 0)
	frame:SetHeight(frame.title:GetStringHeight())
	frame.timer = frame:CreateFontString(nil, "ARTWORK", "GameFontWhite")
	frame.timer:SetJustifyH("RIGHT")
	frame.timer:SetText("---")
	frame.timer:SetPoint("TOP", frame.title, "TOP")
	frame.timer:SetPoint("RIGHT", frame, "RIGHT", 0, 0)
	local icon = params and params.icon or nil
	frame.icon = frame:CreateTexture(nil, "ARTWORK")
	frame.icon:SetSize(16, 16)
	frame.icon:SetAtlas(icon)
	frame.icon:SetPoint("LEFT", frame, "LEFT", 2, 0)
	frame.SetTitle = SetTitle
	frame.SetIcon = SetIcon
	return frame
end
