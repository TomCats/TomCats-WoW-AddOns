--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("osd")

local atlasName = "VignetteLoot"
local promotionEndTime = 1698164940
local modelFrame

local locale = {
    ["enUS"] = { lang = "en-us", title1 = "In-game content, free with Prime:", title2 = "\nZipao Tiger Pet\n\nPounce into battle with the uniquely colored Zipao Tiger pet.", click = "Click for details" },
    ["frFR"] = { lang = "fr-fr", title1 = "Contenu en jeu gratuit avec Prime:", title2 = "\nFamilier tigre Zipao\n\nBondissez dans la bataille avec le familier tigre Zipao aux couleurs uniques.", click = "Cliquer pour les détails" },
    ["deDE"] = { lang = "de-de", title1 = "Kostenlos mit Prime erhältliche Spielinhalte:", title2 = "\nHaustier „Zipao Tiger“\n\nStürze dich mit dem Kampfhaustier „Zipao Tiger“ ins Gefecht.", click = "Klicken Sie für weitere Details" },
    ["esES"] = { lang = "es-es", title1 = "Contenido de juegos, gratis con Prime:", title2 = "\nMascota Tigre zipao\n\nLánzate a la batalla con la mascota Tigre zipao y su color característico.", click = "Haga clic para obtener más detalles" },
    ["esMX"] = { lang = "es-mx", title1 = "Contenido en el juego gratis con Prime:", title2 = "\nMascota tigre Zipao\n\nMuestra tus garras en la batalla con la mascota tigre Zipao con un color único.", click = "Haga clic para obtener más detalles" },
    ["itIT"] = { lang = "it-it", title1 = "Contenuti di gioco, gratis con Prime:", title2 = "\nFamiglio Tigre Zipao\n\nLanciati in battaglia con il famiglio Tigre Zipao dai colori unici.", click = "Clicca per maggiori dettagli" },
    ["ptBR"] = { lang = "pt-br", title1 = "Conteúdo do jogo grátis com Prime:", title2 = "\nMascote Tigre Zipao\n\nPule para a batalha com o mascote colorido Tigre Zipao.", click = "Clique para mais detalhes" },
    ["ptPT"] = { lang = "pt-pt", title1 = "Conteúdo de jogo, grátis com o Prime:", title2 = "\nMascote Tigre Zipao\n\nLança-te à batalha com o exclusivamente colorido mascote Tigre Zipao.", click = "Clique para mais detalhes" },
}

local selectedLocale = locale[GetLocale()] or locale["enUS"]
local url = "https://gaming.amazon.com/zipao-tiger-pet/dp/amzn1.pg.item.f647d068-4d89-4d0f-b95d-d2e6810290be"

PrimeGamingLoot = { }

local visibilityFunctions = {
    [addon.constants.accessoryDisplay.SNOOZED] = function()
        return false
    end,
    [addon.constants.accessoryDisplay.ALWAYS] = function()
        return true
    end,
    [addon.constants.accessoryDisplay.NEVER] = function()
        return false
    end,
    [addon.constants.accessoryDisplay.NOINSTANCES] = function()
        local inInstance = IsInInstance()
        return not inInstance
    end,
}

function PrimeGamingLoot.GetVisibilityOption()
    return TomCats_Account.preferences.AccessoryWindow.primeGamingLoot
end

function PrimeGamingLoot.IsVisible()
    if (TomCats_Account.preferences.AccessoryWindow.primeGamingLoot == addon.constants.accessoryDisplay.SNOOZED
            and TomCats_Account.preferences.AccessoryWindow.snoozed["prime_zipao"] == nil) then
        TomCats_Account.preferences.AccessoryWindow.primeGamingLoot = addon.constants.accessoryDisplay.NOINSTANCES
    end
    if (GetServerTime() > promotionEndTime) then return false end
    --if (C_PetJournal.GetOwnedBattlePetString(171)) then return false end
    return visibilityFunctions[TomCats_Account.preferences.AccessoryWindow.primeGamingLoot]()
end

local function Wear(modelFrame_, itemID)
    local itemLink = "|cff9d9d9d|Hitem:" .. itemID .. "::::::::1:::::::::|h[]|h|r"
    modelFrame_:TryOn(itemLink)
end

function PrimeGamingLoot.Render(Timers, idx)
    local timerRow = Timers:GetTimerRow(idx)
    timerRow:SetIcon(atlasName)
    timerRow:SetTitle("Prime Gaming Loot Ends")
    timerRow:SetTimer(promotionEndTime, 0)

    timerRow.tooltipFunction = function()
        GameTooltip:AddLine(selectedLocale.title1, 1, 0.82, 0, false)
        local numLines = GameTooltip:NumLines()
        local line = _G[GameTooltip:GetName().."TextLeft"..numLines]
        line:SetJustifyH("CENTER")
        GameTooltip:AddLine(selectedLocale.title2, 1, 1, 1, true)
        numLines = GameTooltip:NumLines()
        line = _G[GameTooltip:GetName().."TextLeft"..numLines]
        line:SetJustifyH("CENTER")
        if (not modelFrame) then
            modelFrame = CreateFrame("Frame", nil, GameTooltip)
            modelFrame:SetSize(200, 200)
            --modelFrame:SetPoint("CENTER", GameTooltip, "CENTER")
            local model1 = CreateFrame("PlayerModel", nil, modelFrame)
            modelFrame.model1 = model1
            model1:SetSize(200, 200)
            local facing = 0
            local maxrads = 6.28319
            local duration = 3
            model1:SetScript("OnUpdate", function(self, elapsed)
                facing = (facing + maxrads * (elapsed / duration)) % maxrads
                self:SetFacing(facing)
            end)
        end
        GameTooltip_InsertFrame(GameTooltip, modelFrame)
        modelFrame:SetPoint("RIGHT", GameTooltip, "RIGHT", -12, 0);
        local model1 = modelFrame.model1
        model1:SetPoint("CENTER")
        model1:SetCreature(36910)
        model1:SetCamDistanceScale(1.9)
        modelFrame:Show()
        GameTooltip:AddLine(selectedLocale.click, 1, 1, 1, true)
        numLines = GameTooltip:NumLines()
        line = _G[GameTooltip:GetName().."TextLeft"..numLines]
        line:SetJustifyH("CENTER")
        GameTooltip:Show()
    end

    timerRow.clickFunction = function()
        options.TogglePopup(url, "Press CONTROL-C to copy the link", { "CENTER", UIParent, "CENTER" })
    end

    local height = timerRow:GetHeight() + 4
    timerRow:SetShown(true)
    return height
end

function PrimeGamingLoot.SetVisibilityOption(value)
    TomCats_Account.preferences.AccessoryWindow.primeGamingLoot = value
    if (value == addon.constants.accessoryDisplay.SNOOZED) then
        TomCats_Account.preferences.AccessoryWindow.snoozed["prime_zipao"] = true
    else
        TomCats_Account.preferences.AccessoryWindow.snoozed["prime_zipao"] = nil
    end
    UpdateVisibility()
end

C_Item.RequestLoadItemDataByID(3427)
C_Item.RequestLoadItemDataByID(10035)
C_Item.RequestLoadItemDataByID(6836)
C_Item.RequestLoadItemDataByID(38312)
