--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("mopremix")

local OSD
local lastAtMerchant = false

local component = {
	Name = "CollectionTrackerUI"
}

local filterMenu
local itemButtons

local function BuyItemFromVendor(itemID)
	local filter = GetMerchantFilter()
	SetMerchantFilter(LE_LOOT_FILTER_ALL)
	local itemCount = GetMerchantNumItems()
	for i = 1, itemCount do
		local itemID_ = GetMerchantItemID(i)
		if (itemID_ == itemID) then
			BuyMerchantItem(i)
			break;
		end
	end
	SetMerchantFilter(filter)
end

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
			},
			{
				text = "",
				hasArrow = false,
				notCheckable = true,
			},
			{
				text = "Lock Window",
				hasArrow = false,
				checked = function()
					return TomCats_Account.mopremix.collectionTracker.locked and true or false
				end,
				func = function()
					TomCats_Account.mopremix.collectionTracker.locked = not TomCats_Account.mopremix.collectionTracker.locked
					OSD.isLocked = TomCats_Account.mopremix.collectionTracker.locked
				end
			},
		}
	end
	return filterMenu
end

function component.Init()
	if (component.IsDisplayed() and not OSD) then
		itemButtons = { }
		OSD = Templates.CreateBasicWindow(
				UIParent,
				{
					icon = ImagePNG.tomcats_minimap_icon,
					prefs = TomCats_Account.mopremix.collectionTracker,
					minimizable = true,
					iconEnterFunc = function(self)
						if (TomCats_Account.mopremix.collectionTracker.minimized) then
							GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
							GameTooltip:ClearLines()
							GameTooltip:AddLine("TomCat's Tours\nRemix Collection Tracker", nil, nil, nil, true)
							GameTooltip:AddLine("\n(Click to open)", 1, 1, 1, true)
							GameTooltip:Show()
						end
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
		OSD.isLocked = TomCats_Account.mopremix.collectionTracker.locked
		OSD.title:SetText("Remix Collection Tracker")
		local settingsButton = CreateFrame("Button", nil, OSD)
		settingsButton:SetSize(16, 16)
		settingsButton:SetNormalTexture(ImagePNG.Gear_64)
		settingsButton:GetNormalTexture():SetTexCoord(0, 0.5, 0.5, 1)
		settingsButton:SetPushedTexture(ImagePNG.Gear_64)
		settingsButton:GetPushedTexture():SetTexCoord(0, 0.5, 0, 0.5)
		settingsButton:SetHighlightTexture(ImagePNG.Gear_64)
		settingsButton:GetHighlightTexture():SetAlpha(0.25)
		settingsButton:GetHighlightTexture():SetTexCoord(0.5, 1, 0.5, 1)
		settingsButton:SetScript("OnMouseDown", function()
			settingsButton:GetHighlightTexture():SetTexCoord(0.5, 1, 0, 0.5)
		end)
		settingsButton:SetScript("OnMouseUp", function()
			settingsButton:GetHighlightTexture():SetTexCoord(0.5, 1, 0.5, 1)
		end)
		settingsButton:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
			GameTooltip:AddLine("Settings", 1, 1, 1, true)
			GameTooltip:Show()
		end)
		settingsButton:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
		settingsButton:SetPoint("TOPRIGHT", -6.5, -6.5)
		local filterMenu = TieredMenu.CreateMenu(OSD)
		settingsButton:SetScript("OnClick", function()
			if (filterMenu:IsShown()) then
				filterMenu:Display(false)
			else
				filterMenu:Display(GetFilterMenu(), "TOPRIGHT", settingsButton, "BOTTOMRIGHT", 0, 0)
			end
		end)
		local minimizeButton = CreateFrame("Button", nil, OSD)
		minimizeButton:SetSize(16, 16)
		minimizeButton:SetNormalTexture(ImagePNG.Minimize_64)
		minimizeButton:GetNormalTexture():SetTexCoord(0, 0.5, 0.5, 1)
		minimizeButton:SetPushedTexture(ImagePNG.Minimize_64)
		minimizeButton:GetPushedTexture():SetTexCoord(0, 0.5, 0, 0.5)
		minimizeButton:SetHighlightTexture(ImagePNG.Minimize_64)
		minimizeButton:GetHighlightTexture():SetAlpha(0.25)
		minimizeButton:GetHighlightTexture():SetTexCoord(0.5, 1, 0.5, 1)
		minimizeButton:SetPoint("RIGHT", settingsButton, "LEFT", 0, 0)
		minimizeButton:SetScript("OnMouseDown", function()
			minimizeButton:GetHighlightTexture():SetTexCoord(0.5, 1, 0, 0.5)
		end)
		minimizeButton:SetScript("OnMouseUp", function()
			minimizeButton:GetHighlightTexture():SetTexCoord(0.5, 1, 0.5, 1)
		end)
		minimizeButton:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
			GameTooltip:AddLine("Minimize", 1, 1, 1, true)
			GameTooltip:Show()
		end)
		minimizeButton:SetScript("OnLeave", function()
			GameTooltip:Hide()
		end)
		minimizeButton:SetScript("OnClick", function()
			OSD:Minimize()
		end)
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function()
			local owner = GameTooltip:GetOwner()
			if (owner and itemButtons[owner]) then
				GameTooltip:AddLine(string.format("\nSource: %s", CollectionTrackerService.GetSourceForItem(owner.collectionItem)))
				if (owner.collectionItem.vendorNPC) then
					if (owner.collectionItem.bonesCost) then
						GameTooltip:AddLine(string.format("Cost: %s Bronze + %s Bones", owner.collectionItem.bronzeCost, owner.collectionItem.bonesCost))
					else
						GameTooltip:AddLine(string.format("Cost: %s Bronze", owner.collectionItem.bronzeCost))
					end
				end
				if (owner.collectionItem.collected) then
					GameTooltip:AddLine("Collected: Yes")
				else
					GameTooltip:AddLine("Collected: No")
					if (owner.collectionItem.type == COLLECTION_ITEM_TYPE.TRANSMOG) then
						GameTooltip:AddLine("(Missing one or more appearance sources)")
					end
				end
			end
		end)
	end
