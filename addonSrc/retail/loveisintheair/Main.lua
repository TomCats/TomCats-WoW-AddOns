local addonName, addon = ...
if (not addon.loveisintheair.IsEventActive()) then return end

local C_ClassTrial = C_ClassTrial
local C_Timer = C_Timer
local CreateFrame = CreateFrame
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local GameTooltip = GameTooltip
local GetItemCount = GetItemCount
local GetLFGDungeonRewardInfo = GetLFGDungeonRewardInfo
local GetLFGDungeonRewards = GetLFGDungeonRewards
local GetServerTime = GetServerTime
local RequestLFDPlayerLockInfo = RequestLFDPlayerLockInfo
local UIParent = UIParent
local UnitClass = UnitClass
local UnitFactionGroup = UnitFactionGroup
local UnitFullName = UnitFullName
local UnitGUID = UnitGUID
local UnitLevel = UnitLevel

CreateFrame("FRAME", "TomCats-LoveIsInTheAirTourGuideFrame", UIParent, "TomCats-LoveIsInTheAirTourGuideFrameTemplate")

local Books = addon.loveisintheair.Books
local AP
local book
local characters
local character

local function toggleUI()
    if (not AP["discovered"]) then
        AP["discovered"] = true
        addon.loveisintheair.charm.MinimapLoopPulseAnim:Stop()
    end
    if (not book) then
        addon.loveisintheair:initializeBook()
    else
        book:toggle()
    end
end
function addon.loveisintheair:initializeBook()
    book = Books.CreateBook()
    book:toggle()
    local overview = book:CreatePage("overview")
    local inset1 = overview:CreateInset({
        { "TOPLEFT", book, "TOPLEFT", book.pageOffsetX, book.pageOffsetY },
        { "BOTTOMRIGHT", book, "TOPLEFT", book.pageOffsetX + book.pageWidth, book.pageOffsetY - 77 }
    })
    overview:CreateInset({
        { "TOPLEFT", inset1, "BOTTOMLEFT", 0, -90 },
        { "BOTTOM", book, "BOTTOM", 0, 50 },
        { "RIGHT", book, "TOPLEFT", book.pageOffsetX + book.pageWidth - 47, 0 }
    })
    overview:CreateInset({
        { "TOPLEFT", inset1, "BOTTOMLEFT", 0, -8 },
        { "BOTTOM", inset1, "BOTTOM", 0, -52 },
        { "RIGHT", inset1, "CENTER", -4, 0 }
    })
    overview:CreateInset({
        { "TOPRIGHT", inset1, "BOTTOMRIGHT", 0, -8 },
        { "BOTTOM", inset1, "BOTTOM", 0, -52 },
        { "LEFT", inset1, "CENTER", 4, 0 }
    })
    overview:Show()
end
local characterInitialized = false
local function LFG_UPDATE_RANDOM_INFO()
    local initializing = not characterInitialized
    if (not characterInitialized) then
        local name, realm = UnitFullName("player")
        character.name = name or character.name
        character.realm = realm or character.realm
        character.class = select(2,UnitClass("player")) or character.class
        local level = UnitLevel("player")
        character.level = level and (level > character.level) and level or character.level
        character.faction = UnitFactionGroup("player") or character.faction
        character.completedDungeon = GetLFGDungeonRewards(288)
        character.timestamp = GetServerTime()
        characterInitialized = true
        addon.loveisintheair:UpdateCompleted()
    end
    addon.loveisintheair:SortedCharacterList()
    if (not character.canLootMount) then
        if (character.level >= 10) then
            if (C_ClassTrial.IsClassTrialCharacter() == false) then
                character.canLootMount = true
            else
                character.canLootMount = false
            end
            local _, _, _, _, _, lootItemID = GetLFGDungeonRewardInfo(288, 1)
            if ((lootItemID and lootItemID == 54537) or character.completedDungeon)  then
                character.completedDungeon = GetLFGDungeonRewards(288)
                character.timestamp = GetServerTime()
                if (not initializing) then
                    addon.loveisintheair:UpdateScrollFrame()
                end
                return
            end
        end
    end
    if (character.canLootMount and (not (character.completedDungeon and (character.timestamp >= addon.loveisintheair:GetLastResetTimestamp())))) then
        local completedDungeon = GetLFGDungeonRewards(288)
        if (completedDungeon) then
            character.completedDungeon = true
            character.timestamp = GetServerTime()
            if (not initializing) then
                addon.loveisintheair:UpdateScrollFrame()
                --DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00TomCat's Tours: Love is in the Air: |cffffffff" .. addon.loveisintheair.completedCharacters .. " of " .. addon.loveisintheair.eligibleCharacters .. " Completed Today|r")
            end
        end
    end
