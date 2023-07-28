--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("osd")

local atlasName = "VignetteLoot"
local promotionEndTime = 1692835200
local modelFrame

local locale = {
    ["enUS"] = { lang = "en-us", title1 = "In-game content, free with Prime:", title2 = "\nSilver Pig Pet\n\nThis Silver Pig pet is sure to bring you luck.", click = "Click for details" },
    ["frFR"] = { lang = "fr-fr", title1 = "Contenu en jeu gratuit avec Prime:", title2 = "\nAnimal de compagnie Cochon argenté\n\nCe cochon argenté de compagnie vous portera forcément bonheur !", click = "Cliquer pour les détails" },
    ["deDE"] = { lang = "de-de", title1 = "Kostenlos mit Prime erhältliche Spielinhalte:", title2 = "\nHaustier „Silbernes Schwein“\n\nDas Haustier „Silbernes Schwein“ wird dir mit Sicherheit Glück bringen!", click = "Klicken Sie für weitere Details" },
    ["esES"] = { lang = "es-es", title1 = "Contenido de juegos, gratis con Prime:", title2 = "\nMascota Cerdo de plata\n\nLa mascota Cerdo de plata seguro que te traerá suerte.", click = "Haga clic para obtener más detalles" },
    ["esMX"] = { lang = "es-mx", title1 = "Contenido en el juego gratis con Prime:", title2 = "\nMascota Cerdo de plata\n\nSin duda, este cerdo de plata te traerá suerte.", click = "Haga clic para obtener más detalles" },
    ["itIT"] = { lang = "it-it", title1 = "Contenuti di gioco, gratis con Prime:", title2 = "\nFamiglio Maiale d’Argento\n\nQuesto famiglio Maiale d’Argento ti porterà sicuramente fortuna.", click = "Clicca per maggiori dettagli" },
    ["ptBR"] = { lang = "pt-br", title1 = "Conteúdo do jogo grátis com Prime:", title2 = "\nMascote Porco Prateado\n\nEste mascote Porco Prateado certamente dará sorte.", click = "Clique para mais detalhes" },
    ["ptPT"] = { lang = "pt-br", title1 = "Conteúdo de jogo, grátis com o Prime:", title2 = "\nAnimal de Estimação Porco Prateado\n\nEste animal de estimação Porco Prateado vai-te trazer sorte.", click = "Clique para mais detalhes" },
}

local selectedLocale = locale[GetLocale()] or locale["enUS"]
local url = "https://gaming.amazon.com/silver-pet-pig"

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
    if (GetServerTime() > promotionEndTime) then return false end
    if (not C_PetJournal.GetOwnedBattlePetString(171)) then return false end
    return visibilityFunctions[TomCats_Account.preferences.AccessoryWindow.primeGamingLoot]()
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
        model1:SetCreature(25147)
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
        TomCats_Account.preferences.AccessoryWindow.snoozed["prime_silverpig"] = true
    else
        TomCats_Account.preferences.AccessoryWindow.snoozed["prime_silverpig"] = nil
    end
    UpdateVisibility()
end
