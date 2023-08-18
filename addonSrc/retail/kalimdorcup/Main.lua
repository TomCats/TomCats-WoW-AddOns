local addonName, addon = ...

if (not addon.KalimdorCup.IsEventActive()) then return end

local trackVignettePins, Hook_AcquirePin, setupVignettePinOverride, Hook_Pin_Show
local trackedVignettePins = { }
local vignettePinOverridesIDs = {
	[5104] = true
}

local function OnEvent(self, _, arg1)
	if (arg1 == addonName) then
		self:UnregisterEvent("ADDON_LOADED")
		WorldMapFrame:AddDataProvider(addon.wrap(CreateFromMixins(TomCatsKalimdorCupDataProviderMixin)))
		setupVignettePinOverride(WorldMapFrame)
	end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", OnEvent)

function trackVignettePins(mapFrame)
	local pinPool = mapFrame.pinPools[_G.VignetteDataProviderMixin:GetPinTemplate()]
	if (pinPool) then
		for pin in pinPool:EnumerateActive() do
			if (not trackedVignettePins[pin]) then
				trackedVignettePins[pin] = true
				hooksecurefunc(pin, "Show", Hook_Pin_Show)
				hooksecurefunc(pin, "SetShown", Hook_Pin_Show)
				Hook_Pin_Show(pin)
			end
		end
	end
end

function Hook_Pin_Show(self, setShown)
	if (setShown == false) then return end
	if (self.vignetteID and vignettePinOverridesIDs[self.vignetteID]) then
		self:Hide()
	end
end

function Hook_AcquirePin(self, pinTemplate, ...)
	if (pinTemplate == _G.VignetteDataProviderMixin:GetPinTemplate() or pinTemplate == "AreaPOIPinTemplate") then
		trackVignettePins(self)
	end
end

function setupVignettePinOverride(mapFrame)
	hooksecurefunc(mapFrame, "AcquirePin", Hook_AcquirePin)
	trackVignettePins(mapFrame)
end
