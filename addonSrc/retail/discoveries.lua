--[[ See license.txt for license and copyright information ]]
local addonName, addon = ...

local AlertFrame = AlertFrame
local BlizzardOptionsPanel_OnLoad = BlizzardOptionsPanel_OnLoad
local C_Map = C_Map
local C_VignetteInfo = C_VignetteInfo
local CreateFrame = CreateFrame
local InterfaceAddOnsList_Update = InterfaceAddOnsList_Update
local InterfaceOptions_AddCategory = InterfaceOptions_AddCategory
local InterfaceOptionsPanel_Cancel = InterfaceOptionsPanel_Cancel
local InterfaceOptionsPanel_Default = InterfaceOptionsPanel_Default
local InterfaceOptionsPanel_Refresh = InterfaceOptionsPanel_Refresh
local PlaySound = PlaySound
local SOUNDKIT = SOUNDKIT

local checkedVignetteGUIDs
local discoveredVignettes
local discoveredVignetteAtlases
local interval = 3
local lastVignetteMapID
local timeSinceLastUpdate = 0
local vignettes
local TomCatsDiscoveryAlertSystem
local TomCats_Config = TomCats_Config
local TomCats_ConfigDiscoveries = TomCats_ConfigDiscoveries

local atlasNameBlackList = { }
local atlasNameWhiteList = { }

