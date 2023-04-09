--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("options")

Home = CreateFrame("Frame")
Home:Hide()

local contents
local spacing = 20

local function Prime_OnHyperlinkClick(_, _, _, _, region, left, top, width, height)
	TogglePopup(
			"https://subs.twitch.tv/TomCat",
			"Press Control-C to copy the link",
			{ "CENTER", SettingsPanel.Container.SettingsCanvas, "CENTER", 0, 0 },
			region, { left, top, width, height }
	)
end

local function ShowTooltip(tooltip, frame, offsetX, offsetY)
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(frame, "ANCHOR_NONE")
	GameTooltip:SetPoint("BOTTOMLEFT", frame, "TOPRIGHT", offsetX or 0, offsetY or 0)
	GameTooltip:SetText(tooltip[1], 1, 1, 1)
	for i = 2, #tooltip do
		GameTooltip:AddLine(tooltip[i], 1, 0.82, 0, true)
	end
	GameTooltip:Show()
end

local function HideTooltip()
	GameTooltip:Hide()
end

local function AppendScript(frame, scriptType, newFunction)
	local originalScript = frame:GetScript(scriptType)
	if (originalScript) then
		frame:SetScript(scriptType, function(...)
			originalScript(...)
			newFunction(...)
		end)
	else
		frame:SetScript(scriptType, newFunction)
	end
end

local function AttachTooltip(tooltip, labelRegion, altRegion)
	if (labelRegion) then
		labelRegion:EnableMouse(true)
		labelRegion:SetScript("OnEnter",
				function() ShowTooltip(tooltip, labelRegion, 80, 10) end)
		labelRegion:SetScript("OnLeave", HideTooltip)
	end
	if (altRegion) then
		altRegion:EnableMouse(true)
		AppendScript(altRegion, "OnEnter", function() ShowTooltip(tooltip, altRegion) end)
		AppendScript(altRegion, "OnLeave", HideTooltip)
	end
end