end
local function PLAYER_LEVEL_UP(_, level)
    character.level = level
    if (character.level == 10) then
        RequestLFDPlayerLockInfo()
    elseif (character.level > 10) then
        addon.loveisintheair:UpdateScrollFrame()
    end
end
local function LFG_COMPLETION_REWARD()
    if (not (character.completedDungeon and (character.timestamp >= addon.loveisintheair:GetLastResetTimestamp()))) then
        RequestLFDPlayerLockInfo()
    end
end
local lastBagUpdate
local bagUpdatePending = false
local function handleBagUpdate()
    bagUpdatePending = false
    lastBagUpdate = GetServerTime()
    character.boxes = GetItemCount(54537, true)
    character.charms = GetItemCount(49655, true)
    character.tokens = GetItemCount(49927, true)
    character.bracelets = GetItemCount(49916, true)
    if (addon.loveisintheair.bagUpdate) then
        addon.loveisintheair:bagUpdate()
    end
    addon.loveisintheair:UpdateScrollFrame()
end
local function BAG_UPDATE()
    if (bagUpdatePending) then return end
    local time = GetServerTime()
    if ((not lastBagUpdate) or (time == lastBagUpdate)) then
        bagUpdatePending = true
        C_Timer.After(1, handleBagUpdate)
    else
        handleBagUpdate()
    end
end
local function ADDON_LOADED(_, arg1)
    if (addonName == arg1) then
        addon.UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
        addon.RegisterEvent("LFG_UPDATE_RANDOM_INFO", LFG_UPDATE_RANDOM_INFO)
        addon.RegisterEvent("LFG_COMPLETION_REWARD", LFG_COMPLETION_REWARD)
        addon.RegisterEvent("PLAYER_LEVEL_UP", PLAYER_LEVEL_UP)
        addon.RegisterEvent("BAG_UPDATE", BAG_UPDATE)
        AP = TomCats_Account.loveisintheair
        characters = TomCats_Account.loveisintheair.characters
        local guid = UnitGUID("player")
        local UNKNOWN = "UNKNOWN"
        character = characters[guid] or {
            name = UNKNOWN,
            realm = UNKNOWN,
            class = UNKNOWN,
            timestamp = 0,
            completedDungeon = false,
            level = 0,
            boxes = 0,
            charms = 0,
            tokens = 0,
            bracelets = 0,
            canLootMount = false,
            faction = UNKNOWN
        }
        characters[guid] = character
        addon.loveisintheair.character = character
        addon.loveisintheair.charm = addon.loveisintheair.Charms.Create({
            name = "TomCats-LoveIsInTheAirMinimapButton2023",
            iconTexture = "Interface\\AddOns\\TomCats\\loveisintheair\\images\\liith-icon",
            backgroundColor = { 0.0,0.0,0.0,1.0 },
            handler_onclick = toggleUI
        })
        addon.loveisintheair.charm.tooltip = {
            Show = function(this)
                GameTooltip:ClearLines()
                GameTooltip:SetOwner(this, "ANCHOR_LEFT")
                GameTooltip:SetText("TomCat's Tours:", 1, 1, 1)
                GameTooltip:AddLine("Love is in the Air", nil, nil, nil, true)
                GameTooltip:Show()
            end,
            Hide = function()
                GameTooltip:Hide()
            end
        }
        if (not AP["discovered"]) then
            addon.loveisintheair.charm.MinimapLoopPulseAnim:Play()
        end
        if (TomCats_Account.loveisintheair.preferences.hideButton) then
            addon.loveisintheair.charm:Hide()
        end
    end
end
addon.RegisterEvent("ADDON_LOADED", ADDON_LOADED)
