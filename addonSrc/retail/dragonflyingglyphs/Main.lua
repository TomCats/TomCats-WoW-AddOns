local addonName, addon = ...

local TCL = addon.TomCatsLibs
local WorldMapFrame
local BattlefieldMapFrame
local FlightMapFrame

-- TODO: Add icons to the WorldMapFrame
-- TODO: Add icons to the BattleFieldMapFrame
-- TODO: Add icons to the FlightMapFrame
-- TODO: Add automatic routing
-- TODO: Draw route on the map
-- TODO: Add coins owned indicator + coins remaining to loot
-- TODO: Coins remaining indicator on the maps
-- TODO: Add holiday items available for purchase window
-- TODO: Add shortcut to achievements or achievements remaining tab
-- TODO: Allow automatic use/destruction of holiday 'junk' items
-- TODO: TomCats-Arrows to close in on target
-- TODO: Integrate with map's built-in tracker
-- TODO: Handle zone phase detection and advice
local allowedMaps = {
    WorldMapFrame = true,
    BattlefieldMapFrame = true,
    FlightMapFrame = true
}
local function AddDataProviderToMap(map)
    if (allowedMaps[map:GetName()]) then
        map:AddDataProvider(CreateFromMixins(TomCatsDragonFlyingGlyphsDataProviderMixin))
    end
end
local function ADDON_LOADED(_, arg1)
    if (not WorldMapFrame and _G["WorldMapFrame"]) then
        WorldMapFrame = addon.GetProxy(_G["WorldMapFrame"])
        AddDataProviderToMap(WorldMapFrame)
    end
    if (not BattlefieldMapFrame and _G["BattlefieldMapFrame"]) then
        BattlefieldMapFrame = addon.GetProxy(_G["BattlefieldMapFrame"])
        AddDataProviderToMap(BattlefieldMapFrame)
    end
    if (not FlightMapFrame and _G["FlightMapFrame"]) then
        FlightMapFrame = addon.GetProxy(_G["FlightMapFrame"])
        AddDataProviderToMap(FlightMapFrame)
    end
    if (addonName == arg1) then
        TomCats_Account.dragonflyingglyphs.autoEnabled = TomCats_Account.dragonflyingglyphs.autoEnabled == nil and true or TomCats_Account.dragonflyingglyphs.autoEnabled
        TomCats_Account.dragonflyingglyphs.iconsEnabled = TomCats_Account.dragonflyingglyphs.iconsEnabled == nil and true or TomCats_Account.dragonflyingglyphs.iconsEnabled
        TomCats_Account.dragonflyingglyphs.iconScale = TomCats_Account.dragonflyingglyphs.iconScale == nil and 0.8 or TomCats_Account.dragonflyingglyphs.iconScale
        --addon.dragonflyingglyphs.charm = addon.dragonflyingglyphs.Charms.Create({
        --    name = "TomCats-DragonFlyingGlyphsMinimapButton",
        --    iconTexture = "Interface\\ICONS\\inv_misc_bag_28_halloween",
        --    backgroundColor = { 0.0,0.0,0.0,1.0 },
        --    handler_onclick = function(_, button)
        --        if (IsShiftKeyDown()) then
        --            if (TomCats_Account.dragonflyingglyphs.autoEnabled) then
        --                TomCats_Account.dragonflyingglyphs.autoEnabled = false
        --                ChatFrame1:AddMessage("|cffffff00 The DragonFlying Glyphs automatic features are now disabled|r")
        --            else
        --                TomCats_Account.dragonflyingglyphs.autoEnabled = true
        --                ChatFrame1:AddMessage("|cffffff00 The DragonFlying Glyphs automatic features are now enabled|r")
        --            end
        --        elseif (button == "RightButton") then
        --            addon.SkipPumpkin()
        --        else
        --            if (TomCats_Account.dragonflyingglyphs.iconsEnabled) then
        --                TomCats_Account.dragonflyingglyphs.iconsEnabled = false
        --                ChatFrame1:AddMessage("|cffffff00 The DragonFlying Glyphs icons are now disabled|r")
        --                   else
        --                TomCats_Account.dragonflyingglyphs.iconsEnabled = true
        --                ChatFrame1:AddMessage("|cffffff00 The DragonFlying Glyphs icons are now enabled|r")
        --            end
        --        end
        --    end
        --})
        --addon.dragonflyingglyphs.charm.tooltip = {
        --    Show = function(this)
        --        TomCats_Account.dragonflyingglyphs.discovered = true
        --        addon.dragonflyingglyphs.charm.MinimapLoopPulseAnim:Stop()
        --        GameTooltip:ClearLines()
        --        GameTooltip:SetOwner(this, "ANCHOR_LEFT")
        --        GameTooltip:SetText("TomCat's Tours:", 1, 1, 1)
        --        GameTooltip:AddLine("DragonFlying Glyphs", nil, nil, nil, true)
        --        GameTooltip:AddLine(" ", nil, nil, nil, true)
        --        GameTooltip:AddLine("Follow the orange arrow for an efficient route leading to each of the candy buckets within the current continent", nil, nil, nil, true)
        --        GameTooltip:AddLine(" ", nil, nil, nil, true)
        --        GameTooltip:AddLine("<click> to toggle map icons", nil, nil, nil, true)
        --        GameTooltip:AddLine(" ", nil, nil, nil, true)
        --        GameTooltip:AddLine("<shift-click> to toggle automatic features", nil, nil, nil, true)
        --        GameTooltip:AddLine(" ", nil, nil, nil, true)
        --        GameTooltip:AddLine("<right-click> to skip the next candy bucket in the route", nil, nil, nil, true)
        --        GameTooltip:Show()
        --    end,
        --    Hide = function()
        --        GameTooltip:Hide()
        --    end
        --}
        --if (not TomCats_Account.dragonflyingglyphs.discovered) then
        --    addon.dragonflyingglyphs.charm.MinimapLoopPulseAnim:Play()
        --end
        --if (TomCats_Account.dragonflyingglyphs.preferences.hideButton) then
        --    addon.dragonflyingglyphs.charm:Hide()
        --end
    end
end
local function zoneTweak()
    if (BattlefieldMapFrame) then
        if GetCVar("showBattlefieldMinimap") == "1" then
            local mapID = MapUtil.GetDisplayableMapForPlayer()
            --todo: re-enable if Blizzard addresses that this causes taint spread
            --BattlefieldMapFrame:SetMapID(mapID)
        end
    end
end
local function zoneTweakRecheck()
    if (BattlefieldMapFrame) then
        local mapID1 = MapUtil.GetDisplayableMapForPlayer()
        local mapID2 = BattlefieldMapFrame:GetMapID()
        if (mapID1 ~= mapID2) then
            zoneTweak()
        end
        C_Timer.After(1, zoneTweakRecheck)
    else
        C_Timer.After(5, zoneTweakRecheck)
    end
end
addon.RegisterEvent("ADDON_LOADED", ADDON_LOADED)
TCL.Events.RegisterEvent("ZONE_CHANGED", zoneTweak)
TCL.Events.RegisterEvent("ZONE_CHANGED_INDOORS", zoneTweak)
TCL.Events.RegisterEvent("NEW_WMO_CHUNK", zoneTweak)
zoneTweakRecheck()
if (TomCats and TomCats.Register) then
    TomCats:Register(
        {
            name = "DragonFlying Glyphs",
            version = "01.00.26"
        }
    )
end
