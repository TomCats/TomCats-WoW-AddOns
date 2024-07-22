--[[ See license.txt for license and copyright information ]]
local addonName, addon = ...

local DisableAddOn = C_AddOns.DisableAddOn

local expiredAddOns = {
	"TomCats-ArathiHighlandsRares",
	"TomCats-DarkshoreRares",
	"TomCats-Mechagon",
	"TomCats-Nazjatar",
	"TomCats-Nzoth",
	"TomCats-WarfrontsCommandCenter",
	"TomCats-Complete",
	"TomCats-ChildrensWeek",
	"TomCats-HallowsEnd",
	"TomCats-LoveIsInTheAir",
	"TomCats-LunarFestival",
	"TomCats-Noblegarden"
}

local function OnEvent(event, arg1)
	if (event == "ADDON_LOADED") then
		if (addonName == arg1) then
			for _, expiredAddOn in ipairs(expiredAddOns) do
				DisableAddOn(expiredAddOn)
			end
			addon.UnregisterEvent("ADDON_LOADED", OnEvent)
		end
	end
end
addon.RegisterEvent("ADDON_LOADED", OnEvent)
