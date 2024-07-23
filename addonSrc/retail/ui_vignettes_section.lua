--[[ See license.txt for license and copyright information ]]
local _, addon = ...

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local LayoutMixin = LayoutMixin
local PlaySound = PlaySound
local QuestMapFrame = QuestMapFrame
local QuestScrollFrame = QuestScrollFrame
local SOUNDKIT = SOUNDKIT
local UIParent = UIParent
local WorldMapFrame = WorldMapFrame

local TomCatsVignetteTooltip = TomCatsVignetteTooltip

local function RefreshVignetteSectionHeader(section)
	section.Header:SetNormalAtlas(section.state.collapsed and "Campaign_HeaderIcon_Closed" or "Campaign_HeaderIcon_Open" )
	section.Header:SetPushedAtlas(section.state.collapsed and "Campaign_HeaderIcon_ClosedPressed" or "Campaign_HeaderIcon_OpenPressed")
	section.Header:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight")
	section.Header:SetHitRectInsets(-12, 18 - section.Header.text:GetWidth(), -18, -18)
end

local function RefreshVignetteSection(section)
	RefreshVignetteSectionHeader(section)
	local state = section.state
	for _, v in ipairs(state.titles) do
		v.vignette = nil
		v.bottomPadding = 4
		v:Hide()
	end
	local mapID = WorldMapFrame:GetMapID()
	if (not addon.executeMapActivationRule(mapID)) then
		state.mapID = nil
		state.vignettes = nil
		state.vignettesSorted = nil
		if (section:IsShown()) then
			if (not section:IsDirty()) then
				section:MarkDirty()
			end
			section:Hide()
		end
		return
	end
	if (mapID ~= state.mapID) then
		state.mapID = mapID
		state.vignettes = addon.getVignettes(mapID)
		state.vignettesSorted = nil
	end
	if (not state.vignettes) then
		state.mapID = nil
		state.vignettes = nil
		state.vignettesSorted = nil
		if (section:IsShown()) then
			if (not section:IsDirty()) then
				section:MarkDirty()
			end
			section:Hide()
		end
		return
	end
	if (not section:IsShown()) then
		section:Show()
		if (not section:IsDirty()) then
			section:MarkDirty()
		end
	end
	if (state.collapsed) then
		section.Header.bottomPadding = 22
		section.Header.Note:Hide()
		return
	end
	if (not state.vignettesSorted) then
		state.vignettesSorted = { }
		local rareNames = { }
		local lookupByName = { }
		for _, v in pairs(state.vignettes) do
			local name = v["Name"]
			if (not lookupByName[name]) then
				table.insert(rareNames, name)
				lookupByName[name] = v
			end
		end
		table.sort(rareNames)
		for _, v in ipairs(rareNames) do
			table.insert(state.vignettesSorted, lookupByName[v])
		end
	end
	while (#state.titles < #state.vignettesSorted) do
		local button = CreateFrame("Button", nil, section, "TomCatsVignetteTitleTemplate")
		table.insert(state.titles, button)
		button.layoutIndex = state.nextLayoutIndex
		state.nextLayoutIndex = state.nextLayoutIndex + 1
	end
	local lastShown
	local titleIndex = 1
	for _, vignette in ipairs(state.vignettesSorted) do
		if (vignette.isListed) then
			local button = state.titles[titleIndex]
			titleIndex = titleIndex + 1
			button.text:SetText(vignette["Name"])
			button.vignette = vignette
			lastShown = button
			button:Show()
		end
	end
	if (#state.vignettesSorted == 0) then
		section.Header.Note:Show()
		section.Header.bottomPadding = 64
	else
		section.Header.Note:Hide()
	end
	if (lastShown) then
		section.Header.bottomPadding = 22
		lastShown.bottomPadding = 20
	end
end

local function VignetteSectionHeader_OnClick(self, button)
	if button == "LeftButton" then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		local section = self:GetParent()
		section.state.collapsed = not section.state.collapsed
		RefreshVignetteSection(section)
		if (not section:IsDirty()) then
			section:MarkDirty()
		end
	end
end

TomCatsVignettesSectionMixin = { }

function TomCatsVignettesSectionMixin:OnLoad()
	self:SetParent(QuestScrollFrame.Contents)
	local section = self
	hooksecurefunc(QuestScrollFrame.Contents, "Layout", function(self)
		if (not section:IsShown()) then return end
		local children = self:GetLayoutChildren()
		for _, v in ipairs(children) do
			v.layoutIndex = v.layoutIndex + 1
		end
		table.insert(children, 1, section)
		section.layoutIndex = 1
		local childrenWidth, childrenHeight, hasExpandableChild = self:LayoutChildren(children)
		local frameWidth, frameHeight = self:CalculateFrameSize(childrenWidth, childrenHeight)
		if (hasExpandableChild) then
			childrenWidth, childrenHeight = self:LayoutChildren(children, frameWidth, frameHeight)
			frameWidth, frameHeight = self:CalculateFrameSize(childrenWidth, childrenHeight)
		end
		self:SetSize(frameWidth, frameHeight)
		self:MarkClean()
		section.layoutIndex = nil
	end)
	self.state = {
		collapsed = true,
		titles = { },
		nextLayoutIndex = 2
	}
	self.Header:SetScript("OnClick", VignetteSectionHeader_OnClick)
	RefreshVignetteSectionHeader(section)
	local function RefreshIfVisible()
		if (QuestMapFrame:IsVisible()) then
			RefreshVignetteSection(section)
			if (not section:IsDirty()) then
				section:MarkDirty()
			end
		end
	end
	hooksecurefunc(WorldMapFrame,"OnMapChanged", RefreshIfVisible)
	table.insert(addon.ruleListeners, RefreshIfVisible)
end

function TomCatsVignettesSectionMixin:OnShow()
	RefreshVignetteSection(self)
	LayoutMixin.OnShow(self)
end

TomCatsVignetteTitleMixin = { }

function TomCatsVignetteTitleMixin:OnClick()
	if (not addon.VignetteArrow) then
		addon.VignetteArrow = addon.CreateArrow(0.0, 1.0, 0.0)
	end
	if (addon.VignetteArrow.vignetteID and addon.VignetteArrow.vignetteID == self.vignette.ID) then
		addon.VignetteArrow:ClearTarget()
		addon.VignetteArrow.vignetteID = nil
	else
		local x, y
		if (not self.vignette["Alias"]) then
			x, y = self.vignette:GetLocation()
		else
			x, y = self.vignette["Alias"]:GetLocation()
		end
		addon.VignetteArrow:SetTarget(x, y, WorldMapFrame:GetMapID())
		addon.VignetteArrow.vignetteID = self.vignette.ID
	end
end

function TomCatsVignetteTitleMixin:OnEnter()
	if (self.vignette) then
		TomCatsVignetteTooltip:SetOwner(self)
		TomCatsVignetteTooltip:ClearAllPoints()
		TomCatsVignetteTooltip:SetPoint("TOPLEFT", self, "TOPRIGHT", 34, 0)
		local tooltipWidth = 20 + TomCatsVignetteTooltip:GetWidth()
		if ( tooltipWidth > UIParent:GetRight() - QuestMapFrame:GetParent():GetRight() ) then
			TomCatsVignetteTooltip:ClearAllPoints()
			TomCatsVignetteTooltip:SetPoint("TOPRIGHT", self, "TOPLEFT", -5, 0)
		end
	end
end

function TomCatsVignetteTitleMixin:OnLeave()
	TomCatsVignetteTooltip:SetOwner()
end
