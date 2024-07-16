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

local filterMenu

local function GetFilterMenu()
	if (not filterMenu) then
		filterMenu = {
			{
				text = "Collected",
				hasArrow = false,
				checked = function()
					return CollectionTrackerService.GetFilterOption("collected")
				end,
				func = function()
					CollectionTrackerService.ToggleFilterOption("collected")
				end
			},
			{
				text = "Not Collected",
				hasArrow = false,
				checked = function()
					return CollectionTrackerService.GetFilterOption("notCollected")
				end,
				func = function()
					CollectionTrackerService.ToggleFilterOption("notCollected")
				end
			},
			{
				text = "",
				hasArrow = false,
				notCheckable = true,
			},
			{
				text = "Type",
				isTitle = true,
				notCheckable = true,
			},
			{
				text = "Mounts",
				hasArrow = false,
				checked = function()
					return CollectionTrackerService.GetFilterOption("mounts")
				end,
				func = function()
					CollectionTrackerService.ToggleFilterOption("mounts")
				end
			},
			{
				text = "Pets",
				hasArrow = false,
				checked = function()
					return CollectionTrackerService.GetFilterOption("pets")
				end,
				func = function()
					CollectionTrackerService.ToggleFilterOption("pets")
				end
			},
			{
				text = "Toys",
				hasArrow = false,
				checked = function()
					return CollectionTrackerService.GetFilterOption("toys")
				end,
				func = function()
					CollectionTrackerService.ToggleFilterOption("toys")
				end				},
			{
				text = "Appearances",
				hasArrow = false,
				checked = function()
					return CollectionTrackerService.GetFilterOption("appearances")
				end,
				func = function()
					CollectionTrackerService.ToggleFilterOption("appearances")
				end
			},
			{
				text = "Heirlooms",
				hasArrow = false,
				checked = function()
					return CollectionTrackerService.GetFilterOption("heirlooms")
				end,
				func = function()
					CollectionTrackerService.ToggleFilterOption("heirlooms")
				end
			},
			{
				text = "",
				hasArrow = false,
				notCheckable = true,
			},
			{
				text = "Source",
				isTitle = true,
				notCheckable = true,
			},
			{
				text = "Vendor",
				hasArrow = false,
				checked = function()
					return CollectionTrackerService.GetFilterOption("vendor")
				end,
				func = function()
					CollectionTrackerService.ToggleFilterOption("vendor")
				end
			},
			{
				text = "Achievement",
				hasArrow = false,
				checked = function()
					return CollectionTrackerService.GetFilterOption("achievement")
				end,
				func = function()
					CollectionTrackerService.ToggleFilterOption("achievement")
				end
			}
		}
	end
	return filterMenu
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
			ScrollBox:SetPoint("TOPLEFT", OSD.headerBar, "BOTTOMLEFT", 0, -36)
			ScrollBox:SetPoint("BOTTOMRIGHT", OSD.footerBar, "TOPRIGHT", -24, 4)
			local ScrollBar = CreateFrame("EventFrame", nil, OSD, "MinimalScrollBar")
			OSD.ScrollBar = ScrollBar
			--ScrollBar:SetFrameStrata("HIGH")
			ScrollBar:SetPoint("TOPLEFT", ScrollBox, "TOPRIGHT", 8, 32)
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
			OSD.filterButton = CreateFrame("Button", nil, OSD, "UIMenuButtonStretchTemplate")
			OSD.filterButton:SetSize(93, 24)
			OSD.filterButton.Icon = OSD.filterButton:CreateTexture(nil, "ARTWORK")
			OSD.filterButton.Icon:SetTexture("Interface\\ChatFrame\\ChatFrameExpandArrow")
			OSD.filterButton.Icon:SetSize(10, 12)
			OSD.filterButton.Icon:SetPoint("RIGHT", -5, 0)
			OSD.filterButton:SetPoint("TOPRIGHT", OSD.headerBar, "BOTTOMRIGHT", -24, -6)
			OSD.filterButton.Text:SetText("Filter")
			local filterMenu = TieredMenu.CreateMenu(OSD)
			OSD.filterButton:SetScript("OnClick", function()
				if (filterMenu:IsShown()) then
					filterMenu:Display(false)
				else
					filterMenu:Display(GetFilterMenu(), "TOPLEFT", OSD.filterButton, "TOPRIGHT", -12, -4)
				end
			end)
			OSD.searchBox = CreateFrame("EditBox", nil, OSD, "SearchBoxTemplate")
			OSD.searchBox:SetSize(112, 20)
			OSD.searchBox:SetMaxLetters(40)
			OSD.searchBox:SetPoint("TOPLEFT", OSD.headerBar, "BOTTOMLEFT", 12, -8)
			OSD.searchBox:SetScript("OnTextChanged", function(self)
				SearchBoxTemplate_OnTextChanged(self)
				CollectionTrackerService.SetSearchText(self:GetText())
			end)
		end
		OSD.ScrollBox:SetDataProvider(CollectionTrackerService.GetDataProvider(), ScrollBoxConstants.RetainScrollPosition);
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
