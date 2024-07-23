--[[ See license.txt for license and copyright information ]]
local _, addon = ...

local C_Item = C_Item
local C_MountJournal = C_MountJournal
local C_PetJournal = C_PetJournal
local C_ToyBox = C_ToyBox
local GetItemInfo = C_Item.GetItemInfo
local PlayerHasToy = PlayerHasToy
local ITEM_SPELL_KNOWN = ITEM_SPELL_KNOWN
local LE_ITEM_CLASS_MISCELLANEOUS = Enum.ItemClass.Miscellaneous
local LE_ITEM_MISCELLANEOUS_COMPANION_PET = Enum.ItemMiscellaneousSubclass.CompanionPet
local LE_ITEM_MISCELLANEOUS_MOUNT = Enum.ItemMiscellaneousSubclass.Mount

local KNOWN = "|cffff2020" .. ITEM_SPELL_KNOWN .. "|r"
local LOOT_TYPE = addon.constants.lootTypes

function addon.getLootDisplayInfo(items)
	local loot = { }
	if (items) then
		for i = 1, #items do
			local itemID = items[i]
			local itemName, _, itemRarity, _, _, _, _, _, _, itemTexture, _, classID, subclassID = GetItemInfo(itemID)
			local lootType
			if (itemName) then
				local collectedString
				if (classID == LE_ITEM_CLASS_MISCELLANEOUS and subclassID == LE_ITEM_MISCELLANEOUS_COMPANION_PET) then
					lootType = LOOT_TYPE.COMPANION_PET
					local speciesID = addon.item_companion[itemID]
					if (speciesID) then
						local name = C_PetJournal.GetPetInfoBySpeciesID(speciesID)
						if (name) then
							itemName = name
							collectedString = C_PetJournal.GetOwnedBattlePetString(speciesID)
						end
					end
				elseif (classID == LE_ITEM_CLASS_MISCELLANEOUS and subclassID == LE_ITEM_MISCELLANEOUS_MOUNT) then
					lootType = LOOT_TYPE.MOUNT
					local mountID = C_MountJournal.GetMountFromItem(itemID)
					if (mountID) then
						local creatureName, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(mountID)
						if (creatureName) then
							itemName = creatureName
						end
						if (isCollected) then
							collectedString = KNOWN
						end
					end
				elseif(addon.drakewatcherManuscripts[itemID]) then
					local collected = C_QuestLog.IsQuestFlaggedCompleted(addon.drakewatcherManuscripts[itemID])
					collectedString = collected and KNOWN
					lootType = LOOT_TYPE.DRAKEWATCHER_MANUSCRIPT
				else
					local _, toyName = C_ToyBox.GetToyInfo(itemID)
					if (toyName) then
						lootType = LOOT_TYPE.TOY
						itemName = toyName
						if (PlayerHasToy(itemID)) then
							collectedString = KNOWN
						end
					else
						lootType = LOOT_TYPE.UNKNOWN
						local _, itemSpell = C_Item.GetItemSpell(itemID)
						if (itemSpell) then
							local spellDescription = C_Spell.GetSpellDescription(itemSpell)
							if (spellDescription) then
								collectedString = spellDescription
							end
						end
					end
				end
				table.insert(loot, {
					collectedString = collectedString,
					itemName = itemName,
					itemRarity = itemRarity,
					itemTexture = itemTexture,
					lootType = lootType
				})
			else
				C_Item.RequestLoadItemDataByID(itemID)
			end
		end
	end
	return loot
end
