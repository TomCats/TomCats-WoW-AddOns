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
				encounter.timeRemaining:SetText(timeRemaining or "---")
				encounter.timeRemaining:Show()
				encounter.zoneName:SetAlpha(timeRemaining and 1.0 or 0.5)
				encounter.timeRemaining:SetAlpha(timeRemaining and 1.0 or 0.5)
			end
		end
	end
	local function OnEvent()
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
		for _, v in pairs(Elements) do
			encounter.icons[v.label] = frame:CreateTexture(nil, "ARTWORK")
			encounter.icons[v.label]:SetSize(16, 16)
			encounter.icons[v.label]:SetAtlas(v.icon)
			encounter.icons[v.label]:SetPoint("RIGHT", encounter.zoneName, "LEFT", -2, 0)
			encounter.icons[v.label]:Hide()
		end
	end
	frame.topEdge = frame:CreateTexture(nil, "BACKGROUND")
	frame.topEdge:SetDrawLayer("BACKGROUND", 2)
	frame.topEdge:SetColorTexture(0.25,0.25,0.25,1)
	frame.topEdge:SetHeight(18)
	frame.topEdge:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -5)
	frame.topEdge:SetPoint("RIGHT", frame, "RIGHT", -5, 0)
	frame.topEdge:SetAlpha(0.8)
	frame.topEdge:Show()
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
	frame.icon.logo:SetPoint("TOPLEFT", 6, -6)
	frame.icon.logo:Show()
	frame.icon.Border = frame.icon:CreateTexture(nil, "OVERLAY")
	frame.icon.Border:SetSize(54, 54)
	frame.icon.Border:SetTexture("Interface/Minimap/MiniMap-TrackingBorder")
	frame.icon.Border:SetPoint("TOPLEFT")
	frame.icon.Border:SetDesaturated(1)
	frame:SetSize(maxZoneNameSize + 110, frameHeight + 22 + 20)
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
