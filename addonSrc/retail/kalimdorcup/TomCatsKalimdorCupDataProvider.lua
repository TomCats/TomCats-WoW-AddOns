local _, addon = ...

local eventMapID = 12

local function rescale(pin)
	local scale = TomCats_Account.preferences.MapOptions.iconScale
	local sizeX = 64 * scale
	local sizeY = 64 * scale
	pin.iconFinished:SetSize(48 * scale, 48 * scale)
	pin.iconDefault:SetSize(sizeX, sizeY)
	pin.iconHighlighted:SetSize(sizeX, sizeY)
	pin:SetSize(sizeX, sizeY)
end

TomCatsKalimdorCupDataProviderMixin = CreateFromMixins(MapCanvasDataProviderMixin)

function TomCatsKalimdorCupDataProviderMixin:RefreshAllData()
	local map = self:GetMap()
	map:RemoveAllPinsByTemplate("TomCatsKalimdorCupPinTemplate")
	if (map:GetMapID() == eventMapID) then
		local count = 0
		for _, eventLocation in pairs(addon.KalimdorCup.EventLocations) do
			count = count + 1
			map:AcquirePin("TomCatsKalimdorCupPinTemplate", eventLocation)
		end
	end
end

TomCatsKalimdorCupPinMixin = CreateFromMixins(addon.GetProxy(MapCanvasPinMixin))

function TomCatsKalimdorCupPinMixin:ApplyFrameLevel()
	local frameLevel = self:GetMap():GetPinFrameLevelsManager():GetValidFrameLevel("PIN_FRAME_LEVEL_MAP_LINK")
	self:SetFrameLevel(frameLevel)
end

function TomCatsKalimdorCupPinMixin:OnAcquired(pinInfo)
	self.pinInfo = pinInfo
	if (self.pinInfo.mapID < 80) then
		self.iconFinished:Show()
--		self.iconDefault:SetVertexColor(0, 1, 0)
	else
		self.iconFinished:Hide()
--		self.iconDefault:SetVertexColor(1, 1, 1)
	end
	rescale(self)
	self:SetPosition(pinInfo.x, pinInfo.y)
	self:Show()
	_G.DEBUGPINS[self] = self
end

function TomCatsKalimdorCupPinMixin:OnCanvasScaleChanged()
	local scaleBase = 0.286
	local uiMapID = self:GetMap():GetMapID()
	if (uiMapID == 12 or uiMapID == 13 or uiMapID == 113) then scaleBase = 0.35 end
	self:SetScale(scaleBase * self:GetMap():GetGlobalPinScale() / self:GetParent():GetScale())
	self:SetPosition(self.pinInfo.x, self.pinInfo.y)
	rescale(self)
end

TomCatsKalimdorCupPinMixin.OnLoad = nop

function TomCatsKalimdorCupPinMixin:OnReleased()
	_G.DEBUGPINS[self] = nil
	self:Hide()
end

_G.DEBUGPINS = { }

