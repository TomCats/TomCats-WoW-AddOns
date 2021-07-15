--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local SetAtlas_Orig
local imagePath = ("Interface\\AddOns\\%s\\images\\"):format(addonName) .. "%s"
local buttonFunctions

do
	local frame = CreateFrame("Frame")
	local texture = frame:CreateTexture()
	SetAtlas_Orig = texture.SetAtlas

	local button = CreateFrame("Button")
	buttonFunctions = {
		["Normal"] = {
			orig = button.SetNormalAtlas,
			GetTexture = button.GetNormalTexture,
			SetTexture = button.SetNormalTexture,
		},
		["Highlight"] = {
			orig = button.SetHighlightAtlas,
			GetTexture = button.GetHighlightTexture,
			SetTexture = button.SetHighlightTexture,
		},
		["Pushed"] = {
			orig = button.SetPushedAtlas,
			GetTexture = button.GetPushedTexture,
			SetTexture = button.SetPushedTexture,
		}
	}
end

function SetAtlas(self, atlasName, useAtlasSize, filterMode)
	if (C_Texture.IsOverridden(atlasName)) then
		local atlasInfo = C_Texture.GetAtlasInfo(atlasName)
		self:SetTexture(imagePath:format(atlasInfo.file))
		self:SetTexCoord(atlasInfo.leftTexCoord, atlasInfo.rightTexCoord, atlasInfo.topTexCoord, atlasInfo.bottomTexCoord)
		if useAtlasSize then
			self:SetSize(atlasInfo.width * (atlasInfo.scale or 1), atlasInfo.height * (atlasInfo.scale or 1))
		else
			self:SetSize(atlasInfo.width, atlasInfo.height)
		end
		self:SetHorizTile(atlasInfo.tilesHorizontally)
		self:SetVertTile(atlasInfo.tilesVertically)
	else
		SetAtlas_Orig(self, atlasName, useAtlasSize, filterMode)
	end
end

local function SetButtonAtlas(self, atlasName, blendmode, textureType)
	local functions = buttonFunctions[textureType]
	if (C_Texture.IsOverridden(atlasName)) then
		local atlasInfo = C_Texture.GetAtlasInfo(atlasName)
		functions.SetTexture(self, imagePath:format(atlasInfo.file))
		local texture = functions.GetTexture(self)
		texture:SetTexCoord(atlasInfo.leftTexCoord, atlasInfo.rightTexCoord, atlasInfo.topTexCoord, atlasInfo.bottomTexCoord)
		texture:SetSize(atlasInfo.width, atlasInfo.height)
		texture:SetHorizTile(atlasInfo.tilesHorizontally)
		texture:SetVertTile(atlasInfo.tilesVertically)
	else
		functions.orig(self, atlasName, blendmode)
	end
end

function SetNormalAtlas(self, atlasName, blendMode)
	SetButtonAtlas(self, atlasName, blendMode, "Normal")
end

function SetHighlightAtlas(self, atlasName, blendMode)
	SetButtonAtlas(self, atlasName, blendMode, "Highlight")
end

function SetPushedAtlas(self, atlasName, blendMode)
	SetButtonAtlas(self, atlasName, blendMode, "Pushed")
end

function OverrideButtonAtlases(button)
	button.SetNormalAtlas = SetNormalAtlas
	button.SetHighlightAtlas = SetHighlightAtlas
	button.SetPushedAtlas = SetPushedAtlas
end

--function TomCatsSetAtlas(texture, atlasName, useAtlasScale)
--	local info = TomCatsGetAtlasInfo(atlasName)
--	texture:SetTexture(FileNameLookup[info.file])
--	texture:SetTexCoord(info.leftTexCoord, info.rightTexCoord, info.topTexCoord, info.bottomTexCoord)
--	if useAtlasScale then
--		texture:SetSize(info.width * (info.scale or 1), info.height * (info.scale or 1))
--	else
--		texture:SetSize(info.width, info.height)
--	end
--	texture:SetHorizTile(info.tilesHorizontally)
--	texture:SetVertTile(info.tilesVertically)
--end
