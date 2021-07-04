select(2, ...).SetupGlobalFacade()

local lastPlayerPosition

local function OnUpdate()
	local x, y = UnitPosition("player")
	if (x) then
		lastPlayerPosition.x = x
		lastPlayerPosition.y = y
	end
end

function GetLastPlayerPosition()
	return lastPlayerPosition.x, lastPlayerPosition.y
end

local function OnEvent(event, arg1)
	if (event == "ADDON_LOADED") then
		if (addonName == arg1) then
			local frame = CreateFrame("Frame")
			lastPlayerPosition = TomCats_Character.lastPlayerPosition
			frame:SetScript("OnUpdate", OnUpdate)
		end
	end
end

RegisterEvent("ADDON_LOADED", OnEvent)
