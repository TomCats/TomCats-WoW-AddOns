--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local GetCVar_Orig = getglobal("GetCVar")
local SetCVar_Orig = getglobal("SetCVar")

local cvarOverrides = {
	questLogOpen = "0",
}

function GetCVar(cvar)
	local override = cvarOverrides[cvar]
	if (override ~= nil) then return override end
	if (cvarsAsSavedVariables[cvar]) then
		return _G[cvarsAsSavedVariables[cvar]][cvar]
	end
	return GetCVar_Orig(cvar)
end

function GetCVarBool(cvar)
	local value = GetCVar(cvar)
	return value and value == "1"
end

function SetCVar(cvar, val)
	if (cvarOverrides[cvar]) then
		return
	end
	if (cvarsAsSavedVariables[cvar]) then
		if (val and type(val) == "number") then
			val = tostring(val)
		end
		_G[cvarsAsSavedVariables[cvar]][cvar] = val
	else
		SetCVar_Orig(cvar, val)
	end
end

local function OnEvent(event, arg1)
	if (event == "VARIABLES_LOADED") then
		-- enforce enabling mapFade on a one-time basis for situations where a glitch caused it to be initially disabled
		if (not TomCats_Character.mapFadeSet) then
			SetCVar_Orig("mapFade", 1)
			TomCats_Character.mapFadeSet = true
		end
		UnregisterEvent("VARIABLES_LOADED", OnEvent)
	end
end

RegisterEvent("VARIABLES_LOADED", OnEvent)
