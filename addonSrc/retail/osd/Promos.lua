--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("osd")

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

local promoTypes = {
	["PRIME_GAMING"] = {
		atlasName = "VignetteLoot",
		label = "Prime Gaming Loot Ends"
	},
	["TWITCH_DROP"] = {
		atlasName = "VignetteLoot",
		label = "Twitch Promo Ends"
	},
	["BLIZZARD_OTHER"] = {
		atlasName = "VignetteLoot",
		label = "Blizzard Promotion Ends"
	}
}

local promoData = {
	--{
	--	type = promoTypes.PRIME_GAMING,
	--	startTime = 1709055000,
	--	endTime = 1711470540,
	--	lang = {
	--		["enUS"] = {
	--			urlParams = { "en-us" },
	--			title1 = "In-game content, free with Prime:",
	--			title2 = "\nTabard of Frost Transmog\n\nShow off your love of the winter with the Tabard of Frost.",
	--			click = "Click for details" },
	--		["frFR"] = {
	--			urlParams = { "fr-fr" },
	--			title1 = "Contenu en jeu gratuit avec Prime:",
	--			title2 = "\nTransmogrification Tabard de givre\n\nMontrez votre amour de l'hiver avec le Tabard de givre.",
	--			click = "Cliquer pour les détails" },
	--		["deDE"] = {
	--			urlParams = { "de-de" },
	--			title1 = "Kostenlos mit Prime erhältliche Spielinhalte:",
	--			title2 = "\nTransmog Wappenrock des Frost\n\nZeige deine Liebe zum Winter mit dem Wappenrock des Frosts.",
	--			click = "Klicken Sie für weitere Details" },
	--		["esES"] = {
	--			urlParams = { "es-es" },
	--			title1 = "Contenido de juegos, gratis con Prime:",
	--			title2 = "\nTransfiguración del tabardo de escarcha\n\nDemuestra tu amor por el invierno con el tabardo de escarcha.",
	--			click = "Haga clic para obtener más detalles" },
	--		["esMX"] = {
	--			urlParams = { "es-mx" },
	--			title1 = "Contenido en el juego gratis con Prime:",
	--			title2 = "\nTabard of Frost Transmog\n\nDemuestra tu amor por el invierno con el Tabard of Frost.",
	--			click = "Haga clic para obtener más detalles" },
	--		["itIT"] = {
	--			urlParams = { "it-it" },
	--			title1 = "Contenuti di gioco, gratis con Prime:",
	--			title2 = "\nTrasmog Insegna del Gelo\n\nMostra il tuo amore per l'inverno con l’Insegna del Gelo.",
	--			click = "Clicca per maggiori dettagli" },
	--		["ptBR"] = {
	--			urlParams = { "pt-br" },
	--			title1 = "Conteúdo do jogo grátis com Prime:",
	--			title2 = "\nTransmogrificação Tabard of Frost\n\nMostre seu amor pelo inverno com o Tabard of Frost.",
	--			click = "Clique para mais detalhes" },
	--		["ptPT"] = {
	--			urlParams = { "pt-pt" },
	--			title1 = "Conteúdo de jogo, grátis com o Prime:",
	--			title2 = "\nTransmog Tabardo de Gelo\n\nMostra o teu amor pelo inverno com o Tabardo de Gelo.",
	--			click = "Clique para mais detalhes" },
	--	},
	--	url = "https://gaming.amazon.com/tabard-frost-transmog/dp/amzn1.pg.item.76addf7e-d172-44b1-b145-f19d771b94d5",
	--	slug = "prime_tabard_of_frost",
	--	modelInfo = {
	--		items = { 3427, 10035, 6836, 23709 },
	--		--			creature = 138741,
	--		--			camDistanceScale = 0.8,
	--	},
	--},
	{
		type = promoTypes.TWITCH_DROP,
		startTime = 1724709600,
		endTime = 1727370000,
		lang = {
			["enUS"] = {
				urlParams = { "en-us" },
				title1 = "Support a Streamer on Twitch:",
				title2 = "Earn the Watcher of the Huntress Pet",
				click = "Click for details" },
			["enGB"] = {
				urlParams = { "en-gb" },
				title1 = "Support a Streamer on Twitch:",
				title2 = "Earn the Watcher of the Huntress Pet",
				click = "Click for details" },
			["frFR"] = {
				urlParams = { "fr-fr" },
				title1 = "Soutenez un streamer ou une streameuse sur Twitch:",
				title2 = "Obtenez la mascotte Gardienne de la chasseresse",
				click = "Cliquer pour les détails" },
			["deDE"] = {
				urlParams = { "de-de" },
				title1 = "Unterstützt einen Streamer auf Twitch:",
				title2 = "Holt euch das Haustier „Wächterin der Jägerin“",
				click = "Klicken Sie für weitere Details" },
			["esES"] = {
				urlParams = { "es-es" },
				title1 = "Apoya a un streamer en Twitch:",
				title2 = "Gana la mascota vigía de la cazadora",
				click = "Haga clic para obtener más detalles" },
			["zhTW"] = {
				urlParams = { "zh-tw" },
				title1 = "在 Twitch 上支持實況主獲女:",
				title2 = "獲得女獵手的獵鷹寵物",
				click = "點擊了解更多詳情。" },
			["esMX"] = {
				urlParams = { "es-mx" },
				title1 = "Apoya a un streamer en Twitch:",
				title2 = "Recibir la mascota Vigía de la cazadora",
				click = "Haga clic para obtener más detalles" },
			["ptBR"] = {
				urlParams = { "pt-br" },
				title1 = "Apoie um Streamer na Twitch:",
				title2 = "Ganhe a mascote Guardiã da Caçadora",
				click = "Clique para mais detalhes" },
			["ptPT"] = {
				urlParams = { "pt-br" },
				title1 = "Apoie um Streamer na Twitch:",
				title2 = "Ganhe a mascote Guardiã da Caçadora",
				click = "Clique para mais detalhes" },
			["itIT"] = {
				urlParams = { "it-it" },
				title1 = "Supporta uno streamer su Twitch:",
				title2 = "Ottieni la mascotte Guardiano della Cacciatrice",
				click = "Clicca per maggiori dettagli" },
		},
		url = "https://news.blizzard.com/%s/world-of-warcraft/24126707/support-a-streamer-and-twitch-drops-ahead",
		slug = "twitch_watcher_huntress",
		modelInfo = {
			creature = 185621
		},
	},
	{
		type = promoTypes.TWITCH_DROP,
		startTime = 1724709600,
		endTime = 1726765200,
		lang = {
			["enUS"] = {
				urlParams = { "en-us" },
				title1 = "DRAGONFLIGHT TWITCH DROPS:",
				title2 = "Get the Ghastly Charger Mount",
				click = "Click for details" },
			["enGB"] = {
				urlParams = { "en-gb" },
				title1 = "DRAGONFLIGHT TWITCH DROPS:",
				title2 = "Get the Ghastly Charger MountT",
				click = "Click for details" },
			["frFR"] = {
				urlParams = { "fr-fr" },
				title1 = "DROPS TWITCH POUR DRAGONFLIGHT:",
				title2 = "Obtenez la monture Destrier ignoble",
				click = "Cliquer pour les détails" },
			["deDE"] = {
				urlParams = { "de-de" },
				title1 = "TWITCH-DROPS FÜR DRAGONFLIGHT:",
				title2 = "Holt euch das Reittier „Geisterhaftes Streitross“",
				click = "Klicken Sie für weitere Details" },
			["esES"] = {
				urlParams = { "es-es" },
				title1 = "DROPS DE TWITCH EN DRAGONFLIGHT:",
				title2 = "Consigue la montura destrero espantoso",
				click = "Haga clic para obtener más detalles" },
			["zhTW"] = {
				urlParams = { "zh-tw" },
				title1 = "《巨龍崛起》TWITCH 掉寶：",
				title2 = "入手恐怖戰騎坐騎",
				click = "點擊了解更多詳情。" },
			["esMX"] = {
				urlParams = { "es-mx" },
				title1 = "DROPS DE TWITCH DE DRAGONFLIGHT:",
				title2 = "Consigue la montura Destrero espantoso",
				click = "Haga clic para obtener más detalles" },
			["ptBR"] = {
				urlParams = { "pt-br" },
				title1 = "TWITCH DROPS DE DRAGONFLIGHT:",
				title2 = "Ganhe a montaria Corcel Horripilante",
				click = "Clique para mais detalhes" },
			["ptPT"] = {
				urlParams = { "pt-br" },
				title1 = "TWITCH DROPS DE DRAGONFLIGHT:",
				title2 = "Ganhe a montaria Corcel Horripilante",
				click = "Clique para mais detalhes" },
			["itIT"] = {
				urlParams = { "it-it" },
				title1 = "TWITCH DROP DI DRAGONFLIGHT:",
				title2 = "Ottieni la cavalcatura Destriero dell'Oltretomba",
				click = "Clicca per maggiori dettagli" },
		},
		url = "https://news.blizzard.com/%s/world-of-warcraft/24126707/support-a-streamer-and-twitch-drops-ahead",
		slug = "twitch_ghastly_charger",
		modelInfo = {
			creature = 69219
		},
	},
	--{
	--	type = promoTypes.TWITCH_DROP,
	--	startTime = 1706032800,
	--	endTime = 1706637600,
	--	lang = {
	--		["enUS"] = {
	--			urlParams = { "en-us" },
	--			title1 = "DRAGONFLIGHT TWITCH DROPS:",
	--			title2 = "Get the Grim Campfire Toy",
	--			click = "Click for details" },
	--		["enGB"] = {
	--			urlParams = { "en-gb" },
	--			title1 = "DRAGONFLIGHT TWITCH DROPS:",
	--			title2 = "Get the Grim Campfire Toy",
	--			click = "Click for details" },
	--		["koKR"] = {
	--			urlParams = { "ko-kr" },
	--			title1 = "용군단 트위치 드롭스:",
	--			title2 = "으스스한 모닥불 장난감을 손에 넣으세요!",
	--			click = "자세한 내용을 보려면 클릭하십시오" },
	--		["frFR"] = {
	--			urlParams = { "fr-fr" },
	--			title1 = "DROPS TWITCH POUR DRAGONFLIGHT:",
	--			title2 = "Obtenez le jouet Feu de camp sinistre",
	--			click = "Cliquer pour les détails" },
	--		["deDE"] = {
	--			urlParams = { "de-de" },
	--			title1 = "TWITCH-DROPS FÜR DRAGONFLIGHT:",
	--			title2 = "Holt euch das Spielzeug 'Finsteres Lagerfeuer'",
	--			click = "Klicken Sie für weitere Details" },
	--		["esES"] = {
	--			urlParams = { "es-es" },
	--			title1 = "DROPS DE TWITCH EN DRAGONFLIGHT:",
	--			title2 = "¡hazte con el juguete hoguera macabra!",
	--			click = "Haga clic para obtener más detalles" },
	--		["zhTW"] = {
	--			urlParams = { "zh-tw" },
	--			title1 = "《巨龍崛起》TWITCH 掉寶：",
	--			title2 = "獲取陰森的營火玩具！",
	--			click = "點擊了解更多詳情。" },
	--		["esMX"] = {
	--			urlParams = { "es-mx" },
	--			title1 = "DROPS DE TWITCH DE DRAGONFLIGHT:",
	--			title2 = "¡Consigue el juguete Hoguera macabra!",
	--			click = "Haga clic para obtener más detalles" },
	--		["ptBR"] = {
	--			urlParams = { "pt-br" },
	--			title1 = "TWITCH DROPS DE DRAGONFLIGHT:",
	--			title2 = "Obtenha a Fogueira Sinistra",
	--			click = "Clique para mais detalhes" },
	--		["ptPT"] = {
	--			urlParams = { "pt-br" },
	--			title1 = "TWITCH DROPS DE DRAGONFLIGHT:",
	--			title2 = "Obtenha a Fogueira Sinistra",
	--			click = "Clique para mais detalhes" },
	--		["itIT"] = {
	--			urlParams = { "it-it" },
	--			title1 = "TWITCH DROP DI DRAGONFLIGHT:",
	--			title2 = "Obtenha a Fogueira Sinistra",
	--			click = "Clicca per maggiori dettagli" },
	--	},
	--	url = "https://worldofwarcraft.blizzard.com/%s/news/24054789",
	--	slug = "twitch_grimcampfire",
	--	modelInfo = {
	--		model = 198193
	--	},
	--},
	{
		type = promoTypes.BLIZZARD_OTHER,
		startTime = 1724385600,
		endTime = 1725796740,
		lang = {
			["enUS"] = {
				urlParams = { "en-us" },
				title1 = "Discord Quest:",
				title2 = "\nGet the Parrlok Battle Pet\n\nVisit the TomCat's Tours\nDiscord server to learn more",
				click = "Click for details\n(Other Blizzard Promos)" },
			--["enGB"] = {
			--	urlParams = { "en-gb" },
			--	title1 = "Warcraft Rumble:",
			--	title2 = "\nGNOMELIA DELIVERS WARCRAFT RUMBLE’S JOYFUL CHAOS TO WOW",
			--	click = "Click for details" },
			--["koKR"] = {
			--	urlParams = { "ko-kr" },
			--	title1 = "워크래프트 럼블",
			--	title2 = "노멜리아가 워크래프트® 럼블™의 즐거운 혼돈을 WOW에 선사합니다!",
			--	click = "자세한 내용을 보려면 클릭하십시오" },
			--["frFR"] = {
			--	urlParams = { "fr-fr" },
			--	title1 = "Warcraft Rumble:",
			--	title2 = "\nGNOMÉLIA APPORTE LE JOYEUX CHAOS DE WARCRAFT RUMBLE DANS WORLD OF WARCRAFT",
			--	click = "Cliquer pour les détails" },
			--["deDE"] = {
			--	urlParams = { "de-de" },
			--	title1 = "Warcraft Rumble:",
			--	title2 = "\nGNOMELIA BRINGT DAS FREUDIGE CHAOS VON WARCRAFT RUMBLE NACH WOW",
			--	click = "Klicken Sie für weitere Details" },
			--["esES"] = {
			--	urlParams = { "es-es" },
			--	title1 = "Warcraft Rumble:",
			--	title2 = "\nGNOMELIA TRAE EL ALEGRE CAOS DE WARCRAFT RUMBLE A WOW",
			--	click = "Haga clic para obtener más detalles" },
			--["zhTW"] = {
			--	urlParams = { "zh-tw" },
			--	title1 = "《魔獸兵團》",
			--	title2 = "諾姆莉亞將《魔獸兵團》歡樂的混亂氣氛送進了《魔獸世界》",
			--	click = "點擊了解更多詳情。" },
			--["esMX"] = {
			--	urlParams = { "es-mx" },
			--	title1 = "Warcraft Rumble:",
			--	title2 = "\nGNOMELIA TRAE TODO EL CAOS Y LA DIVERSIÓN DE WARCRAFT RUMBLE A WOW",
			--	click = "Haga clic para obtener más detalles" },
			--["ptBR"] = {
			--	urlParams = { "pt-br" },
			--	title1 = "Warcraft Rumble:",
			--	title2 = "\nGNOMÉSIA TRAZ O CAOS DIVERTIDO DE WARCRAFT RUMBLE PARA WOW",
			--	click = "Clique para mais detalhes" },
			--["ptPT"] = {
			--	urlParams = { "pt-pt" },
			--	title1 = "Warcraft Rumble:",
			--	title2 = "\nGNOMÉSIA TRAZ O CAOS DIVERTIDO DE WARCRAFT RUMBLE PARA WOW",
			--	click = "Clique para mais detalhes" },
			--["itIT"] = {
			--	urlParams = { "it-it" },
			--	title1 = "Warcraft Rumble:",
			--	title2 = "\nGNOMELIA PORTA IL CAOS PIÙ SPASSOSO DI WARCRAFT RUMBLE SU WOW",
			--	click = "Clicca per maggiori dettagli" },
		},
		url = "https://discord.gg/sVNZprqCuW",
		slug = "blizzard_discord_parrlok",
		modelInfo = {
			creature = 229846,
		},
	},
}

