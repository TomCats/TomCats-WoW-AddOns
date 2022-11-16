local addonName, addon = ...

local Elements, ZoneEncounters

local FORMAT_GT_1HOUR = (HOUR_ONELETTER_ABBR .. MINUTE_ONELETTER_ABBR):gsub("%s+", "")
local FORMAT_GT_1MIN =  MINUTE_ONELETTER_ABBR:gsub("%s+", "")
local FORMAT_LT_1MIN = SECOND_ONELETTER_ABBR:gsub("%s+", "")

local function FormatRemainingTime(duration)
	if (duration >= 3600) then
		local hours = math.floor(duration / 3600)
		local minutes = math.floor((duration % 3600) / 60)
		return FORMAT_GT_1HOUR:format(hours, minutes)
	elseif (duration >= 60) then
		local minutes = math.ceil(duration / 60)
		return FORMAT_GT_1MIN:format(minutes)
	else
		return FORMAT_LT_1MIN:format(duration)
	end
end

function addon.PrimalStorms.CreateUI()
	Elements = addon.PrimalStorms.Elements
	ZoneEncounters = addon.PrimalStorms.ZoneEncounters
	local ENCOUNTER_NONE = { element = { label = "None" }}
	local interval, timeSinceLastUpdate = 1, 0
	local dataRefreshInterval, timeSinceLastDataRefresh = 30, 0
	local isDirty = true
	local function OnUpdate(self, elapsed)
		timeSinceLastDataRefresh = timeSinceLastDataRefresh + elapsed
		if (isDirty or timeSinceLastDataRefresh > dataRefreshInterval) then
			initialized = true
			timeSinceLastDataRefresh = 0
			isDirty = nil
			local now = GetServerTime()
			for _, zone in ipairs(ZoneEncounters) do
				zone.encounter = nil
				zone.ends = nil
				for _, encounter in ipairs(zone) do
					local timeRemaining = C_AreaPoiInfo.GetAreaPOISecondsLeft(encounter.elementsPOI)
					if (timeRemaining and timeRemaining > 0) then
						zone.encounter = encounter
						zone.ends = now + timeRemaining
						break
					end
				end
				if (not zone.encounter) then
					for _, encounter in ipairs(zone) do
						local timeRemaining = C_AreaPoiInfo.GetAreaPOISecondsLeft(encounter.stormPOI)
						if (timeRemaining and timeRemaining > 0) then
							zone.encounter = encounter
							zone.ends = now + timeRemaining
							break
						end
					end
				end
				if (not zone.encounter) then
					zone.encounter = ENCOUNTER_NONE
				end
			end
			local playerName = UnitName("player")
			local realmName = GetRealmName()
			local currencyAmount = GetItemCount(199211, true)
			local playerKey = ("%s-%s"):format(playerName, realmName)
			TomCats_Account.primalstorms.preferences.currency[playerKey] = currencyAmount
			local totalAmount = 0
			for _, amount in pairs(TomCats_Account.primalstorms.preferences.currency) do
				totalAmount = totalAmount + amount
			end
			self.currency:SetText(("%d (%d)"):format(currencyAmount, totalAmount))
			TomCats_Account.primalstorms.preferences.dimmedItems[playerKey] = TomCats_Account.primalstorms.preferences.dimmedItems[playerKey] or { }
			local dimmedItems = TomCats_Account.primalstorms.preferences.dimmedItems[playerKey]
			for elementKey, element in pairs(addon.PrimalStorms.Elements) do
				dimmedItems[elementKey] = GetItemCount(element.dimmedItem, true)
				local elementCount = 0
				for _, dimmedItems_ in pairs(TomCats_Account.primalstorms.preferences.dimmedItems) do
					elementCount = elementCount + (dimmedItems_[elementKey] or 0)
				end
				self.elementIcons[elementKey]:SetAlpha(elementCount > 0 and 1.0 or 0.25)
			end
		end
		timeSinceLastUpdate = timeSinceLastUpdate + elapsed
		if (timeSinceLastUpdate > interval) then
			timeSinceLastUpdate = 0
			local now = GetServerTime()
			for idx, zone in ipairs(ZoneEncounters) do
				local timeRemaining
				if (zone.ends and zone.ends - now > 0 ) then
					timeRemaining = FormatRemainingTime(zone.ends - now)
				end
				local encounter = self.encounters[idx]
				for elementType, icon in pairs(encounter.icons) do
					icon:SetShown(elementType == zone.encounter.element.label)
				end
				encounter.zone = zone
				encounter.timeRemaining:SetText(timeRemaining or "---")
				encounter.timeRemaining:Show()
				encounter.zoneName:SetAlpha(timeRemaining and 1.0 or 0.5)
				encounter.timeRemaining:SetAlpha(timeRemaining and 1.0 or 0.5)
			end
		end
	end
	local function OnEvent(_, event)
		isDirty = true
	end
	local BACKDROP_GLUE_TOOLTIP_16_16 = {
		bgFile = "Interface\\Glues\\Common\\Glue-Tooltip-Background",
		edgeFile = "Interface\\Glues\\Common\\Glue-Tooltip-Border",
		tile = true,
		tileEdge = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 10, right = 5, top = 4, bottom = 9 },
	};
	local GLUE_BACKDROP_COLOR = CreateColor(0.09, 0.09, 0.09);
	local GLUE_BACKDROP_BORDER_COLOR = CreateColor(0.8, 0.8, 0.8);
	local frame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	frame.backdropInfo = BACKDROP_GLUE_TOOLTIP_16_16
	frame.backdropColor = GLUE_BACKDROP_COLOR
	frame.backdropColorAlpha = 1.0
	frame.backdropBorderColor = GLUE_BACKDROP_BORDER_COLOR
	frame:SetFrameLevel(3000)
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetClampedToScreen(true)
	frame:SetScript("OnDragStart", function(self)
		if not self.isLocked then
			self:StartMoving()
		end
	end)
	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		TomCats_Account.primalstorms.preferences.WindowLocation = { self:GetPoint() }
	end)
	if (TomCats_Account.primalstorms.preferences.WindowLocation) then
		frame:ClearAllPoints()
		frame:SetPoint(unpack(TomCats_Account.primalstorms.preferences.WindowLocation))
	else
		frame:SetPoint("CENTER", UIParent, "CENTER")
	end
	addon.PrimalStorms.UI = frame
	frame:OnBackdropLoaded()
	frame:SetScript("OnUpdate", OnUpdate)
	frame:SetScript("OnEvent", OnEvent)
	frame.encounters = { }
	local maxZoneNameSize = 0
	local frameHeight = 0
	for idx, zone in ipairs(ZoneEncounters) do
		frame.encounters[idx] = { }
		local encounter = frame.encounters[idx]
		encounter.zoneName = frame:CreateFontString(nil, "ARTWORK", "GameFontWhite")
		encounter.zoneName:SetJustifyH("LEFT")
		encounter.zoneName:SetText(zone.name)
		encounter.zoneName:SetAlpha(0.5)
		maxZoneNameSize = math.max(maxZoneNameSize, encounter.zoneName:GetStringWidth())
		if (idx == 1) then
			encounter.zoneName:SetPoint("TOPLEFT", frame, "TOPLEFT", 30, -30) -- -10
		else
			encounter.zoneName:SetPoint("TOPLEFT", frame.encounters[idx - 1].zoneName, "BOTTOMLEFT", 0, -4)
		end
		frameHeight = frameHeight + encounter.zoneName:GetStringHeight() + 4
		encounter.zoneName:Show()
		encounter.timeRemaining = frame:CreateFontString(nil, "ARTWORK", "GameFontWhite")
		encounter.timeRemaining:SetJustifyH("RIGHT")
		encounter.timeRemaining:SetText("---")
		encounter.timeRemaining:SetPoint("TOP", encounter.zoneName, "TOP")
		encounter.timeRemaining:SetPoint("RIGHT", frame, "RIGHT", -14, 0)
		encounter.timeRemaining:SetAlpha(0.5)
		encounter.icons = { }

		encounter.zoneName:EnableMouse(true)
		encounter.zoneName:SetScript("OnEnter", function(self)
			GameTooltip:ClearLines()
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			DEBUGZONE = encounter
			GameTooltip:SetText(("%s:"):format(encounter.zoneName:GetText()), 1, 1, 1)
			GameTooltip:AddLine(("%s"):format(encounter.zone.encounter.element.label))
			GameTooltip:Show()
		end)
		encounter.zoneName:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)

		for _, v in pairs(Elements) do
			encounter.icons[v.label] = frame:CreateTexture(nil, "ARTWORK")
			encounter.icons[v.label]:SetSize(16, 16)
			encounter.icons[v.label]:SetAtlas(v.icon)
			encounter.icons[v.label]:SetPoint("RIGHT", encounter.zoneName, "LEFT", -2, 0)
			encounter.icons[v.label]:Hide()
			encounter.icons[v.label]:SetScript("OnEnter", encounter.zoneName:GetScript("OnEnter"))
			encounter.icons[v.label]:SetScript("OnLeave", encounter.zoneName:GetScript("OnLeave"))
			encounter.icons[v.label]:EnableMouse(true)
		end
		encounter.timeRemaining:SetScript("OnEnter", encounter.zoneName:GetScript("OnEnter"))
		encounter.timeRemaining:SetScript("OnLeave", encounter.zoneName:GetScript("OnLeave"))
		encounter.timeRemaining:EnableMouse(true)
	end
	frame.headerBar = frame:CreateTexture(nil, "BACKGROUND")
	frame.headerBar:SetDrawLayer("BACKGROUND", 2)
	frame.headerBar:SetColorTexture(0.25,0.25,0.25,1)
	frame.headerBar:SetHeight(18)
	frame.headerBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -5)
	frame.headerBar:SetPoint("RIGHT", frame, "RIGHT", -5, 0)
	frame.headerBar:SetAlpha(0.8)
	frame.headerBar:Show()
	frame.footerBar = frame:CreateTexture(nil, "BACKGROUND")
	frame.footerBar:SetDrawLayer("BACKGROUND", 2)
	frame.footerBar:SetColorTexture(0.25,0.25,0.25,1)
	frame.footerBar:SetHeight(17)
	frame.footerBar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 10)
	frame.footerBar:SetPoint("RIGHT", frame, "RIGHT", -5, 0)
	frame.footerBar:SetAlpha(0.3)
	frame.footerBar:Show()
	frame.currencyIcon = frame:CreateTexture(nil, "ARTWORK")
	frame.currencyIcon:SetSize(16, 16)
	frame.currencyIcon:SetTexture("Interface/icons/inv_enchant_essencecosmicgreater")
	frame.currencyIcon:SetPoint("LEFT", frame.footerBar, "LEFT", 2, 0)
	local currencyMask = frame:CreateMaskTexture()
	currencyMask:SetSize(14, 14)
	currencyMask:SetTexture("Interface/Masks/CircleMask","CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
	currencyMask:SetPoint("CENTER", frame.currencyIcon, "CENTER", 0, 0)
	frame.currencyIcon:AddMaskTexture(currencyMask)
	frame.currencyIcon:Show()
	frame.currency = frame:CreateFontString(nil, "ARTWORK", "GameFontWhite")
	frame.currency:SetJustifyH("LEFT")
	frame.currency:SetText("---")
	frame.currency:SetPoint("LEFT", frame.footerBar, "LEFT", 20, 0)
	frame.currency:EnableMouse(true)
	frame.currency:SetScript("OnEnter", function(self)
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:SetText("Primeval Essence:", 1, 1, 1)

		local playerName = UnitName("player")
		local realmName = GetRealmName()
		local currencyAmount = GetItemCount(199211, true)
		local playerKey = ("%s-%s"):format(playerName, realmName)
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine("Current Character:",1,1,1)
		GameTooltip:AddLine(("%s: %d"):format(playerKey, currencyAmount))
		local owners = { }
		for player, amount in pairs(TomCats_Account.primalstorms.preferences.currency) do
			if (player ~= playerKey) then
				table.insert(owners, { player, amount })
			end
		end
		table.sort(owners, function(a, b) return a[2] > b[2] end)
		if (#owners > 0) then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("Other Characters:",1,1,1)
		end
		for i = 1, math.min(#owners, 9) do
			GameTooltip:AddLine(("%s: %d"):format(owners[i][1], owners[i][2]))
		end
		if (#owners > 9) then
			GameTooltip:AddLine(("... and %d more"):format(#owners - 9))
		end
		GameTooltip:Show()
	end)
	frame.currency:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	frame.currencyIcon:EnableMouse(true)
	frame.currencyIcon:SetScript("OnEnter", frame.currency:GetScript("OnEnter"))
	frame.currencyIcon:SetScript("OnLeave", frame.currency:GetScript("OnLeave"))

	local elementAnchorTarget = frame.footerBar
	local elementAnchorTargetPoint = "RIGHT"
	frame.elementIcons = { }
	for elementKey, element in pairs(addon.PrimalStorms.Elements) do
		frame.elementIcons[elementKey] = frame:CreateTexture(nil, "ARTWORK")
		frame.elementIcons[elementKey]:SetScript("OnEnter", function(self)
			GameTooltip:ClearLines()
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			GameTooltip:SetText(("%s:"):format(element.dimmedName), 1, 1, 1)
			local owned = false
			local playerName = UnitName("player")
			local realmName = GetRealmName()
			local playerKey = ("%s-%s"):format(playerName, realmName)
			GameTooltip:AddLine(" ")
			local ownedBy = { }
			for player, dimmedItems_ in pairs(TomCats_Account.primalstorms.preferences.dimmedItems) do
				if (not owned) then
					owned = (dimmedItems_[elementKey] > 0)
					if (owned) then
						GameTooltip:AddLine("Owned by:",1,1,1)
					end
				end
				if (dimmedItems_[elementKey] > 0) then
					if (player == playerKey) then
						table.insert(ownedBy, 1, player)
					else
						table.insert(ownedBy, player)
					end
				end
			end
			for i = 1, math.min(#ownedBy, 10) do
				GameTooltip:AddLine(ownedBy[i])
			end
			if (#ownedBy > 10) then
				GameTooltip:AddLine(("... and %d more"):format(#ownedBy - 10))
			end
			if (not owned) then
				GameTooltip:AddLine("You don't own any")
			end
			GameTooltip:Show()
		end)
		frame.elementIcons[elementKey]:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
		frame.elementIcons[elementKey]:EnableMouse(true)
		frame.elementIcons[elementKey]:SetSize(16, 16)
		frame.elementIcons[elementKey]:SetTexture(element.dimmedIcon)
		frame.elementIcons[elementKey]:SetPoint("RIGHT", elementAnchorTarget, elementAnchorTargetPoint, -2, 0)
		local elementMask = frame:CreateMaskTexture()
		elementMask:SetSize(14, 14)
		elementMask:SetTexture("Interface/Masks/CircleMask","CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
		elementMask:SetPoint("CENTER", frame.elementIcons[elementKey], "CENTER", 0, 0)
		frame.elementIcons[elementKey]:AddMaskTexture(elementMask)
		frame.elementIcons[elementKey]:Show()
		elementAnchorTarget = frame.elementIcons[elementKey]
		elementAnchorTargetPoint = "LEFT"
	end
	frame.title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	frame.title:SetPoint("TOP", frame, "TOP", 0, -8)
	frame.title:SetText("Primal Storms")
	frame.icon = CreateFrame("Frame", nil, frame)
	frame.icon:SetSize(32, 32)
	frame.icon:SetPoint("TOPLEFT", frame, "TOPLEFT", -1, 3)
	frame.icon.Background = frame.icon:CreateTexture(nil, "ARTWORK")
	frame.icon.Background:SetSize(25, 25)
	frame.icon.Background:SetTexture("Interface/Minimap/UI-Minimap-Background")
	frame.icon.Background:SetPoint("TOPLEFT", frame.icon, "TOPLEFT", 3, -3)
	frame.icon.Background:SetVertexColor(1,1,1,0.6)
	frame.icon.Background:Show()
	frame.icon.logo = frame.icon:CreateTexture(nil, "ARTWORK")
	frame.icon.logo:SetDrawLayer("ARTWORK", 2)
	frame.icon.logo:SetTexture("Interface/AddOns/TomCats/images/tomcats_logo")
	frame.icon.logo:SetSize(20, 20)
	frame.icon.logo:SetPoint("TOPLEFT", 7, -6)
	frame.icon.logo:Show()
	frame.icon.Border = frame.icon:CreateTexture(nil, "OVERLAY")
	frame.icon.Border:SetSize(54, 54)
	frame.icon.Border:SetTexture("Interface/Minimap/MiniMap-TrackingBorder")
	frame.icon.Border:SetPoint("TOPLEFT")
	frame.icon.Border:SetDesaturated(1)
	frame:SetSize(maxZoneNameSize + 110, frameHeight + 42 + 20)
	frame:SetShown(TomCats_Account.primalstorms.preferences.enabled ~= false)
	frame:RegisterEvent("AREA_POIS_UPDATED")
	frame:RegisterEvent("BAG_UPDATE")
	-- event for learning or unlearning transmog
	-- event for when a toy is learned / collection updated?
	-- event for when adding an heirloom
	function addon.PrimalStorms.SetEnabled(enabled)
		TomCats_Account.primalstorms.preferences.enabled = enabled
		frame:SetShown(TomCats_Account.primalstorms.preferences.enabled)
	end
end
