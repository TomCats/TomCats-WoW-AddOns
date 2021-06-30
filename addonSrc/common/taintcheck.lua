local addonName, addon = ...

local taintLog = {

}

local checked = {

}

local function CreateNewKey(keys, newValue)
	local newKeys = { }
	for k, v in ipairs(keys) do
		table.insert(newKeys, v)
	end
	table.insert(newKeys,".")
	table.insert(newKeys, newValue)
	return newKeys
end

local function taintCheckRecursive(tbl, keys, depth)
	if (not keys) then
		keys = { "_G" }
	end
	if (not depth) then
		depth = 1
	end
	if (depth >= 3) then
		--return
	end
	for k, v in pairs(tbl) do
		if (not checked[v]) then
			checked[v] = true
			if (type(k) == "string") then
				local newKeys = CreateNewKey(keys, k)
				local keyString = table.concat(newKeys)
				if (not string.find(keyString, "_G.TomCats")) then
					local isSecure, taint = issecurevariable(tbl, k)
					if (not isSecure) then
						if (taint == "TomCats") then
							table.insert(taintLog, keyString)
						end
					elseif (type(v) == "table") then
						taintCheckRecursive(v, newKeys, depth + 1)
					end
				end
			end
		end
	end
end

TomCats_DEBUG_TAINT_LOG = taintLog
addon.taintCheckRecursive = taintCheckRecursive
--taintCheckRecursive(_G)


--local isSecure, taint = issecurevariable(DropDownList1,"dropdown")
--print(isSecure and "secure" or "tainted", taint, time())
--
-- InterfaceOptionsSocialPanelChatStyle:HookScript("OnEvent", function(self, event, ...)
--	local isSecure, taint = issecurevariable(DropDownList1,"dropdown")
--	print(isSecure and "secure" or "tainted", taint, time())
--	taintCheckRecursive(_G)
-- end)

--hooksecurefunc("UIDropDownMenu_SetDisplayMode", function(frame, displayMode)
--	local isSecure, taint = issecurevariable(frame, "displayMode")
--	print(displayMode)
----	print(frame:GetName(),isSecure and "secure" or "tainted", taint, time())
--end)
