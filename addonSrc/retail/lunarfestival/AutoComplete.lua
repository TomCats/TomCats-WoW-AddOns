local _, addon = ...
if (not addon.lunarfestival.IsEventActive()) then return end

local TCL = addon.lunarfestival.TomCatsLibs
local D = TCL.Data
local function QUEST_COMPLETE()
    local enabledVar = TomCats_Account and TomCats_Account.lunarfestival and TomCats_Account.lunarfestival.autoEnabled
    if (enabledVar) then
        local _, _, numItems, _, _, itemID = GetQuestItemInfo("reward", 1)
        if (itemID == 21100 and numItems == 1) then
            GetQuestReward(0)
        end
    end
end
local function GOSSIP_SHOW()
    local enabledVar = TomCats_Account and TomCats_Account.lunarfestival and TomCats_Account.lunarfestival.autoEnabled
    if (enabledVar) then
        local targetGUID = UnitGUID("target")
        if (targetGUID) then
            local guidParts = {}
            for guidPart in string.gmatch(targetGUID, "[^-]+") do
                table.insert(guidParts, guidPart)
            end
            if ("Creature" == guidParts[1] and D["Quest NPC Lookup"][tonumber(guidParts[6])]) then
                if (C_GossipInfo.GetNumActiveQuests() ~= 0) then
                    C_GossipInfo.SelectAvailableQuest(1)
                end
            end
        end
    end
end
local function BAG_UPDATE()
    local enabledVar = TomCats_Account and TomCats_Account.lunarfestival and TomCats_Account.lunarfestival.autoEnabled
    if (enabledVar) then
        local origState = GetCVar("autoLootDefault")
        for bagId = 0, 4 do
            for slot = 1, C_Container.GetContainerNumSlots(bagId) do
                local itemLink = C_Container.GetContainerItemLink(bagId, slot)
                if (itemLink) then
                    local itemId = C_Item.GetItemInfoInstant(itemLink)
                    if (itemId == 21746) then
                        if (origState == "0") then
                            SetCVar("autoLootDefault","1")
                        end
                        C_Container.UseContainerItem(bagId, slot)
                        if (not (GetCVar("autoLootDefault") == origState)) then
                            SetCVar("autoLootDefault", origState)
                        end
                        return
                    end
                end
            end
        end
    end
end
local function ADDON_LOADED(_, event, ...)
    local var1 = select(1, ...)
    if (var1 == addon.name) then
        TCL.Events.UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
        TCL.Events.RegisterEvent("QUEST_COMPLETE", QUEST_COMPLETE)
        TCL.Events.RegisterEvent("BAG_UPDATE", BAG_UPDATE)
        TCL.Events.RegisterEvent("GOSSIP_SHOW", GOSSIP_SHOW)
    end
end
TCL.Events.RegisterEvent("ADDON_LOADED", ADDON_LOADED)
