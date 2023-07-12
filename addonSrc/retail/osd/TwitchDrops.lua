--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("osd")

local atlasName = "VignetteLoot"
local promotionEndTime = 1689699540
local modelFrame

local locale = {
    ["enUS"] = { lang = "en-us", title1 = "DRAGONFLIGHT TWITCH DROPS:", title2 = "GET YOUR PICNIC BASKET NOW!", click = "Click for details" },
    ["enGB"] = { lang = "en-gb", title1 = "DRAGONFLIGHT TWITCH DROPS:", title2 = "GET YOUR PICNIC BASKET NOW!", click = "Click for details" },
    ["koKR"] = { lang = "ko-kr", title1 = "용군단 트위치 드롭스:", title2 = "지금 바로 소풍 바구니를 손에 넣으세요!", click = "자세한 내용을 보려면 클릭하십시오" },
    ["frFR"] = { lang = "fr-fr", title1 = "DROPS TWITCH POUR DRAGONFLIGHT:", title2 = "OBTENEZ VOTRE PANIER À PIQUE-NIQUE !", click = "Cliquer pour les détails" },
    ["deDE"] = { lang = "de-de", title1 = "TWITCH-DROPS FÜR DRAGONFLIGHT:", title2 = "HOLT EUCH JETZT EUREN PICKNICKKORB!", click = "Klicken Sie für weitere Details" },
    ["esES"] = { lang = "es-es", title1 = "DROPS DE TWITCH EN DRAGONFLIGHT:", title2 = "¡CONSIGUE YA EL JUGUETE CESTA DE MERIENDA!", click = "Haga clic para obtener más detalles" },
    ["zhTW"] = { lang = "zh-tw", title1 = "《巨龍崛起》TWITCH 掉寶：", title2 = "立即獲得你的野餐籃！", click = "點擊了解更多詳情。" },
    ["esMX"] = { lang = "es-mx", title1 = "DROPS DE TWITCH DE DRAGONFLIGHT:", title2 = "¡CONSIGUE TU JUGUETE CESTA DE PICNIC AHORA!", click = "Haga clic para obtener más detalles" },
    ["ptBR"] = { lang = "pt-br", title1 = "TWITCH DROPS DE DRAGONFLIGHT:", title2 = "PEGUE JÁ SUA CESTA DE PIQUENIQUE!", click = "Clique para mais detalhes" },
    ["itIT"] = { lang = "it-it", title1 = "TWITCH DROP DI DRAGONFLIGHT:", title2 = "OTTIENI IL TUO CESTINO DA PICNIC ORA!", click = "Clicca per maggiori dettagli" },
    ["ptPT"] = { lang = "pt-br", title1 = "TWITCH DROPS DE DRAGONFLIGHT:", title2 = "PEGUE JÁ SUA CESTA DE PIQUENIQUE!", click = "Clique para mais detalhes" },
}

local selectedLocale = locale[GetLocale()] or locale["enUS"]
local url = string.format("https://news.blizzard.com/%s/world-of-warcraft/23978152", selectedLocale.lang)

TwitchDrops = { }

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

function TwitchDrops.GetVisibilityOption()
    return TomCats_Account.preferences.AccessoryWindow.twitchDrops
end

function TwitchDrops.IsVisible()
    return visibilityFunctions[TomCats_Account.preferences.AccessoryWindow.twitchDrops]()
end

function TwitchDrops.Render(Timers, idx)
    local timerRow = Timers:GetTimerRow(idx)
    timerRow:SetIcon(atlasName)
    timerRow:SetTitle(string.format("Twitch Promo Ends"))
    timerRow:SetStartTime(promotionEndTime, 0)

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
            local model2 = CreateFrame("PlayerModel", nil, modelFrame)
            modelFrame.model2 = model2
            model2:SetSize(200, 200)
        end
        GameTooltip_InsertFrame(GameTooltip, modelFrame)
        modelFrame:SetPoint("RIGHT", GameTooltip, "RIGHT", -12, 0);
        local model1 = modelFrame.model1
        local model2 = modelFrame.model2
        model1:SetPoint("CENTER")
        model1:SetModel(200894)
        model1:SetFacing(5.8)
        model1:SetPosition(0,0.2,-1.0)
        model1:SetPitch(-0.2)
        model1:SetRoll(0.1)
        model1:SetCamDistanceScale(1.9)
        model2:SetPoint("CENTER")
        model2:SetModel(200895)
        model2:SetFacing(5.8)
        model2:SetCamDistanceScale(2.5)
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

function TwitchDrops.SetVisibilityOption(value)
    TomCats_Account.preferences.AccessoryWindow.twitchDrops = value
    if (value == addon.constants.accessoryDisplay.SNOOZED) then
        TomCats_Account.preferences.AccessoryWindow.snoozed["twitch_picnicbasket"] = true
    else
        TomCats_Account.preferences.AccessoryWindow.snoozed["twitch_picnicbasket"] = nil
    end
    UpdateVisibility()
end