Promos = { }

function Promos.GetPromos()
	return promoData
end

function Promos.UpdateVisibility()
	local primeGamingVisible = false
	local twitchDropsVisible = false
	local blizzardOtherVisible = false
	local serverTime = GetServerTime()
	for _, promo in ipairs(promoData) do
		if (serverTime < promo.endTime and serverTime > promo.startTime
				and not TomCats_Account.preferences.AccessoryWindow.snoozed[promo.slug]) then
			promo.visible = true
			if (startsWith(promo.slug, "prime_")) then
				primeGamingVisible = true
				promo.visibilityFunction = visibilityFunctions[TomCats_Account.preferences.AccessoryWindow.primeGamingLoot]
			elseif (startsWith(promo.slug, "twitch_")) then
				twitchDropsVisible = true
				promo.visibilityFunction = visibilityFunctions[TomCats_Account.preferences.AccessoryWindow.twitchDrops]
			elseif (startsWith(promo.slug, "blizzard_")) then
				blizzardOtherVisible = true
				promo.visibilityFunction = visibilityFunctions[TomCats_Account.preferences.AccessoryWindow.blizzardOther]
			end
		else
			promo.visible = nil
		end
	end
	if (primeGamingVisible and TomCats_Account.preferences.AccessoryWindow.primeGamingLoot == addon.constants.accessoryDisplay.SNOOZED) then
		TomCats_Account.preferences.AccessoryWindow.primeGamingLoot = addon.constants.accessoryDisplay.NOINSTANCES
	end
	if (twitchDropsVisible and TomCats_Account.preferences.AccessoryWindow.twitchDrops == addon.constants.accessoryDisplay.SNOOZED) then
		TomCats_Account.preferences.AccessoryWindow.twitchDrops = addon.constants.accessoryDisplay.NOINSTANCES
	end
	if (blizzardOtherVisible and TomCats_Account.preferences.AccessoryWindow.blizzardOther == addon.constants.accessoryDisplay.SNOOZED) then
		TomCats_Account.preferences.AccessoryWindow.blizzardOther = addon.constants.accessoryDisplay.NOINSTANCES
	end
