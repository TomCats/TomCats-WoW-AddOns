--[[ See license.txt for license and copyright information ]]
local _, addon = ...
local visibilityTypes = addon.constants.visibilityTypes
local cache = addon.newCache(600, 30)

local exceptions = {
	[4529] = {
		["Atlas"] = "vignetteevent"
	},
	[4476] = {
		["Atlas"] = "vignettekill"
	},
	[4950] = {
		["Atlas"] = "vignettekill"
	}
}
for i = 5024, 5031 do
	exceptions[i] = {
		["Atlas"] = "poi-workorders"
	}
end


function addon.getVignettes(mapID)
	local tbl = cache.get(mapID)
	if (not tbl) then
		local namesC = addon.vignette_names.data[mapID]
		if (namesC) then
			local names = loadstring(
					addon.compression.decompress(
							namesC,
							addon.vignette_names.dictionary,
							addon.vignette_names.encodingF))()
			local info = loadstring(
					addon.compression.decompress(
							addon.vignette_info.data[mapID],
							addon.vignette_info.dictionary,
							addon.vignette_info.encodingF))()
			local keys = { }
			for k, v in ipairs(info[1]) do
				keys[v] = k
			end
			tbl = { }
			local v_rule, l_rule, t_rule, cv_rule = unpack(info[3])
			local metatable = {
				__index = function(self, key)
					local k = rawget(self,1)
					local v = rawget(self,2)
					local GetLocation = rawget(self, 3)
					if (key == "Name") then
						return names[k]
					end
					if (key == "isPinned") then
						local visibility = addon.executeVisibilityRule(v_rule, self)
						if (visibility == true or visibility == false) then return visibility end
						return visibility == visibilityTypes.ALL or visibility == visibilityTypes.PIN
					end
					if (key == "isListed") then
						local visibility = addon.executeVisibilityRule(v_rule, self)
						if (visibility == true or visibility == false) then return visibility end
						return visibility == visibilityTypes.ALL or visibility == visibilityTypes.LIST
					end
					if (key == "isVisibleWhenCompleted") then
						return addon.executeCompletedVisibilityRule(cv_rule, self)
					end
					if (key == "GetLocation") then
						return GetLocation
					end
					if (key == "isCompleted") then
						return addon.executeTrackingRule(t_rule, self)
					end
					if (key == "Atlas") then
						return exceptions[v[1]] and exceptions[v[1]]["Atlas"] or v[keys[key]]
					end
					return v[keys[key]]
				end
			}
			for k, v in ipairs(info[2]) do
				local row
				local function GetLocation()
					local location = addon.executeLocationRule(l_rule, row)
					if (not location) then return nil end
					return location[1] / 100000, location[2] / 100000
				end
				row = { k, v, GetLocation}
				setmetatable(row, metatable)
				tbl[row["ID"]] = row
			end
			local aliasKey = keys["Alias"]
			if (aliasKey) then
				for _, v in pairs(tbl) do
					if (v.Alias) then
						local vignette = rawget(v,2)
						vignette[aliasKey] = tbl[v.Alias]
					end
				end
			end
			cache.add(mapID, tbl)
		end
	end
	return tbl
end
