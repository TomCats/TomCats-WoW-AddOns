--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("mopremix")

local eventFrame = CreateFrame("Frame")
local components = { }
local componentsByName = { }


local function OnEvent(_, event, arg1)
	if (event == "FIRST_FRAME_RENDERED" and PlayerGetTimerunningSeasonID() == 1) then
		active = true
		for _, component in ipairs(components) do
			if (component.Init) then
				component.Init(componentsByName)
			end
		end
	end
end

local function OnUpdate()
	for _, component in ipairs(components) do
		if (component.dirty and component.Refresh) then
			component.Refresh()
		end
	end
end

eventFrame:RegisterEvent("FIRST_FRAME_RENDERED")
eventFrame:SetScript("OnEvent", OnEvent)
eventFrame:SetScript("OnUpdate", OnUpdate)

function AddComponent(component)
	table.insert(components, component)
	if (component.Name) then
		componentsByName[component.Name] = component
	end
end
