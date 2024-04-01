local addonName, addon = ...
if (not addon.noblegarden.IsEventActive()) then return end
local chocolates = 0
local safeLoot = true
local lootAttempted = false
local primed = false

local function BAG_UPDATE()
    if (TomCats_Account.noblegarden.enabled and addon.noblegarden.IsEventActive()) then
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
                for slot = 1, C_Container.GetContainerNumSlots(bagId) do
                    local itemLink = C_Container.GetContainerItemLink(bagId, slot)
                    if (itemLink) then
                        local itemId = GetItemInfoInstant(itemLink)
                        if (itemId == 45072) then
                            C_Container.UseContainerItem(bagId, slot)
                            return
                        end
                    end
                end
            end
        else
            lootAttempted = true
        end
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
                function()
                    if (addon.noblegarden.IsEventActive()) then
                        local enabledString = string.format("Egg auto-looting is %s",
                                TomCats_Account.noblegarden.enabled and "enabled" or "disabled"
                        )
                        GameTooltip:AddLine(" ", nil, nil, nil, true)
                        GameTooltip:AddLine("Noblegarden is here!", nil, nil, nil, true)
                        GameTooltip:AddLine(" ", nil, nil, nil, true)
                        GameTooltip:AddLine("You have:\n".. chocolates .. " Noblegarden Chocolates", nil, nil, nil, true)
                        GameTooltip:AddLine(" ", nil, nil, nil, true)
                        GameTooltip:AddLine(enabledString, nil, nil, nil, true)
                    end
                end)
        addon.RegisterEvent("BAG_UPDATE", BAG_UPDATE)
        addon.RegisterEvent("UNIT_SPELLCAST_START", UNIT_SPELLCAST_START)
        addon.RegisterEvent("UNIT_SPELLCAST_STOP", UNIT_SPELLCAST_STOP)
        addon.UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
    end
end

addon.RegisterEvent("ADDON_LOADED", ADDON_LOADED)

