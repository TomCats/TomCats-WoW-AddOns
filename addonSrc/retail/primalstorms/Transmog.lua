local addonName, addon = ...

local L = addon.PrimalStorms.L
local Names = addon.PrimalStorms.Names

local transmogVendorUI
local initialized = false
local ShowUI

local function IsStormVendor()
	local guid = UnitGUID("NPC")
	if (guid) then
		local creatureID = select(6, strsplit("-", guid))
		return creatureID and addon.PrimalStorms.StormVendors[tonumber(creatureID)]
	end
	return false
end

local function BuyItemFromVendor(itemID)
	local filter = GetMerchantFilter()
	SetMerchantFilter(LE_LOOT_FILTER_ALL)
	local itemCount = GetMerchantNumItems()
	for i = 1, itemCount do
		local itemLink = GetMerchantItemLink(i)
		local itemID_ = GetItemInfoFromHyperlink(itemLink)
		if (itemID_ == itemID) then
			BuyMerchantItem(i)
			break;
		end
	end
	SetMerchantFilter(filter)
end

local function AddItem()
	local itemLabel = transmogVendorUI:CreateFontString(nil, "ARTWORK", "GameFontWhite")
	itemLabel:SetJustifyH("LEFT")
	itemLabel:Hide()
	local idx = #transmogVendorUI.items + 1
	if (idx == 1) then
		itemLabel:SetPoint("TOPLEFT", transmogVendorUI, "TOPLEFT", 12 + 66, -32)
	else
		itemLabel:SetPoint("TOPLEFT", transmogVendorUI.items[idx - 1].itemLabel, "TOPLEFT", 0, -24)
	end
	itemLabel:EnableMouse(true)
	itemLabel:SetScript("OnEnter", function(self)
		local itemID = transmogVendorUI.items[idx].itemID
		if (itemID) then
			itemLabel:SetTextColor(1.0, 0.82, 0)
			EmbeddedItemTooltip:SetOwner(self, "ANCHOR_CURSOR_RIGHT", 30, 30)
			EmbeddedItemTooltip:SetItemByID(itemID)
			EmbeddedItemTooltip:Show()
		end
	end)
	itemLabel:SetScript("OnLeave", function(self)
		itemLabel:SetTextColor(1, 1, 1)
		EmbeddedItemTooltip:Hide()
	end)

	local button = CreateFrame("Button", nil, transmogVendorUI, "UIPanelButtonTemplate")
	button:SetPoint("RIGHT", itemLabel, "LEFT", -6, 0)
	button:SetSize(60, 20)
	button:SetScript("OnClick", function()
		for _, item in ipairs(transmogVendorUI.items) do
			item.button:Disable()
		end
		BuyItemFromVendor(transmogVendorUI.items[idx].itemID)
	end)
	button:Hide()
	transmogVendorUI.items[idx] = {
		itemLabel = itemLabel,
		button = button,
	}
end

local function OnUpdate(self)
	if (self.isDirty) then
		self.isDirty = false
		ShowUI()
	end
end

