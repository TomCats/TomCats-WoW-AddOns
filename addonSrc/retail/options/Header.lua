--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("options")

Header = { }

local boundingBox, mask, section

local function Init()
	boundingBox = CreateFrame("Frame")
	local background = CreateFrame("Frame", nil, boundingBox)
	background:SetAllPoints()
	background:SetFrameStrata("LOW")
	local colorBar = background:CreateTexture(nil, "BACKGROUND")
	colorBar:SetColorTexture((140/0.95)/255, (16/0.95)/255, (16/0.95)/255, 0.95)
	colorBar:SetAllPoints()
	mask = background:CreateMaskTexture()
	mask:SetTexture(Image.Blank, "CLAMPTOWHITE", "CLAMPTOWHITE","TRILINEAR")
	mask:SetAllPoints()
	local logo = boundingBox:CreateTexture(nil, "ARTWORK")
	logo:SetTexture(ImagePNG.tomcats_logo_med_nobg, "CLAMP", "CLAMP", "TRILINEAR")
	logo:SetPoint("TOPRIGHT", 40, 0)
	logo:SetSize(128, 64)
	local title = boundingBox:CreateFontString(nil, "ARTWORK", "Game36Font_Shadow2")
	title:SetTextColor(GameFontNormal:GetTextColor())
	--todo: localize
	title:SetText("TomCat's Tours")
	title:SetPoint("BOTTOMLEFT", 29, 16)
	section = boundingBox:CreateFontString(nil, "ARTWORK", "Game18Font")
	section:SetText("")
	section:SetShadowColor(0, 0, 0, 1)
	section:SetShadowOffset(2, -1)
	section:SetPoint("LEFT", title, "RIGHT")
	section:SetPoint("RIGHT", logo, "LEFT")
	section:SetPoint("BOTTOM", boundingBox, "BOTTOM", 0, 20)
	local version = boundingBox:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	--todo: localize
	version:SetText(string.format("Version %s", Version.number))
	version:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 7, 2)
	local divider = boundingBox:CreateTexture()
	divider:SetAtlas("Options_HorizontalDivider", true)
	divider:SetPoint("TOP", 0, -59)
	SettingsPanel.Bg.TopSection:AddMaskTexture(mask)
end

function Header.Acquire(parent, sectionName)
	Init = Init() or nop
	boundingBox:SetParent(parent)
	boundingBox:ClearAllPoints()
	boundingBox:SetPoint("TOPLEFT", parent, "TOPLEFT", -14, 10)
	boundingBox:SetPoint("BOTTOMRIGHT", parent, "TOPRIGHT", 3, -50)
	boundingBox:Show()
	section:SetText(sectionName or "")
	SettingsPanel.Bg.TopSection:AddMaskTexture(mask)
end

function Header.Release()
	boundingBox:Hide()
	SettingsPanel.Bg.TopSection:RemoveMaskTexture(mask)
end
