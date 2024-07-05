--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("mopremix")

local OSD

local component = { }

function component.Init()
	OSD = Templates.CreateBasicWindow(
			UIParent,
			{
				icon = ImagePNG.tomcats_minimap_icon,
				prefs = TomCats_Account.mopremix.collectionTracker,
				minimizable = true,
				iconEnterFunc = function(self)
					GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
					GameTooltip:ClearLines()
					GameTooltip:AddLine("TomCat's Tours\nRemix Collection Tracker", nil, nil, nil, true)
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
	OSD.title:SetText("Remix Collection Tracker")
end

function component.SetDisplayed(displayed)
	TomCats_Account.mopremix.collectionTrackerDisplay = displayed
end

function component.IsDisplayed()
	return TomCats_Account.mopremix.collectionTrackerDisplay
end

AddComponent(component)

CollectionTracker = component