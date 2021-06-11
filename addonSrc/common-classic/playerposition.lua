local addonName, addon = ...

local CreateFrame = CreateFrame
local UnitPosition = UnitPosition
local lastPlayerPosition

local function OnUpdate()
	local x, y = UnitPosition("player")
	if (x) then
		lastPlayerPosition.x = x
		lastPlayerPosition.y = y
	end
end

function addon:GetLastPlayerPosition()
	return lastPlayerPosition.x, lastPlayerPosition.y
end

local function OnEvent(event, arg1)
	if (event == "ADDON_LOADED") then
		if (addonName == arg1) then
			local frame = CreateFrame("Frame")
			lastPlayerPosition = _G.TomCats_Character.lastPlayerPosition
			frame:SetScript("OnUpdate", OnUpdate)
		end
	end
end

addon.RegisterEvent("ADDON_LOADED", OnEvent)
