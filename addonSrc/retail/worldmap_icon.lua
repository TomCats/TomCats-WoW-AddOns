local addonName, addon = ...

local GameTooltip = GameTooltip
local tipFrame

local function ShowTooltip(this)
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(this, "ANCHOR_LEFT")
	GameTooltip:SetText("TomCat's Tours", 1, 1, 1)
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine("<CTRL-CLICK> Toggle Dragon Glyphs") --todo localize
	GameTooltip:Show()
end

local function HideTooltip(this)
	GameTooltip:Hide()
end

local function ButtonDown(self)
	if (self:IsEnabled()) then
		self.Icon:SetPoint("TOPLEFT", self, "TOPLEFT", 8, -8)
		self.IconOverlay:Show()
	end
end

local function ButtonUp(self)
	self.Icon:SetPoint("TOPLEFT", self, "TOPLEFT", 6, -6)
	self.IconOverlay:Hide()
end

local function OnClick(...)
	if (IsControlKeyDown()) then
		addon.dragonflyingglyphs.ToggleIcons()
	end
end

local function OnEvent(event, arg1)
	if (event == "ADDON_LOADED") then
		if (addonName == arg1) then
			local canvasContainer = WorldMapFrame:GetCanvasContainer()
			local frame = CreateFrame("Button", "TomCatIcon", canvasContainer, "TomCats-MinimapButtonTemplate")
			frame:ClearAllPoints()
			frame:SetPoint("TOPRIGHT", canvasContainer, "TOPRIGHT", -3, -34)
			frame:SetFrameStrata("HIGH")
			frame:SetFrameLevel(2)
			--addon.minimapButton = CreateMinimapButton({
			--	name = "TomCats-MinimapButton",
			--	iconTexture = "Interface\\AddOns\\TomCats\\images\\tomcats_logo",
			--	backgroundColor = { 0.0,0.0,0.0,1.0 },
			--	handler_onclick = OpenControlPanel
			--})
			local background = frame.Background
			background:SetDrawLayer("BACKGROUND", 1)
			background:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMaskSmall")
			background:SetWidth(25)
			background:SetHeight(25)
			background:SetVertexColor(0,0,0,1)
			frame.Icon:SetTexture("Interface\\AddOns\\TomCats\\images\\tomcats_logo")
			--end
			--if (buttonInfo.name) then
			--	local scope = _G["TomCats_Account"].preferences
			--	if (scope[name]) then
			--		frame:SetPreferences(scope[name])
			--	else
			--		scope[name] = frame:GetPreferences()
			--	end
			--end
			--if (buttonInfo.handler_onclick) then
			--	frame:SetHandler("OnClick",
			--			function(...)
			--				buttonInfo.handler_onclick(...)
			--			end)
			--end
			frame:SetScript("OnMouseDown", ButtonDown)
			frame:SetScript("OnMouseUp", ButtonUp)
			frame:SetScript("OnClick", OnClick)
			frame:SetScript("OnEnter", ShowTooltip)
			frame:SetScript("OnLeave", HideTooltip)
			addon.UnregisterEvent("ADDON_LOADED", OnEvent)

			if (not TomCats_Account.preferences.dragonGlyphsTipShown) then
				local BACKDROP_GLUE_TOOLTIP_16_16 = {
					bgFile = "Interface\\Glues\\Common\\Glue-Tooltip-Background",
					edgeFile = "Interface\\Glues\\Common\\Glue-Tooltip-Border",
					tile = true,
					tileEdge = true,
					tileSize = 16,
					edgeSize = 16,
					insets = { left = 10, right = 5, top = 4, bottom = 9 },
				};
				local GLUE_BACKDROP_COLOR = CreateColor(0.09, 0.09, 0.09);
				local GLUE_BACKDROP_BORDER_COLOR = CreateColor(0.8, 0.8, 0.8);
				tipFrame = CreateFrame("Button", nil, frame, "BackdropTemplate")
				tipFrame.backdropInfo = BACKDROP_GLUE_TOOLTIP_16_16
				tipFrame.backdropColor = GLUE_BACKDROP_COLOR
				tipFrame.backdropColorAlpha = 1.0
				tipFrame.backdropBorderColor = GLUE_BACKDROP_BORDER_COLOR
				local text = tipFrame:CreateFontString(nil, "ARTWORK", "GameFontWhite")
				text:SetText("Dragon Glyphs! (spoiler alert)\n\nTo enable:\n<CTRL-CLICK> the TomCat's Tours icon")
				text:SetPoint("CENTER", tipFrame, "CENTER", 0, 4)
				tipFrame:SetFrameLevel(3000)
				tipFrame:ClearAllPoints()
				tipFrame:SetPoint("TOPRIGHT", frame, "BOTTOMLEFT", 0, 0)
				tipFrame:SetSize(text:GetStringWidth() + 24, text:GetStringHeight() + 28)
				tipFrame:OnBackdropLoaded()
				tipFrame:SetScript("OnClick", function(self)
					TomCats_Account.preferences.dragonGlyphsTipShown = true
					self:Hide()
				end)
				tipFrame:Hide()
			end
			frame:SetScript("OnShow", function(self)
				if (tipFrame and not TomCats_Account.preferences.dragonGlyphsTipShown) then
					local mapID = WorldMapFrame:GetMapID()
					if (mapID >= 2022 and mapID <= 2025) then
						tipFrame:Show()
					end
				end
			end)
		end
	end
end

addon.RegisterEvent("ADDON_LOADED", OnEvent)