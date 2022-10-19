--[[ See license.txt for license and copyright information ]]
local _, addon = ...

local BackdropTemplateMixin = BackdropTemplateMixin
local BlizzardOptionsPanel_RegisterControl = BlizzardOptionsPanel_RegisterControl
local CONTROLTYPE_CHECKBOX = CONTROLTYPE_CHECKBOX
local CONTROLTYPE_SLIDER = CONTROLTYPE_SLIDER
local InterfaceAddOnsList_Update = InterfaceAddOnsList_Update
local InterfaceOptionsPanel_OnLoad = InterfaceOptionsPanel_OnLoad

local TomCats_Config = TomCats_Config
local TomCats_ConfigIconSizeSlider = TomCats_ConfigIconSizeSlider
local TomCats_ConfigIconSizeSliderLow = TomCats_ConfigIconSizeSliderLow
local TomCats_ConfigIconSizeSliderHigh = TomCats_ConfigIconSizeSliderHigh

local function OnHyperlinkClick(self, link)
	link = "https://" .. link
	if (self.popup:IsShown() and link == self.popup.text) then
		self.popup:Hide()
		return
	end
	self.popup.text = link
	self.popup.info:SetText("Press Control-C to copy the link")
	self.popup.editbox:SetText(self.popup.text)
	self.popup.editbox:HighlightText()
	self.popup:SetFrameStrata("TOOLTIP")
	self.popup:Show()
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

do
	TomCats_Config.name = "TomCat's Tours"
	TomCats_Config.controls = { }
	TomCats_Config.Header.Text:SetFont(TomCats_Config.Header.Text:GetFont(), 64)
	local function Setup_CheckBox(checkBoxInfo)
		local checkBox = checkBoxInfo.component
		checkBox.type = CONTROLTYPE_CHECKBOX
		checkBox.Text:SetText(checkBoxInfo.label)
		checkBox.tooltipText = checkBoxInfo.tooltip
		checkBox.defaultValue = checkBoxInfo.defaultValue
		checkBox.GetValue = function()
			local prefsBase = _G["TomCats_Account"].preferences
			local preferenceTable = checkBoxInfo.preferenceTable and prefsBase[checkBoxInfo.preferenceTable] or prefsBase
			local currentValue
			if (checkBoxInfo.inverseValue) then
				currentValue = preferenceTable and preferenceTable[checkBoxInfo.preferenceKey] and "0" or "1"
			else
				currentValue = preferenceTable and preferenceTable[checkBoxInfo.preferenceKey] and "1" or "0"
			end
			return currentValue
		end
		checkBox.SetValue = checkBoxInfo.SetValue
		BlizzardOptionsPanel_RegisterControl(checkBox, TomCats_Config)
	end
	Setup_CheckBox({
		component = TomCats_Config.checkBox_minimapButton,
		label = "Main \"TomCat's Tours\" Minimap Button",
		tooltip = "Displays the main \"TomCat's Tours\" minimap button",
		defaultValue = "1",
		preferenceTable = "TomCats-MinimapButton",
		preferenceKey = "hidden",
		inverseValue = true,
		SetValue = function(_, value)
			addon.minimapButton:SetEnabled(value == "1")
		end
	})
	Setup_CheckBox({
		component = TomCats_Config.checkBox_betaFeatures,
		label = "Beta Features",
		tooltip = "Enables the beta features",
		defaultValue = "0",
		preferenceKey = "betaEnabled",
		SetValue = function(_, value)
			addon.SetBetaEnabled(value == "1")
		end
	})
	Setup_CheckBox({
		component = TomCats_Config.checkBox_mapIconAnimation,
		label = "Map Icon Animation",
		tooltip = "Animates the map icons for spawned encounters",
		defaultValue = "0",
		preferenceTable = "MapOptions",
		preferenceKey = "iconAnimationEnabled",
		SetValue = function(_, value)
			addon.SetIconAnimationEnabled(value == "1")
		end
	})
	local slider = TomCats_ConfigIconSizeSlider
	slider.type = CONTROLTYPE_SLIDER
	slider.tooltipText = "Sets the size of the encounter icons which are displayed on the world map and battlefield map"
	TomCats_ConfigIconSizeSliderLow:SetText("-")
	TomCats_ConfigIconSizeSliderHigh:SetText("+")
	TomCats_Config.IconSizeSliderLabel.Text:SetText("Map Icon Size");
	slider.SetDisplayValue = slider.SetValue;
	slider.GetValue = function()
		return _G["TomCats_Account"].preferences.MapOptions.iconScale
	end
	slider.GetCurrentValue = slider.GetValue
	slider.SetValue = function (self, value)
		self:SetDisplayValue(value);
		self.value = value;
		_G["TomCats_Account"].preferences.MapOptions.iconScale = value
		addon.SetIconScale(value)
	end
	BlizzardOptionsPanel_RegisterControl(slider, TomCats_Config);
	Setup_CheckBox({
		component = TomCats_Config.checkBox_lunarFestivalMinimapButton,
		label = "Lunar Festival Minimap Button",
		tooltip = "Displays the Lunar Festival minimap button",
		defaultValue = "1",
		preferenceTable = "TomCats-LunarFestivalMinimapButton",
		preferenceKey = "hidden",
		inverseValue = true,
		SetValue = function(_, value)
			if (addon.lunarfestival:IsEventActive()) then
				addon.lunarfestival.charm:SetEnabled(value == "1")
			end
		end
	})
	Setup_CheckBox({
		component = TomCats_Config.checkBox_loveIsInTheAirMinimapButton,
		label = "Love is in the Air Minimap Button",
		tooltip = "Displays the Love is in the Air minimap button",
		defaultValue = "1",
		preferenceTable = "TomCats-LoveIsInTheAirMinimapButton",
		preferenceKey = "hidden",
		inverseValue = true,
		SetValue = function(_, value)
			if (addon.loveisintheair:IsEventActive()) then
				addon.loveisintheair.charm:SetEnabled(value == "1")
			end
		end
	})
	Setup_CheckBox({
		component = TomCats_Config.checkBox_hallowsEndMinimapButton,
		label = "Hallow's End Minimap Button",
		tooltip = "Displays the Hallow's End minimap button",
		defaultValue = "1",
		preferenceTable = "TomCats-HallowsEndMinimapButton",
		preferenceKey = "hidden",
		inverseValue = true,
		SetValue = function(_, value)
			if (addon.hallowsend:IsEventActive()) then
				addon.hallowsend.charm:SetEnabled(value == "1")
			end
		end
	})
	BackdropTemplateMixin.OnBackdropLoaded(slider);
	TomCats_Config.html1:SetScript("OnHyperlinkClick", OnHyperlinkClick)
	TomCats_Config.html1:SetScript("OnHyperlinkEnter", OnHyperlinkEnter)
	TomCats_Config.html1:SetScript("OnHyperlinkLeave", OnHyperlinkLeave)
	InterfaceOptionsPanel_OnLoad(TomCats_Config)
	InterfaceAddOnsList_Update()
end
