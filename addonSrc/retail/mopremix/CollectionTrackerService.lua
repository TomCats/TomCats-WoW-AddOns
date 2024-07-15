--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("mopremix")

local initialized = false
local initializing = false
local collectionItemsLUT
local itemsByModifiedAppearanceID
local itemsByMountID
local eventFrame
local dataProvider
local vendorNPCs
local currentFilter
local lastFilter

local itemLoadingTracker = {
	remaining = 0,
	itemIDs = {	},
	Add = function(self, itemID)
		if (not self.itemIDs[itemID]) then
			self.itemIDs[itemID] = true
			self.remaining = self.remaining + 1
		end
	end,
	Remove = function(self, itemID)
		if (self.itemIDs[itemID]) then
			self.itemIDs[itemID] = nil
			self.remaining = self.remaining - 1
		end
	end,
	IsEmpty = function(self)
		return self.remaining == 0
	end
}

local function RefreshEnsembleItem(collectionItem)
	local appearances = C_Transmog.GetAllSetAppearancesByID(collectionItem.setID)
	local appearanceIDs = { }
	collectionItem.hasAllSources = true
	for _, appearance in ipairs(appearances) do
		local _, appearanceID, _, _, isCollected = C_TransmogCollection.GetAppearanceSourceInfo(appearance.itemModifiedAppearanceID)
		if (not isCollected) then
			collectionItem.hasAllSources = false
		end
		appearanceIDs[appearanceID] = isCollected or appearanceIDs[appearanceID] or false
	end
	collectionItem.hasAllAppearances = true
	for _, appearanceID in pairs(appearanceIDs) do
		if (not appearanceID) then
			collectionItem.hasAllAppearances = false
			break
		end
	end
	collectionItem.collected = collectionItem.hasAllSources
end

local function SetupEnsembleItem(collectionItem, setID)
	collectionItem.setID = setID
	collectionItem.type = COLLECTION_ITEM_TYPE.TRANSMOG
	local setInfo = C_TransmogSets.GetSetInfo(setID)
	if (setInfo.description) then
		collectionItem.name = string.format("%s (%s)", setInfo.name, setInfo.description)
	else
		collectionItem.name = setInfo.name
	end
	RefreshEnsembleItem(collectionItem)
end

local function RefreshToy(itemID)
	local collectionItem = collectionItemsLUT[itemID]
	if (collectionItem) then
		collectionItem.collected = PlayerHasToy(itemID)
	end
end

local function SetupToy(collectionItem)
	collectionItem.type = COLLECTION_ITEM_TYPE.TOY
	RefreshToy(collectionItem.itemID)
end

local function RefreshMount(mountID)
	local collectionItem = itemsByMountID[mountID]
	if (collectionItem) then
		collectionItem.collected = true
	end
end

local function SetupMount(collectionItem)
	collectionItem.mountID = C_MountJournal.GetMountFromItem(collectionItem.itemID)
	itemsByMountID[collectionItem.mountID] = collectionItem
	local name, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(collectionItem.mountID)
	collectionItem.name = name
	collectionItem.type = COLLECTION_ITEM_TYPE.MOUNT
	collectionItem.collected = isCollected
end

local function RefreshHeirloom(itemID)
	local collectionItem = collectionItemsLUT[itemID]
	if (collectionItem) then
		collectionItem.collected = C_Heirloom.PlayerHasHeirloom(itemID)
	end
end

local function SetupHeirloom(collectionItem)
	collectionItem.type = COLLECTION_ITEM_TYPE.HEIRLOOM
	RefreshHeirloom(collectionItem.itemID)
end

local function RefreshEquipmentItem(collectionItem)
	local _, _, _, _, isCollected = C_TransmogCollection.GetAppearanceSourceInfo(collectionItem.itemModifiedAppearanceID)
	collectionItem.collected = isCollected
end

local function SetupEquipmentItem(collectionItem, itemModifiedAppearanceID)
	collectionItem.itemModifiedAppearanceID = itemModifiedAppearanceID
	collectionItem.type = COLLECTION_ITEM_TYPE.EQUIPMENT
	RefreshEquipmentItem(collectionItem)
end


local function HandleItemDataLoad(itemID, success)
	local collectionItem = collectionItemsLUT[itemID]
	if (collectionItem and not collectionItem.loaded) then
		if (success) then
			itemLoadingTracker:Remove(itemID)
			collectionItem.loaded = true
			local itemName, _, _, _, _, _, _, _, _, _, _, classID, subclassID = C_Item.GetItemInfo(itemID)
			collectionItem.name = itemName
			if (classID == Enum.ItemClass.Miscellaneous and subclassID == Enum.ItemMiscellaneousSubclass.Mount) then
				SetupMount(collectionItem)
			else
				local setID = C_Item.GetItemLearnTransmogSet(itemID)
				if (setID) then
					SetupEnsembleItem(collectionItem, setID)
				else
					local _, name = C_ToyBox.GetToyInfo(itemID)
					if (name) then
						collectionItem.name = name
						SetupToy(collectionItem)
					else
						if (C_Heirloom.IsItemHeirloom(itemID)) then
							SetupHeirloom(collectionItem)
						else
							local itemAppearanceID, itemModifiedAppearanceID = C_TransmogCollection.GetItemInfo(itemID)
							if (itemAppearanceID) then
								SetupEquipmentItem(collectionItem, itemModifiedAppearanceID)
							else
								print("Info not loaded for:", collectionItem.name)
							end
						end
					end
				end
			end
			if (itemLoadingTracker:IsEmpty()) then
				initializing = false
				initialized = true
				CollectionTrackerUI.MarkDirty()
				eventFrame:UnregisterEvent("ITEM_DATA_LOAD_RESULT")
			end
		else
			C_Timer.NewTimer(60, function()
				C_Item.RequestLoadItemDataByID(itemID)
			end)
		end
	end
