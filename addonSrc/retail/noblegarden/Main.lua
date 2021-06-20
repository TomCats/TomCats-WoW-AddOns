local addonName, addon = ...
if (not addon.noblegarden.IsEventActive()) then return end

local chocolates = 0
local safeLoot = true
local lootAttempted = false
local primed = false

local function BAG_UPDATE()
    local eggs = GetItemCount(45072, true)
    if (eggs > 0 and (not primed)) then
        primed = true
        C_Timer.After(1,BAG_UPDATE)
        return
    end
    primed = false
    if (safeLoot) then
        chocolates = GetItemCount(44791, true)
        for bagId = 0, 4 do
            for slot = 1, GetContainerNumSlots(bagId) do
                local itemLink = GetContainerItemLink(bagId, slot)
                if (itemLink) then
                    local itemId = GetItemInfoInstant(itemLink)
                    if (itemId == 45072) then
                        UseContainerItem(bagId, slot)
                        return
                    end
                end
            end
        end
    else
        lootAttempted = true
    end
end

local function UNIT_SPELLCAST_START()
    safeLoot = false
end

local function UNIT_SPELLCAST_STOP()
    safeLoot = true
    if (lootAttempted) then
        lootAttempted = false
        BAG_UPDATE()
    end
end

local function ADDON_LOADED(_, arg1)
    if (addonName == arg1) then
        table.insert(addon.minimapButton.ShowHandlers,
        function(this)
                GameTooltip:AddLine(" ", nil, nil, nil, true)
                GameTooltip:AddLine("Noblegarden is active", nil, nil, nil, true)
                GameTooltip:AddLine(" ", nil, nil, nil, true)
                GameTooltip:AddLine("You have:\n".. chocolates .. " Noblegarden Chocolates", nil, nil, nil, true)
                GameTooltip:AddLine(" ", nil, nil, nil, true)
                GameTooltip:AddLine("Egg auto-looting enabled", nil, nil, nil, true)
                end)
        addon.RegisterEvent("BAG_UPDATE", BAG_UPDATE)
        addon.RegisterEvent("UNIT_SPELLCAST_START", UNIT_SPELLCAST_START)
        addon.RegisterEvent("UNIT_SPELLCAST_STOP", UNIT_SPELLCAST_STOP)
        addon.UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
    end
end

addon.RegisterEvent("ADDON_LOADED", ADDON_LOADED)