local function CreateUI()
	transmogVendorUI = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	transmogVendorUI.backdropInfo = {
		bgFile = "Interface\\Glues\\Common\\Glue-Tooltip-Background",
		edgeFile = "Interface\\Glues\\Common\\Glue-Tooltip-Border",
		tile = true,
		tileEdge = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 10, right = 5, top = 4, bottom = 9 },
	}
	transmogVendorUI.backdropColor = CreateColor(0.09, 0.09, 0.09)
	transmogVendorUI.backdropColorAlpha = 1.0
	transmogVendorUI.backdropBorderColor = CreateColor(0.8, 0.8, 0.8)
	transmogVendorUI:SetPoint("TOPLEFT", MerchantFrame, "TOPRIGHT", 16, 0)
	transmogVendorUI:SetWidth(400)
	transmogVendorUI:OnBackdropLoaded()
	transmogVendorUI.headerBar = transmogVendorUI:CreateTexture(nil, "BACKGROUND")
	transmogVendorUI.headerBar:SetDrawLayer("BACKGROUND", 2)
	transmogVendorUI.headerBar:SetColorTexture(0.25,0.25,0.25,1)
	transmogVendorUI.headerBar:SetHeight(18)
	transmogVendorUI.headerBar:SetPoint("TOPLEFT", transmogVendorUI, "TOPLEFT", 10, -5)
	transmogVendorUI.headerBar:SetPoint("RIGHT", transmogVendorUI, "RIGHT", -5, 0)
	transmogVendorUI.headerBar:SetAlpha(0.8)
	transmogVendorUI.headerBar:Show()
	transmogVendorUI.title = transmogVendorUI:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	transmogVendorUI.title:SetPoint("TOP", transmogVendorUI, "TOP", 0, -8)
	transmogVendorUI.title:SetText(WARDROBE)
	transmogVendorUI.icon = CreateFrame("Frame", nil, transmogVendorUI)
	transmogVendorUI.icon:SetSize(32, 32)
	transmogVendorUI.icon:SetPoint("TOPLEFT", transmogVendorUI, "TOPLEFT", -1, 3)
	transmogVendorUI.icon.Background = transmogVendorUI.icon:CreateTexture(nil, "ARTWORK")
	transmogVendorUI.icon.Background:SetSize(25, 25)
	transmogVendorUI.icon.Background:SetTexture("Interface/Minimap/UI-Minimap-Background")
	transmogVendorUI.icon.Background:SetPoint("TOPLEFT", transmogVendorUI.icon, "TOPLEFT", 3, -3)
	transmogVendorUI.icon.Background:SetVertexColor(1,1,1,0.6)
	transmogVendorUI.icon.Background:Show()
	transmogVendorUI.icon.logo = transmogVendorUI.icon:CreateTexture(nil, "ARTWORK")
	transmogVendorUI.icon.logo:SetDrawLayer("ARTWORK", 2)
	transmogVendorUI.icon.logo:SetTexture("Interface/AddOns/TomCats/images/tomcats_logo")
	transmogVendorUI.icon.logo:SetSize(20, 20)
	transmogVendorUI.icon.logo:SetPoint("TOPLEFT", 7, -6)
	transmogVendorUI.icon.logo:Show()
	transmogVendorUI.icon.Border = transmogVendorUI.icon:CreateTexture(nil, "OVERLAY")
	transmogVendorUI.icon.Border:SetSize(54, 54)
	transmogVendorUI.icon.Border:SetTexture("Interface/Minimap/MiniMap-TrackingBorder")
	transmogVendorUI.icon.Border:SetPoint("TOPLEFT")
	transmogVendorUI.icon.Border:SetDesaturated(1)
	transmogVendorUI.items = { }
	initialized = true
	transmogVendorUI:SetScript("OnUpdate", OnUpdate)
	transmogVendorUI:SetScript("OnEvent", function(self, event)
		transmogVendorUI.isDirty = true
	end)
	transmogVendorUI:RegisterEvent("TRANSMOG_COLLECTION_UPDATED")
end

local classNum = 1

function ShowUI()
	if (not initialized) then
		CreateUI()
	end
	local _, playerClass = UnitClass("Player")
	--local _, playerClass = GetClassInfo(classNum)
	--classNum = classNum + 1
	--if (classNum == 13) then classNum = 1 end
	--print(playerClass)
	local idx = 0
	local maxWidth = 0
	local currencyOwned = GetItemCount(199211, true)
	for _, transmogItem in ipairs(addon.PrimalStorms.TransmogItems) do
		if (addon.PrimalStorms.PlayerClassItemTypes[playerClass][transmogItem[2]] ) then
			idx = idx + 1
			if (not transmogVendorUI.items[idx]) then
				AddItem()
			end
			local itemName = Names.GetItemName(transmogItem[1])
			if (itemName == "...") then
				transmogVendorUI.isDirty = true
			end
			transmogVendorUI.items[idx].itemLabel:SetText(itemName)
			local hasTransmog = C_TransmogCollection.PlayerHasTransmogByItemInfo(transmogItem[1])
			transmogVendorUI.items[idx].itemLabel:SetAlpha( hasTransmog and 0.5 or 1.0)
			transmogVendorUI.items[idx].itemLabel:Show()
			transmogVendorUI.items[idx].itemID = transmogItem[1]
			if (not hasTransmog) then
				transmogVendorUI.items[idx].button:SetText(("%d |TInterface/icons/Inv_enchant_essencecosmicgreater:12:12:0:-1:64:64:4:60:4:60|t"):format(transmogItem[3]))
				transmogVendorUI.items[idx].button:SetAlpha(1.0)
				if (currencyOwned >= transmogItem[3]) then
					transmogVendorUI.items[idx].button:Enable()
				else
					transmogVendorUI.items[idx].button:Disable()
				end
			else
				transmogVendorUI.items[idx].button:SetText("|A:Capacitance-General-WorkOrderCheckmark:16:16|a")
				transmogVendorUI.items[idx].button:SetAlpha(0.5)
				transmogVendorUI.items[idx].button:Disable()
			end
			transmogVendorUI.items[idx].button:Show()
			maxWidth = math.max(maxWidth, transmogVendorUI.items[idx].itemLabel:GetStringWidth())
		end
	end
	transmogVendorUI:SetSize(maxWidth + 90, idx * 24 + 40)
	transmogVendorUI:Show()
end

local function HideUI()
	if (transmogVendorUI) then
		transmogVendorUI:SetShown(false)
		for _, item in ipairs(transmogVendorUI.items) do
			item.itemLabel:Hide()
			item.button:Hide()
		end
	end
end

MerchantFrame:HookScript("OnShow", function() if (IsStormVendor()) then ShowUI() end end)
MerchantFrame:HookScript("OnHide", function() HideUI() end)
