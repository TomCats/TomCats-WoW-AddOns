--[[ See license.txt for license and copyright information ]]
local _, addon = ...

local C_Map = C_Map
local CreateFrame = CreateFrame

local interval = 1/60
local timeSinceUpdate = 0
local playerPositionX, playerPositionY, uiMapID

local function OnUpdate(_, elapsed)
	timeSinceUpdate = timeSinceUpdate + elapsed
	if (timeSinceUpdate > interval) then
		timeSinceUpdate = 0
		uiMapID = C_Map.GetBestMapForUnit("player")
		if (uiMapID) then
			local playerPosition = C_Map.GetPlayerMapPosition(uiMapID, "player")
			if (playerPosition) then
				playerPositionX, playerPositionY = playerPosition.x, playerPosition.y
			else
				playerPositionX, playerPositionY = nil, nil
			end
		end
	end
end

local frame = CreateFrame("FRAME")
frame:SetScript("OnUpdate", OnUpdate)

function addon.GetPlayerPosition()
	return playerPositionX, playerPositionY, uiMapID
end

-- refresh player position when:
--  player is moving every 1/5 second and on a map where their position can be tracked
--  player has changed zones - best map for player will have changed