local vignetteIDBlackList = {
	[4435] = true, --[[
		The Winter Wolf vignette belongs to NPC Gwynceirw <The Winter Wolf>, who is non-hostile.
		This is part of the encounter involving Rotbriar Boggart, who is the actual rare.
		When encountering this rare, The Winter Wolf appeared on the minimap until the encounter began.
		(Speaking to Daffodil who flies nearby starts the encounter)
		Rotbriar Boggart appears only once the encounter begins. (vignette ID 4183)
		Both vignettes appear on the minimap for the duration of the encounter
		Rotbriar Boggart might be set for the wrong coordinates (The Winter Wolf is a little bit South - see data)
		Boggart first appears at 65.72, 24.04 in Ardenweald
		The quest ID for the encounter is 60258 (same quest ID for both NPCs)

		Dev: Swap out Rotbriar Boggart for The Winter Wolf as the tracked vignette so that the spawned icon may
			appear before the encounter is started.  Put Rotbriar on the vignetteIDBlackList
	]]
	--[[
		Dev notes for anima conductor related rares:
			The anima conductor rares seem to be always available, but require certain players to activate them.  The
			areaPOI might only appear on the world map when the player has directed the anima conductor to that spot.
			It is not yet known if the clickable object remains available despite the disposition of the anima
			conductor (check this).
	]]
	[4481] = true, --[[
		(Bastion)
		Horn of Courage: This world object is used for summoning Wingflayer the Cruel (id 4198).
		This is enabled via the Kyrian anima conductor.  The game already provides a star icon (larger) for players
		that have this unlocked
		Quest tracking ID is 60314 for both vignette IDs
		Kyrian is required to see and click on the horn
		anima conductor rare

		The Horn of Courage appears on the world map as a larger star that is visible from anywhere.
		GetVignettes() does not return The Horn of Courage's GUID until the player is very close to it
		There is both a yellow dot and a star on the minimap (Horn of Courage is listed twice in the tooltip)
		The Horn of Courage disappears from GetVignettes() and both minimap indicators once Wingflayer is summoned
		As soon as Wingflayer is killed by someone, The Horn of Courage returns to GetVignettes() and both minimap icons

		The Horn of Courage world map icon comes from AreaPOI 6896 and appears via an AreaPOIPinTemplate
		Upon killing Wingflayer, quest ID 62197 and 60314 get completed for both a Kyrian and non-Kyrian player
		The POI reappears on the minimap, but the world map POI disappears as well as the minimap star
		The horn of courage can be clicked again and the rare respawned (but no silver dragon)
		]]
	[4477] = true, --[[
		Black Bell is located in Bastion
		Coordinates: 0.22661843895912 0.22841666638851 x1
		Kyrian is required to see the Black Bell (anima conductor based spawn)
		This is used to start the encounter with Orstus and Sotiros (vignette ID 4476)
		These are 2 NPCs: Larionrider Orstus and Eliminator Sotiros
		Quest tracking ID is 61634 for both vignette IDs
	]]
	[4471] = true, --[[
		Madalav's Hammer in Revendreth
		presumably spawns Forgemaster Madalav (ID = 4472)
		Coordinates: 0.32669773697853 0.14836129546165	x8
		Quest tracking ID is 61618 for both vignette IDs
		Venthyr is required to see the hammer and click on it (anima conductor based spawn)
	]]
	[4480] = true, --[[
		Dredterror Ballista is located in Revendreth
		Coordinates: 0.45844373106956 0.79207587242126 x 35
		Venthyr is required to see the ballista (anima conductor based spawn)
		This is used to start the encounter with Harika the Horrid (vignette ID 4138)
		Quest tracking ID is 59612 for both vignette IDs
	]]
	[4474] = true, --[[
		Sparkling Animaseed is located in Ardenweald
		Coordinates: 0.30439439415932 0.55533993244171 x 8
		Night Fae is required to see the Sparkling Animaseed (anima conductor based spawn)
		This is used to start the encounter with Valfir the Unrelenting (vignette ID 4473)
		Quest tracking ID is 61632 for both vignette IDs
	]]
	[4475] = true, --[[
		Dapperdew (quest ID 61633)
		This is a larger encounter in Star Lake Amphitheater in Ardenweald
		(same location as Niya, As Xavius - quest tracking ID 61207)
		When I arrived, Niya was already spawned and in combat (see vignette ID 4407).
		After Niya was killed, both 61633 and 61207 flagged as completed
		All encounter coordinates submitted were: 0.41501894593239 0.44829621911049 in Ardenweald
		From WowHead:
			Players with Night Fae covenant can speak with Dapperdew and activate the fight.
			This summons one out of 7 rares:
			Astra, As Azshara
			Dreamweaver, As N'Zoth
			Glimmerdust, As Jaina
			Glimmerdust, As Kil'jaeden
			Mi'kai, As Argus, the Unmaker
			Niya, As Xavius
			Senthii, As Gul'dan
	 ]]
	[4478] = true, --[[
		Final Thread is located in Maldraxxus
		Coordinates: 0.31559833884239 0.35319924354553 x6
		Necrolord is required to see the Final Thread (anima conductor based spawn)
		This is used to start the encounter with Gieger (vignette ID 4071)
		Quest tracking ID is 58872 for both vignette IDs
	]]
	[4192] = true, --[[
		Bizarre Blossom Bunch are 3 clickable objects in close proximity to each other that once clicked spawns
		Rootwrithe (does not have a separate vignette ID).  There is no collectible loot according to WowHead
		Quest ID for the encounter is 60273
		The encounter coordinates mostly found are: 0.65081518888474 0.44263985753059 in Adrenweald
	]]
	[4191] = true, --[[
		Unguarded Gorm Eggs are in Ardenweald - cave entrance is 58.5, 31.8
		They are guarded by Egg-Tender Leh'go
		2 egg spawns show up on the minimap, but Leh'go does not
		WowHead users report having to break the eggs in order for Leh'go to spawn, but Leh'go was already spawned
		when I arrived.  Others report Leh'go taking awhile to spawn despite breaking eggs.
		Quest tracking ID is 60266
		Unguarded Gorm Eggs coordinates that were reported are:
		0.57869201898575 0.29515069723129 x25
		0.57859021425247 0.29538902640343 x35
		0.57837241888046 0.29460588097572 x2
	]]
	[4115] = true, --[[
		Wriggling Vine located at 0.58342456817627 0.61796236038208 (reported 35x) in Ardenweald
		Click to pull the wriggling vine and it will spawn Wrigglemortis
		(still shows Wriggling Vine on the minimap)
		Quest tracking ID is 59170
	]]
	[4193] = true, --[[
		Strange Cloud
		located in Ardenweald:
		0.59442234039307 0.46656504273415	28
		0.59443604946136 0.46663561463356	34
		Spawns: The Slumbering Emperor
		Requires taking steady damage in order to not fall asleep while entering the cloud and then casting AOE
		to reveal the NPC
		Quest tracking ID is 60290
	]]
	[4490] = true, --[[
		Pulsing Leech is located in Maldraxxus
		This is part of the Pool of Mixed Monstrosities encounter (no vignette ID for the world object)
		Coordinates: 0.58187514543533 0.7424983382225 x 23
	]]
	[4247] = true, --[[
		From WowHead:
			Amalgamation of Sin rare mob can be found in Revendreth.
			Location: 65.73 29.15
			Required for:  Adventurer of Revendreth
			Rare drop:  Sinstone-Studded Greathelm
			To be able to summon Amalgamation of Sin you need to complete world quest  Summon Your Sins when its up.
			After collecting the sinstone fragments you need to chose a catalyst. You should pick up the left one - Catalyst of Power.
			Alchemist Leticia will give you  Amalgamation of Sin. use it to summon the rare mob, it will appear next to you and attack.
	]]
	[4061] = true, --[[
		Catacombs Cache is located in Revendreth
		Clicking on the dormant golem - it comes to life as Sinstone Hoarder
		during this time, the vignette is no longer visible on the minimap
		Killing Sinstone Hoarder causes the Catacombs Cache to appear as a box on the ground
		Opening the cache completes quest tracking ID 62252
	]]
	[4491] = true, --[[
		Corrupted Sediment  is located in Maldraxxus
		This is part of the Pool of Mixed Monstrosities encounter (no vignette ID for the world object)
		Coordinates: 0.58187514543533 0.7424983382225 x 23
	]]
	[4492] = true, --[[
		Violet Mistake  is located in Maldraxxus
		This is part of the Pool of Mixed Monstrosities encounter (no vignette ID for the world object)
		Coordinates: 0.58187514543533 0.7424983382225 x 23
	]]
	[4493] = true, --[[
		Gelloh is located in Maldraxxus
		This is part of the Pool of Mixed Monstrosities encounter (no vignette ID for the world object)
		Coordinates: 0.58187514543533 0.7424983382225 x 23
	]]
	[4495] = true,  --[[
		Burnblister is located in Maldraxxus
		This is part of the Pool of Mixed Monstrosities encounter (no vignette ID for the world object)
		Coordinates: 0.58187514543533 0.7424983382225 x 23
	]]
	[4496] = true, --[[
		Oily Invertebrate is located in Maldraxxus
		This is part of the Pool of Mixed Monstrosities encounter (no vignette ID for the world object)
		Coordinates: 0.58187514543533 0.7424983382225 x 23
	]]
	[4494] = true, --[[
		Boneslurp is located in Maldraxxus
		This is part of the Pool of Mixed Monstrosities encounter (no vignette ID for the world object)
		Coordinates: 0.58187514543533 0.7424983382225 x 23
	]]
	[4401] = true, --[[
		Astra, As Azshara - is part of the Dapperdew encounter (see ID 4475)
		Coordinates: 0.41280442476273 0.44340083003044 - spawned on the Wow day spanning 3/18-3/19
		Quest tracking ID = 61202
	]]
	[4402] = true, --[[
		Mi'kai, As Argus, the Unmaker - is part of the Dapperdew encounter (see ID 4475)
		Coordinates: 0.41280442476273 0.44340083003044 x121 - spawned on the Wow day spanning 3/15-3/16
		Quest tracking ID = 61202
	]]
	[4403] = true, --[[
		Glimmerdust, As Kil'jaeden - is part of the Dapperdew encounter (see ID 4475)
		Glimmerdust spawns at 0.41280442476273 0.44340083003044 x43 - spawned on the Wow day spanning 3/16-3/17
		Quest tracking ID = 61203
	]]
	[4404] = true, --[[
		Senthii, As Gul'dan is part of the Dapperdew encounter (see ID 4475)
		Glimmerdust spawns at 0.41280442476273 0.44340083003044 x43 - spawned on the Wow day spanning 3/20-3/21
		Quest tracking ID = 61204
	]]
	[4405] = true, --[[
		Glimmerdust, As Jaina - is part of the Dapperdew encounter (see ID 4475)
		Glimmerdust spawns at 0.41280442476273 0.44340083003044	x32 - spawned on the Wow day spanning 3/17-3/18
		Quest tracking ID = 61205
	]]
	[4406] = true, --[[
		Dreamweaver, As N'Zoth is part of the Dapperdew encounter (see ID 4475)
		Glimmerdust spawns at 0.41280442476273 0.44340083003044	x32 - spawned on the Wow day spanning 3/19-3/20
		Quest tracking ID = 61206
	]]
	[4407] = true, --[[
		Niya, As Xavius - is part of the Dapperdew encounter (see ID 4475)
		Niya spawns at 0.41280442476273 0.44340083003044 - spawned on the Wow day spanning 3/14-3/15
		Quest tracking ID = 61207
	 ]]
	[4108] = true, --[[
		Amalgamation of Flesh sighted in Uldum during the last Black Empire assault
		coordinates: 0.59921550750732 0.72384291887283
		Currently we have vignetteID 3878 for this, but may be incorrect or may be associated with the related event
		that ultimately spawns the amalgamation.  See posts on Wowhead regarding the event as it is described for this
		NPC.
	]]
}

