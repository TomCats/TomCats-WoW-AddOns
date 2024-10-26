--[[ See license.txt for license and copyright information ]]
local addonName, addon = ...

local BattlefieldMapFrame
local C_Map = C_Map
local C_VignetteInfo = C_VignetteInfo
local CreateFrame = CreateFrame
local CreateFromMixins = CreateFromMixins
local hooksecurefunc = hooksecurefunc
local MapCanvasPinMixin = MapCanvasPinMixin
local nop = nop
local TextureKitConstants = TextureKitConstants
local WorldMapFrame

TomCatsMapCanvasPinMixin = CreateFromMixins(addon.GetProxy(MapCanvasPinMixin))
local TomCatsMapCanvasPinMixin = TomCatsMapCanvasPinMixin
local TomCatsVignetteTooltip = TomCatsVignetteTooltip

local maps = { }
local atlasSizes = {
	["poi-workorders"] = { 20, 20 }
}
local interval, minInterval, maxInterval = 1, 1/15, 1
local imagePath = ("Interface\\AddOns\\%s\\images\\"):format(addonName)
local timeSinceLastUpdate = 0
local vignetteInfoCache = { }
local activeEncounters = { }
local activePins = { }
local iconAnimationEnabled = true
local globalPinScale = 1.0

local PIN_STATUS = {
	STATIC = 1,
	SPAWNED = 2,
	COMPLETE = 3
}

local atlasTweaks = {
	["Warfront-NeutralHero"] = {
		scaleFactor = 1.2
	},
	["Capacitance-General-WorkOrderCheckmark"] = {
		scaleFactor = 0.9
	}
}

local function ShowHide(element, condition)
	if (condition) then
		element:Show()
		return true
	end
	element:Hide()
	return false
end

local function rescale(pin)
	local atlasName = pin.Texture:GetAtlas()
	if (not atlasName) then
		atlasName = pin.Texture:GetTexture()
	end
	if (atlasName) then
		if (not atlasSizes[atlasName]) then
			atlasSizes[atlasName] = { pin.Texture:GetSize() }
		end
		local zoom = pin:GetParent():GetScale()
		local mapData = maps[pin:GetMap()]
		local sizeX = atlasSizes[atlasName][1] / zoom * (pin.scaleFactor or 1) * mapData.iconScale * globalPinScale
		local sizeY = atlasSizes[atlasName][2] / zoom * (pin.scaleFactor or 1) * mapData.iconScale * globalPinScale
		pin.Texture:SetSize(sizeX, sizeY)
		pin.HighlightTexture:SetSize(sizeX, sizeY)
		pin.BackHighlight:SetSize(sizeX, sizeY)
		pin.Expand:SetSize(sizeX, sizeY)
		pin:SetSize(sizeX, sizeY)
	end
end

local customVignetteIconOverrides = {
	["vignetteevent"] = true,
	["vignettekill"] = true
}

local function setPinIcon(pin, status)
	local atlas = (status <= PIN_STATUS.SPAWNED) and pin.vignette["Atlas"] or "Capacitance-General-WorkOrderCheckmark"
	local override = false
	if (customVignetteIconOverrides[atlas] and _G.TomCats_Account.preferences.defaultVignetteIcon ~= "default") then
		override = _G.TomCats_Account.preferences.defaultVignetteIcon
	end
	if (override) then
		pin.Texture:SetAtlas(nil)
		pin.Texture:SetTexture(imagePath .. "icon-" .. override)
		pin.Texture:SetSize(32,32)
		pin.HighlightTexture:SetAtlas(nil)
		pin.HighlightTexture:SetTexture(imagePath .. "icon-" .. override)
		pin.scaleFactor = 0.75
	else
		--pin.Texture:ClearAllPoints()
		pin.Texture:SetTexture(nil)
		pin.Texture:SetAtlas(atlas, true)
		--pin.HighlightTexture:ClearAllPoints()
		pin.HighlightTexture:SetTexture(nil)
		pin.HighlightTexture:SetAtlas(atlas, true)
		pin.scaleFactor = atlasTweaks[atlas] and atlasTweaks[atlas].scaleFactor or 1
	end
	if (status == PIN_STATUS.SPAWNED) then
		activeEncounters[pin] = true
		pin.Texture:SetVertexColor(1, 0, 0, 1)
		pin.BackHighlight:Show()
		pin.Expand:SetTexCoord(0, 1, 0, 1);
		if (override) then
			pin.Expand:SetAtlas(nil);
			pin.Expand:SetTexture(imagePath .. "icon-" .. override);
		else
			pin.Expand:SetTexture(nil)
			pin.Expand:SetAtlas(atlas, TextureKitConstants.IgnoreAtlasSize);
		end

		if (iconAnimationEnabled) then
			pin.Expand:Show()
			pin.ExpandAndFade:Play()
		end
	else
		activeEncounters[pin] = false
		pin.Texture:SetVertexColor(1, 1, 1, 1)
		pin.BackHighlight:Hide()
		pin.ExpandAndFade:Stop()
		pin.Expand:Hide()
	end
	rescale(pin)
