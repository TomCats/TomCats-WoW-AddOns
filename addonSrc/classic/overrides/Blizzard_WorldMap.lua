--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local function SetupWorldMapFrame()
	WorldMapFrame.CloseButton = WorldMapFrameCloseButton
	WorldMapFrame.CloseButton:ClearAllPoints()
	WorldMapFrame.CloseButton:SetPoint("TOPRIGHT", WorldMapFrame, "TOPRIGHT", 5.6, 5)
	WorldMapFrame.BorderFrame:SetParent(nil)
	WorldMapFrame.BorderFrame:Hide()
	WorldMapFrame.BorderFrame = CreateFrame("Frame", nil, WorldMapFrame, "WorldMapFrameBorderFrameTemplate")
	-- WorldMapFrame.BorderFrame.onCloseCallback = function() print("Closecallback") HideParentPanel(self) end; --todo: is this needed?
	WorldMapFrame:SetFrameStrata("MEDIUM")
	WorldMapContinentDropDown:Hide()
	WorldMapZoneDropDown:Hide()
	WorldMapZoneMinimapDropDown:Hide()
	WorldMapZoomOutButton:Hide()
	WorldMapMagnifyingGlassButton:Hide()
	WorldMapContinentDropDown:SetParent(nil)
	WorldMapZoneDropDown:SetParent(nil)
	WorldMapZoneMinimapDropDown:SetParent(nil)
	WorldMapZoomOutButton:SetParent(nil)
	WorldMapMagnifyingGlassButton:SetParent(nil)
	WorldMapFrame.TitleCanvasSpacerFrame = CreateFrame("Frame", nil, WorldMapFrame)
	WorldMapFrame.TitleCanvasSpacerFrame:SetPoint("TOPLEFT", 2, 0)
	WorldMapFrame.ScrollContainer:ClearAllPoints()
	WorldMapFrame.ScrollContainer:SetPoint("TOPLEFT", WorldMapFrame.TitleCanvasSpacerFrame, "BOTTOMLEFT", 0, 0)
	WorldMapFrame.ScrollContainer:SetPoint("BOTTOMLEFT", 0, 2)
	WorldMapFrame.ScrollContainer:SetPoint("RIGHT", WorldMapFrame.TitleCanvasSpacerFrame)
	WorldMapFrame.ScrollContainer:SetScript("OnLoad", MapCanvasScrollControllerMixin.OnLoad)
	WorldMapFrame.ScrollContainer:SetScript("OnMouseUp", MapCanvasScrollControllerMixin.OnMouseUp)
	WorldMapFrame.ScrollContainer:SetScript("OnMouseDown", MapCanvasScrollControllerMixin.OnMouseDown)
	WorldMapFrame.ScrollContainer:SetScript("OnMouseWheel", MapCanvasScrollControllerMixin.OnMouseWheel)
	WorldMapFrame.ScrollContainer:SetScript("OnHide", MapCanvasScrollControllerMixin.OnHide)
	WorldMapFrame.ScrollContainer:SetScript("OnUpdate", MapCanvasScrollControllerMixin.OnUpdate)
	for k, v in pairs(MapCanvasScrollControllerMixin) do
		if (type(v) == "function") then
			WorldMapFrame.ScrollContainer[k] = v
		end
	end
	WorldMapFrame.AddMaskableTexture = MapCanvasMixin.AddMaskableTexture
	WorldMapFrame.GetMaskTexture = MapCanvasMixin.GetMaskTexture
	WorldMapFrame.UpdateSpacerFrameAnchoring = WorldMapMixin.UpdateSpacerFrameAnchoring
	--WorldMapMixin:OnLoad(WorldMapFrame) --todo: handle everything in the OnLoad
	WorldMapFrame:ClearAllPoints()
	WorldMapFrame:SetPoint("TOP", UIParent, "TOP", 0, 0)
	WorldMapFrame:SetScript("OnShow", WorldMapMixin.OnShow)
	WorldMapFrame:SetScript("OnEvent", WorldMapMixin.OnEvent)
	WorldMapFrame:SetScript("OnHide", WorldMapMixin.OnHide)
	for k, v in pairs(QuestLogOwnerMixin) do
		if (type(v) == "function") then
			WorldMapFrame[k] = v
		end
	end
	for k, v in pairs(WorldMapMixin) do
		if (type(v) == "function") then
			WorldMapFrame[k] = v
		end
	end
	WorldMapFrame.NavBar = WorldMapFrame:AddOverlayFrame("TomCats_WorldMapNavBarTemplate", "FRAME");
	WorldMapFrame.NavBar:SetPoint("TOPLEFT", WorldMapFrame.TitleCanvasSpacerFrame, "TOPLEFT", 64, -25);
	WorldMapFrame.NavBar:SetPoint("BOTTOMRIGHT", WorldMapFrame.TitleCanvasSpacerFrame, "BOTTOMRIGHT", -4, 9);
	WorldMapFrame.SidePanelToggle = WorldMapFrame:AddOverlayFrame("TomCats_WorldMapSidePanelToggleTemplate", "BUTTON", "BOTTOMRIGHT", WorldMapFrame:GetCanvasContainer(), "BOTTOMRIGHT", -2, 1);
	UIPanelWindows["WorldMapFrame"].maximizePoint = "TOP"
	WorldMapMixin.OnLoad(WorldMapFrame)
	WorldMapFrame:SetIgnoreParentScale(false)
	WorldMapFrameBg:SetTexture(("Interface/AddOns/%s/images/374155.BLP"):format(addonName))
	QuestMapFrame.Background.SetAtlas = SetAtlas
	-- todo: the next line can be removed after we are sure that the player doesn't need the original questlog anymore
	getglobal("QuestLog_UpdateQuestDetails")()
end

local function OnEvent(event, arg1)
	if (event == "ADDON_LOADED") then
		if (addonName == arg1) then
			SetupWorldMapFrame()
		end
	end
end

RegisterEvent("ADDON_LOADED", OnEvent)
