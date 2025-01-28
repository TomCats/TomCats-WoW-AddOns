--[[ See license.txt for license and copyright information ]]
local _, addon = ...

local C_ContributionCollector = C_ContributionCollector
local C_QuestLog = C_QuestLog
local C_TaskQuest = C_TaskQuest
local CreateFrame = CreateFrame
local UnitFactionGroup = UnitFactionGroup

local rulePrepend = "local g, o, c, f = ... "
local warfrontStates = { 1, 1, 2, 2 }

local functions = {
	["containsAny"] = function(tbl1, tbl2)
		for _, v in ipairs(tbl2) do
			if (tbl1[v]) then return true end
		end
		return false
	end
}

addon.ruleListeners = { }

local interval, minInterval, maxInterval = 1/15, 1/15, 1.0
local timeSinceLastUpdate = 0

local mapActivationRules = {
	[14] = loadstring(rulePrepend .. "return g.arathiVisible"),
	[62] = loadstring(rulePrepend .. "return g.darkshoreVisible"),
}

local visibilityRules = {
	["default"] = function() return true end,
	["arathi"] = loadstring(rulePrepend .. "return g.arathiPhase and (o.Phase == 3 or o.Phase == g.arathiPhase) and (o.Hostile == 3 or o.Hostile == g.playerFaction)"),
	["darkshore"] = loadstring(rulePrepend .. "return g.darkshorePhase and (o.Phase == 3 or o.Phase == g.darkshorePhase) and (o.Hostile == 3 or o.Hostile == g.playerFaction)"),
	["uldum"] = loadstring(rulePrepend .. "return g.uldumPhase and bit.band(o.Phase, g.uldumPhase) == g.uldumPhase"),
	["vale"] = loadstring(rulePrepend .. "return g.valePhase and bit.band(o.Phase, g.valePhase) == g.valePhase"),
	-- priority: Spawned rare > default rare
	--[[
		If the VignetteID has coordinates, display it on the map
			unless it has related vignettes and at least one of them is visible (g.vignettes)
	]]
	["shadowlands"] = loadstring(rulePrepend .. "if (o.Locations and o.Related and f.containsAny(g.vignettes, o.Related) and not g.vignettes[o.ID]) then return c.visibilityTypes.LIST end return c.visibilityTypes.ALL"),
	["dragonflight"] = loadstring(rulePrepend .. "return (o.SkillID[1] == nil or o.SkillID[1] == 0 or g.PlayerHasSkillID(o.SkillID[1])) and (o.Achievement[0] == nil or o.Achievement[0] == 0 or select(4, o.Achievement[0]))")
}

local locationRules = {
	["default"] = loadstring(rulePrepend .. "return o.Locations[1]"),
	["arathi"] = loadstring(rulePrepend .. "if #o.Locations == 1 then return o.Locations[1] end return o.Locations[g.arathiPhase]")
}

local trackingRules = {
	["default"] = loadstring(rulePrepend .. "return C_QuestLog.IsQuestFlaggedCompleted(o.VisibleTrackingQuestID)"),
	["arathi"] = loadstring(rulePrepend .. "return C_QuestLog.IsQuestFlaggedCompleted(o.PrevQuestID[(o.Hostile == 3 and g.playerFaction) or 1])"),
	["darkshore"] = loadstring(rulePrepend .. "return C_QuestLog.IsQuestFlaggedCompleted(o.VisibleTrackingQuestID) or C_QuestLog.IsQuestFlaggedCompleted(o.PrevQuestID[(o.Hostile == 3 and g.playerFaction) or 1])")
}

local completedVisibilityRules = {
	["default"] = loadstring(rulePrepend .. "return true"),
	["hasOnce"] = loadstring(rulePrepend .. "return not o.Once"),
}

local function executeRule(ruleSet, ruleName, obj)
	return ruleSet[ruleName](addon.globals, obj, addon.constants, functions)
end

function addon.executeVisibilityRule(ruleName, obj)
	return executeRule(visibilityRules, ruleName, obj)
end

function addon.executeLocationRule(ruleName, obj)
	return executeRule(locationRules, ruleName, obj)
end

