local _, addon = ...

function addon.ToggleQueuewu()
	TomCats_Account.preferences.queuewu = not TomCats_Account.preferences.queuewu
	if (TomCats_Account.preferences.queuewu) then
		print("Queuewu enabled!")
	else
		print("Queuewu disabled!")
	end
end

LFGEventFrame:HookScript("OnEvent", function(_, event)
	if (event == "LFG_PROPOSAL_SHOW" and TomCats_Account.preferences.queuewu) then
		local _, handle = PlaySoundFile("Interface\\AddOns\\TomCats\\sound\\Queuewu1.mp3")
		StopSound(handle - 1)
	end
end)

hooksecurefunc("PVPReadyDialog_Display", function()
	if (TomCats_Account.preferences.queuewu) then
		local _, handle = PlaySoundFile("Interface\\AddOns\\TomCats\\sound\\Queuewu1.mp3")
		StopSound(handle - 1)
	end
end)