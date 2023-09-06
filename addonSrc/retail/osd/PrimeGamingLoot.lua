--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("osd")

local atlasName = "VignetteLoot"
local promotionEndTime = 1695918540
local modelFrame

local locale = {
    ["enUS"] = { lang = "en-us", title1 = "In-game content, free with Prime:", title2 = "\nTabard of Brilliance Transmog\n\nShow off your devotion to the Light with the Tabard of Brilliance.", click = "Click for details" },
    ["frFR"] = { lang = "fr-fr", title1 = "Contenu en jeu gratuit avec Prime:", title2 = "\nTransmogrification Tabard de la brillance\n\nMontrez votre dévotion pour la Lumière avec le Tabard de brillance.", click = "Cliquer pour les détails" },
    ["deDE"] = { lang = "de-de", title1 = "Kostenlos mit Prime erhältliche Spielinhalte:", title2 = "\nTransmog vom Waffenrock der Brillanz\n\nZeige mit dem Wappenrock der Brillanz deine Treue zum Licht.", click = "Klicken Sie für weitere Details" },
    ["esES"] = { lang = "es-es", title1 = "Contenido de juegos, gratis con Prime:", title2 = "\nTransfiguración del Tabardo de resplandor\n\nDemuestra tu devoción a la Luz con el Tabardo de resplandor.", click = "Haga clic para obtener más detalles" },
    ["esMX"] = { lang = "es-mx", title1 = "Contenido en el juego gratis con Prime:", title2 = "\nTransfiguración Tabardo de resplandor\n\nDemuestra tu devoción a la Luz con el Tabardo de resplandor.", click = "Haga clic para obtener más detalles" },
    ["itIT"] = { lang = "it-it", title1 = "Contenuti di gioco, gratis con Prime:", title2 = "\nTrasmogrificazione Insegna dell'Acume\n\nMostra la tua devozione alla Luce con l’Insegna dell'Acume.", click = "Clicca per maggiori dettagli" },
    ["ptBR"] = { lang = "pt-br", title1 = "Conteúdo do jogo grátis com Prime:", title2 = "\nTransmogrificação Tabardo da Inteligência\n\nMostre sua devoção à Luz com o Tabardo da Inteligência.", click = "Clique para mais detalhes" },
    ["ptPT"] = { lang = "pt-br", title1 = "Conteúdo de jogo, grátis com o Prime:", title2 = "\nTransmog Tabardo de Resplendor\n\nMostra a tua devoção à Luz com o Tabardo de Resplendor.", click = "Clique para mais detalhes" },
}

local selectedLocale = locale[GetLocale()] or locale["enUS"]
local url = "https://gaming.amazon.com/dp/amzn1.pg.item.270f6968-8b67-4923-9c58-4e3aa121ce8d"

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
            and TomCats_Account.preferences.AccessoryWindow.snoozed["prime_tabardofbrilliance"] == nil) then
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
            local model1 = CreateFrame("DressupModel", nil, modelFrame)
            modelFrame.model1 = model1
            model1:SetSize(200, 200)
            local facing = 0
            local maxrads = 6.28319
            local duration = 3
            Mixin(model1, addon.WardrobeSetsDetailsModelMixin)
            model1:OnLoad()
            model1:SetScript("OnUpdate", function(self, elapsed)
                facing = (facing + maxrads * (elapsed / duration)) % maxrads
                self:SetFacing(facing)
            end)
        end
        GameTooltip_InsertFrame(GameTooltip, modelFrame)
        modelFrame:SetPoint("RIGHT", GameTooltip, "RIGHT", -30, 0)
        modelFrame:SetPoint("LEFT", GameTooltip, "LEFT")
        local model1 = modelFrame.model1
        model1:SetPoint("CENTER")
        GameTooltip:Show()
        GameTooltip:AddLine(selectedLocale.click, 1, 1, 1, true)
        numLines = GameTooltip:NumLines()
        line = _G[GameTooltip:GetName().."TextLeft"..numLines]
        line:SetJustifyH("CENTER")
        GameTooltip:Show()
        modelFrame:Show()
        model1:Undress()
        Wear(model1, 3427)
        Wear(model1, 10035)
        Wear(model1, 6836)
        Wear(model1, 38312)
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
        TomCats_Account.preferences.AccessoryWindow.snoozed["prime_tabardofbrilliance"] = true
    else
        TomCats_Account.preferences.AccessoryWindow.snoozed["prime_tabardofbrilliance"] = nil
    end
    UpdateVisibility()
end

C_Item.RequestLoadItemDataByID(3427)
C_Item.RequestLoadItemDataByID(10035)
C_Item.RequestLoadItemDataByID(6836)
C_Item.RequestLoadItemDataByID(38312)
