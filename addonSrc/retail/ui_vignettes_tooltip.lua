--[[ See license.txt for license and copyright information ]]
local _, addon = ...

local GameTooltip = GameTooltip
local hooksecurefunc = hooksecurefunc
local LOOT_NOUN = LOOT_NOUN

local LOOT_TYPE = addon.constants.lootTypes
local TomCatsVignetteTooltip

local lootIcons = {
	[LOOT_TYPE.UNKNOWN] = 134400, -- question mark
	[LOOT_TYPE.MOUNT] = "StableMaster",
	[LOOT_TYPE.COMPANION_PET] = "WildBattlePetCapturable",
	[LOOT_TYPE.TOY] = 237429,
	[LOOT_TYPE.DRAKEWATCHER_MANUSCRIPT] = "dragon-rostrum",
}

local itemBorderAtlases = {
	"auctionhouse-itemicon-border-gray",
	"auctionhouse-itemicon-border-white",
	"auctionhouse-itemicon-border-green",
	"auctionhouse-itemicon-border-blue",
	"auctionhouse-itemicon-border-purple",
	"auctionhouse-itemicon-border-orange",
	"auctionhouse-itemicon-border-artifact",
	"auctionhouse-itemicon-border-account",
	"auctionhouse-itemicon-border-account"
}

TomCatsVignetteTooltipMixin = { }

function TomCatsVignetteTooltipMixin:OnLoad()
	TomCatsVignetteTooltip = self
	self:RegisterEvent("ITEM_DATA_LOAD_RESULT")
end

function TomCatsVignetteTooltipMixin:SetOwner(owner)
	if (not owner) then
		self.owner = nil
		self:Hide()
		return
	end
	self:ClearAllPoints()
	self.owner = owner
	local alias = owner.vignette["Alias"]
	self:SetPoint("BOTTOMLEFT",owner,"TOPRIGHT", -4, -8)
	self.Text[1]:SetText(("|cff0070dd%s|r"):format(owner.vignette["Name"]))
	self.Text[1]:Show()
	-- Elite / Rare Elite line
	self.Text[2]:Hide()
	-- Description lines
	local description
	if (not alias) then
		description = addon.vignetteDescriptions[owner.vignette.ID]
	else
		description = addon.vignetteDescriptions[alias.ID]
	end
	if (description) then
		self.Text[3]:SetText(description)
		self.Text[3]:Show()
	else
		self.Text[3]:Hide()
	end
	local loot
	if (not alias) then
		loot = addon.getLootDisplayInfo(owner.vignette["Items"])
	else
		loot = addon.getLootDisplayInfo(alias["Items"])
	end
	if (#loot == 0) then
		self.Text[4]:Hide()
	else
		self.Text[4]:SetText(LOOT_NOUN .. ":")
		self.Text[4]:Show()
		self.Loot[1]:SetPoint("TOP", self.Text[4], "BOTTOM", 0, -6)
		self.Loot[1]:SetPoint("LEFT", 10, 0)
	end
	local prevElement = self.Text[1]
	for _, v in ipairs(self.Text) do
		if (v:IsShown()) then
			v:ClearAllPoints()
			if (v.topPadding) then
				v:SetPoint("TOP", prevElement, "BOTTOM", 0, -v.topPadding)
			else
				v:SetPoint("TOP", self, "TOP", 0, -10)
			end
			v:SetPoint("LEFT", self, "LEFT", 10, 0)
			v:SetPoint("RIGHT", self, "RIGHT", -10, 0)
			prevElement = v
		else
			v:ClearAllPoints()
		end
	end
	for k, v in ipairs(self.Loot) do
		local lootItem = loot[k]
		if (lootItem) then
			v.Icon:SetTexture(lootItem.itemTexture)
			v.IconBorder:SetAtlas(itemBorderAtlases[lootItem.itemRarity + 1])
			v.CategoryIcon.IconBorder:SetAtlas(itemBorderAtlases[7])
			local icon = lootIcons[lootItem.lootType]
			if (not icon) then icon = lootIcons[LOOT_TYPE.UNKNOWN] end
			if (lootItem.lootType == LOOT_TYPE.UNKNOWN) then
				v.CategoryIcon:Hide()
			else
				if (type(icon) == "string") then
					v.CategoryIcon.Icon:SetAtlas(icon)
				else
					v.CategoryIcon.Icon:SetTexture(icon)
				end
				v.CategoryIcon:Show()
			end
			v.Text[1]:SetText(lootItem.itemName)
			v.Text[1]:Show()
			if (lootItem.collectedString) then
				v.Text[2]:SetText(lootItem.collectedString)
				v.Text[2]:Show()
			else
				v.Text[2]:Hide()
			end
			if (k ~= 1) then
				v:SetPoint("TOP", self.Loot[k-1], "TOP", 0, -50)
			end
			v:Show()
		else
			v:Hide()
		end
	end
	self.resize = true
	if ((not GameTooltip:IsShown()) or GameTooltip:GetOwner() == UIParent) then
		self.yielding = nil
		self:Show()
	end
end

function TomCatsVignetteTooltipMixin:OnUpdate()
	if (self:IsShown() and self.resize) then
		self.resize = nil
		local totalHeight = 10
		for _, v in ipairs(self.Text) do
			if (v:IsShown()) then
				totalHeight = totalHeight + v:GetLineHeight() * v:GetNumLines() + (v.topPadding or 0)
			end
		end
		totalHeight = totalHeight + 6
		for _, v in ipairs(self.Loot) do
			if (v:IsShown()) then
				totalHeight = totalHeight + 50
			end
		end
		totalHeight = totalHeight + 8
		self:SetHeight(totalHeight)
	end
end

function TomCatsVignetteTooltipMixin:OnEvent(event, ...)
	if (event == "ITEM_DATA_LOAD_RESULT") then
		if (self:IsShown() or self.resize) then
			self:SetOwner(self.owner)
		end
	end
end

local function startYielding()
	TomCatsVignetteTooltip.yielding = true
	TomCatsVignetteTooltip:Hide()
end

local function stopYielding()
	TomCatsVignetteTooltip.yielding = nil
	if (TomCatsVignetteTooltip.owner) then
		TomCatsVignetteTooltip:Show()
	end
end

hooksecurefunc(GameTooltip, "Show", startYielding)
hooksecurefunc(GameTooltip, "Hide", stopYielding)
