--[[ See license.txt for license and copyright information ]]

local function split (inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

local function setDefaultVignetteIcon(iconname)
	print("Setting default vignette icon to: " .. iconname .. "\ntype /reload to take effect")
	TomCats_Account.preferences.defaultVignetteIcon = iconname
end

local function handleSlashCommand(msg)
	if (msg == "") then
		InterfaceOptionsFrame_OpenToCategory(TomCats_Config)
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
