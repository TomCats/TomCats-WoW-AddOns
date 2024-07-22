local addonName, addon = ...

function addon.ToggleQueuewu()
	TomCats_Account.preferences.queuewu = not TomCats_Account.preferences.queuewu
	if (TomCats_Account.preferences.queuewu) then
		MuteSoundFile(567478)
		print("Queuewu enabled!")
	else
		UnmuteSoundFile(567478)
		print("Queuewu disabled!")
	end
end

LFGEventFrame:HookScript("OnEvent", function(_, event)
	if (event == "LFG_PROPOSAL_SHOW" and TomCats_Account.preferences.queuewu) then
		local _, handle = PlaySoundFile("Interface/AddOns/TomCats/sound/Queuewu1.mp3", "Master")
		StopSound(handle - 1)
	end
end)

hooksecurefunc("PVPReadyDialog_Display", function()
	if (TomCats_Account.preferences.queuewu) then
		local _, handle = PlaySoundFile("Interface/AddOns/TomCats/sound/Queuewu1.mp3", "Master")
		StopSound(handle - 1)
	end
end)

local eventFrame = CreateFrame("Frame")

eventFrame:SetScript("OnEvent", function(_, event, arg1)
	if (event == "ADDON_LOADED" and arg1 == addonName) then
		if (TomCats_Account.preferences.queuewu) then
			MuteSoundFile(567478)
			eventFrame:UnregisterEvent("ADDON_LOADED")
		end
	end
end)

eventFrame:RegisterEvent("ADDON_LOADED")
