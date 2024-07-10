--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("mopremix")

local OSD

local component = {
	Name = "CollectionTrackerUI"
}

function component.Init()
	if (component.IsDisplayed() and not OSD) then
		OSD = Templates.CreateBasicWindow(
				UIParent,
				{
					icon = ImagePNG.tomcats_minimap_icon,
					prefs = TomCats_Account.mopremix.collectionTracker,
					minimizable = true,
					iconEnterFunc = function(self)
						GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
						GameTooltip:ClearLines()
						GameTooltip:AddLine("TomCat's Tours\nRemix Collection Tracker", nil, nil, nil, true)
						GameTooltip:AddLine("\nEnjoy the work in progress and download updates regularly to find new features!", 1, 1, 1, true)
						GameTooltip:AddLine("\nIf you have questions or feedback, visit me on Twitch or Discord!", 1, 1, 1, true)
						GameTooltip:AddLine("\nDouble-click to toggle", 1, 1, 1, true)
						GameTooltip:Show()
					end,
					iconLeaveFunc = function()
						GameTooltip:Hide()
					end,
					onMinimizeFunc = function()
						-- stop refreshing until maximized again
					end,
					onMaximizeFunc = function()
						CollectionTrackerService.Init()
					end
				}
		)
		OSD.loading = OSD:CreateFontString(nil, "ARTWORK", "GameFontWhite")
		OSD.loading:SetText("Loading")
		OSD.loading:SetPoint("TOPLEFT", 16, -30)
		OSD.loading:SetPoint("TOPRIGHT", -16, -30)
		OSD.loading:SetPoint("BOTTOM", OSD.footerBar, "TOP", 0, 4)
		OSD.loading:SetWordWrap(true)
		OSD:SetSize(260,100)
		OSD.title:SetText("Remix Collection Tracker")
	end
end

function component.Refresh()
	component.dirty = false
	if (CollectionTrackerService.IsInitialized()) then
		OSD.loading:Hide()
		if (not OSD.ScrollBox) then
			OSD:SetSize(260,500)
			local ScrollBox = CreateFrame("Frame", nil, OSD, "WowScrollBoxList")
			OSD.ScrollBox = ScrollBox
			--ScrollBox:SetFrameStrata("HIGH")
			ScrollBox:SetPoint("TOPLEFT", OSD.headerBar, "BOTTOMLEFT", 0, -4)
			ScrollBox:SetPoint("BOTTOMRIGHT", OSD.footerBar, "TOPRIGHT", -24, 4)
			local ScrollBar = CreateFrame("EventFrame", nil, OSD, "MinimalScrollBar")
			OSD.ScrollBar = ScrollBar
			--ScrollBar:SetFrameStrata("HIGH")
			ScrollBar:SetPoint("TOPLEFT", ScrollBox, "TOPRIGHT", 8, 0)
			ScrollBar:SetPoint("BOTTOMLEFT", ScrollBox, "BOTTOMRIGHT", 8, 0)
			local view = CreateScrollBoxListLinearView();
			view:SetElementExtent(40)
			view:SetElementInitializer("Button", function(button, elementData)
				if (not button.initialized) then
					button:SetSize(100, 40)
					button.label = button:CreateFontString(nil, "ARTWORK", "GameFontWhite")
					button.label:SetPoint("TOPLEFT", 4, -4)
					button.label:SetPoint("BOTTOMRIGHT", -4, 4)
					local topBorder = button:CreateTexture(nil, "BACKGROUND")
					topBorder:SetColorTexture(1,0,0,1)
					topBorder:SetHeight(1)
					topBorder:SetPoint("TOPLEFT")
					topBorder:SetPoint("TOPRIGHT")
					local bottomBorder = button:CreateTexture(nil, "BACKGROUND")
					bottomBorder:SetColorTexture(0,0,1,1)
					bottomBorder:SetHeight(1)
					bottomBorder:SetPoint("BOTTOMLEFT")
					bottomBorder:SetPoint("BOTTOMRIGHT")
					button.initialized = true
					button.label:SetWordWrap(true)
				end
				local color = elementData.collected and "FF00FF00" or "FFFFFFFF"
				button.label:SetText(string.format("|c%s%s|r", color, elementData.name))
			end);
			view:SetPadding(0,0,0,0,0);
			ScrollUtil.InitScrollBoxListWithScrollBar(ScrollBox, ScrollBar, view);
		--			<Frame parentKey="ScrollBox" inherits="WowScrollBoxList" frameStrata="HIGH">
		--	<Anchors>
		--<Anchor point="TOPLEFT" relativeKey="$parent.LeftInset" x="3" y="-36"/>
		--<Anchor point="BOTTOMRIGHT" relativeKey="$parent.LeftInset" x="-2" y="3"/>
		--</Anchors>
		--</Frame>
		--
		--<EventFrame parentKey="ScrollBar" inherits="MinimalScrollBar" frameStrata="HIGH">
		--<Anchors>
		--<Anchor point="TOPLEFT" relativeKey="$parent.ScrollBox" relativePoint="TOPRIGHT" x="8" y="31"/>
		--<Anchor point="BOTTOMLEFT" relativeKey="$parent.ScrollBox" relativePoint="BOTTOMRIGHT" x="8" y="-1"/>
		--</Anchors>
		--</EventFrame>
		end
		OSD.ScrollBox:SetDataProvider(CollectionTrackerService.GetDataProvider(), ScrollBoxConstants.RetainScrollPosition);

		--local newDataProvider = CreateDataProvider()
		--for _, collectionItem in ipairs(CollectionItems) do
		--	newDataProvider:Insert(collectionItem);
		--end
		--OSD.ScrollBox:SetDataProvider(newDataProvider, ScrollBoxConstants.RetainScrollPosition);
	end
end

function component.SetDisplayed(displayed)
	TomCats_Account.mopremix.collectionTrackerDisplay = displayed
	component.Init()
	if (OSD) then
		OSD:SetShown(displayed)
	end
end

function component.IsDisplayed()
	return TomCats_Account.mopremix.collectionTrackerDisplay
end

function component.MarkDirty()
	component.dirty = true
end

AddComponent(component)

CollectionTrackerUI = component
