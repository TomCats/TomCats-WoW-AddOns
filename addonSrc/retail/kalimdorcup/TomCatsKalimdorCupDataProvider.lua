local _, addon = ...

if (not addon.KalimdorCup.IsEventActive()) then return end

local AreaPOIPinMouseOver, appendTooltip

-- local eventMapID = 12 -- Kalimdor
-- local eventMapID = 13 -- Eastern Kingdoms
-- local eventMapID = 101 -- Outland
local eventMapID = 113 -- Northrend

local progress = {
	{ 1100022, "None" },
	{ 1002572, "Bronze" },
	{ 1002575, "Silver" },
	{ 1002573, "Gold" },
}

local raceTypes = {
	"Normal",
	"Advanced",
	"Reverse"
}

local function isFinished(eventLocation)
	if (not select(13, GetAchievementInfo(eventLocation.achievementBase + 2))) then return false end
	if (not select(13, GetAchievementInfo(eventLocation.achievementBase + 5))) then return false end
	if (not select(13, GetAchievementInfo(eventLocation.achievementBase + 8))) then return false end
	return true
end

local function getProgress(achievementBase)
	if (select(13, GetAchievementInfo(achievementBase + 2))) then return 4 end
	if (select(13, GetAchievementInfo(achievementBase + 1))) then return 3 end
	if (select(13, GetAchievementInfo(achievementBase))) then return 2 end
	return 1
end

local function rescale(pin)
	local scale = TomCats_Account.preferences.MapOptions.iconScale
	local sizeX = 64 * scale
	local sizeY = 64 * scale
	pin.iconFinished:SetSize(48 * scale, 48 * scale)
	pin.iconDefault:SetSize(sizeX, sizeY)
	--pin.iconHighlighted:SetSize(sizeX, sizeY)
	pin:SetSize(sizeX, sizeY)
end

local progressFrames

local function addProgressFrame()
	local frame = CreateFrame("Frame", nil, progressFrames)
	frame:SetScale(0.75)
	frame:SetSize(43, 43)
	frame.Icon = frame:CreateTexture(nil, "ARTWORK")
	frame.Icon:SetTexture(PROGRESS_NONE)
	frame.Icon:SetSize(41, 41)
	frame.Icon:SetPoint("CENTER", 0, 0.5)
	local mask = frame:CreateMaskTexture()
	mask:SetTexture("Interface/CharacterFrame/TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE","TRILINEAR")
	mask:SetPoint("TOPLEFT", frame.Icon, 1.2, -1.2)
	mask:SetPoint("BOTTOMRIGHT", frame.Icon, -1.2, 1.2)
	frame.Icon:AddMaskTexture(mask)
	frame.IconBorder = frame:CreateTexture(nil, "BACKGROUND")
	frame.IconBorder:SetAtlas("auctionhouse-itemicon-border-artifact")
	frame.IconBorder:SetSize(54, 54)
	frame.IconBorder:SetPoint("CENTER")
	frame.RaceType = progressFrames:CreateFontString(nil, "ARTWORK", "Game12Font")
	frame.RaceType:SetPoint("TOPLEFT", frame.Icon, "TOPRIGHT", 10, -3)
	frame.Progress = progressFrames:CreateFontString(nil, "ARTWORK", "Game11Font")
	frame.Progress:SetPoint("BOTTOMLEFT", frame.Icon, "BOTTOMRIGHT", 10, 3)
	table.insert(progressFrames.courses, frame)
	if (#progressFrames.courses == 1) then
		frame:SetPoint("TOPLEFT", progressFrames, "TOPLEFT", 0, -14)
	else
		frame:SetPoint("TOPLEFT", progressFrames.courses[#progressFrames.courses - 1], "BOTTOMLEFT", 0, -10)
	end
end

local function setupProgressFrames()
	if (not progressFrames) then
		progressFrames = CreateFrame("Frame")
		progressFrames:SetSize(100, 120)
		progressFrames.courses = { }
		addProgressFrame()
		addProgressFrame()
		addProgressFrame()
	end
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

function TomCatsKalimdorCupPinMixin:OnLoad()
	self.SetPassThroughButtons = nop
end

function TomCatsKalimdorCupPinMixin:ApplyFrameLevel()
	local frameLevel = self:GetMap():GetPinFrameLevelsManager():GetValidFrameLevel("PIN_FRAME_LEVEL_MAP_LINK")
	self:SetFrameLevel(frameLevel)
end

function TomCatsKalimdorCupPinMixin:OnAcquired(pinInfo)
	self.pinInfo = pinInfo
	if (isFinished(self.pinInfo)) then
		self.iconFinished:Show()
	else
		self.iconFinished:Hide()
	end
	rescale(self)
	self:SetPosition(pinInfo.x, pinInfo.y)
	self:Show()
end

function TomCatsKalimdorCupPinMixin:OnCanvasScaleChanged()
	local scaleBase = 0.286
	local uiMapID = self:GetMap():GetMapID()
	if (uiMapID == 12 or uiMapID == 13 or uiMapID == 113) then scaleBase = 0.35 end
	self:SetScale(scaleBase * self:GetMap():GetGlobalPinScale() / self:GetParent():GetScale())
	self:SetPosition(self.pinInfo.x, self.pinInfo.y)
	rescale(self)
end

function TomCatsKalimdorCupPinMixin:OnReleased()
	self:Hide()
end

function appendTooltip(eventLocation)
	setupProgressFrames()
	for i = 1, #progressFrames.courses do
		local p = getProgress(eventLocation.achievementBase + (i-1) * 3)
		progressFrames.courses[i].Icon:SetTexture(progress[p][1])
		progressFrames.courses[i].RaceType:SetText(raceTypes[i])
		progressFrames.courses[i].Progress:SetText(progress[p][2])
	end
	GameTooltip_InsertFrame(GameTooltip, progressFrames)
end

function TomCatsKalimdorCupPinMixin:ShowTooltip()
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip_SetTitle(GameTooltip, self.pinInfo.name, HIGHLIGHT_FONT_COLOR);
	if self.pinInfo.description then
		GameTooltip_AddNormalLine(GameTooltip, self.pinInfo.description);
	end
	appendTooltip(self.pinInfo)
	GameTooltip:Show()
end

function TomCatsKalimdorCupPinMixin:OnMouseEnter()
    self.HighlightTexture:Show()
	self:ShowTooltip()
end

function TomCatsKalimdorCupPinMixin:OnMouseLeave()
	self.HighlightTexture:Hide()
	GameTooltip:Hide()
end

function AreaPOIPinMouseOver(_, pin, tooltipShown, areaPoiID)
	if (tooltipShown) then
		local eventLocation = areaPoiID and addon.KalimdorCup.EventLocations[areaPoiID]
		if (eventLocation) then
			appendTooltip(eventLocation)
			GameTooltip:Show()
		end
	end
end

EventRegistry:RegisterCallback("AreaPOIPin.MouseOver", AreaPOIPinMouseOver);
