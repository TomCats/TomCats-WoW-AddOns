local _, addon = ...
local uimapgroupmember = addon.uimapgroupmember
local uimapgroupmemberByMap = { }
local uimapgroupmemberByMapGroup = { }
addon.uimapgroupmemberByMap = uimapgroupmemberByMap
addon.uimapgroupmemberByMapGroup = uimapgroupmemberByMapGroup
local lastMapGroupID = 0
for i = 1, #uimapgroupmember, 3 do
	uimapgroupmemberByMap[uimapgroupmember[i+2]] = i
	local mapGroupID = uimapgroupmember[i+1]
	if (mapGroupID ~= lastMapGroupID) then
		lastMapGroupID = mapGroupID
		uimapgroupmemberByMapGroup[mapGroupID] = i
	end
end
