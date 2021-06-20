local addonName, addon = ...
if (not addon.loveisintheair.IsEventActive()) then return end

addon.loveisintheair = addon.loveisintheair or { }

local function OnEvent(event, arg1)
	if (event == "ADDON_LOADED" and addonName == arg1) then
		TomCats_Account = TomCats_Account or { }
		TomCats_Account.loveisintheair = TomCats_Account.loveisintheair or { }
		TomCats_Account.loveisintheair.preferences = TomCats_Account.loveisintheair.preferences or { }
		TomCats_Account.loveisintheair.characters = TomCats_Account.loveisintheair.characters or { }
		TomCats_Character = TomCats_Character or { }
		TomCats_Character.loveisintheair = TomCats_Character.loveisintheair or { }
		TomCats_Character.loveisintheair.preferences = TomCats_Character.loveisintheair.preferences or { }
		addon.UnregisterEvent("ADDON_LOADED", OnEvent)
	end
end

addon.RegisterEvent("ADDON_LOADED", OnEvent)