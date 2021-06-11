local addonName, addon = ...

local GetCVar = GetCVar
local SetCVar = SetCVar

local cvarOverrides = {
	questLogOpen = "0",
--	showDungeonEntrancesOnMap = "1"
}

function TomCats_GetCVar(cvar)
	local override = cvarOverrides[cvar]
	if (override ~= nil) then return override end
	if (addon.cvarsAsSavedVariables[cvar]) then
		return _G[addon.cvarsAsSavedVariables[cvar]][cvar]
	end
	return GetCVar(cvar)
end

function TomCats_GetCVarBool(cvar)
	local value = TomCats_GetCVar(cvar)
	return value and value == "1"
end

function TomCats_SetCVar(cvar, val)
	if (cvarOverrides[cvar]) then
		return
	end
	if (addon.cvarsAsSavedVariables[cvar]) then
		if (val and type(val) == "number") then
			val = tostring(val)
		end
		_G[addon.cvarsAsSavedVariables[cvar]][cvar] = val
	else
		SetCVar(cvar, val)
	end
end

local function OnEvent(event, arg1)
	if (event == "VARIABLES_LOADED") then
		-- enforce enabling mapFade on a one-time basis for situations where a glitch caused it to be initially disabled
		if (not TomCats_Character.mapFadeSet) then
			SetCVar("mapFade",1)
			TomCats_Character.mapFadeSet = true
		end
		addon.UnregisterEvent("VARIABLES_LOADED", OnEvent)
	end
end

addon.RegisterEvent("VARIABLES_LOADED", OnEvent)
