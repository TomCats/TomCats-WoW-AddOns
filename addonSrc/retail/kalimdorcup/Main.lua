local addonName, addon = ...

local function OnEvent(self, _, arg1)
	if (arg1 == addonName) then
		self:UnregisterEvent("ADDON_LOADED")
		WorldMapFrame:AddDataProvider(addon.wrap(CreateFromMixins(TomCatsKalimdorCupDataProviderMixin)))
	end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", OnEvent)