end

function Promos.IsVisible(promo)
	if (not promo) then
		for _, promo_ in ipairs(promoData) do
			if (Promos.IsVisible(promo_)) then
				return true
			end
		end
		return false
	end
	if (not promo.visible) then
		return false
	end
	return promo.visibilityFunction and promo.visibilityFunction() or false
end

function Promos.Render(Timers, idx, promo)
	local timerRow = Timers:GetTimerRow(idx)
	timerRow:SetIcon(promo.atlasName or promo.type.atlasName)
	timerRow:SetTitle(promo.label or promo.type.label)
	timerRow:SetTimer(promo.endTime, 0)
	local selectedLang = promo.lang[GetLocale()] or promo.lang["enUS"]
	timerRow.tooltipFunction = function()
		local hasTransmog = promo.modelInfo.items and true
		GameTooltip:AddLine(selectedLang.title1, 1, 0.82, 0, false)
		local numLines = GameTooltip:NumLines()
		local line = _G[GameTooltip:GetName().."TextLeft"..numLines]
		local modelLoaded = false
		line:SetJustifyH("CENTER")
		GameTooltip:AddLine(selectedLang.title2, 1, 1, 1, true)
		numLines = GameTooltip:NumLines()
		line = _G[GameTooltip:GetName().."TextLeft"..numLines]
		line:SetJustifyH("CENTER")
		if (not promo.modelFrame) then
			promo.modelFrame = CreateFrame("Frame", nil, GameTooltip)
			promo.modelFrame:SetSize(200, 200)
			local model1 = CreateFrame(
					hasTransmog and "DressupModel" or "PlayerModel", nil, promo.modelFrame)
			promo.modelFrame.model1 = model1
			model1:SetSize(200, 200)
			local facing = 0
			local maxrads = 6.28319
			local duration = 3
			if (hasTransmog) then
				Mixin(model1, addon.WardrobeSetsDetailsModelMixin)
				model1:OnLoad()
			end
			model1:SetScript("OnUpdate", function(self, elapsed)
				if (not modelLoaded and not hasTransmog) then
					if (promo.modelInfo.creature) then
						model1:SetCreature(promo.modelInfo.creature)
					else
						model1:SetModel(promo.modelInfo.model)
					end
				end
				facing = (facing + maxrads * (elapsed / duration)) % maxrads
				self:SetFacing(facing)
			end)
		end
		GameTooltip_InsertFrame(GameTooltip, promo.modelFrame)
		if (hasTransmog) then
			promo.modelFrame:SetPoint("RIGHT", GameTooltip, "RIGHT", -30, 0)
			promo.modelFrame:SetPoint("LEFT", GameTooltip, "LEFT")
		else
			promo.modelFrame:SetPoint("RIGHT", GameTooltip, "RIGHT", -12, 0);
		end
		local model1 = promo.modelFrame.model1
		model1:SetPoint("CENTER")
		if (hasTransmog) then
			GameTooltip:AddLine(selectedLang.click, 1, 1, 1, true)
			numLines = GameTooltip:NumLines()
			line = _G[GameTooltip:GetName().."TextLeft"..numLines]
			line:SetJustifyH("CENTER")
			GameTooltip:Show()
			promo.modelFrame:Show()
			model1:Undress()
			for _, itemID in ipairs(promo.modelInfo.items) do
				local itemLink = "|cff9d9d9d|Hitem:" .. itemID .. "::::::::1:::::::::|h[]|h|r"
				model1:TryOn(itemLink)
			end
		else
			model1:SetPoint("CENTER")
			if (promo.modelInfo.creature) then
				model1:SetCreature(promo.modelInfo.creature)
			else
				model1:SetModel(promo.modelInfo.model)
			end
			model1:SetScript("OnModelLoaded", function()
				modelLoaded = true
			end)
			if (promo.modelInfo.camDistanceScale) then
				model1:SetCamDistanceScale(promo.modelInfo.camDistanceScale)
			end
			promo.modelFrame:Show()
			GameTooltip:AddLine(selectedLang.click, 1, 1, 1, true)
			numLines = GameTooltip:NumLines()
			line = _G[GameTooltip:GetName().."TextLeft"..numLines]
			line:SetJustifyH("CENTER")
			GameTooltip:Show()
		end
	end
	timerRow.clickFunction = function()
		options.TogglePopup(string.format(promo.url, unpack(selectedLang.urlParams)), "Press " .. (IsMacClient() and "Cmd" or "Ctrl") .. "-C to copy the link", { "CENTER", UIParent, "CENTER" })
	end
	local height = timerRow:GetHeight() + 4
	timerRow:SetShown(true)
	return height
end

function Promos.GetVisibilityOption(scope)
	return TomCats_Account.preferences.AccessoryWindow[scope]
end

function Promos.SetVisibilityOption(scope, slugPrefix, value)
	if (value == addon.constants.accessoryDisplay.SNOOZED) then
		Promos.UpdateVisibility()
		for _, promo in ipairs(Promos.GetPromos()) do
			if (startsWith(promo.slug, slugPrefix) and Promos.IsVisible(promo)) then
				TomCats_Account.preferences.AccessoryWindow.snoozed[promo.slug] = true
			end
		end
	else
		for slug in pairs(TomCats_Account.preferences.AccessoryWindow.snoozed) do
			if (startsWith(slug, slugPrefix)) then
				TomCats_Account.preferences.AccessoryWindow.snoozed[slug] = nil
			end
		end
	end
	TomCats_Account.preferences.AccessoryWindow[scope] = value
	UpdateVisibility()
end

for _, promo in ipairs(promoData) do
	if (promo.modelInfo.items) then
		for _, itemID in ipairs(promo.modelInfo.items) do
			C_Item.RequestLoadItemDataByID(itemID)
		end
	end
end
