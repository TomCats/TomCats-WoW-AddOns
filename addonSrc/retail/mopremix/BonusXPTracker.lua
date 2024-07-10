--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("mopremix")

local eventFrame
local charVars = { }
local playerUnitGUID
local atMaxLevel = false
local OSD
local bonusXPItems = {
	[224407] = "uncommon",
	[224408] = "rare",
	[220764] = "rare",
	[220763] = "epic",
}

local encounterXPDrops = {
	[1] = "uncommon",
	[2] = "rare",
	[3] = "epic",
	[5] = "epic",
	[14] = "epic",
	[15] = "epic",
	[16] = "epic",
}

local bonusXPTokenTypes = {
	"uncommon",
	"rare",
	"epic"
}

local worldBosses = {
	[1563] = true, -- Galleon
	[1564] = true, -- Sha of Anger
	[1571] = true, -- Nalak
	[1587] = true, -- Oondasta
}

local lastMailboxUpdate = 0

local component = {
	Name = "BonusXPTracker"
}

local function SetSynchronized()
	charVars.synchronized = true
	OSD.xpCaption:Hide()
	OSD:SetSize(OSD:GetWidth(), 60)
end

local function ShowXPTrackerTooltip(self)
	GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	GameTooltip:ClearLines()
	GameTooltip:AddLine("TomCat's Tours\nBonus XP Tracker", nil, nil, nil, true)
	GameTooltip:AddLine("\nThe tool helps you determine the optimal time to use the Bonus Experience stored in your mailbox. The status bar displays your current progress to reach level 70, as well as where your XP will be if you utilize all your Bonus Experience.", 1, 1, 1, true)
	if (not charVars.synchronized) then
		GameTooltip:AddLine("\nTo get started, visit a mailbox to let the tool count any any Bonus Experience you have saved up. It will detect when more Bonus Experience may have been added to your mailbox after that so long as you keep the addon running.", nil, nil, nil, true)
		GameTooltip:AddLine("\nKeep checking for updates as TomCat continues to add more useful features throughout the event!", nil, nil, nil, true)
	end
	GameTooltip:Show()
end

local function HideXPTrackerTooltip()
	GameTooltip:Hide()
end

function GetXPBonus()
	local aura = C_UnitAuras.GetPlayerAuraBySpellID(440393)
	return aura and aura.points[9] or 0
end

function GetPlayerUnitGUID()
	if (not playerUnitGUID) then
		playerUnitGUID = UnitGUID("player")
	end
	return playerUnitGUID
end

function UpdateBonusXPTracker()
	local level = charVars.level or 10
	local xp = charVars.xp or 0
	local data = XPData[level - 9]
	local bonus = GetXPBonus() or 0
	for bonusXPTokenIndex, bonusXPTokenType in ipairs(bonusXPTokenTypes) do
		for i = 1, charVars[bonusXPTokenType] do
			xp = xp + (data[bonusXPTokenIndex + 2] * (bonus + 100)) / 100
			while (xp >= data[1]) do
				xp = xp - data[1]
				level = level + 1
				data = XPData[level - 9]
				if (not data) then
					break
				end
			end
			if (level == 70) then
				break
			end
		end
		if (level == 70) then
			break
		end
	end
	if (charVars.level == 70) then
		OSD.xpBar:SetSize(OSD.footerBar:GetWidth(), OSD.footerBar:GetHeight())
		OSD.xpBarTotal:SetText("100% (100%)")
		OSD.xpBarPending:Hide()
	else
		local characterXP = XPData[1][2] - XPData[(charVars.level or 10) - 9][2] + (charVars.xp or 0)
		local percentageEarned = characterXP / XPData[1][2]
		local XPPending
		if (not data) then
			XPPending = XPData[1][2] - characterXP
		else
			XPPending = XPData[1][2] - data[2] + xp - characterXP
		end
		local percentagePending = XPPending / XPData[1][2]
		OSD.xpBar:SetSize(OSD.footerBar:GetWidth() * percentageEarned, OSD.footerBar:GetHeight())
		OSD.xpBarPending:SetSize(OSD.footerBar:GetWidth() * percentagePending, OSD.footerBar:GetHeight())
		OSD.xpBarTotal:SetText(string.format("%s%% (%s%%)", math.floor(percentageEarned * 1000)/10, math.floor((percentageEarned + percentagePending) * 1000)/10))
	end
