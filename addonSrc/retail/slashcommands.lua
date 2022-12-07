--[[ See license.txt for license and copyright information ]]

local function setDefaultVignetteIcon(iconname)
	print("Setting default vignette icon to: " .. iconname .. "\ntype /reload to take effect")
	TomCats_Account.preferences.defaultVignetteIcon = iconname
end

local function handleSlashCommand(msg)
	if (msg == "/TOMCAT" or msg == "/TOMCATS") then
		Settings.OpenToCategory(TomCats_Config.category:GetID())
	else
		local t={}
		for str in string.gmatch(msg, "([^ ]+)") do
			table.insert(t, str)
		end
		if (t[2] == "icon") then
			setDefaultVignetteIcon(select(2, unpack(t)))
		end
	end
end

-- Work-around for Blizzard's issue where slash commands are allowing taint to spread
local lastMessage

local function starts(String,Start)
	return string.sub(String,1,string.len(Start))==Start
end

hooksecurefunc("ChatEdit_ParseText", function(editBox, send, parseIfNoSpaces)
	if (send == 0) then
		lastMessage = editBox:GetText()
	end
end)

hooksecurefunc("ChatFrame_DisplayHelpTextSimple", function(frame)
	if (lastMessage and lastMessage ~= "") then
		local cmd = string.upper(lastMessage)
		if (starts(cmd, "/TOMCAT")) then
			local count = 1
			local numMessages = frame:GetNumMessages()
			local function predicateFunction(entry)
				if (count == numMessages) then
					if (entry == HELP_TEXT_SIMPLE) then
						return true
					end
				end
				count = count + 1
			end
			frame:RemoveMessagesByPredicate(predicateFunction)
			handleSlashCommand(cmd)
		end
	end
end)

--
--SLASH_TOMCATS1 = "/TOMCATS"
--SLASH_TOMCATS2 = "/TOMCAT"
--SlashCmdList["TOMCATS"] = handleSlashCommand
