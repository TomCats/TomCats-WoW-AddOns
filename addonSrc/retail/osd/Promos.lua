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
	--	type = promoTypes.TWITCH_DROP,
	--	startTime = 1699380000,
	--	endTime = 1699984800,
	--	lang = {
	--		["enUS"] = {
	--			urlParams = { "en-us" },
	--			title1 = "DRAGONFLIGHT TWITCH DROPS:",
	--			title2 = "GET THE DOTTIE PET",
	--			click = "Click for details" },
	--		["enGB"] = {
	--			urlParams = { "en-gb" },
	--			title1 = "DRAGONFLIGHT TWITCH DROPS:",
	--			title2 = "GET THE DOTTIE PET",
	--			click = "Click for details" },
	--		["koKR"] = {
	--			urlParams = { "ko-kr" },
	--			title1 = "용군단 트위치 드롭스:",
	--			title2 = "도티 애완동물과 길들인 흰색 낙타 탈것을 손에 넣으세요",
	--			click = "자세한 내용을 보려면 클릭하십시오" },
	--		["frFR"] = {
	--			urlParams = { "fr-fr" },
	--			title1 = "DROPS TWITCH POUR DRAGONFLIGHT:",
	--			title2 = "OBTENEZ LA MASCOTTE DOTTIE",
	--			click = "Cliquer pour les détails" },
	--		["deDE"] = {
	--			urlParams = { "de-de" },
	--			title1 = "TWITCH-DROPS FÜR DRAGONFLIGHT:",
	--			title2 = "HOLT EUCH DAS HAUSTIER DOTTIE",
	--			click = "Klicken Sie für weitere Details" },
	--		["esES"] = {
	--			urlParams = { "es-es" },
	--			title1 = "DROPS DE TWITCH EN DRAGONFLIGHT:",
	--			title2 = "CONSIGUE LA MASCOTA LOCUELA",
	--			click = "Haga clic para obtener más detalles" },
	--		["zhTW"] = {
	--			urlParams = { "zh-tw" },
	--			title1 = "《巨龍崛起》TWITCH 掉寶：",
	--			title2 = "獲得點點寵物和白色騎乘駱駝坐騎",
	--			click = "點擊了解更多詳情。" },
	--		["esMX"] = {
	--			urlParams = { "es-mx" },
	--			title1 = "DROPS DE TWITCH DE DRAGONFLIGHT:",
	--			title2 = "CONSIGUE LA MASCOTA DOTI",
	--			click = "Haga clic para obtener más detalles" },
	--		["ptBR"] = {
	--			urlParams = { "pt-br" },
	--			title1 = "TWITCH DROPS DE DRAGONFLIGHT:",
	--			title2 = "ADOTE A MASCOTE PINTINHA",
	--			click = "Clique para mais detalhes" },
	--		["ptPT"] = {
	--			urlParams = { "pt-br" },
	--			title1 = "TWITCH DROPS DE DRAGONFLIGHT:",
	--			title2 = "ADOTE A MASCOTE PINTINHA",
	--			click = "Clique para mais detalhes" },
	--		["itIT"] = {
	--			urlParams = { "it-it" },
	--			title1 = "TWITCH DROP DI DRAGONFLIGHT:",
	--			title2 = "OTTIENI LA MASCOTTE DOTTIE",
	--			click = "Clicca per maggiori dettagli" },
	--	},
	--	url = "https://news.blizzard.com/%s/world-of-warcraft/23987093",
	--	slug = "twitch_dottie",
	--	modelInfo = {
	--		creature = 151788
	--	},
	--},
	--{
	--	type = promoTypes.TWITCH_DROP,
	--	startTime = 1699984800,
	--	endTime = 1700589600,
	--	lang = {
	--		["enUS"] = {
	--			urlParams = { "en-us" },
	--			title1 = "DRAGONFLIGHT TWITCH DROPS:",
	--			title2 = "GET THE WHITE RIDING CAMEL MOUNT",
	--			click = "Click for details" },
	--		["enGB"] = {
	--			urlParams = { "en-gb" },
	--			title1 = "DRAGONFLIGHT TWITCH DROPS:",
	--			title2 = "GET THE WHITE RIDING CAMEL MOUNT",
	--			click = "Click for details" },
	--		["koKR"] = {
	--			urlParams = { "ko-kr" },
	--			title1 = "용군단 트위치 드롭스:",
	--			title2 = "도티 애완동물과 길들인 흰색 낙타 탈것을 손에 넣으세요",
	--			click = "자세한 내용을 보려면 클릭하십시오" },
	--		["frFR"] = {
	--			urlParams = { "fr-fr" },
	--			title1 = "DROPS TWITCH POUR DRAGONFLIGHT:",
	--			title2 = "OBTENEZ LA MONTURE DROMADAIRE BLANC",
	--			click = "Cliquer pour les détails" },
	--		["deDE"] = {
	--			urlParams = { "de-de" },
	--			title1 = "TWITCH-DROPS FÜR DRAGONFLIGHT:",
	--			title2 = "HOLT DAS WEISSE REITKAMEL",
	--			click = "Klicken Sie für weitere Details" },
	--		["esES"] = {
	--			urlParams = { "es-es" },
	--			title1 = "DROPS DE TWITCH EN DRAGONFLIGHT:",
	--			title2 = "CONSIGUE LA MONTURA DEL CAMELLO DE MONTAR BLANCO",
	--			click = "Haga clic para obtener más detalles" },
	--		["zhTW"] = {
	--			urlParams = { "zh-tw" },
	--			title1 = "《巨龍崛起》TWITCH 掉寶：",
	--			title2 = "獲得點點寵物和白色騎乘駱駝坐騎",
	--			click = "點擊了解更多詳情。" },
	--		["esMX"] = {
	--			urlParams = { "es-mx" },
	--			title1 = "DROPS DE TWITCH DE DRAGONFLIGHT:",
	--			title2 = "CONSIGUE LA MONTURA CAMELLO DE MONTAR BLANCO",
	--			click = "Haga clic para obtener más detalles" },
	--		["ptBR"] = {
	--			urlParams = { "pt-br" },
	--			title1 = "TWITCH DROPS DE DRAGONFLIGHT:",
	--			title2 = "ADOTE O CAMELO BRANCO DE MONTARIA",
	--			click = "Clique para mais detalhes" },
	--		["ptPT"] = {
	--			urlParams = { "pt-br" },
	--			title1 = "TWITCH DROPS DE DRAGONFLIGHT:",
	--			title2 = "ADOTE O CAMELO BRANCO DE MONTARIA",
	--			click = "Clique para mais detalhes" },
	--		["itIT"] = {
	--			urlParams = { "it-it" },
	--			title1 = "TWITCH DROP DI DRAGONFLIGHT:",
	--			title2 = "OTTIENI LA CAVALCATURA DROMEDARIO CAVALCABILE BIANCO",
	--			click = "Clicca per maggiori dettagli" },
	--	},
	--	url = "https://news.blizzard.com/%s/world-of-warcraft/23987093",
	--	slug = "twitch_whiteridingcamel",
	--	modelInfo = {
	--		creature = 54879
	--	},
	--},
	{
		type = promoTypes.PRIME_GAMING,
		startTime = 1703611800,
		endTime = 1706635740,
		lang = {
			["enUS"] = {
				urlParams = { "en-us" },
				title1 = "In-game content, free with Prime:",
				title2 = "\nSwift Windsteed Mount\n\nOne of Pandaria's most elusive creatures, said to bring good fortune to its rider.",
				click = "Click for details" },
			["frFR"] = {
				urlParams = { "fr-fr" },
				title1 = "Contenu en jeu gratuit avec Prime:",
				title2 = "\nMonture Swift Winddestrier\n\nL'une des créatures les plus insaisissables de Pandarie, censée porter chance à son cavalier.",
				click = "Cliquer pour les détails" },
			["deDE"] = {
				urlParams = { "de-de" },
				title1 = "Kostenlos mit Prime erhältliche Spielinhalte:",
				title2 = "\nReittier Schnell Windsteed“\n\nEine der am schwersten fassbaren Kreaturen Pandarias, von der gesagt wird, dass sie ihrem Reiter Glück bringen soll.",
				click = "Klicken Sie für weitere Details" },
			["esES"] = {
				urlParams = { "es-es" },
				title1 = "Contenido de juegos, gratis con Prime:",
				title2 = "\nCorcel del viento presto\n\nUna de las criaturas más esquivas de Pandaria, de la que se dice que trae buena suerte a su jinete.",
				click = "Haga clic para obtener más detalles" },
			["esMX"] = {
				urlParams = { "es-mx" },
				title1 = "Contenido en el juego gratis con Prime:",
				title2 = "\nCorcel del viento presto\n\nUna de las criaturas más escurridizas de Pandaria, se dice que trae buena fortuna a su jinete.",
				click = "Haga clic para obtener más detalles" },
			["itIT"] = {
				urlParams = { "it-it" },
				title1 = "Contenuti di gioco, gratis con Prime:",
				title2 = "\nCavalcatura Destriero del vento veloce\n\nUna delle creature più sfuggenti di Pandaria, che si dice porti fortuna a chi la cavalca.",
				click = "Clicca per maggiori dettagli" },
			["ptBR"] = {
				urlParams = { "pt-br" },
				title1 = "Conteúdo do jogo grátis com Prime:",
				title2 = "\nMontaria Corcel do Vento Veloz\n\nUma das criaturas mais misteriosas de Pandária, que supostamente traz boa sorte para seu cavaleiro.",
				click = "Clique para mais detalhes" },
			["ptPT"] = {
				urlParams = { "pt-pt" },
				title1 = "Conteúdo de jogo, grátis com o Prime:",
				title2 = "\nMontaria Corcel do Vento Veloz\n\nUma das criaturas mais esquivas de Pandaria conhecida por trazer boa sorte a quem a monta.",
				click = "Clique para mais detalhes" },
		},
		url = "https://gaming.amazon.com/swift-windsteed-mount/dp/amzn1.pg.item.9ad235f8-23cb-458f-9ab1-b0210155dd83",
		slug = "prime_swiftwindsteed",
		modelInfo = {
			creature = 68288,
			camDistanceScale = 0.8,
		},
	},
	--{
	--	type = promoTypes.BLIZZARD_OTHER,
	--	startTime = 1698165000,
	--	endTime = 1699851600,
	--	lang = {
	--		["enUS"] = {
	--			urlParams = { "en-us" },
	--			title1 = "Warcraft Rumble:",
	--			title2 = "\nGNOMELIA DELIVERS WARCRAFT RUMBLE’S JOYFUL CHAOS TO WOW",
	--			click = "Click for details" },
	--		["enGB"] = {
	--			urlParams = { "en-gb" },
	--			title1 = "Warcraft Rumble:",
	--			title2 = "\nGNOMELIA DELIVERS WARCRAFT RUMBLE’S JOYFUL CHAOS TO WOW",
	--			click = "Click for details" },
	--		["koKR"] = {
	--			urlParams = { "ko-kr" },
	--			title1 = "워크래프트 럼블",
	--			title2 = "노멜리아가 워크래프트® 럼블™의 즐거운 혼돈을 WOW에 선사합니다!",
	--			click = "자세한 내용을 보려면 클릭하십시오" },
	--		["frFR"] = {
	--			urlParams = { "fr-fr" },
	--			title1 = "Warcraft Rumble:",
	--			title2 = "\nGNOMÉLIA APPORTE LE JOYEUX CHAOS DE WARCRAFT RUMBLE DANS WORLD OF WARCRAFT",
	--			click = "Cliquer pour les détails" },
	--		["deDE"] = {
	--			urlParams = { "de-de" },
	--			title1 = "Warcraft Rumble:",
	--			title2 = "\nGNOMELIA BRINGT DAS FREUDIGE CHAOS VON WARCRAFT RUMBLE NACH WOW",
	--			click = "Klicken Sie für weitere Details" },
	--		["esES"] = {
	--			urlParams = { "es-es" },
	--			title1 = "Warcraft Rumble:",
	--			title2 = "\nGNOMELIA TRAE EL ALEGRE CAOS DE WARCRAFT RUMBLE A WOW",
	--			click = "Haga clic para obtener más detalles" },
	--		["zhTW"] = {
	--			urlParams = { "zh-tw" },
	--			title1 = "《魔獸兵團》",
	--			title2 = "諾姆莉亞將《魔獸兵團》歡樂的混亂氣氛送進了《魔獸世界》",
	--			click = "點擊了解更多詳情。" },
	--		["esMX"] = {
	--			urlParams = { "es-mx" },
	--			title1 = "Warcraft Rumble:",
	--			title2 = "\nGNOMELIA TRAE TODO EL CAOS Y LA DIVERSIÓN DE WARCRAFT RUMBLE A WOW",
	--			click = "Haga clic para obtener más detalles" },
	--		["ptBR"] = {
	--			urlParams = { "pt-br" },
	--			title1 = "Warcraft Rumble:",
	--			title2 = "\nGNOMÉSIA TRAZ O CAOS DIVERTIDO DE WARCRAFT RUMBLE PARA WOW",
	--			click = "Clique para mais detalhes" },
	--		["ptPT"] = {
	--			urlParams = { "pt-pt" },
	--			title1 = "Warcraft Rumble:",
	--			title2 = "\nGNOMÉSIA TRAZ O CAOS DIVERTIDO DE WARCRAFT RUMBLE PARA WOW",
	--			click = "Clique para mais detalhes" },
	--		["itIT"] = {
	--			urlParams = { "it-it" },
	--			title1 = "Warcraft Rumble:",
	--			title2 = "\nGNOMELIA PORTA IL CAOS PIÙ SPASSOSO DI WARCRAFT RUMBLE SU WOW",
	--			click = "Clicca per maggiori dettagli" },
	--	},
	--	url = "https://news.blizzard.com/%s/world-of-warcraft/24023091",
	--	slug = "blizzard_gnomelia",
	--	modelInfo = {
	--		creature = 184285,
	--	},
	--},
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
					model1:SetCreature(promo.modelInfo.creature)
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
			model1:SetCreature(promo.modelInfo.creature)
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
		options.TogglePopup(string.format(promo.url, unpack(selectedLang.urlParams)), "Press CONTROL-C to copy the link", { "CENTER", UIParent, "CENTER" })
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
