local _, addon = ...
if (not addon.loveisintheair.IsEventActive()) then return end

addon.loveisintheair.Data["Chapters"] = {
    { title = "Chapter 1:\nIntro", icon = "Interface\\ICONS\\Inv_valentinesboxofchocolates02" },
}
