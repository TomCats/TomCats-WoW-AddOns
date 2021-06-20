local _, addon = ...
if (not addon.lunarfestival.IsEventActive()) then return end

local TCL = addon.TomCatsLibs
local D = TCL.Data
-- hard disabled due to no saved variables at current release
local P = { showCompleted = false }
local providers = { }
local PlayerFaction = UnitFactionGroup("player")
local TITLE_COLOR = CreateColor(1.0, 0.82, 0.0, 1.0)
local WHITE_COLOR = CreateColor(1.0, 1.0, 1.0, 1.0)
local GREY_COLOR = CreateColor(0.8, 0.8, 0.8, 1.0)
local RED_COLOR = CreateColor(1.0, 0.0, 0.0, 1.0)
local GREEN_COLOR = CreateColor(0.0, 1.0, 0.0, 1.0)
local IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted

local WorldMapTooltip = TomCatsLunarFestivalGameTooltip

local function ShowHide(element, condition)
    if (condition) then
        element:Show()
        return true
    end
    element:Hide()
    return false
end

local function IsAreQuestsCompleted(pinInfo)
    if (pinInfo.quest) then
        return IsQuestFlaggedCompleted(pinInfo.quest["Quest ID"])
    else
        local questIDs = pinInfo.entrance["Quest IDs"]
        for i = 1, #questIDs do
            if (not IsQuestFlaggedCompleted(questIDs[i])) then
                return false
            end
        end
    end
    return true
end
local function addToTomTom(waypointInfo, setClosest)
    TomTom:AddWaypoint(waypointInfo.uiMapID, waypointInfo.location.x, waypointInfo.location.y, {
        title = waypointInfo.title,
        persistent = nil,
        minimap = true,
        world = true,
    })
    if (setClosest and (not IsInInstance())) then
        TomTom:SetClosestWaypoint()
    end
end
local function addQuestToTomTom(quest, setClosest)
    addToTomTom({
        uiMapID = quest["UIMap ID"],
        location = quest["Location"],
        title = addon.getCreatureNameByQuestID(quest["Quest ID"]) .. "\n(" ..  C_Map.GetAreaInfo(quest["Area ID"]) .. ")"
    }, setClosest)
end
local function addEntranceToTomTom(entrance, setClosest)
    local questCount = #entrance["Quest IDs"]
    local quest = D["Quests"][entrance["Quest IDs"][1]]
    local title
    if (questCount == 1) then
        title = addon.getCreatureNameByQuestID(quest["Quest ID"]) .. "\n(" ..  C_Map.GetAreaInfo(quest["Area ID"]) .. ")"
    else
        title = addon.getCreatureNameByQuestID(quest["Quest ID"]) .. "\n(" ..  C_Map.GetAreaInfo(quest["Area ID"]) .. ")\nplus " .. (questCount - 1) .. "more"
    end
    addToTomTom({
        uiMapID = entrance["UIMap ID"],
        location = entrance["Location"],
        title = title
    }, setClosest)
end
TomCatsLunarFestivalDataProviderMixin = CreateFromMixins(MapCanvasDataProviderMixin)
function TomCatsLunarFestivalDataProviderMixin.UpdatePreferences()
    for i = 1, #providers do
        providers[i]:RefreshAllData()
    end
end

local enabled = false

local allPins = { }

TomCatsLunarFestivalDataProviderMixin.activePins = {}
TomCatsLunarFestivalDataProviderMixin.activeEntrancePins = {}
TomCatsLunarFestivalDataProviderMixin.activePathways = {}
TomCatsLunarFestivalDataProviderMixin.activePOIs = {}

function TomCatsLunarFestivalDataProviderMixin:AcquireLine()
    local line = self.linePool:Acquire()
    allPins[line] = line
    return line
end

function TomCatsLunarFestivalDataProviderMixin:ReleaseLine(line)
    allPins[line] = nil
    self.linePool:Release(line)
    line:Hide()
end

