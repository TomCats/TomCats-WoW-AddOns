--[[
Maps.lua
Copyright (C) 2018-2022 TomCat's Tours
All rights reserved.

For more information, contact via email at tomcat@tomcatstours.com
(or visit https://www.tomcatstours.com)
]]
local _, addon = ...
if (not addon.hallowsend.IsEventActive()) then return end
--select(2, ...).SetupGlobalFacade()

local C_Map = C_Map
local CreateVector2D = CreateVector2D

local maps = { }
local topLeft = CreateVector2D(0,0)
local bottomRight = CreateVector2D(1,1)

local function getMapInfo(uiMapID)
	maps[uiMapID] = maps[uiMapID] or { }
	return maps[uiMapID]
end

local function GetMapScale(uiMapID)
	local mapInfo = getMapInfo(uiMapID)
	if (not mapInfo.mapScaleX) then
		local _, worldTopLeft = C_Map.GetWorldPosFromMapPos(uiMapID, topLeft)
		local _, worldBottomRight = C_Map.GetWorldPosFromMapPos(uiMapID, bottomRight)
		mapInfo.mapScaleX = math.abs(worldBottomRight.x - worldTopLeft.x)
		mapInfo.mapScaleY = math.abs(worldBottomRight.y - worldTopLeft.y)
	end
	return mapInfo.mapScaleX, mapInfo.mapScaleY
end

function addon.GetWorldPosFromMapPos(x, y, uiMapID)
	local mapScaleX, mapScaleY = GetMapScale(uiMapID)
	return x * mapScaleX, y * mapScaleY
end

function addon.GetDistanceInYards(x1, y1, x2, y2)
	return math.sqrt((x2 - x1)^2+(y2 - y1)^2)
end

function addon.GetDistanceInYards2(uiMapID, x1, y1, x2, y2)
	local mapScaleX, mapScaleY = GetMapScale(uiMapID)
	return math.sqrt((x2 * mapScaleX - x1 * mapScaleX)^2+(y2 * mapScaleY - y1 * mapScaleY)^2)
end
