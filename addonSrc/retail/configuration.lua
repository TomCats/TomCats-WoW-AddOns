--[[ See license.txt for license and copyright information ]]
local _, addon = ...

local _, _, _, tocversion = GetBuildInfo()

local BackdropTemplateMixin = BackdropTemplateMixin

local CONTROLTYPE_CHECKBOX = CONTROLTYPE_CHECKBOX
local CONTROLTYPE_SLIDER = CONTROLTYPE_SLIDER

local TomCats_Config = TomCats_Config
local TomCats_ConfigIconSizeSlider = TomCats_ConfigIconSizeSlider
local TomCats_ConfigIconSizeSliderLow = TomCats_ConfigIconSizeSliderLow
local TomCats_ConfigIconSizeSliderHigh = TomCats_ConfigIconSizeSliderHigh

local TomCats_ConfigHEIconSizeSlider = TomCats_ConfigHEIconSizeSlider
local TomCats_ConfigHEIconSizeSliderLow = TomCats_ConfigHEIconSizeSliderLow
local TomCats_ConfigHEIconSizeSliderHigh = TomCats_ConfigHEIconSizeSliderHigh

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
	local controls = { }
	TomCats_Config.name = "TomCat's Tours"
	local category = Settings.RegisterCanvasLayoutCategory(TomCats_Config, TomCats_Config.name);
	TomCats_Config.category = category
	Settings.RegisterAddOnCategory(category);
	TomCats_Config.OnCommit = nop
	TomCats_Config.nDefault = nop
	function TomCats_Config:OnRefresh(...)
		for _, control in ipairs(controls) do
			control:SetValue(control:GetValue())
		end
	end
	TomCats_Config.Header.Text:SetFont(TomCats_Config.Header.Text:GetFont(), 64)
	local function Setup_CheckBox(checkBoxInfo)
		local checkBox = checkBoxInfo.component
		checkBox.type = CONTROLTYPE_CHECKBOX
		checkBox.Text:SetText(checkBoxInfo.label)
		checkBox.tooltipText = checkBoxInfo.tooltip
		checkBox.defaultValue = checkBoxInfo.defaultValue
		checkBox.GetValue = function(self)
			local prefsBase = (checkBoxInfo.prefsBase and _G["TomCats_Account"][checkBoxInfo.prefsBase]) or _G["TomCats_Account"].preferences
			local preferenceTable = (checkBoxInfo.preferenceTable and prefsBase[checkBoxInfo.preferenceTable]) or prefsBase
			local currentValue
			if (checkBoxInfo.inverseValue) then
				currentValue = preferenceTable and preferenceTable[checkBoxInfo.preferenceKey] and "0" or "1"
			else
				currentValue = preferenceTable and preferenceTable[checkBoxInfo.preferenceKey] and "1" or "0"
			end
			return currentValue
		end
		checkBox.SetValue = checkBoxInfo.SetValue
		if (tocversion >= 100000) then
			checkBox.SetValue = function(self, value)
				checkBox:SetChecked(value == "1")
				checkBoxInfo.SetValue(self, value)
			end
			checkBox:SetScript("OnClick", function()
				checkBox:SetValue(checkBox:GetChecked() and "1" or "0")
			end)
		end
		table.insert(controls, checkBox)
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
	do
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
		table.insert(controls, slider);
		BackdropTemplateMixin.OnBackdropLoaded(slider);
	end
	if (addon.lunarfestival:IsEventActive()) then
		TomCats_Config.checkBox_lunarFestivalMinimapButton:Show()
		Setup_CheckBox({
			component = TomCats_Config.checkBox_lunarFestivalMinimapButton,
			label = "Lunar Festival Minimap Button",
			tooltip = "Displays the Lunar Festival minimap button",
			defaultValue = "1",
			preferenceTable = "TomCats-LunarFestivalMinimapButton",
			preferenceKey = "hidden",
			SetValue = function(_, value)
				if (addon.lunarfestival:IsEventActive()) then
					addon.lunarfestival.charm:SetEnabled(value == "1")
				end
			end
		})
	end
	if (addon.loveisintheair:IsEventActive()) then
		TomCats_Config.checkBox_loveIsInTheAirMinimapButton:Show()
		Setup_CheckBox({
			component = TomCats_Config.checkBox_loveIsInTheAirMinimapButton,
			label = "Love is in the Air Minimap Button",
			tooltip = "Displays the Love is in the Air minimap button",
			defaultValue = "1",
			preferenceTable = "TomCats-LoveIsInTheAirMinimapButton",
			preferenceKey = "hidden",
			SetValue = function(_, value)
				if (addon.loveisintheair:IsEventActive()) then
					addon.loveisintheair.charm:SetEnabled(value == "1")
				end
			end
		})
	end
	if (addon.hallowsend:IsEventActive()) then
		TomCats_Config.checkBox_hallowsEndMinimapButton:Show()
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
		TomCats_Config.checkBox_hallowsEndArrow:Show()
		Setup_CheckBox({
			component = TomCats_Config.checkBox_hallowsEndArrow,
			label = "Hallow's End Arrow",
			tooltip = "Displays the Hallow's End arrow on the minimap",
			defaultValue = "1",
			prefsBase = "hallowsend",
			preferenceKey = "arrowsEnabled",
			SetValue = function(_, value)
				if (addon.hallowsend:IsEventActive()) then
					_G["TomCats_Account"].hallowsend.arrowsEnabled = (value == "1")
					TomCats_HallowsEnd_SetupArrow()
				end
			end
		})
		TomCats_Config.checkBox_hallowsEndAutomated:Show()
		Setup_CheckBox({
			component = TomCats_Config.checkBox_hallowsEndAutomated,
			label = "Hallow's End Automatic Features",
			tooltip = "Enables the Hallow's End automatic features",
			defaultValue = "1",
			prefsBase = "hallowsend",
			preferenceKey = "autoEnabled",
			SetValue = function(_, value)
				if (addon.hallowsend:IsEventActive()) then
					_G["TomCats_Account"].hallowsend.autoEnabled = (value == "1")
				end
			end
		})
		local slider = TomCats_ConfigHEIconSizeSlider
		TomCats_Config.HEIconSizeSliderLabel:Show()
		TomCats_ConfigHEIconSizeSlider:Show()
		slider.type = CONTROLTYPE_SLIDER
		slider.tooltipText = "Sets the size of the pumpkin icons"
		TomCats_ConfigHEIconSizeSliderLow:SetText("-")
		TomCats_ConfigHEIconSizeSliderHigh:SetText("+")
		TomCats_Config.HEIconSizeSliderLabel.Text:SetText("Hallow's End Icon Size");
		slider.SetDisplayValue = slider.SetValue;
		slider.GetValue = function()
			return _G["TomCats_Account"].hallowsend.iconScale
		end
		slider.GetCurrentValue = slider.GetValue
		slider.SetValue = function (self, value)
			self:SetDisplayValue(value);
			self.value = value;
			_G["TomCats_Account"].hallowsend.iconScale = value
			addon.hallowsend.SetIconScale(value)
		end
		table.insert(controls, slider);
	end
	TomCats_Config.html1:SetScript("OnHyperlinkClick", OnHyperlinkClick)
	TomCats_Config.html1:SetScript("OnHyperlinkEnter", OnHyperlinkEnter)
	TomCats_Config.html1:SetScript("OnHyperlinkLeave", OnHyperlinkLeave)
end
