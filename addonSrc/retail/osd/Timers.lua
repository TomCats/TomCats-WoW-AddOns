--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("osd")

local Timer = { }
local tooltipInstance = 0

function Timer:GetHeight()
	return self.frame.title:GetStringHeight()
end

function Timer:GetTitleWidth()
	return self.frame.title:GetStringWidth()
end

function Timer:New(parentFrame)
	self.frame = Templates.CreateTimerRow(parentFrame)
	self.frame:SetScript("OnEnter", function()
		local tooltipInstance_ = tooltipInstance + 1
		tooltipInstance = tooltipInstance_
		C_Timer.NewTimer(0.25, function()
			if (tooltipInstance == tooltipInstance_) then
				GameTooltip:SetOwner(self.frame, "ANCHOR_CURSOR")
				if (self.tooltipFunction) then
					self.tooltipFunction()
				else
					GameTooltip:SetText(self.tooltipText)
					GameTooltip:Show()
				end
				local mX, mY = GetCursorPosition()
				local scale = UIParent:GetEffectiveScale()
				mX = mX / scale
				mY = (mY + 30) / scale
				local tooltipWidth = GameTooltip:GetWidth()
				GameTooltip:ClearAllPoints()
				GameTooltip:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", mX - (tooltipWidth / 2), mY)
			end
		end)
	end)
	self.frame:SetScript("OnLeave", function()
		tooltipInstance = tooltipInstance + 1
		local numLines = GameTooltip:NumLines()
		for i = 1, numLines do
			local line = _G[GameTooltip:GetName().."TextLeft"..i]
			line:SetJustifyH("LEFT")
		end
		GameTooltip:Hide()
	end)
	self.frame:SetScript("OnClick", function()
		if (self.clickFunction) then
			self.clickFunction()
		end
	end)
end

function Timer:Reset()
	self:SetIcon()
	self:SetTitle("---")
	self:SetTimer()
	self:SetShown(false)
end

function Timer:SetIcon(icon, desaturated, scale)
	self.frame.icon:SetAtlas(icon)
	self.frame.icon:SetDesaturated(desaturated == true)
end

function Timer:SetShown(shown)
	self.frame:SetShown(shown)
end

function Timer:SetTitle(text)
	self.frame.title:SetText(text)
end

function Timer:SetTooltipText(text)
	self.tooltipText = text
end

function Timer:SetStartTime(val, gracePeriod)
	self.endTime = nil
	self.startTime = val
	self.gracePeriod = gracePeriod
	if (self.startTime == nil) then
		self.frame.timer:SetText("---")
	elseif (type(self.startTime) == "number") then
		local remaining = self.startTime - GetServerTime()
		if (remaining < 0 and -remaining < gracePeriod) then
			self.frame.timer:SetText("NOW")
		else
			self.frame.timer:SetText(Time.FormatRemainingTime(self.startTime - GetServerTime(), "---"))
		end
	else
		self.frame.timer:SetText(self.endTime or "---")
	end
end

function Timer:SetTimer(val)
	self.endTime = val
	self.startTime = nil
	self.gracePeriod = nil
	if (self.endTime == nil) then
		self.frame.timer:SetText("---")
	elseif (type(self.endTime) == "number") then
		if (self.endTime < 0) then
			self.frame.timer:SetText("NOW")
		else
			self.frame.timer:SetText(Time.FormatRemainingTime(self.endTime - GetServerTime(), "---"))
		end
	else
		self.frame.timer:SetText(self.endTime or "---")
	end
end

function Timer:Update()
	if (self.endTime) then
		if (self.endTime < 0) then
			self.frame.timer:SetText("NOW")
		else
			self.frame.timer:SetText(Time.FormatRemainingTime(self.endTime - GetServerTime(), "---"))
		end
	elseif (self.startTime) then
		local remaining = self.startTime - GetServerTime()
		if (remaining <= 0) then
			self.frame.timer:SetText("NOW")
			if (remaining < -self.gracePeriod) then
				OSD:Refresh()
			end
		else
			self.frame.timer:SetText(Time.FormatRemainingTime(self.startTime - GetServerTime(), "---"))
		end
	end
end

Timers = {
	interval = 0.25
}

function Timers:GetHeight()
	return self.frame:GetHeight()
end

function Timers:GetWidth()
	return self.width or 100
end

function Timers:GetTimerRow(idx)
	while (#self.children < idx) do
		local child = self:AddChild(UI.New(Timer, self.frame))
		if (child.idx == 1) then
			child.frame:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 0, -2)
			child.frame:SetPoint("TOPRIGHT", self.frame, "TOPRIGHT", 0, -2)
		else
			child.frame:SetPoint("TOPLEFT", self.children[child.idx - 1].frame, "BOTTOMLEFT", 0, -4)
			child.frame:SetPoint("TOPRIGHT", self.children[child.idx - 1].frame, "BOTTOMRIGHT", 0, -4)
		end
	end
	return self.children[idx]
end

function Timers:New(parent)
	self.frame = CreateFrame("Frame", nil, parent.frame)
	self.frame:SetPoint("TOPLEFT", parent.frame, "TOPLEFT", 12, -30)
	self.frame:SetPoint("TOPRIGHT", parent.frame, "TOPRIGHT", -14, -30)
end

function Timers:Refresh()
	local height = 0
	local idx = 0
	local minWidth = 100
	if (IsElementalStormsVisible()) then
		local elementalStorms = GetElementalStorms()
		for _, elementalStorm in ipairs(elementalStorms) do
			idx = idx + 1
			local timerRow = self:GetTimerRow(idx)
			timerRow:SetIcon(elementalStorm.icon, elementalStorm.desaturated)
			timerRow:SetTitle(elementalStorm.title)
			timerRow:SetTimer(elementalStorm.endTime)
			timerRow.tooltipFunction = nil
			timerRow:SetTooltipText("Elemental Storms (ends)")
			height = height + timerRow:GetHeight() + 4
			timerRow:SetShown(true)
		end
	end
	if (GreedyEmissary and GreedyEmissary.IsVisible()) then
		idx = idx + 1
		height = height + GreedyEmissary.Render(self, idx)
	end
	if (TimeRifts and TimeRifts.IsVisible()) then
		idx = idx + 1
		height = height + TimeRifts.Render(self, idx)
	end
	if (TwitchDrops and TwitchDrops.IsVisible()) then
		idx = idx + 1
		height = height + TwitchDrops.Render(self, idx)
	end
	if (PrimeGamingLoot and PrimeGamingLoot.IsVisible()) then
		idx = idx + 1
		height = height + PrimeGamingLoot.Render(self, idx)
	end
	for idx_ = 1, idx do
		minWidth = math.max(minWidth, self:GetTimerRow(idx_):GetTitleWidth())
	end
	for idx_ = idx + 1, #self.children do
		self:GetTimerRow(idx_):Reset()
	end
	self.frame:SetHeight(height)
	self.width = minWidth + 100
end

function Timers:Update(elapsed)
	return Throttle(self, elapsed)
end
