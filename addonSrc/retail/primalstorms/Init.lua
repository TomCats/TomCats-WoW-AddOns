local addonName, addon = ...

addon.PrimalStorms = { }

local function OnEvent(event, arg1)
	if (event == "ADDON_LOADED" and addonName == arg1) then
		TomCats_Account.primalstorms.preferences.enabled = (TomCats_Account.primalstorms.preferences.enabled == nil and true) or TomCats_Account.primalstorms.preferences.enabled
		TomCats_Account.primalstorms.preferences.currency = TomCats_Account.primalstorms.preferences.currency or { }
		TomCats_Account.primalstorms.preferences.dimmedItems = TomCats_Account.primalstorms.preferences.dimmedItems or { }
		addon.UnregisterEvent("ADDON_LOADED", OnEvent)
		addon.PrimalStorms.CreateUI()
	end
end

addon.RegisterEvent("ADDON_LOADED", OnEvent)