end

local function OnEvent(_, event, arg1, arg2)
	if (event == "ITEM_DATA_LOAD_RESULT") then
		HandleItemDataLoad(arg1, arg2)
	elseif (event == "TRANSMOG_SEARCH_UPDATED") then
		for _, collectionItem in ipairs(CollectionItems) do
			if (collectionItem.type == COLLECTION_ITEM_TYPE.TRANSMOG) then
				RefreshEnsembleItem(collectionItem)
			elseif (collectionItem.type == COLLECTION_ITEM_TYPE.EQUIPMENT) then
				RefreshEquipmentItem(collectionItem)
			end
		end
		CollectionTrackerUI.MarkDirty()
	elseif (event == "NEW_MOUNT_ADDED") then
		RefreshMount(arg1)
		CollectionTrackerUI.MarkDirty()
	elseif (event == "NEW_TOY_ADDED") then
		RefreshToy(arg1)
		CollectionTrackerUI.MarkDirty()
	elseif (event == "HEIRLOOMS_UPDATED") then
		RefreshHeirloom()
	elseif (event == "MERCHANT_SHOW") then
		if (initialized) then
			local guid = UnitGUID("npc")
			if (guid) then
				local unitType, _, _, _, _, npcID = strsplit("-", guid)
				if (unitType == "Creature") then
					npcID = tonumber(npcID)
					if (vendorNPCs[npcID]) then
						CollectionTrackerService.SetFilter(COLLECTION_TRACKER_FILTER.VENDOR, npcID)
					end
				end
			end
		end
	elseif (event == "MERCHANT_CLOSED") then
		if (initialized) then
			CollectionTrackerService.SetFilter(COLLECTION_TRACKER_FILTER.NONE)
		end
	end
end

CollectionTrackerService = { }

function CollectionTrackerService.Init()
	if (not initialized and not initializing) then
		initializing = true
		collectionItemsLUT = { }
		itemsByModifiedAppearanceID = { }
		itemsByMountID = { }
		illusionSpellItemLUT = { }
		eventFrame = CreateFrame("Frame")
		eventFrame:RegisterEvent("ITEM_DATA_LOAD_RESULT")
		--eventFrame:RegisterEvent("TRANSMOG_COLLECTION_SOURCE_ADDED")
		eventFrame:RegisterEvent("TRANSMOG_SEARCH_UPDATED")
		eventFrame:RegisterEvent("MERCHANT_SHOW")
		eventFrame:RegisterEvent("MERCHANT_CLOSED")
		eventFrame:RegisterEvent("NEW_MOUNT_ADDED")
		eventFrame:RegisterEvent("NEW_TOY_ADDED")
		eventFrame:RegisterEvent("HEIRLOOMS_UPDATED")
		eventFrame:SetScript("OnEvent", OnEvent)
		for _, collectionItem in ipairs(CollectionItems) do
			setmetatable(collectionItem, CollectionItemsMetatable)
			collectionItemsLUT[collectionItem.itemID] = collectionItem
			itemLoadingTracker:Add(collectionItem.itemID)
			vendorNPCs[collectionItem.vendorNPC] = true
		end
		for _, collectionItem in ipairs(CollectionItems) do
			C_Item.RequestLoadItemDataByID(collectionItem.itemID)
		end
	end
end

function CollectionTrackerService.GetDataProvider()
	if (not dataProvider) then
		dataProvider = CreateDataProvider();
		dataProvider:SetSortComparator(function(a, b)
			return a.name < b.name
		end, true)
		CollectionTrackerService.SetFilter(COLLECTION_TRACKER_FILTER.NONE)
	end
	return dataProvider
end

function CollectionTrackerService.SetFilter(filter, arg1)
	dataProvider:Flush()
	if (filter == COLLECTION_TRACKER_FILTER.NONE) then
		dataProvider:InsertTable(CollectionItems)
		lastFilter = COLLECTION_TRACKER_FILTER.NONE
	elseif (filter == COLLECTION_TRACKER_FILTER.VENDOR) then
		lastFilter = currentFilter
		local vendorItems = { }
		for _, collectionItem in ipairs(CollectionItems) do
			if (collectionItem.vendorNPC == arg1) then
				table.insert(vendorItems, collectionItem)
			end
		end
		dataProvider:InsertTable(vendorItems)
	end
	currentFilter = COLLECTION_TRACKER_FILTER.NONE
end

function CollectionTrackerService.IsInitialized()
	return initialized
end

COLLECTION_TRACKER_FILTER = {
	NONE = 0,
	VENDOR = 1,
}