function TomCatsLunarFestivalDataProviderMixin:QUEST_TURNED_IN(_, questID)
    local pin = self.activePins[questID]
    if (pin) then
        if (not pin.completed) then
            if (P.showCompleted) then
                pin:SetIconState("Completed")
                pin.completed = true
            else
                self:GetMap():RemovePin(self.activePins[questID])
                self.activePins[questID] = nil
            end
        end
    end
    local entrancePinIDs = D["Entrance IDs by Quest ID Lookup"][questID]
    if (entrancePinIDs) then
        for i = 1, #entrancePinIDs do
            local entrancePin = self.activeEntrancePins[entrancePinIDs[i]]
            if (entrancePin) then
                if (not entrancePin.completed) then
                    if (IsAreQuestsCompleted(entrancePin.pinInfo)) then
                        if (P.showCompleted) then
                            entrancePin:SetIconState("Completed")
                            entrancePin.completed = true
                        else
                            self:GetMap():RemovePin(self.activeEntrancePins[entrancePinIDs[i]])
                            self.activeEntrancePins[entrancePinIDs[i]] = nil
                        end
                    end
                end
            end
        end
    end
    if (not P.showCompleted) then
        local pathways = D["Pathways by Quest ID Lookup"][questID]
        if (pathways) then
            for _, pathway in ipairs(pathways) do
                local activePathway = self.activePathways[pathway["Pathway ID"]]
                if (activePathway) then
                    for _, line in ipairs(activePathway) do
                        self:ReleaseLine(line)
                    end
                    self.activePathways[pathway["Pathway ID"]] = nil
                end
            end
        end
    end
end
function TomCatsLunarFestivalDataProviderMixin:QUEST_LOG_UPDATE()
    for questID, pin in pairs(self.activePins) do
        if (not pin.completed) then
            if (IsQuestFlaggedCompleted(questID)) then
                if (P.showCompleted) then
                    pin.completed = true
                    pin:SetIconState("Completed")
                else
                    self:QUEST_TURNED_IN(nil, questID)
                end
            end
        end
    end
    for entrance, pin in pairs(self.activeEntrancePins) do
        if (not pin.completed) then
            if (IsAreQuestsCompleted(pin.pinInfo)) then
                if (P.showCompleted) then
                    pin.completed = true
                    pin:SetIconState("Completed")
                else
                    self:GetMap():RemovePin(self.activeEntrancePins[entrance])
                    self.activeEntrancePins[entrance] = nil
                end
            end
        end
    end
    if (not P.showCompleted) then
        for pathwayID, activePathway in pairs(self.activePathways) do
            if (IsQuestFlaggedCompleted(D["Pathways"][pathwayID]["Quest ID"])) then
                for _, line in ipairs(activePathway) do
                    self.linePool:Release(line)
                end
                self.activePathways[pathwayID] = nil
            end
        end
    end
end
function TomCatsLunarFestivalDataProviderMixin:OnAdded(owningMap)
    MapCanvasDataProviderMixin.OnAdded(self, owningMap)
    if not self.linePool then
        self.linePool = CreateFramePool("FRAME", self:GetMap():GetCanvas(), "TomCatsLunarFestivalPathwayLineTemplate");
    end
    -- P = addon.savedVariables.character.preferences
    table.insert(providers, self)
    TCL.Events.RegisterEvent("QUEST_TURNED_IN", self)
    TCL.Events.RegisterEvent("QUEST_LOG_UPDATE", self)
end
local function canShowEntrance(entrance)
    if (entrance["Type"] == 3 and PlayerFaction == "Horde") then return false end
    if (entrance["Type"] == 4 and PlayerFaction == "Alliance") then return false end
    return true