do
	local tmp1 = {
		["poi-nzothpylon"] = true, -- minor n'zoth vision
		["VignetteEventElite"] = true, -- special events in the n'zoth zones
		["VignetteLoot"] = true, -- Black Empire Cache
		["VignetteKillElite"] = true, -- special elite in the n'zoth zones
		["nazjatar-nagaevent"] = true, -- purple skulls esp. in Nazjatar
		["PortalRed"] = true, -- chaotic riftstone (maw)
		["PortalBlue"] = true, -- animaflow teleporter (maw)
		["poi-soulspiritghost"] = true, -- souls in the maw
		["VignetteKillElite"] = true, -- Beastwarrens in the maw
		["Profession"] = true, -- Soulsteel Anvil in the maw
		["poi-graveyard-neutral"] = true, -- player's corpse location in the maw
		["TeleportationNetwork-32x32"] = true, -- from discord dump
		["poi-workorders"] = true, -- from discord dump
		["QuestObjective"] = true, -- from discord dump
		["Object"] = true, -- from discord dump
		["Warfronts-BaseMapIcons-Empty-Workshop-Minimap-small"] = true, -- from discord dump
		["VignetteLootElite"] = true, -- from discord dump
		["SmallQuestBang"] = true, -- from discord dump
		["WarMode-Broker-32x32"] = true, -- from discord dump 3/15
		["Vehicle-Air-Occupied"] = true, -- from discord dump 3/15
	}
	for k in pairs(tmp1) do
		atlasNameBlackList[string.lower(k)] = true
	end
	local tmp2 = {
		["Warfront-NeutralHero"] = true, -- special events in the maw
		["VignetteEvent"] = true, -- star icon (sl)
		["VignetteKill"] = true, -- star icon (bfa)
	}
	for k in pairs(tmp2) do
		atlasNameWhiteList[string.lower(k)] = true
	end
	TomCats_ConfigDiscoveries.name = "Discoveries"
	TomCats_ConfigDiscoveries.parent = "TomCat's Tours"
	TomCats_ConfigDiscoveries.controls = { }
	TomCats_ConfigDiscoveries.Header.Text:SetFont(TomCats_ConfigDiscoveries.Header.Text:GetFont(), 64)
	BlizzardOptionsPanel_OnLoad(
			TomCats_ConfigDiscoveries,
			function(self)
				for _, v in ipairs(self.controls) do
					if (v.okay) then v:okay() end
				end
			end,
			InterfaceOptionsPanel_Cancel,
			InterfaceOptionsPanel_Default,
			InterfaceOptionsPanel_Refresh
	)
	InterfaceOptions_AddCategory(TomCats_ConfigDiscoveries)
	InterfaceAddOnsList_Update()
