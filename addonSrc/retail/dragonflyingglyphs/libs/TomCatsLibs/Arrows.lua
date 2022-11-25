local addon = select(2,...)
--noinspection UnusedDef
local lib = addon.TomCatsLibs.Arrows
local Colors = addon.TomCatsLibs.Colors
local imagePath = "Interface\\AddOns\\TomCats\\dragonflyingglyphs\\libs\\TomCatsLibs\\images\\"
local frame = CreateFrame("Frame", nil, nil)
local function refreshArrow(self)
    local target = self:GetAttribute("target")
    if (target) then
        --TODO: Skip if UnitPosition is unknown
        local playerFacing = GetPlayerFacing()
        local playerPosition = C_Map.GetPlayerMapPosition(self:GetAttribute("mapID"), "player")
        if (playerFacing and playerPosition) then
            if (not self:IsShown()) then self:Show() end
            local adj = 0
            if (GetCVar("rotateMinimap") == "1") then
                adj = adj - playerFacing
            end
            local rads = math.atan2(playerPosition.y - target.y, target.x - playerPosition.x) + adj
            local rotation = rads - (math.pi * 0.5)
            local overlay = self:GetAttribute("overlay")
            overlay:SetRotation(rotation)
            local background = self:GetAttribute("background")
            background:SetRotation(rotation)
            self:SetPoint("CENTER", Minimap, "CENTER", 53 * math.cos(rads), 53 * math.sin(rads))
        else
            if (self:IsShown()) then self:Hide() end
        end
    end
end
local arrowMetatable = {
    __index = CreateFromMixins(
        getmetatable(frame)["__index"],
        {
            SetTarget = function(self, target, mapID)
                self:SetAttribute("target", target)
                self:SetAttribute("mapID", mapID)
                self:SetScript("OnUpdate",refreshArrow)
                self:Show()
            end,
            ClearTarget = function(self)
                self:SetAttribute("target",nil)
                self:SetScript("OnUpdate",nil)
                self:Hide()
            end,
            GetObjectType = function() return "TomCatsLib-Arrow" end }
    )
}
function lib:CreateArrow(colorOrR, g, b)
    local frame = CreateFrame("Frame", nil, Minimap)
    setmetatable(frame,arrowMetatable)
    frame:Hide()
    frame:SetSize(34,34)
    frame:SetPoint("CENTER", Minimap, "CENTER",0,0)
    frame:SetFrameStrata("MEDIUM")
    local overlay = frame:CreateTexture(nil, "OVERLAY");
    overlay:SetAllPoints(frame);
    if (type(colorOrR) == "number") then
        overlay:SetColorTexture(colorOrR, g, b, 1);
    else
        local color = Colors[colorOrR]
        if (not color) then
            color = Colors.GOLD
        end
        local r, g, b = unpack(color)
        overlay:SetColorTexture(r, g, b, 1);
    end
    local mask = frame:CreateMaskTexture();
    mask:SetTexture(imagePath .. "arrow_mask");
    mask:SetSize(34, 34);
    mask:SetAllPoints(frame);
    overlay:AddMaskTexture(mask);
    local background = frame:CreateTexture(nil, "BACKGROUND");
    background:SetTexture(imagePath .. "arrow_shadow");
    background:SetSize(34, 34);
    background:SetAllPoints(frame);
    frame:SetAttribute("overlay",mask)
    frame:SetAttribute("background",background)
    return frame
end