function addon.executeTrackingRule(ruleName, obj)
	return executeRule(trackingRules, ruleName, obj)
end

function addon.executeCompletedVisibilityRule(ruleName, obj)
	return executeRule(completedVisibilityRules, ruleName, obj)
end

function addon.executeMapActivationRule(mapID)
	if (mapActivationRules[mapID]) then
		return mapActivationRules[mapID](addon.globals)
	else
		return true
	end
end

local function NotifyRuleListeners()
	if (rawget(addon.globals,"changed")) then
		rawset(addon.globals,"changed", nil)
		for _, v in ipairs(addon.ruleListeners) do
			v()
		end
	end
end

local function IsTimeDurationQuestActive(questID)
	return C_TaskQuest.GetQuestTimeLeftMinutes(questID) or C_QuestLog.IsQuestFlaggedCompleted(questID)
end

local function OnUpdate(_, elapsed)
	timeSinceLastUpdate = timeSinceLastUpdate + elapsed
	if (timeSinceLastUpdate > interval) then
		timeSinceLastUpdate = 0
		addon.globals.arathiPhase = warfrontStates[C_ContributionCollector.GetState(11)]
		addon.globals.arathiVisible = not C_QuestLog.IsQuestFlaggedCompleted(52781) and not C_PlayerInfo.IsPlayerInChromieTime()
		addon.globals.darkshorePhase = warfrontStates[C_ContributionCollector.GetState(118)]
		addon.globals.darkshoreVisible = not C_QuestLog.IsQuestFlaggedCompleted(54411) and not C_PlayerInfo.IsPlayerInChromieTime()
		if (addon.globals.arathiPhase and addon.globals.darkshorePhase) then
			interval = maxInterval
		else
			interval = minInterval
		end
		if (IsTimeDurationQuestActive(57157)) then
			addon.globals.uldumPhase = 1
		elseif (IsTimeDurationQuestActive(56308)) then
			addon.globals.uldumPhase = 2
		elseif (IsTimeDurationQuestActive(55350)) then
			addon.globals.uldumPhase = 4
		else
			addon.globals.uldumPhase = 0
		end
		if (IsTimeDurationQuestActive(56064)) then
			addon.globals.valePhase = 1
		elseif (IsTimeDurationQuestActive(57728)) then
			addon.globals.valePhase = 2
		elseif (IsTimeDurationQuestActive(57008)) then
			addon.globals.valePhase = 4
		else
			addon.globals.valePhase = 0
		end
		addon.globals.betaEnabled = addon.IsBetaEnabled and addon.IsBetaEnabled()
		addon.globals.vignettes = addon.globals.vignettes or { }
		addon.globals.PlayerHasSkillID = addon.PlayerHasSkillID
		local vignettesChanged = false
		if (addon.vignetteGUIDsByVignetteID) then
			for k in pairs(addon.vignetteGUIDsByVignetteID) do
				if (not addon.globals.vignettes[k]) then
					addon.globals.vignettes[k] = true
					vignettesChanged = true
				end
			end
			local removals
			for k in pairs(addon.globals.vignettes) do
				if (not addon.vignetteGUIDsByVignetteID[k]) then
					removals = removals or { }
					table.insert(removals,k)
				end
			end
			if (removals) then
				vignettesChanged = true
				for _, v in ipairs(removals) do
					addon.globals.vignettes[v] = nil
				end
			end
			if (vignettesChanged) then
				rawset(addon.globals,"changed", true)
			end
		end
	end
	NotifyRuleListeners()
end

local g = { }

g.factions = { Alliance = 1, Horde = 2, Neutral = 3 }
g.playerFaction = g.factions[UnitFactionGroup("player")]
g.playerIsAlliance = g.playerFaction == g.factions.Alliance
g.playerIsHorde = g.playerFaction == g.factions.Horde

addon.globals = { }

setmetatable(addon.globals, {
	__index = function(_,k)
		return g[k]
	end,
	__newindex = function(t,k,v)
		if (g[k] ~= v) then
			rawset(t,"changed", true)
			g[k] = v
		end
	end
})

local frame = CreateFrame("FRAME")
OnUpdate(frame, maxInterval + 1)
frame:SetScript("OnUpdate", OnUpdate)
