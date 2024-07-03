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
					prefs = TomCats_Account.mopremix.osd,
					minimizable = true,
					iconEnterFunc = function(self)
						GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
						GameTooltip:ClearLines()
						GameTooltip:AddLine("TomCat's Tours Remix Edition", nil, nil, nil, true)
						GameTooltip:AddLine("\nEnjoy the work in progress and download updates regularly to find new features!", 1, 1, 1, true)
						GameTooltip:AddLine("\nIf you have questions or feedback, visit me on Twitch or Discord!", 1, 1, 1, true)
						GameTooltip:AddLine("\nDouble-click to toggle", 1, 1, 1, true)
						GameTooltip:Show()
					end,
					iconLeaveFunc = function()
						GameTooltip:Hide()
					end
				}
		)
		OSD:SetSize(260,100)
		OSD.title:SetText("TomCat's Tours")
		--OSD:Hide()
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