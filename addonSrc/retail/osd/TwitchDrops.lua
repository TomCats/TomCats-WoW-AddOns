--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("osd")

local atlasName = "VignetteLoot"
local promotionEndTime = 1694538000
local modelFrame

local locale = {
    ["enUS"] = { lang = "en-us", title1 = "DRAGONFLIGHT TWITCH DROPS:", title2 = "GET THE DASHING BUCCANEER’S SLOPS TRANSMOG NOW!", click = "Click for details" },
    ["enGB"] = { lang = "en-gb", title1 = "DRAGONFLIGHT TWITCH DROPS:", title2 = "GET THE DASHING BUCCANEER’S SLOPS TRANSMOG NOW!", click = "Click for details" },
    ["koKR"] = { lang = "ko-kr", title1 = "용군단 트위치 드롭스:", title2 = "오늘 바로 늠름한 해적의 의복 형상변환을 손에 넣으세요!", click = "자세한 내용을 보려면 클릭하십시오" },
    ["frFR"] = { lang = "fr-fr", title1 = "DROPS TWITCH POUR DRAGONFLIGHT:", title2 = "OBTENEZ LA TRANSMOGRIFICATION « TENUE DE CORSAIRE ALLÈGRE » MAINTENANT !", click = "Cliquer pour les détails" },
    ["deDE"] = { lang = "de-de", title1 = "TWITCH-DROPS FÜR DRAGONFLIGHT:", title2 = "HOLT EUCH JETZT DIE TRANSMOGRIFIZIERUNG „KLEIDUNG DES VERWEGENEN BUKANIERS“!", click = "Klicken Sie für weitere Details" },
    ["esES"] = { lang = "es-es", title1 = "DROPS DE TWITCH EN DRAGONFLIGHT:", title2 = "¡HAZTE CON EL CONJUNTO DE TRANSFIGURACIÓN CALZAS DE BUCANERO MALANDRÍN!", click = "Haga clic para obtener más detalles" },
    ["zhTW"] = { lang = "zh-tw", title1 = "《巨龍崛起》TWITCH 掉寶：", title2 = "立即獲取迅捷海盜裝塑形！", click = "點擊了解更多詳情。" },
    ["esMX"] = { lang = "es-mx", title1 = "DROPS DE TWITCH DE DRAGONFLIGHT:", title2 = "¡OBTÉN EL ROPAJE DE BUCANERO ELEGANTE AHORA!", click = "Haga clic para obtener más detalles" },
    ["ptBR"] = { lang = "pt-br", title1 = "TWITCH DROPS DE DRAGONFLIGHT:", title2 = "GARANTA JÁ A TRANSMOGRIFICAÇÃO TRAPOS DO BUCANEIRO AUDAZ!", click = "Clique para mais detalhes" },
    ["itIT"] = { lang = "it-it", title1 = "TWITCH DROP DI DRAGONFLIGHT:", title2 = "OTTIENI IL SET DI TRASMOGRIFICAZIONE STRACCI DEL BUCANIERE ARDITO ORA!", click = "Clicca per maggiori dettagli" },
}

locale["ptPT"] = locale["ptBR"]

local selectedLocale = locale[GetLocale()] or locale["enUS"]
local url = string.format("https://news.blizzard.com/%s/world-of-warcraft/23999066", selectedLocale.lang)

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
    if (TomCats_Account.preferences.AccessoryWindow.twitchDrops == addon.constants.accessoryDisplay.SNOOZED
            and TomCats_Account.preferences.AccessoryWindow.snoozed["twitch_slops"] == nil) then
        TomCats_Account.preferences.AccessoryWindow.twitchDrops = addon.constants.accessoryDisplay.NOINSTANCES
    end
    if (GetServerTime() > promotionEndTime) then return false end
    return visibilityFunctions[TomCats_Account.preferences.AccessoryWindow.twitchDrops]()
end

local function Wear(modelFrame_, itemID)
    local itemLink = "|cff9d9d9d|Hitem:" .. itemID .. "::::::::1:::::::::|h[]|h|r"
    modelFrame_:TryOn(itemLink)
end

function TwitchDrops.Render(Timers, idx)
    local timerRow = Timers:GetTimerRow(idx)
    timerRow:SetIcon(atlasName)
    timerRow:SetTitle(string.format("Twitch Promo Ends"))
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
            --modelFrame = CreateFrame("Frame", nil, GameTooltip)
            --modelFrame:SetSize(200, 200)
            ----modelFrame:SetPoint("CENTER", GameTooltip, "CENTER")
            --local model1 = CreateFrame("PlayerModel", nil, modelFrame)
            --modelFrame.model1 = model1
            --model1:SetSize(200, 200)
            --local model2 = CreateFrame("PlayerModel", nil, modelFrame)
            --modelFrame.model2 = model2
            --model2:SetSize(200, 200)
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
        --local model2 = modelFrame.model2
        model1:SetPoint("CENTER")
        --model1:SetModel(200894)
        --model1:SetFacing(5.8)
        --model1:SetPosition(0,0.2,-1.0)
        --model1:SetPitch(-0.2)
        --model1:SetRoll(0.1)
        --model1:SetCamDistanceScale(1.9)
        --model2:SetPoint("CENTER")
        --model2:SetModel(200895)
        --model2:SetFacing(5.8)
        --model2:SetCamDistanceScale(2.5)
        GameTooltip:AddLine(selectedLocale.click, 1, 1, 1, true)
        numLines = GameTooltip:NumLines()
        line = _G[GameTooltip:GetName().."TextLeft"..numLines]
        line:SetJustifyH("CENTER")
        GameTooltip:Show()
        modelFrame:Show()
        model1:Undress()
        Wear(model1, 190923)
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
        TomCats_Account.preferences.AccessoryWindow.snoozed["twitch_slops"] = true
    else
        TomCats_Account.preferences.AccessoryWindow.snoozed["twitch_slops"] = nil
    end
    UpdateVisibility()
end

C_Item.RequestLoadItemDataByID(190923)
