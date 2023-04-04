--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope()

Templates = Templates or { }

local AddPopoutEntry, CreateNextBackButton, SetSelectedEntry

function AddPopoutEntry(parent, label, value)
	local idx = #parent.entries + 1
	local entry = CreateFrame("Button", nil, parent.Popout, "ResizeLayoutFrame")
	parent.entries[idx] = entry
	entry:SetSize(250,20)
	entry.widthPadding = 14
	entry.defaultWidth = 50
	entry.HighlightBGTex = CreateFrame("Frame", nil, entry)
	entry.HighlightBGTex:SetAlpha(0)
	entry.HighlightBGTex:SetAllPoints()
	entry.HighlightBGTex.ignoreInLayout = true
	entry.HighlightBGTex.Left = entry.HighlightBGTex:CreateTexture(nil, "BACKGROUND")
	entry.HighlightBGTex.Left:SetAtlas("charactercreate-customize-dropdown-linemouseover-side", true)
	entry.HighlightBGTex.Left:SetPoint("TOPLEFT")
	entry.HighlightBGTex.Right = entry.HighlightBGTex:CreateTexture(nil, "BACKGROUND")
	entry.HighlightBGTex.Right:SetAtlas("charactercreate-customize-dropdown-linemouseover-side", true)
	entry.HighlightBGTex.Right:SetPoint("BOTTOMRIGHT")
	entry.HighlightBGTex.Right:SetTexCoord(1,0,0,1)
	entry.HighlightBGTex.Middle = entry.HighlightBGTex:CreateTexture(nil, "BACKGROUND")
	entry.HighlightBGTex.Middle:SetAtlas("charactercreate-customize-dropdown-linemouseover-middle", true)
	entry.HighlightBGTex.Middle:SetPoint("TOPLEFT", entry.HighlightBGTex.Left, "TOPRIGHT")
	entry.HighlightBGTex.Middle:SetPoint("BOTTOMRIGHT", entry.HighlightBGTex.Right, "BOTTOMLEFT")
	entry:SetScript("OnEnter", function()
		entry.HighlightBGTex:SetAlpha(0.15)
	end)
	entry:SetScript("OnLeave", function()
		entry.HighlightBGTex:SetAlpha(0)
	end)
	entry.SelectionDetails = CreateFrame("Frame", nil, entry)
	entry.SelectionDetails:SetSize(250, 20)
	entry.SelectionDetails:SetPoint("TOPLEFT", 14, 0)
	entry.SelectionDetails.selectionNamePadding = 14
	entry.SelectionDetails.SelectionName = entry.SelectionDetails:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	entry.SelectionDetails.SelectionName:SetJustifyH("LEFT")
	entry.SelectionDetails.SelectionName:SetAllPoints()
	entry.SelectionDetails.SelectionName:SetText(label)
	if (idx == 1) then
		entry:SetPoint("TOPLEFT", 5, -12)
	else
		entry:SetPoint("TOPLEFT", parent.entries[idx - 1], "BOTTOMLEFT")
	end
	entry.value = value
	return entry
end

function CreateNextBackButton(parent, type, anchor)
	local button = CreateFrame("Button", nil, parent)
	button:SetSize(32, 32)
	button:SetNormalAtlas("charactercreate-customize-" .. type .. "button")
	button:SetPushedAtlas("charactercreate-customize-" .. type .. "button-down")
	button:SetHighlightAtlas("charactercreate-customize-" .. type .. "button")
	button:SetDisabledAtlas("charactercreate-customize-" .. type .. "button-disabled")
	button:SetScript("OnMouseDown", function()
		button:SetHighlightAtlas("charactercreate-customize-" .. type .. "button-down")
	end)
	button:SetScript("OnClick", function()
		parent:Select(type == "back" and parent.selectedIndex - 1 or parent.selectedIndex + 1)	end)
	button:SetScript("OnMouseUp", function() button:SetHighlightAtlas("charactercreate-customize-" .. type .. "button")  end)
	button:SetPoint(anchor)
	return button
end

