--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

uimapgroupmemberByMap = { }
uimapgroupmemberByMapGroup = { }

local lastMapGroupID = 0
for i = 1, #uimapgroupmember, 3 do
	uimapgroupmemberByMap[uimapgroupmember[i+2]] = i
	local mapGroupID = uimapgroupmember[i+1]
	if (mapGroupID ~= lastMapGroupID) then
		lastMapGroupID = mapGroupID
		uimapgroupmemberByMapGroup[mapGroupID] = i
	end
end
