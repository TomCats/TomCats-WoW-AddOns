local addonName, addon = ...
if (not addon.midsummer.IsEventActive()) then return end

local function OnEvent(event, arg1)
	if (event == "ADDON_LOADED" and addonName == arg1) then
		TomCats_Account = TomCats_Account or { }
		TomCats_Account.midsummer = TomCats_Account.midsummer or {
			discovered = false,
			autoEnabled = true,
			iconsEnabled = true
		}
		TomCats_Account.midsummer.preferences = TomCats_Account.midsummer.preferences or { }
		addon.UnregisterEvent("ADDON_LOADED", OnEvent)
	end
end

addon.RegisterEvent("ADDON_LOADED", OnEvent)