end
function TomCatsLunarFestivalDataProviderMixin:RefreshAllData(fromOnShow)
    self.activeMapID = self:GetMap():GetMapID()
    for _, pin in pairs(self.activePins) do
        self:GetMap():RemovePin(pin)
    end
    self.activePins = {}
    for _, pin in pairs(self.activeEntrancePins) do
        self:GetMap():RemovePin(pin)
    end
    self.activeEntrancePins = {}
    for _, pathway in pairs(self.activePathways) do
        for _, line in ipairs(pathway) do
            self:ReleaseLine(line)
        end
    end
    self.activePathways = {}
    for _, pin in pairs(self.activePOIs) do
        self:GetMap():RemovePin(pin)
    end
    self.activePOIs = {}
    local lookup = D["Pathways by UIMap ID Lookup"][self.activeMapID]
    if (lookup) then
        for i = 1, #lookup do
            local pathway = lookup[i]
            if (P.showCompleted or (not IsQuestFlaggedCompleted(pathway["Quest ID"]))) then
                local width = self:GetMap():GetCanvas():GetWidth()
                local height = self:GetMap():GetCanvas():GetHeight()
                local path = lookup[i]["Path"]
                local activePathway = {}
                for j = 1, #path - 1 do
                    local line = self:AcquireLine()
                    line.Fill:SetThickness(3)
                    line.Fill:SetStartPoint("TOPLEFT", self:GetMap():GetCanvas(), width * path[j].x, - height * path[j].y)
                    line.Fill:SetEndPoint("TOPLEFT", self:GetMap():GetCanvas(), width * path[j+1].x, - height * path[j+1].y)
                    ShowHide(line, enabled)
                    table.insert(activePathway, line)
                end
                self.activePathways[pathway["Pathway ID"]] = activePathway
            end
        end
    end
    lookup = D["Quest IDs by UIMap ID Lookup"][self.activeMapID]
    if (lookup) then
        for i = 1, #lookup do
            local quest = lookup[i]
            if (P.showCompleted or (not IsQuestFlaggedCompleted(quest["Quest ID"]))) then
                local location = quest["Location"]
                if (quest["UIMap ID"] ~= self:GetMap():GetMapID()) then
                    local continentID, worldPosition = C_Map.GetWorldPosFromMapPos(quest["UIMap ID"], location)
                    local uiMapID, mapPosition = C_Map.GetMapPosFromWorldPos(continentID, worldPosition, self:GetMap():GetMapID())
                    location = mapPosition
                end
                if (location) then
                    self.activePins[quest["Quest ID"]] = self:GetMap():AcquirePin("TomCatsLunarFestivalPinTemplate", {
                        quest = quest,
                        location = location,
                        provider = self
                    })
                end
            end
        end
    end
    lookup = D["Entrance IDs by UIMap ID Lookup"][self.activeMapID]
    if (lookup) then
        for i = 1, #lookup do
            local entrance = lookup[i]
            if (canShowEntrance(entrance)) then
                local pinInfo = {
                    entrance = entrance,
                    provider = self
                }
                local allCompleted = IsAreQuestsCompleted(pinInfo)
                if (P.showCompleted or (not allCompleted)) then
                    local location = entrance["Location"]
                    if (entrance["UIMap ID"] ~= self:GetMap():GetMapID()) then
                        local continentID, worldPosition = C_Map.GetWorldPosFromMapPos(entrance["UIMap ID"], location)
                        local _, mapPosition = C_Map.GetMapPosFromWorldPos(continentID, worldPosition, self:GetMap():GetMapID())
                        location = mapPosition
                    end
                    if (location) then
                        pinInfo.location = location
                        self.activeEntrancePins[entrance["Entrance ID"]] = self:GetMap():AcquirePin("TomCatsLunarFestivalPinTemplate", pinInfo)
                    end
                end
            end
        end
    end
    local phasedZones = D["Phased Zone by Visible UIMap ID Lookup"][self.activeMapID]
    if (phasedZones) then
        for _, phasedZone in pairs(phasedZones) do
            if (C_Map.GetMapArtID(phasedZone["UIMap ID"]) ~= phasedZone["Timewalking Map Art ID"]) then
                local displayPOI = false
                for i = 1, #phasedZone["Quest IDs"] do
                    if (P.showCompleted or (not IsQuestFlaggedCompleted(phasedZone["Quest IDs"][i]))) then
                        displayPOI = true
                    end
                end
                if (displayPOI) then
                    local poiInfo = CreateFromMixins(C_AreaPoiInfo.GetAreaPOIInfo(phasedZone["UIMap ID"], phasedZone["Timewalking NPC POI ID"]))
                    if (poiInfo.position) then
                        local continentID, worldPosition = C_Map.GetWorldPosFromMapPos(phasedZone["UIMap ID"], poiInfo.position)
                        local uiMapID, mapPosition = C_Map.GetMapPosFromWorldPos(continentID, worldPosition, self:GetMap():GetMapID())
                        poiInfo.position = mapPosition
                        self.activePOIs[poiInfo.areaPoiID] = self:GetMap():AcquirePin("TomCatsLunarFestivalAreaPOIPinTemplate", poiInfo)
                    end
                end
            end
        end
    end
end
TomCatsLunarFestivalAreaPOIPinMixin = CreateFromMixins(AreaPOIPinMixin)

function TomCatsLunarFestivalAreaPOIPinMixin:OnAcquired(pinInfo)
    AreaPOIPinMixin.OnAcquired(self, pinInfo)
    ShowHide(self, enabled)
end

--TomCatsLunarFestivalPinMixin = CreateFromMixins(MapCanvasPinMixin)
TomCatsLunarFestivalPinMixin = CreateFromMixins(addon.GetProxy(MapCanvasPinMixin))

