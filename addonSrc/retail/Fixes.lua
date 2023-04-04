--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope()

local CreateFrame_Orig = CreateFrame

local function RefreshContentHeight(frame)
	local top = frame:GetTop()
	local bottom = top
	for idx, region in ipairs({ frame:GetRegions() }) do
		-- Add paragraph spacing suppport
		if (idx > 1 and frame.paragraphSpacing) then
			local point1 = { region:GetPoint(1) }
			local point2 = { region:GetPoint(2) }
			point1[5] = -frame.paragraphSpacing
			region:ClearAllPoints()
			region:SetPoint(unpack(point1))
			region:SetPoint(unpack(point2))
		end
		local regionTop = region:GetTop()
		local regionBottom = regionTop - region:GetStringHeight()
		if (regionBottom < bottom) then
			bottom = regionBottom
		end
	end
	local contentHeight = top - bottom
	frame:SetHeight(contentHeight)
	return contentHeight
end

--[[
	Fix for broken GetContentHeight() for SimpleHTML which does not retrieve the height of wrapped text
]]
local function GetScaledRect(frame)
	RefreshContentHeight(frame)
	return frame:GetScaledRectInternal()
end

--[[
	Fix for broken GetContentHeight() for SimpleHTML which does not retrieve the height of wrapped text
]]
local function GetContentHeight(frame)
	return RefreshContentHeight(frame)
end
--[[
	Fix for missing Set*Atlas functions for CheckButton
]]
local function SetCheckedAtlas(self, atlas, useAtlasScale)
	local atlasInfo = C_Texture.GetAtlasInfo(atlas)
	local texture = self:CreateTexture(nil, "ARTWORK")
	texture:SetTexture(atlasInfo.file)
	texture:SetTexCoord(atlasInfo.leftTexCoord, atlasInfo.rightTexCoord, atlasInfo.topTexCoord, atlasInfo.bottomTexCoord)
	self:SetCheckedTexture(texture)
end

local function SetDisabledCheckedAtlas(self, atlas, useAtlasScale)
	local atlasInfo = C_Texture.GetAtlasInfo(atlas)
	local texture = self:CreateTexture(nil, "ARTWORK")
	texture:SetTexture(atlasInfo.file)
	texture:SetTexCoord(atlasInfo.leftTexCoord, atlasInfo.rightTexCoord, atlasInfo.topTexCoord, atlasInfo.bottomTexCoord)
	self:SetDisabledCheckedTexture(texture)
end

--[[
	Fix for SimpleHTML issues whereas width of its contents is not resized automatically due to missing anchors
	and unexpected need to call GetWidth() on each region which will trigger a resize
]]
function CreateFrame(frameType, name, parent, template, id)
	local frame = CreateFrame_Orig(frameType, name, parent, template, id)
	frameType = string.upper(frameType)
	if (frameType == "SIMPLEHTML" and template) then
		local w, h = frame:GetSize()
		local points = { }
		for i = 1, frame:GetNumPoints() do
			table.insert(points, { frame:GetPoint(i) })
		end
		if (w == 0 or h == 0) then
			frame:SetSize(1, 1)
		end
		if (#points == 0) then
			frame:SetPoint("CENTER")
		end
		for _, region in ipairs({ frame:GetRegions() }) do
			if (region:GetNumPoints() < 2) then
				region:SetPoint("RIGHT")
			end
			region:GetWidth()
		end
		frame:ClearAllPoints()
		for _, point in ipairs(points) do
			frame:SetPoint(unpack(point))
		end
		frame.GetContentHeight = GetContentHeight
		frame.GetScaledRectInternal = frame.GetScaledRect
		frame.GetScaledRect = GetScaledRect
	elseif (frameType == "CHECKBUTTON") then
		frame.SetCheckedAtlas = SetCheckedAtlas
		frame.SetDisabledCheckedAtlas = SetDisabledCheckedAtlas
	end
	return frame
end
