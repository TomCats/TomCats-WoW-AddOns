--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("mopremix")

local DisplayMenu, DisplaySubMenu, Factory_CreateMenuButton, PopulateMenu

function DisplayMenu(menuFrame, menuData, ...)
	if (menuData) then
		menuFrame:SetScale(1)
		menuFrame.opening = true
		menuFrame:ClearAllPoints()
		menuFrame:SetPoint(...)
		menuFrame:Show()
		local minWidth = PopulateMenu(menuFrame, menuData)
		menuFrame:SetWidth(math.max(minWidth + 40), 240)
		local menuFrameMaxHeight = UIParent:GetHeight() * UIParent:GetEffectiveScale() - 25
		local menuFrameHeight = menuFrame:GetHeight() * menuFrame:GetEffectiveScale()
		if (menuFrameHeight > menuFrameMaxHeight) then
			local newScale = menuFrameMaxHeight / menuFrameHeight
			menuFrame:SetScale(newScale)
		end
	else
		menuFrame:Hide()
		menuFrame.submenu:Hide()
	end
end

function DisplaySubMenu(menu, button, submenu)
	if (submenu) then
		menu.submenu:ClearAllPoints()
		--if (ScreenSide.GetCurrentSide(menu:GetParent()) == SCREEN_LEFT) then
			menu.submenu:SetPoint("TOPLEFT", button, "RIGHT", -12, 16)
		--else
		--	menu.submenu:SetPoint("RIGHT", button, "LEFT", -6, 0)
		--end
		local minWidth = PopulateMenu(menu.submenu, submenu)
		menu.submenu:SetWidth(minWidth + 40)
		menu.submenu:Show()
	else
		menu.submenu:Hide()
	end
end

function Factory_CreateMenuButton(parent)
	return CreateMenuButton(parent)
end

function PopulateMenu(frame, menuData)
	local bottom = 2147483647
	local minWidth = 0
	for i = 1, #menuData do
		local menuButton = frame.buttons[i]
		menuButton:SetOpts(menuData[i])
		if (menuButton:HasPrevious()) then
			menuButton:SetPoint("TOPLEFT", menuButton:GetPrevious(), "BOTTOMLEFT", 0, 0)
		else
			menuButton:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -16)
		end
		menuButton:SetPoint("RIGHT", frame, "RIGHT", -6, 0)
		menuButton:Show()
		minWidth = math.max(minWidth, menuButton.minWidth)
		bottom = math.min(bottom, menuButton:GetBottom())
	end
	frame:SetHeight(frame:GetTop() - bottom + 20)
	for i = #menuData + 1, #frame.buttons do
		frame.buttons[i]:Hide()
	end
	return minWidth
end

TieredMenu = { }

function TieredMenu.CreateMenu(parent)
	local menuFrame = CreateFrame("Frame", nil, parent, "BackdropTemplate")
	menuFrame:SetSize(240, 50)
	menuFrame.backdropInfo = BACKDROP_GLUE_TOOLTIP_16_16
	menuFrame.backdropColor = GLUE_BACKDROP_COLOR
	menuFrame.backdropColorAlpha = 1.0
	menuFrame.backdropBorderColor = GLUE_BACKDROP_BORDER_COLOR
	menuFrame:OnBackdropLoaded()
	menuFrame.buttons = CreateFactory(function()
		return Factory_CreateMenuButton(menuFrame)
	end)
	local hovered = false
	local notHovering = 0
	menuFrame:SetScript("OnEnter", function()
		hovered = true
		notHovering = 0
	end)
	menuFrame:SetScript("OnUpdate", function(_, elapsed)
		if (hovered) then
			if (menuFrame:IsMouseOver() or (menuFrame.submenu:IsShown() and menuFrame.submenu:IsMouseOver())) then
				notHovering = 0
			else
				notHovering = notHovering + elapsed
				if (notHovering > 2) then
					hovered = false
					notHovering = 0
					menuFrame:Hide()
					menuFrame.submenu:Hide()
				end
			end
		end
		menuFrame.opening = false
	end)
	menuFrame:SetScript("OnEvent", function()
		if (not (menuFrame.opening or menuFrame:IsMouseOver() or
				(menuFrame.submenu:IsShown() and menuFrame.submenu:IsMouseOver()))) then
			hovered = false
			notHovering = 0
			menuFrame:Hide()
			menuFrame.submenu:Hide()
		end
	end)
	menuFrame:SetScript("OnHide", function()
		hovered = false
		notHovering = 0
	end)
	menuFrame:SetFrameStrata("FULLSCREEN_DIALOG")
	menuFrame:SetToplevel(true)
	menuFrame:SetClampedToScreen(true)
	menuFrame.Display = DisplayMenu
	menuFrame.submenuFunc = DisplaySubMenu
	menuFrame.submenu = CreateFrame("Frame", nil, menuFrame, "BackdropTemplate")
	menuFrame.submenu:SetSize(240, 50)
	menuFrame.submenu.backdropInfo = BACKDROP_GLUE_TOOLTIP_16_16
	menuFrame.submenu.backdropColor = GLUE_BACKDROP_COLOR
	menuFrame.submenu.backdropColorAlpha = 1.0
	menuFrame.submenu.backdropBorderColor = GLUE_BACKDROP_BORDER_COLOR
	menuFrame.submenu:OnBackdropLoaded()
	menuFrame.submenu.buttons = CreateFactory(function()
		return Factory_CreateMenuButton(menuFrame.submenu)
	end)
	menuFrame.submenu:SetPoint("LEFT", menuFrame, "RIGHT")
	menuFrame.submenu:SetFrameStrata("FULLSCREEN_DIALOG")
	menuFrame.submenu:SetToplevel(true)
	menuFrame.submenu:SetClampedToScreen(true)
	menuFrame.submenu:Hide()
	menuFrame:Hide()
	menuFrame:RegisterEvent("GLOBAL_MOUSE_UP")
	return menuFrame
end
