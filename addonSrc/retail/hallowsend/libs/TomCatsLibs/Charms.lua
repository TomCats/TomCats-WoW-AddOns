local addonName, addon = ...
if (not addon.hallowsend.IsEventActive()) then return end

local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local Minimap = Minimap
local MinimapCluster = MinimapCluster
local MinimapZoneTextButton = MinimapZoneTextButton

addon.hallowsend.Charms = { }

local seqNum = 1;

--[[-- Begin SexyMap Compatibility --
local sexyMapQueue

local function setupButtonForSexyMap(btn)
    local sexyMapPresent = select(4, GetAddOnInfo("SexyMap"))
    if (not sexyMapPresent) then return end
    local _, sexyMapLoaded = IsAddOnLoaded("SexyMap")
    if (not sexyMapLoaded) then
        if (not sexyMapQueue) then
            sexyMapQueue = { }
            local function processQueue(_, arg1)
                if (arg1 == "SexyMap") then
                    addon.UnregisterEvent("ADDON_LOADED", processQueue)
                    for _, button in ipairs(sexyMapQueue) do
                        setupButtonForSexyMap(button)
                    end
                end
            end
            addon.RegisterEvent("ADDON_LOADED", processQueue)
        end
        table.insert(sexyMapQueue, btn)
        return
    end
    local ldbiMock = CreateFromMixins(btn)
    setmetatable(ldbiMock, getmetatable(btn))
    function ldbiMock:GetName() return "LibDBIcon10_" .. btn.title end
    function ldbiMock:SetScript() end
    function ldbiMock:SetPoint() end
    function ldbiMock:SetAllPoints() end
    function ldbiMock:ClearAllPoints() end
    function ldbiMock:Hide() end
    function ldbiMock:Show() end
    _G[ldbiMock:GetName()] = ldbiMock
    table.insert(LibStub["libs"]["LibDBIcon-1.0"].objects, ldbiMock)
    LibStub["libs"]["LibDBIcon-1.0"].callbacks:Fire("LibDBIcon_IconCreated", ldbiMock, btn.title)
end

-- End SexyMap Compatibility --]]

local TOMCATS_LIBS_ICON_LASTFRAMELEVEL = 10

function addon.hallowsend.Charms.Create(buttonInfo)
    --noinspection GlobalCreationOutsideO
    if (MinimapZoneTextButton and MinimapZoneTextButton:GetParent() == MinimapCluster) then
        MinimapZoneTextButton:SetParent(Minimap)
    end
    local name = buttonInfo.name
    if (not name) then
        name = addonName .. "MinimapButton" .. seqNum
        seqNum = seqNum + 1
    end
    --noinspection UnusedDef
    local frame = CreateFrame("Button", name, Minimap, "TomCats-HallowsEndMinimapButtonTemplate");
    frame:SetFrameLevel(TOMCATS_LIBS_ICON_LASTFRAMELEVEL)
    if (buttonInfo.backgroundColor) then
        local background = _G[name .. "Background"];
        background:SetDrawLayer("BACKGROUND", 1)
        background:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMaskSmall")
        background:SetWidth(25)
        background:SetHeight(25)
        background:SetVertexColor(unpack(buttonInfo.backgroundColor))
        frame.backgroundColor = buttonInfo.backgroundColor
    end
    frame.title = buttonInfo.title or name
    if (buttonInfo.iconTexture) then
        _G[name .. "Icon"]:SetTexture(buttonInfo.iconTexture)
    end
    if (buttonInfo.name) then
        local scope = TomCats_Account.preferences
        if (scope[name]) then
            frame:SetPreferences(scope[name])
        else
            scope[name] = frame:GetPreferences()
        end
    end
    if (buttonInfo.handler_onclick) then
        frame:SetHandler("OnClick",
                function(...)
                    if (not InCombatLockdown()) then
                        buttonInfo.handler_onclick(...)
                    end
                end)
    end
    -- need to fix this before re-enabling: SexyMap will fade out our icon but will not put it back
    -- setupButtonForSexyMap(frame)
    return frame
end