function SetSelectedEntry(frame, entry)
	if (type(entry) == "number") then
		entry = frame.entries[entry]
	end
	if (frame.selected ~= entry) then
		frame.selected = entry
		frame.Button.SelectionName:SetText(entry.SelectionDetails.SelectionName:GetText())
		for idx, e in ipairs(frame.entries) do
			if (e == entry) then
				e.SelectionDetails.SelectionName:SetFontObject("GameFontNormal")
				frame.selectedIndex = idx
				frame.BackButton:SetEnabled(idx ~= 1)
				frame.NextButton:SetEnabled(idx ~= #frame.entries)
			else
				e.SelectionDetails.SelectionName:SetFontObject("GameFontHighlight")
			end
		end
		if (frame.OnSelectionChanged) then
			frame:OnSelectionChanged()
		end
	end
end

function Templates.CreateSelectionPopoutWithButtons(parent, entries, callback)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetSize(304, 38)
	frame.NextButton = CreateNextBackButton(frame, "next", "RIGHT")
	frame.BackButton = CreateNextBackButton(frame, "back", "LEFT")
	frame.Button = CreateFrame("EventButton", nil, frame)
	frame.Button.HandlesGlobalMouseEvent = SelectionPopoutButtonMixin.HandlesGlobalMouseEvent
	frame.Button:SetSize(250, 38)
	frame.Button:SetPoint("CENTER")
	frame.Button:SetNormalAtlas("charactercreate-customize-dropdownbox")
	frame.Button:SetHighlightAtlas("charactercreate-customize-dropdownbox-open", "ADD")
	frame.Button:GetHighlightTexture():SetAlpha(0)
	local popoutShown = false
	frame.Button:SetScript("OnEnter", function()
		if (not popoutShown) then
			frame.Button:SetNormalAtlas("charactercreate-customize-dropdownbox-hover")
			frame.Button:GetHighlightTexture():SetAlpha(0)
		else
			frame.Button:GetHighlightTexture():SetAlpha(0.3)
		end
	end)
	frame.Button:SetScript("OnLeave", function()
		frame.Button:SetNormalAtlas("charactercreate-customize-dropdownbox")
	end)
	frame.Button:SetScript("OnEvent", function(self, _, buttonID)
		if (buttonID == "LeftButton" and self:IsShown()) then
			for _, e in ipairs(frame.entries) do
				if (e:IsMouseOver()) then
					frame:Select(e)
				end
			end
			local mouseOver = self:IsMouseOver()
			popoutShown = frame.Popout:IsShown()
			if (mouseOver) then
				popoutShown = not popoutShown
			else
				popoutShown = false
			end
			frame.Popout:SetShown(popoutShown)
			if (mouseOver and not popoutShown) then
				frame.Button:SetNormalAtlas("charactercreate-customize-dropdownbox-hover")
				frame.Button:GetHighlightTexture():SetAlpha(0)
			else
				frame.Button:SetNormalAtlas("charactercreate-customize-dropdownbox")
				frame.Button:GetHighlightTexture():SetAlpha(0.3)
			end
		end
	end)
	frame.Button:RegisterEvent("GLOBAL_MOUSE_DOWN")
	frame.Popout = CreateFrame("Frame", nil, frame, "ResizeLayoutFrame")
	frame.Popout:SetShown(false)
	frame.Popout:SetSize(350, 100)
	frame.Popout:SetPoint("TOP", frame.Button, "BOTTOM", 0, 11)
	frame.Popout:SetFrameLevel(500)
	frame.Popout.Border = CreateFrame("Frame", nil, frame.Popout, "NineSlicePanelTemplate")
	frame.Popout.widthPadding = 6
	frame.Popout.heightPadding = 32
	frame.Popout.Border.layoutType = "CharacterCreateDropdown"
	frame.entries = { }
	frame.Button.SelectionName = frame.Button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	frame.Button.SelectionName:SetPoint("TOP", 0, -12)
	NineSlicePanelMixin.OnLoad(frame.Popout.Border)
	frame.Add = AddPopoutEntry
	frame.Select = SetSelectedEntry
	if (entries) then
		local selectedIndex = 1
		for idx, entry in ipairs(entries) do
			frame:Add(entry.label, entry.value)
			if (entry.selected) then
				selectedIndex = idx
			end
		end
		frame:Select(selectedIndex)
	end
	frame.OnSelectionChanged = callback
	return frame
end