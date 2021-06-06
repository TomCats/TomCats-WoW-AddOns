local CloseMenus
local hooksecurefunc
local UIMenus

UIMenus = {
	"TomCats_DropDownList1",
	"TomCats_DropDownList2",
};

function CloseMenus()
	local menusVisible = nil;
	local menu
	for index, value in pairs(UIMenus) do
		menu = _G[value];
		if ( menu and menu:IsShown() ) then
			menu:Hide();
			menusVisible = 1;
		end
	end
	return menusVisible;
end

hooksecurefunc("CloseMenus", CloseMenus)
