--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("options")

LinkButton = { }

local function OnClick(self)
	TogglePopup(
			self.linkText,
			"Press " .. (IsMacClient() and "Cmd" or "Ctrl") .. "-C to copy the link",
			{ "CENTER", SettingsPanel.Container.SettingsCanvas, "CENTER", 0, 0 },
			self
	)
end

local function OnEnter(self)
	self.icon:ClearAllPoints()
	self.icon:SetPoint("LEFT", -4, 0)
	self.icon:SetScale(1.25)
	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 12)
	GameTooltip:SetText(self.label)
	GameTooltip:Show()
end

local function OnLeave(self)
	self.icon:SetScale(1.0)
	self.icon:ClearAllPoints()
	self.icon:SetPoint("LEFT", 0, 0)
	GameTooltip:Hide()
end

function LinkButton.Create(frame, label, linkText, iconPath, originalWidth)
	local linkButton = CreateFrame("Button", nil, frame)
	linkButton:SetScript("OnClick", OnClick)
	linkButton:SetScript("OnEnter", OnEnter)
	linkButton:SetScript("OnLeave", OnLeave)
	linkButton.label = label
	linkButton.icon = linkButton:CreateTexture()
	linkButton.icon:SetTexture(iconPath, "CLAMP", "CLAMP", "TRILINEAR")
	linkButton.icon:SetSize(originalWidth > 128 and 64 or 32, 32)
	linkButton.icon:SetPoint("LEFT", 0, 0)
	linkButton:SetSize(32, 32)
	linkButton.linkText = linkText
	return linkButton
end
