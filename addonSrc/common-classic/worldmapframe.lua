local addonName, addon = ...

local nop = nop
local CreateFromMixins = CreateFromMixins
local DungeonEntranceDataProviderMixin = TomCats_DungeonEntranceDataProviderMixin
local TomCats_WorldMapFrame = TomCats_WorldMapFrame
local UIParent = UIParent
local WorldMapFrame = WorldMapFrame

local function CollectAnchors(obj)
	local anchors = { }
	for i =1, obj:GetNumPoints() do
		table.insert(anchors,{ obj:GetPoint(i) })
	end
	return anchors
end

local function ReattachAnchors(obj, oldParent, newParent, anchors)
	obj:ClearAllPoints()
	obj:SetParent(newParent)
	for _, v in ipairs(anchors) do
		for k1, v1 in ipairs(v) do
			if (v1 == oldParent) then
				v[k1] = newParent
			end
		end
		obj:SetPoint(unpack(v))
	end
end

local function Mixin(object, ...)
	for i = 1, select("#", ...) do
		local mixin = select(i, ...);
		for k, v in pairs(mixin) do
			if (type(v) ~= "userdata") then object[k] = v end
		end
	end
	return object;
end

local function MergeScrollContainer()
	WorldMapFrame.ScrollContainer:ClearAllPoints()
	WorldMapFrame.ScrollContainer:SetPoint("TOPLEFT", WorldMapFrame.TitleCanvasSpacerFrame, "BOTTOMLEFT", 0, 0)
	WorldMapFrame.ScrollContainer:SetPoint("BOTTOMLEFT", 0, 2)
	WorldMapFrame.ScrollContainer:SetPoint("RIGHT", WorldMapFrame.TitleCanvasSpacerFrame)

	TomCats_WorldMapFrame.ScrollContainer:SetScript("OnLoad", nop)
	TomCats_WorldMapFrame.ScrollContainer:SetScript("OnMouseUp", nop)
	TomCats_WorldMapFrame.ScrollContainer:SetScript("OnMouseDown", nop)
	TomCats_WorldMapFrame.ScrollContainer:SetScript("OnMouseWheel", nop)
	TomCats_WorldMapFrame.ScrollContainer:SetScript("OnHide", nop)
	TomCats_WorldMapFrame.ScrollContainer:SetScript("OnUpdate", nop)

	WorldMapFrame.ScrollContainer:SetScript("OnLoad", TomCats_WorldMapFrame.ScrollContainer.OnLoad)
	WorldMapFrame.ScrollContainer:SetScript("OnMouseUp", TomCats_WorldMapFrame.ScrollContainer.OnMouseUp)
	WorldMapFrame.ScrollContainer:SetScript("OnMouseDown", TomCats_WorldMapFrame.ScrollContainer.OnMouseDown)
	WorldMapFrame.ScrollContainer:SetScript("OnMouseWheel", TomCats_WorldMapFrame.ScrollContainer.OnMouseWheel)
	WorldMapFrame.ScrollContainer:SetScript("OnHide", TomCats_WorldMapFrame.ScrollContainer.OnHide)
	WorldMapFrame.ScrollContainer:SetScript("OnUpdate", TomCats_WorldMapFrame.ScrollContainer.OnUpdate)

	for k, v in pairs(TomCats_WorldMapFrame.ScrollContainer) do
		if (type(v) == "function") then
			WorldMapFrame.ScrollContainer[k] = v
		end
	end

	WorldMapFrame.ScrollContainer.Child:SetParent(nil)
	WorldMapFrame.ScrollContainer.Child:Hide()
	WorldMapFrame.ScrollContainer:SetScrollChild(TomCats_WorldMapFrame.ScrollContainer.Child)
	WorldMapFrame.ScrollContainer.Child = TomCats_WorldMapFrame.ScrollContainer.Child
	TomCats_WorldMapFrame.ScrollContainer.Child = nil
	WorldMapFrame.ScrollContainer.Child:ClearAllPoints()
	WorldMapFrame.ScrollContainer.Child:SetPoint("TOPLEFT")
end