Home:SetScript("OnShow", function(self)
	addon.minimapButton.Icon:SetDesaturated(true)
	addon.minimapButton:Disable()
	Header.Acquire(self)
	if (not contents) then
		contents = CreateFrame("Frame", nil, UIParent, "ResizeLayoutFrame")
		local playerName = UnitName("player")
		local greetings = CreateOptionsTitle(contents, string.format("Greetings %s!", playerName))
		local welcome = CreateFrame("SimpleHTML",nil, contents, "@addonName@_HTML_Welcome")
		welcome:SetPoint("TOPLEFT", greetings, "BOTTOMLEFT", 0, 0)
		welcome:SetPoint("RIGHT")
		welcome:SetScript("OnHyperlinkClick", Prime_OnHyperlinkClick)
		welcome.paragraphSpacing = 12
		local configurationTitle = CreateOptionsTitle(contents, "Settings", welcome)
		local configurationFrame = CreateFrame("Frame", nil, contents, "ResizeLayoutFrame")
		configurationFrame:SetPoint("LEFT")
		configurationFrame:SetPoint("RIGHT")
		configurationFrame:SetPoint("TOP", configurationTitle, "BOTTOM", 0, 0)
		configurationFrame:SetHeight(80)

		local minimapButtonConfig = CreateFrame("Frame", nil, configurationFrame)
		minimapButtonConfig:SetPoint("TOPLEFT")
		minimapButtonConfig:SetPoint("RIGHT")
		minimapButtonConfig:SetHeight(28)
		minimapButtonConfig.Label = minimapButtonConfig:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		minimapButtonConfig.Label:SetJustifyH("LEFT")
		minimapButtonConfig.Label:SetPoint("LEFT", 32, 0)
		minimapButtonConfig.Label:SetText("Minimap Button")
		minimapButtonConfig.checkButton = CreateFrame("CheckButton", nil, minimapButtonConfig)
		minimapButtonConfig.checkButton:SetSize(30, 29)
		minimapButtonConfig.checkButton:SetPoint("LEFT", 230, 0)
		minimapButtonConfig.checkButton:SetNormalAtlas("checkbox-minimal", true)
		minimapButtonConfig.checkButton:SetPushedAtlas("checkbox-minimal", true)
		minimapButtonConfig.checkButton:SetCheckedAtlas("checkmark-minimal", true)
		minimapButtonConfig.checkButton:SetDisabledCheckedAtlas("checkmark-minimal-disabled", true)
		minimapButtonConfig.checkButton:SetScript("OnClick", function(self)
			addon.minimapButton:SetEnabled(self:GetChecked())
		end)
		minimapButtonConfig.checkButton:SetChecked(addon.minimapButton:IsEnabled())
		AttachTooltip({
			"Minimap Button",
			"Enables or disables the TomCat's Tours icon on the minimap"
		}, minimapButtonConfig.Label, minimapButtonConfig.checkButton)

		local mapIconSizeConfig = CreateFrame("Frame", nil, configurationFrame)
		mapIconSizeConfig:SetPoint("TOPLEFT", minimapButtonConfig, "BOTTOMLEFT", 0, -8)
		mapIconSizeConfig:SetPoint("RIGHT")
		mapIconSizeConfig:SetHeight(28)
		mapIconSizeConfig.Label = mapIconSizeConfig:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		mapIconSizeConfig.Label:SetJustifyH("LEFT")
		mapIconSizeConfig.Label:SetPoint("LEFT", 32, 0)
		mapIconSizeConfig.Label:SetText("Map Icon Size")
		mapIconSizeConfig.slider = CreateFrame("Frame", nil, mapIconSizeConfig, "MinimalSliderWithSteppersTemplate")
		mapIconSizeConfig.slider:Init(addon.GetIconScale(),0.5,2,100)
		mapIconSizeConfig.slider:SetPoint("LEFT", 230, 0)
		mapIconSizeConfig.icon = mapIconSizeConfig:CreateTexture(nil, "ARTWORK")
		mapIconSizeConfig.icon:SetAtlas("VignetteKill", true)
		mapIconSizeConfig.icon:SetScale(0.7 * WorldMapFrame:GetScale() * addon.GetIconScale())
		mapIconSizeConfig.icon:SetPoint(
				"CENTER",
				mapIconSizeConfig.slider,
				"RIGHT",
				32 / (0.7 * WorldMapFrame:GetScale() * addon.GetIconScale()),
				0)
		mapIconSizeConfig.slider.Slider:SetScript("OnValueChanged", function(_, value)
			addon.SetIconScale(value)
			local trueScale = 0.7 * WorldMapFrame:GetScale() * addon.GetIconScale()
			mapIconSizeConfig.icon:ClearAllPoints()
			mapIconSizeConfig.icon:SetScale(trueScale)
			mapIconSizeConfig.icon:SetPoint(
					"CENTER",
					mapIconSizeConfig.slider,
					"RIGHT",
					32 / trueScale,
					0)
		end)
		AttachTooltip({
			"Map Icon Size",
			"Adjusts the size of TomCat's Tours icons on the world map"
		}, mapIconSizeConfig.Label, mapIconSizeConfig.slider.Slider)

		local mapIconAnimationConfig = CreateFrame("Frame", nil, configurationFrame)
		mapIconAnimationConfig:SetPoint("TOPLEFT", mapIconSizeConfig, "BOTTOMLEFT", 0, -8)
		mapIconAnimationConfig:SetPoint("RIGHT")
		mapIconAnimationConfig:SetHeight(28)
		mapIconAnimationConfig.Label = mapIconAnimationConfig:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		mapIconAnimationConfig.Label:SetJustifyH("LEFT")
		mapIconAnimationConfig.Label:SetPoint("LEFT", 32, 0)
		mapIconAnimationConfig.Label:SetText("Map Icon Animation")
		mapIconAnimationConfig.checkButton = CreateFrame("CheckButton", nil, mapIconAnimationConfig)
		mapIconAnimationConfig.checkButton:SetSize(30, 29)
		mapIconAnimationConfig.checkButton:SetPoint("LEFT", 230, 0)
		mapIconAnimationConfig.checkButton:SetNormalAtlas("checkbox-minimal", true)
		mapIconAnimationConfig.checkButton:SetPushedAtlas("checkbox-minimal", true)
		mapIconAnimationConfig.checkButton:SetCheckedAtlas("checkmark-minimal", true)
		mapIconAnimationConfig.checkButton:SetDisabledCheckedAtlas("checkmark-minimal-disabled", true)
		mapIconAnimationConfig.checkButton:SetScript("OnClick", function(self)
			addon.SetIconAnimationEnabled(self:GetChecked())
		end)
		mapIconAnimationConfig.checkButton:SetChecked(addon.IsIconAnimationEnabled())
		AttachTooltip({
			"Map Icon Animation",
			"Sets if the map icons will animate when there is an active rare or treasure"
		}, mapIconAnimationConfig.Label, mapIconAnimationConfig.checkButton)

		local accessoryWindowConfig = CreateFrame("Frame", nil, configurationFrame)
		accessoryWindowConfig:SetPoint("TOPLEFT", mapIconAnimationConfig, "BOTTOMLEFT", 0, -8)
		accessoryWindowConfig:SetPoint("RIGHT")
		accessoryWindowConfig:SetHeight(28)
		accessoryWindowConfig.Label = accessoryWindowConfig:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		accessoryWindowConfig.Label:SetJustifyH("LEFT")
		accessoryWindowConfig.Label:SetPoint("LEFT", 32, 0)
		accessoryWindowConfig.Label:SetText("Elemental Storms")
		local accessoryWindowDisplayPreference = osd.GetVisibilityOption()
		local accessoryDisplayConstants = addon.constants.accessoryDisplay
		accessoryWindowConfig.selectionPopout = Templates.CreateSelectionPopoutWithButtons(
				accessoryWindowConfig,
				{
					{
						label = "Always Shown",
						value = accessoryDisplayConstants.ALWAYS,
						selected = accessoryWindowDisplayPreference == accessoryDisplayConstants.ALWAYS
					},
					{
						label = "Never Shown",
						value = accessoryDisplayConstants.NEVER,
						selected = accessoryWindowDisplayPreference == accessoryDisplayConstants.NEVER
					},
					{
						label = "Hide when in instances",
						value = accessoryDisplayConstants.NOINSTANCES,
						selected = accessoryWindowDisplayPreference == accessoryDisplayConstants.NOINSTANCES
					},
					{
						label = "Shown when in relevant areas",
						value = accessoryDisplayConstants.RELEVANTZONES,
						selected = accessoryWindowDisplayPreference == accessoryDisplayConstants.RELEVANTZONES
					},
				},
				function()
					osd.SetVisibilityOption(accessoryWindowConfig.selectionPopout.selected.value)
				end
		)
		accessoryWindowConfig.selectionPopout:SetPoint("LEFT", 230, 0)
		accessoryWindowConfig.selectionPopout.Popout:Layout()
		AttachTooltip({
			"Elemental Storms",
			"Set when to display the Elemental Storms timers within the accessory window",
		}, accessoryWindowConfig.Label, accessoryWindowConfig.selectionPopout.Button)

		if (addon.noblegarden.IsEventActive()) then
			local noblegardenConfig = CreateFrame("Frame", nil, configurationFrame)
			noblegardenConfig:SetPoint("TOPLEFT", accessoryWindowConfig, "BOTTOMLEFT", 0, -8)
			noblegardenConfig:SetPoint("RIGHT")
			noblegardenConfig:SetHeight(28)
			noblegardenConfig.Label = noblegardenConfig:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			noblegardenConfig.Label:SetJustifyH("LEFT")
			noblegardenConfig.Label:SetPoint("LEFT", 32, 0)
			noblegardenConfig.Label:SetText("Noblegarden")
			noblegardenConfig.checkButton = CreateFrame("CheckButton", nil, noblegardenConfig)
			noblegardenConfig.checkButton:SetSize(30, 29)
			noblegardenConfig.checkButton:SetPoint("LEFT", 230, 0)
			noblegardenConfig.checkButton:SetNormalAtlas("checkbox-minimal", true)
			noblegardenConfig.checkButton:SetPushedAtlas("checkbox-minimal", true)
			noblegardenConfig.checkButton:SetCheckedAtlas("checkmark-minimal", true)
			noblegardenConfig.checkButton:SetDisabledCheckedAtlas("checkmark-minimal-disabled", true)
			noblegardenConfig.checkButton:SetScript("OnClick", function(self)
				TomCats_Account.noblegarden.enabled = self:GetChecked()
			end)
			noblegardenConfig.checkButton:SetChecked(TomCats_Account.noblegarden.enabled)
			AttachTooltip({
				"Noblegarden",
				"Enables or disables the TomCat's Tours Nobelgarden egg auto-looting feature"
			}, noblegardenConfig.Label, noblegardenConfig.checkButton)
		end

		local contactTitle = CreateOptionsTitle(contents, "Links", configurationFrame)
		local contact = CreateFrame("SimpleHTML",nil, contents, "@addonName@_HTML_Contact")
		contact:SetPoint("TOPLEFT", contactTitle, "BOTTOMLEFT", 0, 0)
		contact:SetPoint("RIGHT")

		local links = {
			{ ImagePNG.icon_www, "Visit TomCatsTours.com", "https://tomcatstours.com", 128},
			{ ImagePNG.icon_prime, "Support for free\nusing your Amazon Prime", "https://subs.twitch.tv/TomCat",  163},
			{ ImagePNG.icon_twitch, "Watch live at\nTwitch.tv/TomCat", "https://twitch.tv/TomCat", 110},
			{ ImagePNG.icon_github, "Sponsor via GitHub", "https://github.com/sponsors/TomCats", 128},
			{ ImagePNG.icon_paypal, "Contribute via PayPal", "https://www.paypal.com/donate?hosted_button_id=QDVM7VNAMAQJ2", 104},
			{ ImagePNG.icon_patreon, "Become a Patreon", "https://www.patreon.com/join/TomCatsTours", 128},
			{ ImagePNG.icon_discord, "Join us on Discord", "https://discord.gg/T7qXXSt", 144},
			{ ImagePNG.icon_twitter, "Follow on Twitter", "https://twitter.com/TomCatsTours", 141},
			{ ImagePNG.icon_wago, "Download at Wago AddOns", "https://addons.wago.io/addons/tomcats", 169},
			{ ImagePNG.icon_curseforge, "Download at CurseForge", "https://www.curseforge.com/wow/addons/tomcats", 162},
		}

		local linksFrame = CreateFrame("Frame", nil, contents)
		linksFrame:SetPoint("LEFT")
		linksFrame:SetPoint("RIGHT")
		linksFrame:SetPoint("TOP", contact, "BOTTOM", 0, -spacing)
		linksFrame:SetHeight(32)

		local linkIconTotalWidth = 0
		for _, linkData in ipairs(links) do
			local link = LinkButton.Create(linksFrame,
					linkData[2],
					linkData[3],
					linkData[1],
					linkData[4])
			linkIconTotalWidth = linkIconTotalWidth + linkData[4]
			linkData.link = link
		end

		linksFrame.IsLayoutFrame = ResizeLayoutMixin.IsLayoutFrame

		function linksFrame:Layout()
			local linkSpacing = (linksFrame:GetWidth() - (linkIconTotalWidth / 4)) / #links
			for idx, linkData in ipairs(links) do
				linkData.link:ClearAllPoints()
				linkData.link:SetPoint("LEFT",
						idx == 1 and linksFrame or links[idx - 1].link,
						"LEFT",
						idx == 1 and linkSpacing / 2 or (links[idx-1][4] / 4) + linkSpacing,
						0)
			end
		end
		local featuresTitle = CreateOptionsTitle(contents, "New and Upcoming Features", linksFrame)
		local features = CreateFrame("SimpleHTML",nil, contents, "@addonName@_HTML_Features")
		features:SetPoint("TOPLEFT", featuresTitle, "BOTTOMLEFT", 0, 0)
		features:SetPoint("RIGHT")
	end
	ScrollBox.Acquire(self, contents, spacing * 3)
end)

