--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("mopremix")

local eventFrame = CreateFrame("Frame")
local components = { }
local componentsByName = { }


local function OnEvent(_, event, arg1)
	if (event == "PLAYER_LOGIN" and PlayerGetTimerunningSeasonID() == 1) then
		OSD = Templates.CreateBasicWindow(
				UIParent,
				{
					icon = ImagePNG.tomcats_minimap_icon,
					prefs = TomCats_Account.mopremix.osd
				}
		)
		OSD:SetSize(260,100)
		OSD.title:SetText("TomCat's Tours")
		OSD:Hide()
		for _, component in ipairs(components) do
			if (component.Init) then
				component.Init(componentsByName)
			end
		end
	end
end

eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", OnEvent)

function AddComponent(component)
	table.insert(components, component)
	if (component.Name) then
		componentsByName[component.Name] = component
	end
end