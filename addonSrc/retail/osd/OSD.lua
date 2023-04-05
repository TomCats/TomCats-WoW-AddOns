--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("osd")

local frame = CreateFrame("Frame")
local UpdateVisibility

local relevantZones = {
	[1978] = true
}

local visibilityFunctions = {
	[addon.constants.accessoryDisplay.ALWAYS] = function()
		OSD.frame:Show()
	end,
	[addon.constants.accessoryDisplay.NEVER] = function()
		OSD.frame:Hide()
	end,
	[addon.constants.accessoryDisplay.NOINSTANCES] = function()
		local inInstance = IsInInstance()
		OSD.frame:SetShown(not inInstance)
	end,
	[addon.constants.accessoryDisplay.RELEVANTZONES] = function()
		local inInstance = IsInInstance()
		if (inInstance) then
			OSD.frame:Hide()
		else
			local uiMapID = C_Map.GetBestMapForUnit("player")
			while (uiMapID) do
				if (relevantZones[uiMapID]) then
					OSD.frame:Show()
					return
				end
				local mapInfo = C_Map.GetMapInfo(uiMapID)
				uiMapID = mapInfo and mapInfo.parentMapID or nil
			end
			OSD.frame:Hide()
		end
	end,
}

local OSDProtoType = {
	AfterRefresh = function(self)
		self.frame:SetHeight(self.TimerRows:GetHeight() + 64 - 17)
	end,
	New = function(self)
		self.frame = Templates.CreateBasicWindow(
				UIParent,
				{
					icon = ImagePNG.tomcats_minimap_icon,
					prefs = TomCats_Account.preferences.AccessoryWindow
				}
		)
		self.frame:SetSize(260,30)
		self.frame.title:SetText("TomCat's Tours")
		self.frame.footerBar:Hide()
		self:AddChild(UI.New(Timers, self), "TimerRows")
	end,
}

local function OnEvent(_, event, arg1, arg2)
	if (event == "AREA_POIS_UPDATED") then
		OSD:Refresh()
	elseif (event == "PLAYER_ENTERING_WORLD") then
		OSD = UI.New(OSDProtoType)
		OSD.frame.icon:EnableMouse(false)
		local settingsButton = CreateFrame("Button", nil, OSD.frame)
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
		settingsButton:SetScript("OnClick", function()
			if (addon.SettingsCategory) then
				Settings.OpenToCategory(addon.SettingsCategory:GetID())
			end
		end)
		settingsButton:SetScript("OnMouseUp", function()
			settingsButton:GetHighlightTexture():SetTexCoord(0.5, 1, 0.5, 1)
		end)
		settingsButton:SetPoint("TOPRIGHT", -6.5, -6.5)
		frame:SetScript("OnUpdate", function(_, elapsed)
			OSD:Update(elapsed)
		end)
		if (arg2) then
			OSD:Refresh()
		end
		frame:UnregisterEvent("PLAYER_ENTERING_WORLD")
		UpdateVisibility()
	elseif (event == "ZONE_CHANGED" or event == "ZONE_CHANGED_INDOORS" or event == "ZONE_CHANGED_NEW_AREA") then
		UpdateVisibility()
	end
end

function UpdateVisibility()
	if (OSD) then
		local level = UnitLevel("player")
		if (level == 70) then
			visibilityFunctions[TomCats_Account.preferences.AccessoryWindow.elementalStorms]()
		else
			OSD.frame:Hide()
		end
	end
end

function GetVisibilityOption()
	return TomCats_Account.preferences.AccessoryWindow.elementalStorms
end

function SetVisibilityOption(value)
	TomCats_Account.preferences.AccessoryWindow.elementalStorms = value
	UpdateVisibility()
end

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("AREA_POIS_UPDATED")
frame:RegisterEvent("ZONE_CHANGED");
frame:RegisterEvent("ZONE_CHANGED_INDOORS");
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
frame:SetScript("OnEvent", OnEvent)