end

local function OnEvent(_, event, ...)
	local dirty = false
	if (not atMaxLevel) then
		local args = { ... }
		if ((event == "PLAYER_XP_UPDATE" and args[1] == "player") or event == "PLAYER_LEVEL_UP") then
			if (charVars.synchronized) then
				charVars.level = UnitLevel("player")
				atMaxLevel = charVars.level == 70
				charVars.xp = UnitXP("player")
				if (atMaxLevel) then
					OSD:Hide()
				end
				dirty = true
			end
		elseif ((event == "UNIT_SPELLCAST_SUCCEEDED" and args[1] == "player" and args[3] == 440393)
			or (event == "UNIT_AURA" and args[1] == "player")) then
			if (charVars.synchronized) then
				local bonus = GetXPBonus()
				if (bonus ~= 0) then
					charVars.bonus = bonus
					eventFrame:UnregisterEvent("UNIT_AURA")
				end
				dirty = true
			end
		elseif (event == "CHAT_MSG_LOOT" and args[12] == GetPlayerUnitGUID()) then
			if (charVars.synchronized and lastMailboxUpdate ~= GetTime()) then
				local itemID = string.match(args[1], "item:(%d+)")
				if (itemID) then
					itemID = tonumber(itemID)
					if (bonusXPItems[itemID]) then
						charVars[bonusXPItems[itemID]] = charVars[bonusXPItems[itemID]] - 1
						dirty = true
					end
				end
			end
		elseif (event == "ENCOUNTER_END" and args[5] == 1) then
			if (charVars.synchronized and encounterXPDrops[args[3]]) then
				charVars[encounterXPDrops[args[3]]] = charVars[encounterXPDrops[args[3]]] + 1
				dirty = true
			end
		elseif (event == "BOSS_KILL" and worldBosses[args[3]]) then
			if (charVars.synchronized) then
				charVars.epic = charVars.epic + 1
				dirty = true
			end
		elseif (event == "SCENARIO_COMPLETED") then
			if (charVars.synchronized) then
				local instanceInfo = { GetInstanceInfo() }
				if (instanceInfo[3] == 11) then
					charVars.rare = charVars.rare + 1
					dirty = true
				elseif (instanceInfo[3] == 12) then
					charVars.uncommon = charVars.uncommon + 1
					dirty = true
				end
			end
		elseif (event == "MAIL_INBOX_UPDATE") then
			lastMailboxUpdate = GetTime()
			local itemCounts = {
				[224407] = 0,
				[224408] = 0,
				[220764] = 0,
				[220763] = 0,
			}
			for index = 1, GetInboxNumItems() do
				for attachIndex = 1, ATTACHMENTS_MAX_RECEIVE do
					local itemID = select(2, GetInboxItem(index, attachIndex))
					if itemID and itemCounts[itemID] ~= nil then
						itemCounts[itemID] = itemCounts[itemID] + 1
					end
				end
			end
			charVars.level = UnitLevel("player")
			charVars.xp = UnitXP("player")
			charVars.uncommon = itemCounts[224407]
			charVars.rare = itemCounts[224408] + itemCounts[220764]
			charVars.epic = itemCounts[220763]
			SetSynchronized()
			dirty = true
		end
		if (charVars.synchronized) then
			local newBonus = GetXPBonus()
			if (newBonus ~= 0 and charVars.bonus ~= newBonus) then
				charVars.bonus = GetXPBonus()
				dirty = true
			end
		end
		if (dirty) then
			UpdateBonusXPTracker()
		end
	end
end