--function TomCatsKalimdorCupPinMixin:ShowTooltip()
--    local tooltip = WorldMapTooltip
--    WorldMapTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 10, 20)
--    WorldMapTooltip:ClearLines();
--    local questIDs
--    if (self.pinInfo.quest) then questIDs = { self.pinInfo.quest["Quest ID"] } else questIDs = self.pinInfo.entrance["Quest IDs"] end
--    if (self.pinInfo.entrance) then
--        if (self.pinInfo.entrance["Type"] == 3) then
--            GameTooltip_AddColoredLine(tooltip, "Portals leading to:", GREEN_COLOR, true)
--            GameTooltip_AddColoredLine(tooltip, "(Alliance Only)", WHITE_COLOR, true)
--            GameTooltip_AddBlankLinesToTooltip(tooltip, 1);
--        elseif (self.pinInfo.entrance["Type"] == 4) then
--            GameTooltip_AddColoredLine(tooltip, "Portals leading to:", GREEN_COLOR, true)
--            GameTooltip_AddColoredLine(tooltip, "(Horde Only)", WHITE_COLOR, true)
--            GameTooltip_AddBlankLinesToTooltip(tooltip, 1);
--        end
--    end
--    local questIDsToShow = {}
--    for i = 1, #questIDs do
--        if (P.showCompleted or (not IsQuestFlaggedCompleted(questIDs[i]))) then
--            table.insert(questIDsToShow,questIDs[i])
--        end
--    end
--    for i = 1, #questIDsToShow do
--        local questID = questIDsToShow[i]
--        local IDNumber, Name, Points, Completed, Month, Day, Year, Description, Flags, Image, RewardText, isGuildAch = GetAchievementInfo(questID)
--            GameTooltip_AddColoredLine(tooltip, Name, TITLE_COLOR, false)
--            GameTooltip_AddBlankLinesToTooltip(tooltip, 1);
--            GameTooltip_AddColoredLine(tooltip, Description, WHITE_COLOR, true)
--            --GameTooltip_AddColoredLine(tooltip, questID, WHITE_COLOR, true)
--            --GameTooltip_AddColoredLine(tooltip, C_Map.GetAreaInfo(D["Quests"][questIDsToShow[i]]["Area ID"]), WHITE_COLOR, true)
--            if (self.completed) then
--                GameTooltip_AddColoredLine(tooltip, "Completed", RED_COLOR, true)
--            end
--            if (i < #questIDs) then
--                GameTooltip_AddBlankLinesToTooltip(tooltip, 1);
--            end
--    end
--    --if (self.pinInfo.entrance) then
--    --    if (self.pinInfo.entrance["Type"] == 1) then
--    --        GameTooltip_AddBlankLinesToTooltip(tooltip, 1);
--    --        GameTooltip_AddColoredLine(tooltip, "(Entryway)", GREY_COLOR, true)
--    --    elseif (self.pinInfo.entrance["Type"] == 2) then
--    --        GameTooltip_AddBlankLinesToTooltip(tooltip, 1);
--    --        GameTooltip_AddColoredLine(tooltip, "(Dungeon Entrance)", GREY_COLOR, true)
--    --    end
--    --end
--    --if (self.pinInfo.phasedZone) then
--    --    local phasedZone = self.pinInfo.phasedZone
--    --    GameTooltip_AddBlankLinesToTooltip(tooltip, 1)
--    --    local poiInfo = C_AreaPoiInfo.GetAreaPOIInfo(phasedZone["UIMap ID"], phasedZone["Timewalking NPC POI ID"])
--    --    GameTooltip_AddColoredLine(tooltip, "This NPC is in a different phase", RED_COLOR, true)
--    --    GameTooltip_AddColoredLine(tooltip, "Visit " .. poiInfo.name .. " first:", RED_COLOR, true)
--    --    GameTooltip_AddColoredLine(tooltip, poiInfo.description, GREY_COLOR, true)
--    --end
--    if (TomTom) then
--        GameTooltip_AddBlankLinesToTooltip(tooltip, 1)
--        GameTooltip_AddColoredLine(tooltip, "Click to add a TomTom Waypoint", WHITE_COLOR, true)
--    end
--    if (not addon.dragonflyingglyphs.IsRideAlongComplete(questIDsToShow[1])) then
--        GameTooltip_AddBlankLinesToTooltip(tooltip, 1)
--        GameTooltip_AddColoredLine(tooltip, "Your passenger hasn't collected this glyph yet", GREEN_COLOR, true)
--    end
--    WorldMapTooltip:Show()
--    WorldMapTooltip.recalculatePadding = true
--end
--function TomCatsKalimdorCupPinMixin:HideItemTooltip()
--    WorldMapTooltip:Hide()
--end
--function TomCatsKalimdorCupPinMixin:SetIconState(state)
--   local iconStates = self:GetIconStates()
--   local stateTexture = self["icon" .. state]
--   for i = 1, #iconStates do
--       if (iconStates[i] ~= stateTexture) then iconStates[i]:Hide() end
--   end
--    stateTexture:Show()
--end
--function TomCatsKalimdorCupPinMixin:OnMouseEnter()
--    self:SetIconState("Highlighted")
--    self:ShowTooltip()
--end
--function TomCatsKalimdorCupPinMixin:OnMouseLeave()
--    if (not self.completed) then
--        self:SetIconState("Default")
--    else
--        self:SetIconState("Completed")
--    end
--    self:HideItemTooltip()
--end
--function TomCatsKalimdorCupPinMixin:OnMouseDown()
----    setIconState(self.iconPushed)
----    self:HideItemTooltip()
--end
--function TomCatsKalimdorCupPinMixin:OnMouseUp(button)
--    if (TomTom) then
--        if (button == "LeftButton") then
--            if (self.pinInfo.quest) then
--                addQuestToTomTom(self.pinInfo.quest, true)
--            end
--            if (self.pinInfo.entrance) then
--                addEntranceToTomTom(self.pinInfo.entrance, true)
--            end
--        end
--        --if (button == "RightButton") then
--        --    for _, pin in pairs(self.pinInfo.provider.activePins) do
--        --        addQuestToTomTom(pin.pinInfo.quest, false)
--        --    end
--        --    for _, pin in pairs(self.pinInfo.provider.activeEntrancePins) do
--        --        addEntranceToTomTom(pin.pinInfo.entrance, false)
--        --    end
--        --    if (not IsInInstance()) then
--        --        TomTom:SetClosestWaypoint()
--        --    end
--        --end
--    end
--end
--function TomCatsKalimdorCupPinMixin:GetIconStates()
--    return { self.iconDefault, self.iconHighlighted, self.iconPushed, self.iconCompleted }
--end
--
--local function OnUpdate()
--    local enabledVar = TomCats_Account and TomCats_Account.dragonflyingglyphs and TomCats_Account.dragonflyingglyphs.iconsEnabled
--    if (enabledVar ~= enabled) then
--        enabled = enabledVar
--        for pin in pairs(allPins) do
--            ShowHide(pin, enabled)
--        end
--    end
--end
--
--CreateFrame("FRAME"):SetScript("OnUpdate",OnUpdate)
--
--function addon.dragonflyingglyphs.SetIconScale()
--    for pin in pairs(allPins) do
--        rescale(pin)
--    end
--end
--
--function addon.dragonflyingglyphs.RefreshAll()
--    refreshAll()
--end
