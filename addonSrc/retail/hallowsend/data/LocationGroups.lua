local _, addon = ...
if (not addon.hallowsend.IsEventActive()) then return end

select(2, ...).hallowsend.TomCatsLibs.Data.loadData(
    "Location Groups",
    { "Group ID" },
    {
        {12},
        {13},
        {101},
        {113},
        {203},
        {207},
        {424},
            -- Removed due to inability to get a player's coordinates while they are inside of the garrison
            -- {572},
        {619},
        {875},
        {876},
        {1978},
        {2133},
    }
)
