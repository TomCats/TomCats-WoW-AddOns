--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local function OverlayVariables(template, overlay)
	local newVars = { }
	for k, v in pairs(template) do
		if (overlay[k] ~= nil and type(v) == type(overlay[k])) then
			if (type(v) == "table") then
				newVars[k] = (v == HINT_ALL) and overlay[k] or OverlayVariables(v, overlay[k])
			else
				newVars[k] = overlay[k]
			end
		else
			newVars[k] = (v == HINT_ALL) and { } or v
		end
	end
	return newVars
end

local function OnEvent(event, arg1)
	if (event == "ADDON_LOADED") then
		if (addonName == arg1) then
			for k, v in pairs(defaultSavedVariables) do
				AddAllowedGlobals(k)
				_G[k] = OverlayVariables(v, _G[k] or { })
			end
			UnregisterEvent("ADDON_LOADED", OnEvent)
		end
	end
end

RegisterEvent("ADDON_LOADED", OnEvent)