end

local function updateVignettePin(pin)
	local vignette = pin.vignette
	if (vignette) then
		if (pin.isSpawned) then
			setPinIcon(pin, PIN_STATUS.SPAWNED)
		else
			local isCompleted = vignette.isCompleted
			if (isCompleted) then
				setPinIcon(pin, PIN_STATUS.COMPLETE)
			else
				setPinIcon(pin, PIN_STATUS.STATIC)
			end
		end
	end
end

local function GetVignettePosition(vignetteGUIDs, mapID)
	if (#vignetteGUIDs == 1) then
		return C_VignetteInfo.GetVignettePosition(vignetteGUIDs[1], mapID), vignetteGUIDs[1]
	end
	local idx = C_VignetteInfo.FindBestUniqueVignette(vignetteGUIDs)
	if (idx) then
		local position = C_VignetteInfo.GetVignettePosition(vignetteGUIDs[idx], mapID)
		if (position) then return position, vignetteGUIDs[idx] end
	end
	for _, v in ipairs(vignetteGUIDs) do
		local vignetteInfo = vignetteInfoCache[v]
		if (vignetteInfo and not vignetteInfo.isDead) then
			local position = C_VignetteInfo.GetVignettePosition(vignetteInfo.vignetteGUID, mapID)
			if (position) then return position, vignetteInfo.vignetteGUID end
		end
	end
end

local function OnUpdate(_, elapsed)
	timeSinceLastUpdate = timeSinceLastUpdate + elapsed
	if (timeSinceLastUpdate > interval) then
		timeSinceLastUpdate = 0
		local mapID = C_Map.GetBestMapForUnit("player")
		local affectedMaps
		for mapFrame, mapData in pairs(maps) do
			if (next(mapData.pins) and mapID == mapFrame:GetMapID() and mapFrame:IsShown()) then
				affectedMaps = affectedMaps or { }
				table.insert(affectedMaps, mapData)
			end
		end
		local newInterval
		if (affectedMaps) then
			local vignettes = C_VignetteInfo.GetVignettes()
			local vignetteGUIDsByVignetteID
			if (#vignettes ~= 0) then
				newInterval = minInterval --todo: move this to when a known rare is identified
				for _, v in ipairs(vignettes) do
					local vignetteInfo = vignetteInfoCache[v]
					if (not vignetteInfo) then
						vignetteInfo = C_VignetteInfo.GetVignetteInfo(v)
						if (vignetteInfo) then
							vignetteInfoCache[v] = vignetteInfo
						else
							vignetteInfoCache[v] = false
						end
					end
					if (vignetteInfo) then
						vignetteGUIDsByVignetteID = vignetteGUIDsByVignetteID or { }
						vignetteGUIDsByVignetteID[vignetteInfo.vignetteID] = vignetteGUIDsByVignetteID[vignetteInfo.vignetteID] or { }
						table.insert(vignetteGUIDsByVignetteID[vignetteInfo.vignetteID], v)
					end
				end
			end
			addon.vignetteGUIDsByVignetteID = vignetteGUIDsByVignetteID
			for vignetteID in pairs(affectedMaps[1].pins) do
				local vignetteGUIDs = vignetteGUIDsByVignetteID and vignetteGUIDsByVignetteID[vignetteID]
				for _, mapInfo in ipairs(affectedMaps) do
					local pin = mapInfo.pins[vignetteID]
					local spawned
					if (pin) then
						if (vignetteGUIDs) then
							local position, vignetteGUID = GetVignettePosition(vignetteGUIDs, mapID)
							if (position) then
								if (not pin.isSpawned) then
									pin.isSpawned = true
									pin.vignetteInfo = vignetteInfoCache[vignetteGUID]
									updateVignettePin(pin)
								end
								pin:SetPosition(position:GetXY())
								spawned = true
							end
						end
						if (not spawned) then
							if (pin.isSpawned) then
								pin.isSpawned = false
								pin.vignetteInfo = nil
								updateVignettePin(pin)
							end
							local x, y = pin.vignette:GetLocation()
							if (not x) then
								x = -100
								y = -100
							end
							pin:SetPosition(x, y)
						end
					end
				end
			end
		end
		interval = newInterval or maxInterval
	end
end

local TomCatsMapCanvasDataProviderMixin = { }

function TomCatsMapCanvasDataProviderMixin:GetMap()
	return self.owningMap
end

function TomCatsMapCanvasDataProviderMixin:OnAdded(owningMap)
	self.owningMap = owningMap
end

function TomCatsMapCanvasDataProviderMixin:RefreshAllData()
	vignetteInfoCache = { }
	local mapFrame = self:GetMap()
	local mapData = maps[mapFrame]
	if (mapData) then
		if (not addon.executeMapActivationRule(mapFrame:GetMapID())) then
			return
		end
		local vignetteInfo = addon.getVignettes(mapFrame:GetMapID())
		if (vignetteInfo) then
			for vignetteID, vignette in pairs(vignetteInfo) do
				if (vignette.isPinned) then
					if (not mapData.pins[vignetteID]) then
						local completed = vignette.isCompleted
						ShowHide(
								mapFrame:AcquirePin("TomCatsMapPinTemplate", vignette),
								not completed or vignette.isVisibleWhenCompleted
						)
					end
				end
			end
		end
	end
end

function TomCatsMapCanvasDataProviderMixin:OnCanvasScaleChanged()
	local mapData = maps[self:GetMap()]
	if (mapData) then
		for _, pin in pairs(mapData.pins) do
			rescale(pin)
		end
	end
end

function TomCatsMapCanvasDataProviderMixin:OnMapChanged()
	local mapFrame = self:GetMap()
	local mapData = maps[mapFrame]
	if (mapData) then
		for vignetteID, pin in pairs(mapData.pins) do
			mapData.pins[vignetteID] = nil
			pin:Hide()
			mapFrame:RemovePin(pin)
		end
	end
	self:RefreshAllData()
end

local function setQuestFocus()
	local mapFrame = WorldMapFrame
	local mapData = maps[mapFrame]
	for _, pin in pairs(mapData.pins) do
		local completed = pin.vignette.isCompleted
		ShowHide(
				pin,
				not completed or pin.vignette.isVisibleWhenCompleted
		)
	end
end

local function setupMapProvider(map, iconScale)
	assert(map)
	if (not maps[map]) then
		maps[map] = {
			pins = { },
			iconScale = iconScale,
			mapFrame = map
		}
		local provider = CreateFromMixins(TomCatsMapCanvasDataProviderMixin)
		map:AddDataProvider(provider)
		table.insert(addon.ruleListeners, function()
			provider:OnMapChanged()
		end)
		if (map == WorldMapFrame) then
			hooksecurefunc(WorldMapFrame.target,"SetFocusedQuestID", setQuestFocus)
			hooksecurefunc(WorldMapFrame.target,"ClearFocusedQuestID", setQuestFocus)
		end
	end
end

local trackedVignettePins = { }

local vignettePinOverridesIDs = { }

for _, v in ipairs(addon.vignettes_known) do
	vignettePinOverridesIDs[v] = true
end

--todo: Determine if this will create any performance issue when more rares are added to the overrides lookup (currently OK)
local function Hook_Pin_Show(self, setShown)
	if (setShown == false) then return end
	if (self.vignetteID and vignettePinOverridesIDs[self.vignetteID]) then
		self:Hide()
	end
end

local function trackVignettePins(mapFrame)
	local pinPool = mapFrame.pinPools[_G.VignetteDataProviderMixin:GetPinTemplate()]
	if (pinPool) then
		for pin in pinPool:EnumerateActive() do
			if (not trackedVignettePins[pin]) then
				trackedVignettePins[pin] = true
				hooksecurefunc(pin, "Show", Hook_Pin_Show)
				hooksecurefunc(pin, "SetShown", Hook_Pin_Show)
				Hook_Pin_Show(pin)
			end
		end
	end
end

local function Hook_AcquirePin(self, pinTemplate, ...)
	if (pinTemplate == _G.VignetteDataProviderMixin:GetPinTemplate() or pinTemplate == "AreaPOIPinTemplate") then
		trackVignettePins(self)
	end
end

local function setupVignettePinOverride(mapFrame)
	hooksecurefunc(mapFrame, "AcquirePin", Hook_AcquirePin)
	trackVignettePins(mapFrame)
end

local function OnEvent(event, arg1)
	if (event == "ADDON_LOADED") then
		if (addonName == arg1) then
			iconAnimationEnabled = _G["TomCats_Account"].preferences.MapOptions.iconAnimationEnabled
			globalPinScale = _G["TomCats_Account"].preferences.MapOptions.iconScale
		end
		if (not WorldMapFrame and _G["WorldMapFrame"]) then
			WorldMapFrame = addon.GetProxy(_G["WorldMapFrame"])
			setupMapProvider(WorldMapFrame, 0.7)
			setupVignettePinOverride(_G["WorldMapFrame"])
		end
		if (not BattlefieldMapFrame and _G["BattlefieldMapFrame"]) then
			BattlefieldMapFrame = addon.GetProxy(_G["BattlefieldMapFrame"])
			setupMapProvider(BattlefieldMapFrame, 0.8)
			setupVignettePinOverride(_G["BattlefieldMapFrame"])
		end
	end
end

addon.RegisterEvent("ADDON_LOADED", OnEvent)
CreateFrame("Frame"):SetScript("OnUpdate", OnUpdate)

function TomCatsMapCanvasPinMixin:ApplyFrameLevel()
	local frameLevel = self:GetMap():GetPinFrameLevelsManager():GetValidFrameLevel("PIN_FRAME_LEVEL_MAP_LINK")
	self:SetFrameLevel(frameLevel)
end

function TomCatsMapCanvasPinMixin:IsMouseClickEnabled()
	return true
end

function TomCatsMapCanvasPinMixin:OnAcquired(vignette)
	activePins[self] = true
	self.vignette = vignette
	local mapData = maps[self:GetMap()]
	mapData.pins[vignette.ID] = self
	local x, y = vignette:GetLocation()
	if (not x) then
		x = -100
		y = -100
	end
	self:SetPosition(x,y)
	updateVignettePin(self)
	rescale(self)
	self:ApplyCurrentScale()
end

function TomCatsMapCanvasPinMixin:OnLoad()
	self.SetPassThroughButtons = nop
end

function TomCatsMapCanvasPinMixin:OnMouseClickAction()
	if (addon.IsBetaEnabled()) then
		if (not addon.VignetteArrow) then
			addon.VignetteArrow = addon.CreateArrow(0.0, 1.0, 0.0)
		end
		if (addon.VignetteArrow.vignetteID and addon.VignetteArrow.vignetteID == self.vignette.ID) then
			addon.VignetteArrow:ClearTarget()
			addon.VignetteArrow.vignetteID = nil
		else
			local x, y = self.vignette:GetLocation()
			addon.VignetteArrow:SetTarget(x, y, self:GetMap():GetMapID())
			addon.VignetteArrow.vignetteID = self.vignette.ID
		end
	end
end

function TomCatsMapCanvasPinMixin:OnMouseEnter()
	if (self.vignetteInfo and self.vignetteInfo.widgetSetID) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		GameTooltip_SetTitle(GameTooltip, self.vignette["Name"]);
		local overflow = GameTooltip_AddWidgetSet(GameTooltip, self.vignetteInfo.widgetSetID, self.vignetteInfo.addPaddingAboveWidgets and 10);
		GameTooltip:Show()
		if (overflow) then
			GameTooltip:SetPadding(0, -overflow);
		end
	else
		TomCatsVignetteTooltip:SetOwner(self)
	end
end

function TomCatsMapCanvasPinMixin:OnMouseLeave()
	if (self.vignetteInfo and self.vignetteInfo.widgetSetID) then
		GameTooltip:Hide();
	else
		TomCatsVignetteTooltip:SetOwner()
	end
end

function TomCatsMapCanvasPinMixin:OnReleased()
	activePins[self] = nil
	if (self.vignette) then
		maps[self:GetMap()].pins[self.vignette.ID] = nil
	end
	self.vignette = nil
	self.isSpawned = nil
	self.scaleFactor = nil
	self.Texture:SetAtlas(nil)
	self.HighlightTexture:SetAtlas(nil)
	self.Texture:SetVertexColor(1, 1, 1, 1)
	activeEncounters[self] = false
	self.ExpandAndFade:Stop()
	self.Expand:Hide()
end

function addon.GetIconScale()
	return _G["TomCats_Account"].preferences.MapOptions.iconScale
end

function addon.SetIconScale(value)
	_G["TomCats_Account"].preferences.MapOptions.iconScale = value
	globalPinScale = value
	for pin in pairs(activePins) do
		rescale(pin)
	end
end

function addon.IsIconAnimationEnabled()
	return _G["TomCats_Account"].preferences.MapOptions.iconAnimationEnabled
end

function addon.SetIconAnimationEnabled(value)
	_G["TomCats_Account"].preferences.MapOptions.iconAnimationEnabled = value
	iconAnimationEnabled = value
	if (iconAnimationEnabled) then
		for k, v in pairs(activeEncounters) do
			if (v) then
				k.Expand:Show()
				k.ExpandAndFade:Play()
			end
		end
	else
		for k, v in pairs(activeEncounters) do
			if (v) then
				k.ExpandAndFade:Stop()
				k.Expand:Hide()
			end
		end
	end
end
