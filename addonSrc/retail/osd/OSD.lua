--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("osd")

local OSDProtoType = {
	AfterRefresh = function(self)
		self.frame:SetHeight(self.TimerRows:GetHeight() + 64)
	end,
	New = function(self)
		self.frame = Templates.CreateBasicWindow(
				UIParent,
				{
					icon = string.format("Interface/AddOns/%s/images/tomcats_logo", addonName)
				}
		)
		self.frame:SetSize(300,30)
		self.frame.title:SetText("TomCat's Tours")
		self:AddChild(UI.New(Timers, self), "TimerRows")
	end,
}

local frame = CreateFrame("Frame")

local function OnEvent(_, event, arg1, arg2)
	if (event == "AREA_POIS_UPDATED") then
		OSD:Refresh()
	elseif (event == "PLAYER_ENTERING_WORLD") then
		OSD = UI.New(OSDProtoType)
		frame:SetScript("OnUpdate", function(_, elapsed)
			OSD:Update(elapsed)
		end)
		if (arg2) then
			OSD:Refresh()
		end
		frame:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
end

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("AREA_POIS_UPDATED")
frame:SetScript("OnEvent", OnEvent)
