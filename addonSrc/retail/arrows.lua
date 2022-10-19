--[[
Arrows.lua
Copyright (C) 2018-2022 TomCat's Tours
All rights reserved.

For more information, contact via email at tomcat@tomcatstours.com
(or visit https://www.tomcatstours.com)
]]
local addonName, addon = ...

local minimap_size = {
    indoor = {
        [0] = 300, -- scale
        [1] = 240, -- 1.25
        [2] = 180, -- 5/3
        [3] = 120, -- 2.5
        [4] = 80,  -- 3.75
        [5] = 50,  -- 6
    },
    outdoor = {
        [0] = 466 + 2/3, -- scale
        [1] = 400,       -- 7/6
        [2] = 333 + 1/3, -- 1.4
        [3] = 266 + 2/6, -- 1.75
        [4] = 200,       -- 7/3
        [5] = 133 + 1/3, -- 3.5
    },
}

local GetViewRadius = C_Minimap and C_Minimap.GetViewRadius or function()
    local zoom = Minimap:GetZoom()
    local indoors = GetCVar("minimapZoom")+0 == zoom and "outdoor" or "indoor"
    return minimap_size[indoors][zoom] / 2
end

local CreateFrame = CreateFrame
local GetCVar = GetCVar
local GetPlayerFacing = GetPlayerFacing
local Minimap = Minimap
local Mixin = Mixin

local arrows = { }
local active = false

local function OnUpdate()
    if (active) then
        local playerFacing = GetPlayerFacing()
        local unitPositionX, unitPositionY = UnitPosition("player")
        local hasPosition = playerFacing and unitPositionX and unitPositionY
        for arrow, arrowActive in pairs(arrows) do
            if (hasPosition and arrowActive) then
                local distance = addon.GetDistanceInYards(
                        arrow.worldTargetX,
                        arrow.worldTargetY,
                        unitPositionX,
                        unitPositionY)
                local r = GetViewRadius()
                if (distance > r * 0.75) then
                    if (not arrow:IsShown()) then arrow:Show() end
                    if (arrow.ping:IsShown()) then
                        arrow.ping.animation:Stop()
                        arrow.ping:Hide()
                    end
                    local adj = 0
                    if (GetCVar("rotateMinimap") == "1") then
                        adj = adj - playerFacing
                    end
                    local rads = math.atan2((arrow.worldTargetY - unitPositionY) / 1.5, arrow.worldTargetX - unitPositionX) + adj
                    local rotation = rads + (math.pi * 0.50)
                    arrow.overlay:SetRotation(rads)
                    arrow.background:SetRotation(rads)
                    arrow:ClearAllPoints()
                    local arrowRadius = (Minimap:GetWidth() /  2) - 17
                    arrow:SetPoint("CENTER", Minimap, "CENTER", arrowRadius * math.cos(rotation), arrowRadius * math.sin(rotation))
                else
                    if (not arrow.ping:IsShown()) then
                        arrow.ping:Show()
                        arrow.ping.animation:Play()
                    end
                    local xDist = unitPositionY - arrow.worldTargetY
                    local yDist = unitPositionX - arrow.worldTargetX
                    if (GetCVar("rotateMinimap") == "1") then
                        local s = math.sin(playerFacing)
                        local c = math.cos(playerFacing)
                        local newXDist = xDist*c - yDist*s
                        local newYDist = xDist*s + yDist*c
                        xDist = newXDist
                        yDist = newYDist
                    end
                    local w = Minimap:GetWidth() / 2
                    local h = Minimap:GetHeight() / 2
                    arrow.ping:SetPoint(
                            "CENTER",
                            Minimap,
                            "CENTER",
                            ((xDist) / r) * h,
                            -((yDist) / r) * w
                    )
                    if (arrow:IsShown()) then arrow:Hide() end
                end
            else
                if (arrow.ping:IsShown()) then
                    arrow.ping.animation:Stop()
                    arrow.ping:Hide()
                end
                if (arrow:IsShown()) then arrow:Hide() end
            end
        end
    end
end

local function OnEnter(arrow, target)
    if (arrow.tooltip) then
        arrow.tooltip.Show(target or arrow)
    end
end

local function OnLeave(arrow)
    if (arrow.tooltip) then
        arrow.tooltip.Hide()
    end
end

local frame = CreateFrame("Frame")
frame:SetScript("OnUpdate", OnUpdate)

local ArrowMixin = { }

function ArrowMixin:SetTarget(targetX, targetY, mapID)
    assert(type(targetX) == "number")
    assert(type(targetY) == "number")
    assert(type(mapID) == "number")
    self.targetX = targetX
    self.targetY = targetY
    self.mapID = mapID
    local _, coordinate = C_Map.GetWorldPosFromMapPos(mapID, { x = targetX, y = targetY })
    self.worldTargetX = coordinate.x
    self.worldTargetY = coordinate.y
    arrows[self] = true
    active = true
    self:Show()
end

function ArrowMixin:ClearTarget()
    self.targetX = nil
    self.targetY = nil
    self.mapID = nil
    arrows[self] = false
    active = false
    for _, v in pairs(arrows) do
        if (v) then
            active = true
        end
    end
    self:Hide()
    if (self.ping:IsShown()) then
        self.ping.animation:Stop()
        self.ping:Hide()
    end
end

local imagePath = ("Interface\\AddOns\\%s\\images\\"):format(addonName)

function addon.CreateArrow(r, g, b)
    local arrow = CreateFrame("Frame", nil, Minimap)
    Mixin(arrow, ArrowMixin)
    arrows[arrow] = false
    arrow:SetScript("OnEnter", function() OnEnter(arrow) end)
    arrow:SetScript("OnLeave", OnLeave)
    arrow:Hide()
    arrow:SetSize(34,34)
    arrow:SetPoint("CENTER", Minimap, "CENTER",0,0)
    arrow:SetFrameStrata("LOW")
    arrow:SetFrameLevel(3)
    local overlay = arrow:CreateTexture(nil, "OVERLAY")
    overlay:SetAllPoints(arrow)
    overlay:SetColorTexture(r, g, b, 1)
    local mask = arrow:CreateMaskTexture()
    mask:SetTexture(imagePath .. "arrow_mask")
    mask:SetSize(34, 34)
    mask:SetAllPoints(arrow)
    overlay:AddMaskTexture(mask)
    local background = arrow:CreateTexture(nil, "BACKGROUND")
    --"Interface\\AddOns\\%s\\images\\%s.blp" "Interface\\AddOns\\TomCats\\hallowsend\\libs\\TomCatsLibs\\images\\"
    background:SetTexture(imagePath .. "arrow_shadow")
    background:SetSize(34, 34)
    background:SetAllPoints(arrow)
    arrow.overlay = mask
    arrow.background = background
    local ping = CreateFrame("Frame", nil, Minimap)
    ping:Hide()
    arrow.ping = ping
    ping:SetScript("OnEnter", function() OnEnter(arrow, ping) end)
    ping:SetScript("OnLeave", OnLeave)
    ping:SetSize(32, 32)
    ping:SetPoint("CENTER", Minimap, "CENTER", 0, 0)
    ping:SetFrameStrata("LOW")
    ping:SetFrameLevel(3)
    ping.centerRing = ping:CreateTexture(nil, "OVERLAY")
    ping.centerRing:SetTexture("Interface\\minimap\\UI-Minimap-Ping-Center")
    ping.centerRing:SetSize(16, 16)
    ping.centerRing:SetPoint("CENTER")
    ping.rotatingRing = ping:CreateTexture(nil, "OVERLAY")
    ping.rotatingRing:SetTexture("Interface\\minimap\\UI-Minimap-Ping-Rotate")
    ping.rotatingRing:SetSize(24, 24)
    ping.rotatingRing:SetPoint("CENTER")
    ping.expandingRing = ping:CreateTexture(nil, "OVERLAY")
    ping.expandingRing:SetTexture("Interface\\minimap\\UI-Minimap-Ping-Expand")
    ping.expandingRing:SetSize(16, 16)
    ping.expandingRing:SetPoint("CENTER")
    ping.animation = ping:CreateAnimationGroup()
    ping.animation:SetLooping("REPEAT")
    local rotationAnim = ping.animation:CreateAnimation("Rotation")
    rotationAnim:SetTarget(ping.rotatingRing)
    rotationAnim:SetDegrees(-180)
    rotationAnim:SetDuration(0.8)
    rotationAnim:SetOrder(1)
    local scaleAnim = ping.animation:CreateAnimation("Scale")
    scaleAnim:SetTarget(ping.expandingRing)
    scaleAnim:SetFromScale(0.1, 0.1)
    scaleAnim:SetToScale(1.5, 1.5)
    scaleAnim:SetDuration(0.8)
    scaleAnim:SetOrder(1)
    return arrow
end