function TomCatsLunarFestivalPinMixin:ApplyFrameLevel()
    local frameLevel = self:GetMap():GetPinFrameLevelsManager():GetValidFrameLevel("PIN_FRAME_LEVEL_MAP_LINK")
    self:SetFrameLevel(frameLevel)
end

function TomCatsLunarFestivalPinMixin:OnAcquired(pinInfo)
    self.completed = nil;
    self:SetIconState("Default")
    self.iconDungeon:Hide()
    self.iconEntrance:Hide()
    self.iconPortalAlliance:Hide()
    self.iconPortalHorde:Hide()
    self.iconPhased:Hide()
    self.pinInfo = pinInfo
    self:SetPosition(pinInfo.location.x, pinInfo.location.y)
    if (IsAreQuestsCompleted(pinInfo)) then
        self.completed = true
        self:SetIconState("Completed")
    end
    if (pinInfo.entrance) then
        if (pinInfo.entrance["Type"] == 1) then
            self.iconEntrance:Show();
        elseif (pinInfo.entrance["Type"] == 2) then
            self.iconDungeon:Show();
        elseif (pinInfo.entrance["Type"] == 3) then
            self.iconPortalAlliance:Show();
        elseif (pinInfo.entrance["Type"] == 4) then
            self.iconPortalHorde:Show();
        end
    elseif (pinInfo.quest) then
        local phasedZone = D["Phased Zone by Quest ID Lookup"][pinInfo.quest["Quest ID"]]
        if (phasedZone) then
            if (C_Map.GetMapArtID(phasedZone["UIMap ID"]) ~= phasedZone["Timewalking Map Art ID"]) then
                local poiInfo = CreateFromMixins(C_AreaPoiInfo.GetAreaPOIInfo(phasedZone["UIMap ID"], phasedZone["Timewalking NPC POI ID"]))
                if (poiInfo.position) then
                    self.iconPhased:Show()
                    self.pinInfo.phasedZone = phasedZone
                end
            end
        end
    end
    allPins[self] = true
    ShowHide(self, enabled)
end
function TomCatsLunarFestivalPinMixin:OnCanvasScaleChanged()
    local scaleBase = 0.425
    local uiMapID = self:GetMap():GetMapID()
    if (uiMapID == 12 or uiMapID == 13 or uiMapID == 113) then scaleBase = 0.35 end
    self:SetScale(scaleBase * self:GetMap():GetGlobalPinScale() / self:GetParent():GetScale())
    self:SetPosition(self.pinInfo.location.x, self.pinInfo.location.y)
end

TomCatsLunarFestivalPinMixin.OnLoad = nop

function TomCatsLunarFestivalPinMixin:OnReleased()
    allPins[self] = nil
    self:Hide()
end

