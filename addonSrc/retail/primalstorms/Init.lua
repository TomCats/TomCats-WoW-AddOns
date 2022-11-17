local addonName, addon = ...

addon.PrimalStorms = { }

local function OnEvent(event, arg1)
	if (event == "ADDON_LOADED" and addonName == arg1) then
		TomCats_Account.primalstorms.preferences.enabled = (TomCats_Account.primalstorms.preferences.enabled == nil and true) or TomCats_Account.primalstorms.preferences.enabled
		TomCats_Account.primalstorms.preferences.eligibleClasses = TomCats_Account.primalstorms.preferences.eligibleClasses or {
			false,false,false,false,false,false,false,false,false,false,false,false,false
		}
		TomCats_Account.primalstorms.preferences.currency = TomCats_Account.primalstorms.preferences.currency or { }
		TomCats_Account.primalstorms.preferences.dimmedItems = TomCats_Account.primalstorms.preferences.dimmedItems or { }
		local newCurrency = { }
		for k, v in pairs(TomCats_Account.primalstorms.preferences.currency) do
			if (v ~= 0) then
				newCurrency[k] = v
			end
		end
		TomCats_Account.primalstorms.preferences.currency = newCurrency
		local newDimmedItems = { }
		for k, v in pairs(TomCats_Account.primalstorms.preferences.dimmedItems) do
			local keep = false
			for k1 in pairs(addon.PrimalStorms.Elements) do
				if (v[k1] and v[k1] > 0) then
					keep = true
				end
			end
			if (keep) then
				newDimmedItems[k] = v
			end
		end
		TomCats_Account.primalstorms.preferences.dimmedItems = newDimmedItems
		addon.UnregisterEvent("ADDON_LOADED", OnEvent)
		addon.PrimalStorms.CreateUI()
	end
end

addon.RegisterEvent("ADDON_LOADED", OnEvent)
