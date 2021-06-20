--[[ See license.txt for license and copyright information ]]

local function handleSlashCommand()
	InterfaceOptionsFrame_OpenToCategory(TomCats_Config)
end

SLASH_TOMCATS1 = "/TOMCATS"
SLASH_TOMCATS2 = "/TOMCAT"
SlashCmdList["TOMCATS"] = handleSlashCommand
