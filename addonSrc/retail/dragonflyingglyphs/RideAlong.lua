local _, addon = ...

local TCL = addon.TomCatsLibs
local PREFIX = "TCT_RIDEALONG"
local D = TCL.Data
local currentPassenger
local currentPassengerData
local achievementIDXs = { }

local achievementIDs = { }
for k in pairs(D["Quests"].records) do
	table.insert(achievementIDs, k)
end
table.sort(achievementIDs)
for k, v in ipairs(achievementIDs) do
	achievementIDXs[v] = k
end

local function transmitUpdate()
	if (UnitInParty("player")) then
		local isRidingAlong
		for i = 1, 40 do
			local debuff = select(10, UnitDebuff("player", i))
			if (not debuff) then
				break
			end
			if (debuff == 390108) then
				isRidingAlong = true
				break
			end
		end
		if (isRidingAlong) then
			local response = { }
			table.insert(response,"R")
			for _, v in ipairs(achievementIDs) do
				local completed = select(4, GetAchievementInfo(v))
				if (completed) then
					table.insert(response, "1")
				else
					table.insert(response, "0")
				end
			end
			C_ChatInfo.SendAddonMessage(PREFIX, table.concat(response), "RAID")
		end
	end
end

local function msgReceived(_, _, prefix, msg, _, _, sender)
	if (prefix == PREFIX) then
		if (not currentPassenger and msg == "UPDATEME") then
			transmitUpdate()
		end
		if (currentPassenger and currentPassenger == sender and msg and string.sub(msg, 1, 1) == "R") then
			currentPassengerData = string.sub(msg, 2)
			addon.dragonflyingglyphs.RefreshAll()
		end
	end
end

local function passengersChanged(_, event)
	local hasRideAlong
	for i = 1, 40 do
		local aura = select(10, UnitAura("player", i))
		if (not aura) then
			break
		end
		if (aura == 388599) then
			hasRideAlong = true
			break
		end
	end
	if (hasRideAlong) then
		local _, passenger, realm = UnitVehicleSeatInfo("player", 1)
		if (passenger) then
			if (realm) then passenger = passenger .. "-" .. realm end
			currentPassenger = passenger
			C_ChatInfo.SendAddonMessage(PREFIX, "UPDATEME", "RAID")
		else
			currentPassenger = nil
			currentPassengerData = nil
		end
	else
		currentPassenger = nil
		currentPassengerData = nil
	end
end

local function init()
	C_ChatInfo.RegisterAddonMessagePrefix(PREFIX)
	passengersChanged()
	transmitUpdate()
end

TCL.Events.RegisterEvent("VEHICLE_PASSENGERS_CHANGED", passengersChanged)
TCL.Events.RegisterEvent("PLAYER_ENTERING_WORLD", init)
TCL.Events.RegisterEvent("CHAT_MSG_ADDON", msgReceived)

TCL.Events.RegisterEvent("CRITERIA_EARNED", transmitUpdate)
TCL.Events.RegisterEvent("CRITERIA_COMPLETE", transmitUpdate)
TCL.Events.RegisterEvent("ACHIEVEMENT_EARNED", transmitUpdate)

function addon.dragonflyingglyphs.IsRideAlongComplete(achievementID)
	if (not currentPassenger or not currentPassengerData) then
		return true
	end
	local idx = achievementIDXs[achievementID]
	if (not idx) then
		return true
	end
	local status = string.sub(currentPassengerData, idx, idx)
	if (status == "0") then return false else return true end
end
