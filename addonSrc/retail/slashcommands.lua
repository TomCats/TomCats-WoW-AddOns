--[[ See license.txt for license and copyright information ]]

local function setDefaultVignetteIcon(iconname)
	print("Setting default vignette icon to: " .. iconname .. "\ntype /reload to take effect")
	TomCats_Account.preferences.defaultVignetteIcon = iconname
end

local function handleSlashCommand(msg)
	if (msg == "") then
		Settings.OpenToCategory(TomCats_Config.category:GetID())
	else
		local t={}
		for str in string.gmatch(msg, "([^ ]+)") do
			table.insert(t, str)
		end
		if (t[1] == "icon") then
			setDefaultVignetteIcon(select(2, unpack(t)))
		end
	end
end

SLASH_TOMCATS1 = "/TOMCATS"
SLASH_TOMCATS2 = "/TOMCAT"
SlashCmdList["TOMCATS"] = handleSlashCommand