function TomCatsLunarFestivalPinMixin:ShowTooltip()
    local tooltip = WorldMapTooltip
    WorldMapTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 10, 20)
    WorldMapTooltip:ClearLines();
    local questIDs
    if (self.pinInfo.quest) then questIDs = { self.pinInfo.quest["Quest ID"] } else questIDs = self.pinInfo.entrance["Quest IDs"] end
    if (self.pinInfo.entrance) then
        if (self.pinInfo.entrance["Type"] == 3) then
            GameTooltip_AddColoredLine(tooltip, "Portals leading to:", GREEN_COLOR, true)
            GameTooltip_AddColoredLine(tooltip, "(Alliance Only)", WHITE_COLOR, true)
            GameTooltip_AddBlankLinesToTooltip(tooltip, 1);
        elseif (self.pinInfo.entrance["Type"] == 4) then
            GameTooltip_AddColoredLine(tooltip, "Portals leading to:", GREEN_COLOR, true)
            GameTooltip_AddColoredLine(tooltip, "(Horde Only)", WHITE_COLOR, true)
            GameTooltip_AddBlankLinesToTooltip(tooltip, 1);
        end
    end
    local questIDsToShow = {}
    for i = 1, #questIDs do
        if (P.showCompleted or (not IsQuestFlaggedCompleted(questIDs[i]))) then
            table.insert(questIDsToShow,questIDs[i])
        end
    end
    for i = 1, #questIDsToShow do
            GameTooltip_AddColoredLine(tooltip, addon.getCreatureNameByQuestID(questIDsToShow[i]), TITLE_COLOR, true)
            GameTooltip_AddColoredLine(tooltip, C_Map.GetAreaInfo(D["Quests"][questIDsToShow[i]]["Area ID"]), WHITE_COLOR, true)
            if (self.completed) then
                GameTooltip_AddColoredLine(tooltip, "Completed", RED_COLOR, true)
            end
            if (i < #questIDs) then
                GameTooltip_AddBlankLinesToTooltip(tooltip, 1);
            end
    end
    if (self.pinInfo.entrance) then
        if (self.pinInfo.entrance["Type"] == 1) then
            GameTooltip_AddBlankLinesToTooltip(tooltip, 1);
            GameTooltip_AddColoredLine(tooltip, "(Entryway)", GREY_COLOR, true)
        elseif (self.pinInfo.entrance["Type"] == 2) then
            GameTooltip_AddBlankLinesToTooltip(tooltip, 1);
            GameTooltip_AddColoredLine(tooltip, "(Dungeon Entrance)", GREY_COLOR, true)
        end
    end
    if (self.pinInfo.phasedZone) then
        local phasedZone = self.pinInfo.phasedZone
        GameTooltip_AddBlankLinesToTooltip(tooltip, 1)
        local poiInfo = C_AreaPoiInfo.GetAreaPOIInfo(phasedZone["UIMap ID"], phasedZone["Timewalking NPC POI ID"])
        GameTooltip_AddColoredLine(tooltip, "This NPC is in a different phase", RED_COLOR, true)
        GameTooltip_AddColoredLine(tooltip, "Visit " .. poiInfo.name .. " first:", RED_COLOR, true)
        GameTooltip_AddColoredLine(tooltip, poiInfo.description, GREY_COLOR, true)
    end
    if (TomTom) then
        GameTooltip_AddBlankLinesToTooltip(tooltip, 1)
        GameTooltip_AddColoredLine(tooltip, "Click to add a TomTom Waypoint", WHITE_COLOR, true)
        GameTooltip_AddColoredLine(tooltip, "Right-Click to add all visible waypoints from this map", WHITE_COLOR, true)
    end
    WorldMapTooltip:Show()
    WorldMapTooltip.recalculatePadding = true
end
function TomCatsLunarFestivalPinMixin:HideItemTooltip()
    WorldMapTooltip:Hide()
end
function TomCatsLunarFestivalPinMixin:SetIconState(state)
   local iconStates = self:GetIconStates()
   local stateTexture = self["icon" .. state]
   for i = 1, #iconStates do
       if (iconStates[i] ~= stateTexture) then iconStates[i]:Hide() end
   end
    stateTexture:Show()
end
function TomCatsLunarFestivalPinMixin:OnMouseEnter()
    self:SetIconState("Highlighted")
    self:ShowTooltip()
end
function TomCatsLunarFestivalPinMixin:OnMouseLeave()
    if (not self.completed) then
        self:SetIconState("Default")
    else
        self:SetIconState("Completed")
    end
    self:HideItemTooltip()
end
function TomCatsLunarFestivalPinMixin:OnMouseDown()
--    setIconState(self.iconPushed)
--    self:HideItemTooltip()
end
function TomCatsLunarFestivalPinMixin:OnMouseUp(button)
    if (TomTom) then
        if (button == "LeftButton") then
            if (self.pinInfo.quest) then
                addQuestToTomTom(self.pinInfo.quest, true)
            end
            if (self.pinInfo.entrance) then
                addEntranceToTomTom(self.pinInfo.entrance, true)
            end
        end
        if (button == "RightButton") then
            for _, pin in pairs(self.pinInfo.provider.activePins) do
                addQuestToTomTom(pin.pinInfo.quest, false)
            end
            for _, pin in pairs(self.pinInfo.provider.activeEntrancePins) do
                addEntranceToTomTom(pin.pinInfo.entrance, false)
            end
            if (not IsInInstance()) then
                TomTom:SetClosestWaypoint()
            end
        end
    end
end
function TomCatsLunarFestivalPinMixin:GetIconStates()
    return { self.iconDefault, self.iconHighlighted, self.iconPushed, self.iconCompleted }
end

local function OnUpdate()
    local enabledVar = TomCats_Account and TomCats_Account.lunarfestival and TomCats_Account.lunarfestival.iconsEnabled
    if (enabledVar ~= enabled) then
        enabled = enabledVar
        for pin in pairs(allPins) do
            ShowHide(pin, enabled)
        end
    end
end

CreateFrame("FRAME"):SetScript("OnUpdate",OnUpdate)
