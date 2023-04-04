--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("options")

ScrollBox = { }

local boundingBox, scrollFrame, scrollBar

local function Init(parent)
	scrollFrame = CreateFrame("Frame", nil, parent, "WowScrollBox")
	scrollBar = CreateFrame("EventFrame", nil, parent, "MinimalScrollBar")
	scrollBar:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", 16, -6)
	scrollBar:SetPoint("BOTTOMLEFT", scrollFrame, "BOTTOMRIGHT", 16, 7)
	boundingBox = CreateFrame("Frame", nil, scrollFrame)
	boundingBox:SetPoint("TOPLEFT")
	boundingBox:SetPoint("RIGHT")
	boundingBox:SetHeight(30)
	boundingBox.scrollable = true
	local view = CreateScrollBoxLinearView()
	ScrollUtil.InitScrollBoxWithScrollBar(scrollFrame, scrollBar, view)
end

function ScrollBox.Acquire(parent, contents, padding)
	Init = Init(parent) or nop
	scrollFrame:SetParent(parent)
	scrollBar:SetParent(parent)
	scrollFrame:ClearAllPoints()
	scrollFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 16, -50)
	scrollFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -36, 0)
	if (scrollFrame.contents) then
		scrollFrame.contents:ClearAllPoints()
		scrollFrame.contents:SetParent(nil)
	end
	scrollFrame.contents = contents
	contents:SetParent(boundingBox)
	contents:ClearAllPoints()
	contents:SetPoint("TOPLEFT")
	contents:SetPoint("RIGHT")
	contents:Layout()
	boundingBox:SetHeight(contents:GetHeight() + (padding or 0))
	scrollFrame:FullUpdate(true)
	scrollFrame:ScrollToBegin()
end