end

function component.Refresh()
	component.dirty = false
	if (CollectionTrackerService.IsInitialized()) then
		OSD.loading:Hide()
		if (not OSD.ScrollBox) then
			OSD:SetSize(260,450)
			local ScrollBox = CreateFrame("Frame", nil, OSD, "WowScrollBoxList")
			OSD.ScrollBox = ScrollBox
			--ScrollBox:SetFrameStrata("HIGH")
			ScrollBox:SetPoint("TOPLEFT", OSD.headerBar, "BOTTOMLEFT", 4, -36)
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
					itemButtons[button] = true
					button:SetSize(100, 40)
					button.label = button:CreateFontString(nil, "ARTWORK", "GameFontWhite")
					button.label:SetPoint("TOPLEFT", 4, -4)
					button.label:SetPoint("BOTTOMRIGHT", -4, 4)
					local topBorder = button:CreateTexture(nil, "BACKGROUND")
					topBorder:SetColorTexture(0.2,0.2,0.2,0.3)
					topBorder:SetPoint("TOPLEFT", 0, -1)
					topBorder:SetPoint("BOTTOMRIGHT", 0, 1)
					button.initialized = true
					button.label:SetWordWrap(true)
					button:RegisterForClicks("AnyUp")
					button:SetScript("OnEnter", function(self)
						if (CollectionTrackerService.IsAtMerchant() and not self.collectionItem.collected) then
							SetCursor("BUY_CURSOR")
						end
						GameTooltip:SetOwner(self, "ANCHOR_NONE")
						if (ScreenSide.GetCurrentSide(OSD) == SCREEN_RIGHT) then
							GameTooltip:SetPoint("RIGHT", self, "LEFT")
						else
							GameTooltip:SetPoint("LEFT", self, "RIGHT")
						end
						GameTooltip:SetItemByID(self.collectionItem.itemID)
						GameTooltip:Show()
					end)
					button:SetScript("OnLeave", function()
						ResetCursor()
						GameTooltip:Hide()
					end)
					button:SetScript("OnClick", function(self)
						if (not self.collectionItem.collected) then
							BuyItemFromVendor(self.collectionItem.itemID)
						end
					end)
				end
				button.collectionItem = elementData
				local color = elementData.collected and "FF00FF00" or "FFFFFFFF"
				button.label:SetText(string.format("|c%s%s|r", color, elementData.name))
			end);
			view:SetPadding(0,0,0,0,0);
			ScrollUtil.InitScrollBoxListWithScrollBar(ScrollBox, ScrollBar, view);
			OSD.searchBox = CreateFrame("EditBox", nil, OSD, "SearchBoxTemplate")
			OSD.searchBox:SetSize(210, 20)
			OSD.searchBox:SetMaxLetters(40)
			OSD.searchBox:SetPoint("TOPLEFT", OSD.headerBar, "BOTTOMLEFT", 12, -8)
			OSD.searchBox:SetScript("OnTextChanged", function(self)
				SearchBoxTemplate_OnTextChanged(self)
				CollectionTrackerService.SetSearchText(self:GetText())
			end)
			OSD.footerBarText = OSD:CreateFontString(nil, "ARTWORK", "GameFontNormal")
			OSD.footerBarText:SetPoint("TOP", OSD.footerBar, "TOP", 0, -1)
		end
		OSD.ScrollBox:SetDataProvider(CollectionTrackerService.GetDataProvider(), ScrollBoxConstants.RetainScrollPosition);
		local isAtMerchant = CollectionTrackerService.IsAtMerchant()
		if (not lastAtMerchant == isAtMerchant) then
			lastAtMerchant = isAtMerchant
			if (isAtMerchant) then
				OSD.isLocked = true
				OSD:ClearAllPoints()
				OSD:SetPoint("TOPLEFT", MerchantFrame, "TOPRIGHT", 12, 0)
				OSD.footerBarText:SetText("Showing Merchant's Items Only!")
			else
				OSD.isLocked = TomCats_Account.mopremix.collectionTracker.locked
				OSD:ClearAllPoints()
				OSD:SetPoint(unpack(TomCats_Account.mopremix.collectionTracker.WindowLocation))
			end
		end
		if (not isAtMerchant) then
			OSD.footerBarText:SetText(string.format("%s/%s Collected (%s Shown)", CollectionTrackerService.GetTotals()))
		end
	end
end

function component.SetDisplayed(displayed)
	TomCats_Account.mopremix.collectionTrackerDisplay = displayed
	component.Init()
	if (OSD) then
		OSD:Maximize()
		OSD:SetShown(displayed)
	end
	if (displayed) then
		CollectionTrackerService.Init()
	end
end

function component.IsDisplayed()
	return TomCats_Account.mopremix.collectionTrackerDisplay
end

function component.MarkDirty()
	component.dirty = true
end

local scrollPosition

function component.PreserveScrollPosition()
	if (OSD and OSD.ScrollBar) then
		scrollPosition = OSD.ScrollBar:GetScrollPercentage()
	end
end

function component.RestoreScrollPosition()
	if (OSD and OSD.ScrollBar and scrollPosition) then
		OSD.ScrollBar:SetScrollPercentage(scrollPosition, true)
	end
end

function component.UpdateLoadingPercentage(percentage)
	OSD.loading:SetText(string.format("Loading %s%%", math.floor(percentage * 100)))
end

AddComponent(component)

CollectionTrackerUI = component
