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

		local contactTitle = CreateOptionsTitle(contents, "Links", welcome)
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

		local configurationTitle = CreateOptionsTitle(contents, "Settings (Map and Floating Window)", linksFrame)
		local configurationFrame = CreateFrame("Frame", nil, contents, "ResizeLayoutFrame")
		configurationFrame:SetPoint("LEFT")
		configurationFrame:SetPoint("RIGHT")
		configurationFrame:SetPoint("TOP", configurationTitle, "BOTTOM", 0, 0)
		configurationFrame:SetHeight(80)

		local tipFrame =  CreateFrame("Frame", nil, configurationFrame)
		tipFrame:SetPoint("TOPLEFT")
		tipFrame:SetPoint("RIGHT")
		tipFrame:SetHeight(14)
		tipFrame.Label = tipFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		tipFrame.Label:SetJustifyH("LEFT")
		tipFrame.Label:SetPoint("LEFT", 16, 0)
		tipFrame.Label:SetText("|cFFFF0000TIP:|r The floating window hides or shows depending on if you have features enabled for it")

		local minimapButtonConfig = CreateFrame("Frame", nil, configurationFrame)
		minimapButtonConfig:SetPoint("TOPLEFT", tipFrame, "BOTTOMLEFT", 16, -8)
		minimapButtonConfig:SetPoint("RIGHT")
		minimapButtonConfig:SetHeight(30)
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
		mapIconSizeConfig:SetHeight(30)
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
		mapIconAnimationConfig:SetHeight(30)
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
		accessoryWindowConfig:SetHeight(30)
		accessoryWindowConfig.Label = accessoryWindowConfig:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		accessoryWindowConfig.Label:SetJustifyH("LEFT")
		accessoryWindowConfig.Label:SetPoint("LEFT", 32, 0)
		accessoryWindowConfig.Label:SetText("Elemental Storms")
		local accessoryWindowDisplayPreference = osd.ElementalStorms_GetVisibilityOption()
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
					osd.ElementalStorms_SetVisibilityOption(accessoryWindowConfig.selectionPopout.selected.value)
				end
		)
		accessoryWindowConfig.selectionPopout:SetPoint("LEFT", 230, 0)
		accessoryWindowConfig.selectionPopout.Popout:Layout()
		AttachTooltip({
			"Elemental Storms",
			"Set when to display the Elemental Storms timers within the floating window\n\n(The floating window will only be visible when you have features enabled for it)",
		}, accessoryWindowConfig.Label, accessoryWindowConfig.selectionPopout.Button)
		local last = accessoryWindowConfig

		if (osd.TimeRifts) then
			local timeRiftsConfig = CreateFrame("Frame", nil, configurationFrame)
			timeRiftsConfig:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, -8)
			last = timeRiftsConfig
			timeRiftsConfig:SetPoint("RIGHT")
			timeRiftsConfig:SetHeight(30)
			timeRiftsConfig.Label = timeRiftsConfig:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			timeRiftsConfig.Label:SetJustifyH("LEFT")
			timeRiftsConfig.Label:SetPoint("LEFT", 32, 0)
			timeRiftsConfig.Label:SetText("Time Rifts")
			local timeRiftsConfigDisplayPreference = osd.TimeRifts.GetVisibilityOption()
			local timeRiftsConfigDisplayConstants = addon.constants.accessoryDisplay
			timeRiftsConfig.selectionPopout = Templates.CreateSelectionPopoutWithButtons(
					timeRiftsConfig,
					{
						{
							label = "Always Shown",
							value = timeRiftsConfigDisplayConstants.ALWAYS,
							selected = timeRiftsConfigDisplayPreference == timeRiftsConfigDisplayConstants.ALWAYS
						},
						{
							label = "Never Shown",
							value = timeRiftsConfigDisplayConstants.NEVER,
							selected = timeRiftsConfigDisplayPreference == timeRiftsConfigDisplayConstants.NEVER
						},
						{
							label = "Hide when in instances",
							value = timeRiftsConfigDisplayConstants.NOINSTANCES,
							selected = timeRiftsConfigDisplayPreference == timeRiftsConfigDisplayConstants.NOINSTANCES
						},
					},
					function()
						osd.TimeRifts.SetVisibilityOption(timeRiftsConfig.selectionPopout.selected.value)
					end
			)
			timeRiftsConfig.selectionPopout:SetPoint("LEFT", 230, 0)
			timeRiftsConfig.selectionPopout.Popout:Layout()
			AttachTooltip({
				"Time Rifts",
				"Set when to display the Time Rifts timers within the floating window\n\n(The floating window will only be visible when you have features enabled for it)",
			}, timeRiftsConfig.Label, timeRiftsConfig.selectionPopout.Button)
		end

		if (osd.Superbloom) then
			local superbloom = CreateFrame("Frame", nil, configurationFrame)
			superbloom:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, -8)
			last = superbloom
			superbloom:SetPoint("RIGHT")
			superbloom:SetHeight(30)
			superbloom.Label = superbloom:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			superbloom.Label:SetJustifyH("LEFT")
			superbloom.Label:SetPoint("LEFT", 32, 0)
			superbloom.Label:SetText("Superbloom")
			local superbloomConfigDisplayPreference = osd.Superbloom.GetVisibilityOption()
			local superbloomRiftsConfigDisplayConstants = addon.constants.accessoryDisplay
			superbloom.selectionPopout = Templates.CreateSelectionPopoutWithButtons(
					superbloom,
					{
						{
							label = "Always Shown",
							value = superbloomRiftsConfigDisplayConstants.ALWAYS,
							selected = superbloomConfigDisplayPreference == superbloomRiftsConfigDisplayConstants.ALWAYS
						},
						{
							label = "Never Shown",
							value = superbloomRiftsConfigDisplayConstants.NEVER,
							selected = superbloomConfigDisplayPreference == superbloomRiftsConfigDisplayConstants.NEVER
						},
						{
							label = "Hide when in instances",
							value = superbloomRiftsConfigDisplayConstants.NOINSTANCES,
							selected = superbloomConfigDisplayPreference == superbloomRiftsConfigDisplayConstants.NOINSTANCES
						},
					},
					function()
						osd.Superbloom.SetVisibilityOption(superbloom.selectionPopout.selected.value)
					end
			)
			superbloom.selectionPopout:SetPoint("LEFT", 230, 0)
			superbloom.selectionPopout.Popout:Layout()
			AttachTooltip({
				"Superbloom",
				"Set when to display the Superbloom timers within the floating window\n\n(The floating window will only be visible when you have features enabled for it)",
			}, superbloom.Label, superbloom.selectionPopout.Button)
		end

		if (osd.Promos) then
			local twitchDropsConfig = CreateFrame("Frame", nil, configurationFrame)
			twitchDropsConfig:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, -8)
			last = twitchDropsConfig
			twitchDropsConfig:SetPoint("RIGHT")
			twitchDropsConfig:SetHeight(30)
			twitchDropsConfig.Label = twitchDropsConfig:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			twitchDropsConfig.Label:SetJustifyH("LEFT")
			twitchDropsConfig.Label:SetPoint("LEFT", 32, 0)
			twitchDropsConfig.Label:SetText("Twitch Promos")
			local twitchDropsConfigDisplayPreference = osd.Promos.GetVisibilityOption("twitchDrops")
			local twitchDropsConfigDisplayConstants = addon.constants.accessoryDisplay
			twitchDropsConfig.selectionPopout = Templates.CreateSelectionPopoutWithButtons(
					twitchDropsConfig,
					{
						{
							label = "Snooze",
							value = twitchDropsConfigDisplayConstants.SNOOZED,
							selected = twitchDropsConfigDisplayPreference == twitchDropsConfigDisplayConstants.SNOOZED
						},
						{
							label = "Always Shown",
							value = twitchDropsConfigDisplayConstants.ALWAYS,
							selected = twitchDropsConfigDisplayPreference == twitchDropsConfigDisplayConstants.ALWAYS
						},
						{
							label = "Never Shown",
							value = twitchDropsConfigDisplayConstants.NEVER,
							selected = twitchDropsConfigDisplayPreference == twitchDropsConfigDisplayConstants.NEVER
						},
						{
							label = "Hide when in instances",
							value = twitchDropsConfigDisplayConstants.NOINSTANCES,
							selected = twitchDropsConfigDisplayPreference == twitchDropsConfigDisplayConstants.NOINSTANCES
						},
					},
					function()
						osd.Promos.SetVisibilityOption("twitchDrops", "twitch_", twitchDropsConfig.selectionPopout.selected.value)
					end
			)
			twitchDropsConfig.selectionPopout:SetPoint("LEFT", 230, 0)
			twitchDropsConfig.selectionPopout.Popout:Layout()
			AttachTooltip({
				"Twitch Drops",
				"Set when to display the Twitch Drops timer within the floating window\n\n|cFFFF0000PRO TIP: |r|cFFFFFFFFUse \"Snooze\" to stop displaying until the next promo begins|r\n\n(The floating window will only be visible when you have features enabled for it)",
			}, twitchDropsConfig.Label, twitchDropsConfig.selectionPopout.Button)
		end

		if (osd.Promos) then
			local primeGamingLootConfig = CreateFrame("Frame", nil, configurationFrame)
			primeGamingLootConfig:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, -8)
			last = primeGamingLootConfig
			primeGamingLootConfig:SetPoint("RIGHT")
			primeGamingLootConfig:SetHeight(30)
			primeGamingLootConfig.Label = primeGamingLootConfig:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			primeGamingLootConfig.Label:SetJustifyH("LEFT")
			primeGamingLootConfig.Label:SetPoint("LEFT", 32, 0)
			primeGamingLootConfig.Label:SetText("Prime Gaming Loot")
			local primeGamingLootConfigDisplayPreference = osd.Promos.GetVisibilityOption("primeGamingLoot")
			local primeGamingLootConfigDisplayConstants = addon.constants.accessoryDisplay
			primeGamingLootConfig.selectionPopout = Templates.CreateSelectionPopoutWithButtons(
					primeGamingLootConfig,
					{
						{
							label = "Snooze",
							value = primeGamingLootConfigDisplayConstants.SNOOZED,
							selected = primeGamingLootConfigDisplayPreference == primeGamingLootConfigDisplayConstants.SNOOZED
						},
						{
							label = "Always Shown",
							value = primeGamingLootConfigDisplayConstants.ALWAYS,
							selected = primeGamingLootConfigDisplayPreference == primeGamingLootConfigDisplayConstants.ALWAYS
						},
						{
							label = "Never Shown",
							value = primeGamingLootConfigDisplayConstants.NEVER,
							selected = primeGamingLootConfigDisplayPreference == primeGamingLootConfigDisplayConstants.NEVER
						},
						{
							label = "Hide when in instances",
							value = primeGamingLootConfigDisplayConstants.NOINSTANCES,
							selected = primeGamingLootConfigDisplayPreference == primeGamingLootConfigDisplayConstants.NOINSTANCES
						},
					},
					function()
						osd.Promos.SetVisibilityOption("primeGamingLoot", "prime_", primeGamingLootConfig.selectionPopout.selected.value)
					end
			)
			primeGamingLootConfig.selectionPopout:SetPoint("LEFT", 230, 0)
			primeGamingLootConfig.selectionPopout.Popout:Layout()
			AttachTooltip({
				"Prime Gaming Loot",
				"Set when to display the Prime Gaming Loot timer within the floating window\n\n|cFFFF0000PRO TIP: |r|cFFFFFFFFUse \"Snooze\" to stop displaying until the next promo begins|r\n\n(The floating window will only be visible when you have features enabled for it)",
			}, primeGamingLootConfig.Label, primeGamingLootConfig.selectionPopout.Button)
		end

		if (osd.Promos) then
			local blizzardOtherConfig = CreateFrame("Frame", nil, configurationFrame)
			blizzardOtherConfig:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, -8)
			last = blizzardOtherConfig
			blizzardOtherConfig:SetPoint("RIGHT")
			blizzardOtherConfig:SetHeight(30)
			blizzardOtherConfig.Label = blizzardOtherConfig:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			blizzardOtherConfig.Label:SetJustifyH("LEFT")
			blizzardOtherConfig.Label:SetPoint("LEFT", 32, 0)
			blizzardOtherConfig.Label:SetText("Other Blizzard Promos")
			local blizzardOtherConfigDisplayPreference = osd.Promos.GetVisibilityOption("blizzardOther")
			local blizzardOtherConfigDisplayConstants = addon.constants.accessoryDisplay
			blizzardOtherConfig.selectionPopout = Templates.CreateSelectionPopoutWithButtons(
					blizzardOtherConfig,
					{
						{
							label = "Snooze",
							value = blizzardOtherConfigDisplayConstants.SNOOZED,
							selected = blizzardOtherConfigDisplayPreference == blizzardOtherConfigDisplayConstants.SNOOZED
						},
						{
							label = "Always Shown",
							value = blizzardOtherConfigDisplayConstants.ALWAYS,
							selected = blizzardOtherConfigDisplayPreference == blizzardOtherConfigDisplayConstants.ALWAYS
						},
						{
							label = "Never Shown",
							value = blizzardOtherConfigDisplayConstants.NEVER,
							selected = blizzardOtherConfigDisplayPreference == blizzardOtherConfigDisplayConstants.NEVER
						},
						{
							label = "Hide when in instances",
							value = blizzardOtherConfigDisplayConstants.NOINSTANCES,
							selected = blizzardOtherConfigDisplayPreference == blizzardOtherConfigDisplayConstants.NOINSTANCES
						},
					},
					function()
						osd.Promos.SetVisibilityOption("blizzardOther", "blizzard_", blizzardOtherConfig.selectionPopout.selected.value)
					end
			)
			blizzardOtherConfig.selectionPopout:SetPoint("LEFT", 230, 0)
			blizzardOtherConfig.selectionPopout.Popout:Layout()
			AttachTooltip({
				"Other Blizzard Promotions",
				"Set when to display timers for other Blizzard promotions within the floating window\n\n|cFFFF0000PRO TIP: |r|cFFFFFFFFUse \"Snooze\" to stop displaying until the next promo begins|r\n\n(The floating window will only be visible when you have features enabled for it)",
			}, blizzardOtherConfig.Label, blizzardOtherConfig.selectionPopout.Button)
		end

		if (osd.GreedyEmissary and osd.GreedyEmissary:IsEventActive()) then
			local treasureGoblinConfig = CreateFrame("Frame", nil, configurationFrame)
			treasureGoblinConfig:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, -8)
			last = treasureGoblinConfig
			treasureGoblinConfig:SetPoint("RIGHT")
			treasureGoblinConfig:SetHeight(30)
			treasureGoblinConfig.Label = treasureGoblinConfig:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			treasureGoblinConfig.Label:SetJustifyH("LEFT")
			treasureGoblinConfig.Label:SetPoint("LEFT", 32, 0)
			treasureGoblinConfig.Label:SetText("Treasure Goblin")
			local treasureGoblinDisplayPreference = osd.TreasureGoblin_GetVisibilityOption()
			local treasureGoblinDisplayConstants = addon.constants.accessoryDisplay
			treasureGoblinConfig.selectionPopout = Templates.CreateSelectionPopoutWithButtons(
					treasureGoblinConfig,
					{
						{
							label = "Always Shown",
							value = treasureGoblinDisplayConstants.ALWAYS,
							selected = treasureGoblinDisplayPreference == treasureGoblinDisplayConstants.ALWAYS
						},
						{
							label = "Never Shown",
							value = treasureGoblinDisplayConstants.NEVER,
							selected = treasureGoblinDisplayPreference == treasureGoblinDisplayConstants.NEVER
						},
						{
							label = "Hide when in instances",
							value = treasureGoblinDisplayConstants.NOINSTANCES,
							selected = treasureGoblinDisplayPreference == treasureGoblinDisplayConstants.NOINSTANCES
						},
					},
					function()
						osd.TreasureGoblin_SetVisibilityOption(treasureGoblinConfig.selectionPopout.selected.value)
					end
			)
			treasureGoblinConfig.selectionPopout:SetPoint("LEFT", 230, 0)
			treasureGoblinConfig.selectionPopout.Popout:Layout()
			AttachTooltip({
				"Special Event: A Greedy Emissary",
				"Set when to display the Treasure Goblin timers within the floating window\n\n(The floating window will only be visible when you have features enabled for it)",
			}, treasureGoblinConfig.Label, treasureGoblinConfig.selectionPopout.Button)
		end

		if (addon.midsummer and addon.midsummer.IsEventActive()) then
			local midsummerConfig = CreateFrame("Frame", nil, configurationFrame)
			midsummerConfig:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, -8)
			last = midsummerConfig
			midsummerConfig:SetPoint("RIGHT")
			midsummerConfig:SetHeight(30)
			midsummerConfig.Label = midsummerConfig:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			midsummerConfig.Label:SetJustifyH("LEFT")
			midsummerConfig.Label:SetPoint("LEFT", 32, 0)
			midsummerConfig.Label:SetText("Midsummer (Minimap Button)")
			midsummerConfig.checkButton = CreateFrame("CheckButton", nil, midsummerConfig)
			midsummerConfig.checkButton:SetSize(30, 29)
			midsummerConfig.checkButton:SetPoint("LEFT", 230, 0)
			midsummerConfig.checkButton:SetNormalAtlas("checkbox-minimal", true)
			midsummerConfig.checkButton:SetPushedAtlas("checkbox-minimal", true)
			midsummerConfig.checkButton:SetCheckedAtlas("checkmark-minimal", true)
			midsummerConfig.checkButton:SetDisabledCheckedAtlas("checkmark-minimal-disabled", true)
			midsummerConfig.checkButton:SetScript("OnClick", function(self)
				TomCats_Account.midsummer.preferences.hideButton = not self:GetChecked()
				addon.midsummer.charm:SetShown(not TomCats_Account.midsummer.preferences.hideButton)
			end)
			midsummerConfig.checkButton:SetChecked(TomCats_Account.midsummer.preferences.hideButton ~= true)
			AttachTooltip({
				"Midsummer Fire Festival",
				"Enables or disables the Midsummer Fire Festival icon on the minimap"
			}, midsummerConfig.Label, midsummerConfig.checkButton)
		end

		if (addon.noblegarden and addon.noblegarden.IsEventActive()) then
			local noblegardenConfig = CreateFrame("Frame", nil, configurationFrame)
			noblegardenConfig:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, -8)
			last = noblegardenConfig
			noblegardenConfig:SetPoint("RIGHT")
			noblegardenConfig:SetHeight(30)
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

		local featuresTitle = CreateOptionsTitle(contents, "Recently Added and Upcoming Features", configurationFrame)
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
