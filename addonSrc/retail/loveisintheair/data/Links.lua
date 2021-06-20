local _, addon = ...
if (not addon.loveisintheair.IsEventActive()) then return end

addon.loveisintheair.Data["Links"] = {
    ["community"] = { type = "joinCommunity" },
}