function CreateOptionsTitle(parent, text, previousSibling)
	local titleFrame = CreateFrame("Frame", nil, parent)
	local optionsTitle = titleFrame:CreateFontString(nil, "Artwork", "GameFontHighlightHuge")
	optionsTitle:SetText(text)
	optionsTitle:SetPoint("TOPLEFT", 0, 0)
	local underline = titleFrame:CreateTexture()
	underline:SetAtlas("Options_HorizontalDivider", true)
	underline:SetPoint("BOTTOMLEFT", 0, 12)
	if (previousSibling) then
		titleFrame:SetPoint("LEFT")
		titleFrame:SetPoint("RIGHT")
		titleFrame:SetPoint("TOP", previousSibling, "BOTTOM", 0, -spacing)
	else
		titleFrame:SetPoint("TOPLEFT", 0, -spacing)
		titleFrame:SetPoint("RIGHT")
	end
	titleFrame:SetHeight(optionsTitle:GetStringHeight() + 20)
	return titleFrame
end

Home:SetScript("OnHide", function()
	addon.minimapButton.Icon:SetDesaturated(false)
	addon.minimapButton:Enable()
	Header.Release()
end)

--todo: localize
addon.SettingsCategory = Settings.RegisterCanvasLayoutCategory(Home, "TomCat's Tours")
Settings.RegisterAddOnCategory(addon.SettingsCategory)