end

local function serializeTable(val, key)
	local tmp
	if (key) then
		if (type(key) == "string") then
			tmp = "[\"" .. key .. "\"]="
		else
			tmp = "[" .. key .. "]="
		end
	else
		tmp = ""
	end
	if type(val) == "table" then
		tmp = tmp .. "{"
		for k, v in pairs(val) do
			tmp =  tmp .. serializeTable(v, k) .. ","
		end
		tmp = tmp .. "}"
	elseif type(val) == "number" then
		tmp = tmp .. tostring(val)
	elseif type(val) == "string" then
		tmp = tmp .. string.format("%q", val)
	elseif type(val) == "boolean" then
		tmp = tmp .. (val and "true" or "false")
	else
		tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
	end
	return tmp
end

local function OnHyperlinkClick(self, link)
	if (self.popup:IsShown() and link == self.popup.lastLink) then
		self.popup.lastLink = nil
		self.popup:Hide()
		return
	end
	self.popup.lastLink = link
	if (link == "discoveries") then
		self.popup.editbox.text = addon.base64.encode(serializeTable(_G["TomCats_Account"].discoveries))
		self.popup.info:SetText("Press Control-C to copy the data")
	else
		self.popup.editbox.text = "https://" .. link
		self.popup.info:SetText("Press Control-C to copy the link")
	end
	self.popup.editbox:SetText(self.popup.editbox.text)
	self.popup.editbox:HighlightText()
	self.popup:Show()
	self.popup.editbox:SetFocus()
	self.popup:SetFrameStrata("TOOLTIP")
