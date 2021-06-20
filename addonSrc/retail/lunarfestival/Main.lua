local addonName, addon = ...
if (not addon.lunarfestival.IsEventActive()) then return end

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
        map:AddDataProvider(CreateFromMixins(TomCatsLunarFestivalDataProviderMixin))
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
        addon.lunarfestival.charm = addon.lunarfestival.Charms.Create({
            name = "TomCats-LunarFestivalMinimapButton",
            iconTexture = "Interface\\AddOns\\TomCats\\lunarfestival\\images\\lunarfestival-icon",
            backgroundColor = { 0.0,0.0,0.0,1.0 },
            handler_onclick = function()
                if (not TomCats_Account.lunarfestival.discovered) then
                    TomCats_Account.lunarfestival.discovered = true
                    ChatFrame1:AddMessage("|TInterface/AddOns/TomCats/images/tomcat_chat_icon_lg.blp:16:32:0:2:64:64:0:64:0:32|t|cff00ff00 The Lunar Festival has arrived!|r")
                    ChatFrame1:AddMessage("|TInterface/AddOns/TomCats/images/tomcat_chat_icon_lg.blp:16:32:0:2:64:64:0:64:32:64|t|cffffff00 To toggle the Lunar Festival features, click and/or shift-click the icon|r")
                    addon.lunarfestival.charm.MinimapLoopPulseAnim:Stop()
                else
                    if (IsShiftKeyDown()) then
                        if (TomCats_Account.lunarfestival.autoEnabled) then
                            TomCats_Account.lunarfestival.autoEnabled = false
                            ChatFrame1:AddMessage("|cffffff00 The Lunar Festival quest automatic features are now disabled|r")
                        else
                            TomCats_Account.lunarfestival.autoEnabled = true
                            ChatFrame1:AddMessage("|cffffff00 The Lunar Festival quest automatic features are now enabled|r")
                        end
                    else
                        if (TomCats_Account.lunarfestival.iconsEnabled) then
                            TomCats_Account.lunarfestival.iconsEnabled = false
                            ChatFrame1:AddMessage("|cffffff00 The Lunar Festival icons are now disabled|r")
                            ChatFrame1:AddMessage("|cffffff00 (shift-click to toggle quest auto-looting)|r")
                        else
                            TomCats_Account.lunarfestival.iconsEnabled = true
                            ChatFrame1:AddMessage("|cffffff00 The Lunar Festival icons are now enabled|r")
                            ChatFrame1:AddMessage("|cffffff00 (shift-click to toggle quest auto-looting)|r")
                        end
                    end
                end
            end
        })
        addon.lunarfestival.charm.tooltip = {
            Show = function(this)
                GameTooltip:ClearLines()
                GameTooltip:SetOwner(this, "ANCHOR_LEFT")
                GameTooltip:SetText("TomCat's Tours:", 1, 1, 1)
                GameTooltip:AddLine("Lunar Festival", nil, nil, nil, true)
                GameTooltip:Show()
            end,
            Hide = function()
                GameTooltip:Hide()
            end
        }
        if (not TomCats_Account.lunarfestival.discovered) then
            addon.lunarfestival.charm.MinimapLoopPulseAnim:Play()
        end
        if (TomCats_Account.lunarfestival.preferences.hideButton) then
            addon.lunarfestival.charm:Hide()
        end
    end
end
local function zoneTweak()
    if (BattlefieldMapFrame) then
        if GetCVar("showBattlefieldMinimap") == "1" then
            local mapID = MapUtil.GetDisplayableMapForPlayer()
            BattlefieldMapFrame:SetMapID(mapID)
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
            name = "Lunar Festival",
            version = "01.00.26"
        }
    )
end
