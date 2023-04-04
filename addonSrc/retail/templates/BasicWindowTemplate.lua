--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope()

Templates = Templates or { }

local defaultParams = {
	parent = UIParent,
	alpha = 1.0
}

local backdropInfo = {
	bgFile = "Interface\\Glues\\Common\\Glue-Tooltip-Background",
	edgeFile = "Interface\\Glues\\Common\\Glue-Tooltip-Border",
	tile = true,
	tileEdge = true,
	tileSize = 16,
	edgeSize = 16,
	insets = { left = 10, right = 5, top = 4, bottom = 9 },
};

local backdropColor = CreateColor(0.09, 0.09, 0.09);
local backdropBorderColor = CreateColor(0.8, 0.8, 0.8);

function Templates.CreateBasicWindow(parentFrame, params)
	params = params or defaultParams
	local prefs = params.prefs or { }
	local frame = CreateFrame("Frame",nil, parentFrame, "BackdropTemplate")
	frame.backdropInfo = backdropInfo
	frame.backdropColor = backdropColor
	frame.backdropColorAlpha = params.alpha or defaultParams.alpha
	frame.backdropBorderColor = backdropBorderColor
	frame:SetFrameLevel(3000)
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetClampedToScreen(true)
	frame:SetScript("OnDragStart", function(self)
		if not self.isLocked then
			self:StartMoving()
		end
	end)
	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		prefs.WindowLocation = { self:GetPoint() }
	end)
	if (prefs.WindowLocation and (#prefs.WindowLocation > 0)) then
		frame:ClearAllPoints()
		frame:SetPoint(unpack(prefs.WindowLocation))
	else
		frame:SetPoint("TOP", parentFrame, "CENTER")
	end
	frame:OnBackdropLoaded()
	frame.headerBar = frame:CreateTexture(nil, "BACKGROUND")
	frame.headerBar:SetDrawLayer("BACKGROUND", 2)
	frame.headerBar:SetColorTexture(0.25,0.25,0.25,1)
	frame.headerBar:SetHeight(18)
	frame.headerBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -5)
	frame.headerBar:SetPoint("RIGHT", frame, "RIGHT", -5, 0)
	frame.headerBar:SetAlpha(0.8)
	frame.headerBar:Show()
	frame.footerBar = frame:CreateTexture(nil, "BACKGROUND")
	frame.footerBar:SetDrawLayer("BACKGROUND", 2)
	frame.footerBar:SetColorTexture(0.25,0.25,0.25,1)
	frame.footerBar:SetHeight(17)
	frame.footerBar:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 10)
	frame.footerBar:SetPoint("RIGHT", frame, "RIGHT", -5, 0)
	frame.footerBar:SetAlpha(0.3)
	frame.footerBar:Show()
	frame.title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	frame.title:SetPoint("TOP", frame, "TOP", 0, -8)
	if (params and params.icon) then
		frame.icon = CreateFrame("Button", nil, frame)
		frame.icon:SetSize(32, 32)
		frame.icon:SetPoint("TOPLEFT", frame, "TOPLEFT", -1, 3)
		frame.icon.Background = frame.icon:CreateTexture(nil, "ARTWORK")
		frame.icon.Background:SetSize(25, 25)
		frame.icon.Background:SetTexture("Interface/Minimap/UI-Minimap-Background")
		frame.icon.Background:SetPoint("TOPLEFT", frame.icon, "TOPLEFT", 3, -3)
		frame.icon.Background:SetVertexColor(1,1,1,0.6)
		frame.icon.Background:Show()
		frame.icon.logo = frame.icon:CreateTexture(nil, "ARTWORK")
		frame.icon.logo:SetDrawLayer("ARTWORK", 2)
		frame.icon.logo:SetTexture(params.icon, "CLAMP", "CLAMP", "TRILINEAR")
		frame.icon.logo:SetSize(32, 32)
		frame.icon.logo:SetPoint("TOPLEFT", 7, -6)
		frame.icon.logo:Show()
		frame.icon.Border = frame.icon:CreateTexture(nil, "OVERLAY")
		frame.icon.Border:SetSize(54, 54)
		frame.icon.Border:SetTexture("Interface/Minimap/MiniMap-TrackingBorder")
		frame.icon.Border:SetPoint("TOPLEFT")
		frame.icon.Border:SetDesaturated(1)
	end
	return frame
end