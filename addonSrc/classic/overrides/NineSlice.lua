--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local CreateTexture = getglobal("UIParent").CreateTexture

local function CreateTextureOverride(self, ...)
	local texture = CreateTexture(self, ...)
	texture.SetAtlas = SetAtlas
	return texture
end

local Onload = NineSlicePanelMixin.OnLoad
function NineSlicePanelMixin:OnLoad()
	self.CreateTexture = CreateTextureOverride
	Onload(self)
end
