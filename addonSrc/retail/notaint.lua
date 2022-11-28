local addonName, addon = ...

local StaticPopup_Show2 = StaticPopup_Show

-- In order to correctly educate players so they do not inadvertently disable an addon in an attempt to solve a problem
-- which will not be solved by disabling the addon, additional information will be presented before they will have
-- that option.

local function StaticPopup_Show(arg1, arg2)
	if (arg1 == "ADDON_ACTION_FORBIDDEN" and addonName == arg2) then
		TomCats_Static_Popup:Show()
		TomCats_Static_Popup:SetFrameStrata("DIALOG")
		TomCats_Static_Popup:SetFrameLevel(100)
		TomCats_Static_Popup:ClearAllPoints()
		TomCats_Static_Popup:SetPoint("TOP", StaticPopup1, "BOTTOM", 0, -10)
		TomCats_Static_Popup.Text:SetText("Typing /reload will usually clear this type of error without disabling the addon\n\nIf the issue persists, this is not normal. Please report any details to TomCat")
		TomCats_Static_Popup.Text:SetHeight(80)
	end
end

hooksecurefunc("StaticPopup_Show", StaticPopup_Show)