function component.Init()
	if (not GameLimitedMode_IsActive()) then
		OSD = Templates.CreateBasicWindow(
				UIParent,
				{
					icon = ImagePNG.tomcats_minimap_icon,
					prefs = TomCats_Account.mopremix.osd,
				}
		)
		OSD:SetSize(260,100)
		OSD.title:SetText("Bonus XP Tracker")
		OSD:Hide()
		eventFrame = CreateFrame("Frame")
		eventFrame:RegisterEvent("PLAYER_XP_UPDATE")
		eventFrame:RegisterEvent("PLAYER_LEVEL_UP")
		eventFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		eventFrame:RegisterEvent("CHAT_MSG_LOOT")
		eventFrame:RegisterEvent("MAIL_INBOX_UPDATE")
		eventFrame:RegisterEvent("ENCOUNTER_END")
		eventFrame:RegisterEvent("BOSS_KILL")
		eventFrame:RegisterEvent("SCENARIO_COMPLETED")
		eventFrame:RegisterEvent("UNIT_AURA")
		eventFrame:SetScript("OnEvent", OnEvent)
		charVars = TomCats_Character.mopremix.bonusxp
		local level = UnitLevel("player")
		atMaxLevel = level == 70
		local xp = UnitXP("player")
		if (charVars.level ~= level or charVars.xp ~= xp) then
			charVars.synchronized = false
		end
		OSD.xpBar = OSD:CreateTexture(nil, "BACKGROUND")
		OSD.xpBar:SetDrawLayer("BACKGROUND", 2)
		OSD.xpBar:SetColorTexture(0.54,0.098,0.105,1.0)
		OSD.xpBar:SetPoint("LEFT", OSD.footerBar, "LEFT")
		OSD.xpBar:SetSize(1, OSD.footerBar:GetHeight())

		OSD.xpCaption = OSD:CreateFontString(nil, "ARTWORK", "GameFontWhite")
		OSD.xpCaption:SetText("Visit a mailbox to begin tracking Bonus Experience")
		OSD.xpCaption:SetPoint("TOPLEFT", 16, -30)
		OSD.xpCaption:SetPoint("TOPRIGHT", -16, -30)
		OSD.xpCaption:SetPoint("BOTTOM", OSD.footerBar, "TOP", 0, 4)
		OSD.xpCaption:SetWordWrap(true)

		OSD.xpBarTitle = OSD:CreateFontString(nil, "ARTWORK", "GameFontWhite")
		OSD.xpBarTitle:SetJustifyH("LEFT")
		OSD.xpBarTitle:SetText("XP")
		OSD.xpBarTotal = OSD:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		OSD.xpBarTotal:SetJustifyH("RIGHT")
		OSD.xpBarTotal:SetText("??% (??%)")
		OSD.xpBarTitle:SetPoint("BOTTOMLEFT", OSD.footerBar, "BOTTOMLEFT", 8, 4)
		OSD.xpBarTotal:SetPoint("BOTTOMRIGHT", OSD.footerBar, "BOTTOMRIGHT", -4, 4)

		OSD.xpBarPending = OSD:CreateTexture(nil, "BACKGROUND")
		OSD.xpBarPending:SetDrawLayer("BACKGROUND", 2)
		OSD.xpBarPending:SetColorTexture(0.54,0.098,0.105,0.5)
		OSD.xpBarPending:SetPoint("LEFT", OSD.xpBar, "RIGHT")
		OSD.xpBarPending:SetSize(1, OSD.footerBar:GetHeight())

		OSD.footerBar:SetScript("OnEnter", ShowXPTrackerTooltip)
		OSD.footerBar:SetScript("OnLeave", HideXPTrackerTooltip)
		OSD.xpCaption:SetScript("OnEnter", ShowXPTrackerTooltip)
		OSD.xpCaption:SetScript("OnLeave", HideXPTrackerTooltip)
		if (not atMaxLevel and component.IsVisible()) then
			OSD:Show()
		end
		if (charVars.synchronized) then
			SetSynchronized()
		end
		if (not atMaxLevel) then
			UpdateBonusXPTracker()
		end
	end
end

function component.IsVisible()
	return TomCats_Account.mopremix.bonusXPTrackerDisplay == addon.constants.accessoryDisplay.WHENAPPLICABLE
end

function component.GetVisibilityOption()
	return TomCats_Account.mopremix.bonusXPTrackerDisplay
end

function component.SetVisibilityOption(value)
	TomCats_Account.mopremix.bonusXPTrackerDisplay = value
	if (not GameLimitedMode_IsActive()) then
		local level = UnitLevel("player")
		if (level < 70 and component.IsVisible()) then
			OSD:Show()
		else
			OSD:Hide()
		end
	end
end

AddComponent(component)

BonusXPTracker = component
