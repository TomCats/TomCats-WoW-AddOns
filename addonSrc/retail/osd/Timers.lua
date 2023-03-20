--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("osd")

local Timer = { }

function Timer:GetHeight()
	return self.frame.title:GetStringHeight()
end

function Timer:New(parentFrame)
	self.frame = Templates.CreateTimerRow(parentFrame)
end

function Timer:Reset()
	self:SetIcon()
	self:SetTitle("---")
	self:SetTimer()
	self:SetShown(false)
end

function Timer:SetIcon(icon, desaturated)
	self.frame.icon:SetAtlas(icon)
	self.frame.icon:SetDesaturated(desaturated == true)
end

function Timer:SetShown(shown)
	self.frame:SetShown(shown)
end

function Timer:SetTitle(text)
	self.frame.title:SetText(text)
end

function Timer:SetTimer(val)
	self.endTime = val
	if (self.endTime == nil) then
		self.frame.timer:SetText("---")
	elseif (type(self.endTime) == "number") then
		self.frame.timer:SetText(Time.FormatRemainingTime(self.endTime - GetServerTime(), "---"))
	else
		self.frame.timer:SetText(self.endTime or "---")
	end
end

function Timer:Update()
	if (self.endTime) then
		self.frame.timer:SetText(Time.FormatRemainingTime(self.endTime - GetServerTime(), "---"))
	end
end

Timers = {
	interval = 0.25
}

function Timers:GetHeight()
	return self.frame:GetHeight()
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
	local elementalStorms = GetElementalStorms()
	local height = 0
	for idx, elementalStorm in ipairs(elementalStorms) do
		local timerRow = self:GetTimerRow(idx)
		timerRow:SetIcon(elementalStorm.icon, elementalStorm.desaturated)
		timerRow:SetTitle(elementalStorm.title)
		timerRow:SetTimer(elementalStorm.endTime)
		height = height + timerRow:GetHeight() + 4
		timerRow:SetShown(true)
	end
	for idx = #elementalStorms + 1, #self.children do
		self:GetTimerRow(idx):Reset()
	end
	-- todo: set fixed height for widget
	self.frame:SetHeight(height)
end

function Timers:Update(elapsed)
	return Throttle(self, elapsed)
end