end

local function OnHyperlinkEnter(self, link, _, fontString)
	self.linksHighlight = self.linksHighlight or self:CreateFontString()
	self.links = fontString
	self.linksHighlight:ClearAllPoints()
	self.linksHighlight:SetFont(self.links:GetFont())
	local text = self.links:GetText()
	text = string.gsub(text, "(|H.-|h)", "")
	text = string.gsub(text, "(|h)", "")
	text = string.gsub(text, link, "|cFFFFD100" .. link .. "|r")
	self.linksHighlight:SetText(text)
	self.linksHighlight:Show()
	for i = 1, self.links:GetNumPoints() do
		self.linksHighlight:SetPoint(self.links:GetPoint(i))
	end
	self.linksHighlight:SetSpacing(self.links:GetSpacing())
	self.linksHighlight:SetJustifyH(self.links:GetJustifyH())
	self.linksHighlight:SetShadowOffset(self.links:GetShadowOffset())
	self.linksHighlight:SetSize(self.links:GetSize())
	self.links:SetAlpha(0.1)
end

local function OnHyperlinkLeave(self)
	self.linksHighlight:Hide()
	self.links:SetAlpha(1.0)
end

TomCats_ConfigDiscoveries.html:SetScript("OnHyperlinkClick", OnHyperlinkClick)
TomCats_ConfigDiscoveries.html:SetScript("OnHyperlinkEnter", OnHyperlinkEnter)
TomCats_ConfigDiscoveries.html:SetScript("OnHyperlinkLeave", OnHyperlinkLeave)
TomCats_ConfigDiscoveries.discoveriesButton:SetScript("OnClick", function()
	OnHyperlinkClick(TomCats_ConfigDiscoveries.html, "discoveries")
end)

local function updateDiscoveryCount(amount)
	addon.discoveries = addon.discoveries or 0
	addon.discoveries = addon.discoveries + amount
	local totalDiscoveries = _G["TomCats_Account"].discoveriesResetCount + addon.discoveries
	local newDiscoveries = addon.discoveries
	if (totalDiscoveries == newDiscoveries) then
		TomCats_Config.discoveriesButton:SetText(("Discoveries: %d"):format(totalDiscoveries))
		TomCats_ConfigDiscoveries.discoveriesButton:SetText(("Discoveries: %d"):format(totalDiscoveries))
	else
		TomCats_Config.discoveriesButton:SetText(("Discoveries: %d (New: %d)"):format(totalDiscoveries, newDiscoveries))
		TomCats_ConfigDiscoveries.discoveriesButton:SetText(("Discoveries: %d (New: %d)"):format(totalDiscoveries, newDiscoveries))
	end
	if (addon.discoveries == 0 and _G["TomCats_Account"].discoveriesResetCount == 0) then
		TomCats_ConfigDiscoveries.discoveriesButton:Disable()
	else
		TomCats_ConfigDiscoveries.discoveriesButton:Enable()
	end
end

TomCats_ConfigDiscoveries.discoveriesResetCounterButton:SetScript("OnClick", function()
	_G["TomCats_Account"].discoveriesResetCount = _G["TomCats_Account"].discoveriesResetCount + addon.discoveries
	updateDiscoveryCount(-addon.discoveries)
end)

local function GetExtendedVignetteInfo(vignetteInfo, mapID)
	vignetteInfo.mapID = mapID
	local vignettePosition = C_VignetteInfo.GetVignettePosition(vignetteInfo.vignetteGUID, mapID)
	if (vignettePosition) then
		vignetteInfo.x = vignettePosition.x
		vignetteInfo.y = vignettePosition.y
	end
	return vignetteInfo
