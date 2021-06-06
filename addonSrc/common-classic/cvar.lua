local _, addon = ...

local GetCVar = GetCVar
local SetCVar = SetCVar

local cvarOverrides = {
	mapFade = "1",
	questLogOpen = "0"
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

