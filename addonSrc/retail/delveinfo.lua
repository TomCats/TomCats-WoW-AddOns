--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("delveinfo")

hooksecurefunc("WeeklyRewards_ShowUI", function()
	local delvInfo = WeeklyRewardsFrame.WorldFrame.DelvInfo
	if (not delvInfo) then
		WeeklyRewardsFrame.WorldFrame.DelvInfo = CreateFrame("Frame", nil, WeeklyRewardsFrame.WorldFrame)
		delvInfo = WeeklyRewardsFrame.WorldFrame.DelvInfo
		delvInfo.Text = delvInfo:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		delvInfo.Text:SetJustifyH("LEFT")
		delvInfo.Text:SetPoint("TOPLEFT", 8, - 8)
		delvInfo.Background = delvInfo:CreateTexture(nil, "BACKGROUND")
		delvInfo.Background:SetColorTexture(0, 0, 0, 0.8)
		delvInfo.Background:SetAllPoints()
		delvInfo.Background:Show()
		delvInfo:SetSize(300, 80)
	end
	local activities = C_WeeklyRewards.GetActivities(Enum.WeeklyRewardChestThresholdType.World)
	local activityTotals = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	for k, activity in ipairs(activities) do
		if (activity.level) then
			activityTotals[activity.level] = activity.progress
		end
	end
	local text = "TomCat's Tours: Delve Info\n\n"
	local hasInfo = false
	for k, activityTotal in ipairs(activityTotals) do
		if (activityTotal > 0) then
			if (k == 1) then
				text = text .. ("Tier 1 (or higher) + World Activities: %s"):format(activityTotal) .. "\n"
			else
				text = text .. ("Tier %s (or higher): %s"):format(k, activityTotal) .. "\n"
			end
			hasInfo = true
		end
	end
	if (not hasInfo) then
		text = text .. ("Not enough data yet")
	end
	delvInfo.Text:SetText(text)
	delvInfo:ClearAllPoints()
	delvInfo:SetPoint("TOPLEFT", WeeklyRewardsFrame.WorldFrame.Name, "BOTTOMLEFT", 0, - 8)
end)