end

local function OnUpdate(_, elapsed)
	timeSinceLastUpdate = timeSinceLastUpdate + elapsed
	local mapID = C_Map.GetBestMapForUnit("player")
	if (mapID ~= lastVignetteMapID) then
		lastVignetteMapID = mapID
		vignettes = addon.getVignettes(lastVignetteMapID)
		if (not vignettes and mapID == 1961) then vignettes = { } end
		checkedVignetteGUIDs = { }
		timeSinceLastUpdate = 0
	end
	if (timeSinceLastUpdate >= interval) then
		timeSinceLastUpdate = 0
		if (vignettes) then
			local vignetteGUIDs = C_VignetteInfo.GetVignettes()
			if (#vignetteGUIDs ~= 0) then
				for _, v in ipairs(vignetteGUIDs) do
					if (not checkedVignetteGUIDs[v]) then
						checkedVignetteGUIDs[v] = true
						local vignetteInfo = C_VignetteInfo.GetVignetteInfo(v)
						if (vignetteInfo and not vignetteIDBlackList[vignetteInfo.vignetteID]) then
							local vignette = vignettes[vignetteInfo.vignetteID]
							if (vignetteInfo.type == 0) then
								local atlasName = string.lower(vignetteInfo.atlasName)
								if (atlasNameWhiteList[atlasName] and not vignette) then
									if (not discoveredVignettes[vignetteInfo.vignetteID]) then
										discoveredVignettes[vignetteInfo.vignetteID] = GetExtendedVignetteInfo(vignetteInfo, mapID)
										print("New Vignette:",vignetteInfo.name, vignetteInfo.x, vignetteInfo.y)
										updateDiscoveryCount(1)
										TomCatsDiscoveryAlertSystem:AddAlert()
									end
								elseif (not atlasNameBlackList[atlasName] and not atlasNameWhiteList[atlasName]) then
									if (not discoveredVignetteAtlases[vignetteInfo.atlasName]) then
										discoveredVignetteAtlases[vignetteInfo.atlasName] = GetExtendedVignetteInfo(vignetteInfo, mapID)
										print("New Map Icon:",vignetteInfo.atlasName, vignetteInfo.name, vignetteInfo.x, vignetteInfo.y)
										updateDiscoveryCount(1)
										TomCatsDiscoveryAlertSystem:AddAlert()
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

local function TomCatsDiscoveryAlertFrame_SetUp(frame)
	frame.Title:SetText("TomCat's Tours:");
	frame.Text:SetText("New discovery!");
	PlaySound(SOUNDKIT.UI_AZERITE_EMPOWERED_ITEM_LOOT_TOAST)
end

local function OnEvent(event, arg1)
	if (event == "ADDON_LOADED") then
		if (addonName == arg1) then
			TomCatsDiscoveryAlertSystem = AlertFrame:AddQueuedAlertFrameSubSystem("TomCatsDiscoveryAlertFrameTemplate", TomCatsDiscoveryAlertFrame_SetUp);
			if (_G["TomCats_Account"].discoveriesVersion ~= "@version@") then
				_G["TomCats_Account"].discoveries.vignettes = { }
				_G["TomCats_Account"].discoveries.vignetteAtlases = { }
				_G["TomCats_Account"].discoveriesResetCount = 0
				_G["TomCats_Account"].discoveriesVersion = "@version@"
			end
			local discoveries = 0
			discoveredVignettes = _G["TomCats_Account"].discoveries.vignettes
			for _ in pairs(discoveredVignettes) do
				discoveries = discoveries + 1
			end
			discoveredVignetteAtlases = _G["TomCats_Account"].discoveries.vignetteAtlases
			for _ in pairs(discoveredVignetteAtlases) do
				discoveries = discoveries + 1
			end
			discoveries = discoveries - _G["TomCats_Account"].discoveriesResetCount
			updateDiscoveryCount(discoveries)
			CreateFrame("Frame"):SetScript("OnUpdate", OnUpdate)
			addon.UnregisterEvent("ADDON_LOADED", OnEvent)
		end
	end
end

addon.RegisterEvent("ADDON_LOADED", OnEvent)
