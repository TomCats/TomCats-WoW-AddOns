--[[ See license.txt for license and copyright information ]]
local addonName, addon = ...

local C_Minimap = C_Minimap
local CreateFrame = CreateFrame
local GetCVar = GetCVar
local GetPlayerFacing = GetPlayerFacing
local Minimap = Minimap
local Mixin = Mixin

local arrows = { }
local active = false
local betaFeaturesEnabled = false

local function OnUpdate()
    if (active) then
        local playerFacing = GetPlayerFacing()
        local playerPositionX, playerPositionY, playerMapID = addon.GetPlayerPosition()
        local hasPosition = playerFacing and playerPositionX and playerPositionY and playerMapID
        for arrow, arrowActive in pairs(arrows) do
            -- currently only shows arrows that are on the same map as the player
            if (hasPosition and arrowActive and playerMapID == arrow.mapID
                    and addon.GetDistanceInYards2(
                            arrow.mapID,
                            arrow.targetX,
                            arrow.targetY,
                            playerPositionX,
                            playerPositionY) > (C_Minimap.GetViewRadius() * 0.75)) then
                if (not arrow:IsShown()) then arrow:Show() end
                local adj = 0
                if (GetCVar("rotateMinimap") == "1") then
                    adj = adj - playerFacing
                end
                local rads = math.atan2((playerPositionY - arrow.targetY) / 1.5, arrow.targetX - playerPositionX) + adj
                local rotation = rads - (math.pi * 0.5)
                arrow.overlay:SetRotation(rotation)
                arrow.background:SetRotation(rotation)
                arrow:ClearAllPoints()
                arrow:SetPoint("CENTER", Minimap, "CENTER", 53 * math.cos(rads), 53 * math.sin(rads))
            else
                if (arrow:IsShown()) then arrow:Hide() end
            end
        end
    end
end

local frame = CreateFrame("FRAME")
frame:SetScript("OnUpdate", OnUpdate)

local ArrowMixin = { }

function ArrowMixin:SetTarget(targetX, targetY, mapID)
    if (not betaFeaturesEnabled) then return end
    assert(type(targetX) == "number")
    assert(type(targetY) == "number")
    assert(type(mapID) == "number")
    self.targetX = targetX
    self.targetY = targetY
    self.mapID = mapID
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
end

local imagePath = ("Interface\\AddOns\\%s\\images\\"):format(addonName)

function addon.CreateArrow(r, g, b)
    local arrow = CreateFrame("Frame", nil, Minimap)
    Mixin(arrow, ArrowMixin)
    arrows[arrow] = false
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
    background:SetTexture(imagePath .. "arrow_shadow")
    background:SetSize(34, 34)
    background:SetAllPoints(arrow)
    arrow.overlay = mask
    arrow.background = background
    return arrow
end

function addon.EnableArrows(enable)
    if (enable) then
        betaFeaturesEnabled = true
        frame:Show()
    else
        betaFeaturesEnabled = false
        frame:Hide()
        for arrow in pairs(arrows) do
            arrow:Hide()
        end
    end
end