local function MergeWorldMapFrame()
	WorldMapFrame.TitleCanvasSpacerFrame = TomCats_WorldMapFrame.TitleCanvasSpacerFrame
	TomCats_WorldMapFrame.TitleCanvasSpacerFrame = nil
	WorldMapFrame.TitleCanvasSpacerFrame:SetParent(WorldMapFrame)
	WorldMapFrame.TitleCanvasSpacerFrame:ClearAllPoints()
	WorldMapFrame.TitleCanvasSpacerFrame:SetPoint("TOPLEFT", 2, 0)

	MergeScrollContainer()

	WorldMapFrame.BorderFrame:SetParent(nil)
	WorldMapFrame.BorderFrame:Hide()
	WorldMapFrame.BorderFrame = TomCats_WorldMapFrame.BorderFrame
	TomCats_WorldMapFrame.BorderFrame = nil
	WorldMapFrame.BorderFrame:SetParent(WorldMapFrame)
	WorldMapFrame.BorderFrame:ClearAllPoints()
	WorldMapFrame.BorderFrame:SetAllPoints()
	WorldMapFrame.BorderFrame.InsetBorderTop:ClearAllPoints()
	WorldMapFrame.BorderFrame.InsetBorderTop:SetPoint("TOPLEFT",2,-63)
	WorldMapFrame.BorderFrame.InsetBorderTop:SetPoint("RIGHT",WorldMapFrame.ScrollContainer)

	local questLogAnchors = CollectAnchors(TomCats_WorldMapFrame.QuestLog)
	WorldMapFrame.QuestLog = TomCats_WorldMapFrame.QuestLog
	TomCats_WorldMapFrame.QuestLog = nil
	ReattachAnchors(WorldMapFrame.QuestLog, TomCats_WorldMapFrame, WorldMapFrame, questLogAnchors)

	local worldMapFrameBgAnchors = CollectAnchors(_G.TomCats_WorldMapFrameBg)
	ReattachAnchors(_G.TomCats_WorldMapFrameBg, TomCats_WorldMapFrame, WorldMapFrame, worldMapFrameBgAnchors)

	WorldMapFrame:SetIgnoreParentScale(false)
	WorldMapFrame:ClearAllPoints()
	WorldMapFrame:SetPoint("TOP", UIParent, "TOP", 0, 0)
	TomCats_WorldMapFrame:SetScript("OnLoad", nop)
	TomCats_WorldMapFrame:SetScript("OnShow", nop)
	TomCats_WorldMapFrame:SetScript("OnEvent", nop)
	TomCats_WorldMapFrame:SetScript("OnHide", nop)
	WorldMapFrame:SetScript("OnLoad", WorldMapFrame.OnLoad)
	WorldMapFrame:SetScript("OnShow", TomCats_WorldMapFrame.OnShow)
	WorldMapFrame:SetScript("OnEvent", WorldMapFrame.OnEvent)
	WorldMapFrame:SetScript("OnHide", WorldMapFrame.OnHide)

	for k, v in pairs(TomCats_WorldMapFrame) do
		if (type(v) == "function") then
			WorldMapFrame[k] = v
		end
	end

	WorldMapFrame.closureRegistry = TomCats_WorldMapFrame.closureRegistry
	TomCats_WorldMapFrame.closureRegistry = nil
	WorldMapFrame.funcRegistry = TomCats_WorldMapFrame.funcRegistry
	TomCats_WorldMapFrame.funcRegistry = nil
	WorldMapFrame.minimizedWidth = TomCats_WorldMapFrame.minimizedWidth
	TomCats_WorldMapFrame.minimizedWidth = nil
	WorldMapFrame.minimizedHeight = TomCats_WorldMapFrame.minimizedHeight
	TomCats_WorldMapFrame.minimizedHeight = nil
	WorldMapFrame.detailLayerPool = TomCats_WorldMapFrame.detailLayerPool
	TomCats_WorldMapFrame.detailLayerPool = nil

	WorldMapFrame:UpdateSpacerFrameAnchoring()

	WorldMapFrame.NavBar = WorldMapFrame:AddOverlayFrame("TomCats_WorldMapNavBarTemplate", "FRAME");
	WorldMapFrame.NavBar:SetPoint("TOPLEFT", WorldMapFrame.TitleCanvasSpacerFrame, "TOPLEFT", 64, -25);
	WorldMapFrame.NavBar:SetPoint("BOTTOMRIGHT", WorldMapFrame.TitleCanvasSpacerFrame, "BOTTOMRIGHT", -4, 9);
	--WorldMapFrame.SidePanelToggle = WorldMapFrame:AddOverlayFrame("TomCats_WorldMapSidePanelToggleTemplate", "BUTTON", "BOTTOMRIGHT", WorldMapFrame:GetCanvasContainer(), "BOTTOMRIGHT", -2, 1);

	WorldMapFrame:SetupMinimizeMaximizeButton()

	_G.WorldMapContinentDropDown:Hide()
	_G.WorldMapZoneDropDown:Hide()
	_G.WorldMapZoneMinimapDropDown:Hide()
	_G.WorldMapZoomOutButton:Hide()
	_G.WorldMapMagnifyingGlassButton:Hide()
	_G.WorldMapContinentDropDown:SetParent(nil)
	_G.WorldMapZoneDropDown:SetParent(nil)
	_G.WorldMapZoneMinimapDropDown:SetParent(nil)
	_G.WorldMapZoomOutButton:SetParent(nil)
	_G.WorldMapMagnifyingGlassButton:SetParent(nil)

	WorldMapFrame.CloseButton = _G.WorldMapFrameCloseButton
	WorldMapFrame.CloseButton:ClearAllPoints()
	WorldMapFrame.CloseButton:SetPoint("TOPRIGHT", WorldMapFrame, "TOPRIGHT", 5.6, 5)
	WorldMapFrame.BorderFrame.MaximizeMinimizeFrame:ClearAllPoints()
	WorldMapFrame.BorderFrame.MaximizeMinimizeFrame:SetPoint("RIGHT", WorldMapFrame.CloseButton, "LEFT", 8.5, 0)
	if WorldMapFrame:ShouldBeMinimized() then
		WorldMapFrame:Minimize();
	else
		WorldMapFrame:Maximize();
	end
	for k in pairs(WorldMapFrame.dataProviders) do
		if (k.setAreaLabelCallback) then
			WorldMapFrame:RemoveDataProvider(k)
			WorldMapFrame:AddDataProvider(k)
			break;
		end
	end
	WorldMapFrame:AddDataProvider(CreateFromMixins(DungeonEntranceDataProviderMixin));
	WorldMapFrame:AddOverlayFrame("TomCats_WorldMapTrackingOptionsButtonTemplate", "DROPDOWNTOGGLEBUTTON", "TOPRIGHT", WorldMapFrame:GetCanvasContainer(), "TOPRIGHT", -4, -2);
end

local function OnEvent(event, arg1)
	if (event == "ADDON_LOADED") then
		if (addonName == arg1) then
			MergeWorldMapFrame()
		end
	end
end

addon.RegisterEvent("ADDON_LOADED", OnEvent)
