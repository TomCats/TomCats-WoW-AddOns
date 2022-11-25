local addonName, addon = ...

addon.dragonflyingglyphs = addon.dragonflyingglyphs or { }

local function OnEvent(event, arg1)
	if (event == "ADDON_LOADED" and addonName == arg1) then
		TomCats_Account = TomCats_Account or { }
		TomCats_Account.dragonflyingglyphs = TomCats_Account.dragonflyingglyphs or {
			discovered = false,
			autoEnabled = true,
			iconsEnabled = true
		}
		TomCats_Account.dragonflyingglyphs.preferences = TomCats_Account.dragonflyingglyphs.preferences or { }
		addon.UnregisterEvent("ADDON_LOADED", OnEvent)
	end
end

addon.RegisterEvent("ADDON_LOADED", OnEvent)
