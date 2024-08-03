--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("osd")

local frame = CreateFrame("Frame")

local OSDProtoType = {
	AfterRefresh = function(self)
		self.frame:SetHeight(self.TimerRows:GetHeight() + 64 - 17)
        self.frame:SetWidth(self.TimerRows:GetWidth())
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
		UpdateVisibility()
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
		settingsButton:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
			GameTooltip:AddLine("The timers can be toggled between showing, hiding, or snoozing. Configure your settings by clicking here.", 1, 1, 1, true)
			GameTooltip:Show()
		end)
		settingsButton:SetScript("OnLeave", function()
			GameTooltip:Hide()
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
	elseif (event == "ZONE_CHANGED"
			or event == "ZONE_CHANGED_INDOORS"
			or event == "ZONE_CHANGED_NEW_AREA"
			or event == "NEW_PET_ADDED"
	) then
		UpdateVisibility()
	end
end

function UpdateVisibility()
	if (OSD) then
		local level = UnitLevel("player")
        local shown = false
		if (level == 70) then
			shown = shown or IsElementalStormsVisible()
        end
        shown = shown or GreedyEmissary and GreedyEmissary.IsVisible()
		shown = shown or TimeRifts and TimeRifts.IsVisible()
		shown = shown or Superbloom and Superbloom.IsVisible()
		shown = shown or RadiantEchoes and RadiantEchoes.IsVisible()
		Promos.UpdateVisibility()
		shown = shown or Promos.IsVisible()
    	OSD.frame:SetShown(shown)
        if (shown) then
            OSD:Refresh()
        end
	end
end

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("AREA_POIS_UPDATED")
frame:RegisterEvent("ZONE_CHANGED");
frame:RegisterEvent("ZONE_CHANGED_INDOORS");
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
frame:RegisterEvent("NEW_PET_ADDED");
frame:SetScript("OnEvent", OnEvent)
