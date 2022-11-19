local _, addon = ...

local ITEMTYPE = { }
do
	local types = {"CLOAK","CLOTH_ARMOR","LEATHER_ARMOR","MAIL_ARMOR","OFFHAND","PLATE_ARMOR","SHIELD","WEAPON_1H_AXE","WEAPON_1H_MACE","WEAPON_1H_SWORD","WEAPON_2H_SWORD","WEAPON_CROSSBOW","WEAPON_DAGGER","WEAPON_POLEARM","WEAPON_STAFF"}
	for _, type in ipairs(types) do
		ITEMTYPE[type] = type
	end
end

addon.PrimalStorms.PlayerClassItemTypes = {
	WARRIOR = {
		CLOAK = true,
		PLATE_ARMOR = true,
		WEAPON_1H_AXE = true,
		WEAPON_1H_SWORD = true,
		WEAPON_1H_MACE = true,
		WEAPON_DAGGER = true,
		SHIELD = true,
		OFFHAND = true,
		WEAPON_2H_SWORD = true,
		WEAPON_STAFF = true,
		WEAPON_POLEARM = true,
		WEAPON_CROSSBOW = true,
	},
	PALADIN = {
		CLOAK = true,
		PLATE_ARMOR = true,
		WEAPON_1H_AXE = true,
		WEAPON_1H_SWORD = true,
		WEAPON_1H_MACE = true,
		SHIELD = true,
		OFFHAND = true,
		WEAPON_2H_SWORD = true,
		WEAPON_POLEARM = true,
	},
	HUNTER = {
		CLOAK = true,
		MAIL_ARMOR = true,
		WEAPON_1H_AXE = true,
		WEAPON_1H_SWORD = true,
		WEAPON_DAGGER = true,
		OFFHAND = true,
		WEAPON_2H_SWORD = true,
		WEAPON_STAFF = true,
		WEAPON_POLEARM = true,
		WEAPON_CROSSBOW = true,
	},
	ROGUE = {
		CLOAK = true,
		LEATHER_ARMOR = true,
		WEAPON_1H_AXE = true,
		WEAPON_1H_SWORD = true,
		WEAPON_1H_MACE = true,
		WEAPON_DAGGER = true,
		OFFHAND = true,
		WEAPON_CROSSBOW = true,
	},
	PRIEST = {
		CLOAK = true,
		CLOTH_ARMOR = true,
		WEAPON_1H_MACE = true,
		WEAPON_DAGGER = true,
		OFFHAND = true,
		WEAPON_STAFF = true,
	},
	DEATHKNIGHT = {
		CLOAK = true,
		PLATE_ARMOR = true,
		WEAPON_1H_AXE = true,
		WEAPON_1H_SWORD = true,
		WEAPON_1H_MACE = true,
		OFFHAND = true,
		WEAPON_2H_SWORD = true,
		WEAPON_POLEARM = true,
	},
	SHAMAN = {
		CLOAK = true,
		MAIL_ARMOR = true,
		WEAPON_1H_AXE = true,
		WEAPON_1H_MACE = true,
		WEAPON_DAGGER = true,
		SHIELD = true,
		OFFHAND = true,
		WEAPON_STAFF = true,
	},
	MAGE = {
		CLOAK = true,
		CLOTH_ARMOR = true,
		WEAPON_1H_SWORD = true,
		WEAPON_DAGGER = true,
		OFFHAND = true,
		WEAPON_STAFF = true,
	},
	WARLOCK = {
		CLOAK = true,
		CLOTH_ARMOR = true,
		WEAPON_1H_SWORD = true,
		WEAPON_DAGGER = true,
		OFFHAND = true,
		WEAPON_STAFF = true,
	},
	MONK = {
		CLOAK = true,
		LEATHER_ARMOR = true,
		WEAPON_1H_AXE = true,
		WEAPON_1H_SWORD = true,
		WEAPON_1H_MACE = true,
		OFFHAND = true,
		WEAPON_STAFF = true,
		WEAPON_POLEARM = true,
	},
	DRUID = {
		CLOAK = true,
		LEATHER_ARMOR = true,
		WEAPON_1H_MACE = true,
		WEAPON_DAGGER = true,
		OFFHAND = true,
		WEAPON_STAFF = true,
		WEAPON_POLEARM = true,
	},
	DEMONHUNTER = {
		CLOAK = true,
		LEATHER_ARMOR = true,
		WEAPON_1H_AXE = true,
		WEAPON_1H_SWORD = true,
		OFFHAND = true,
	},
	EVOKER = {
		CLOAK = true,
		MAIL_ARMOR = true,
		WEAPON_1H_AXE = true,
		WEAPON_1H_SWORD = true,
		WEAPON_1H_MACE = true,
		WEAPON_DAGGER = true,
		OFFHAND = true,
		WEAPON_2H_SWORD = true,
		WEAPON_STAFF = true,
	},
}

addon.PrimalStorms.TransmogItems = {
	{ 199416, ITEMTYPE.WEAPON_1H_AXE, 25 }, --Galerider Crescent
	{ 199406, ITEMTYPE.WEAPON_1H_MACE, 25 }, --Galerider Mallet
	{ 199403, ITEMTYPE.WEAPON_1H_MACE, 25 }, --Stormbender Maul
	{ 199409, ITEMTYPE.WEAPON_1H_SWORD, 25 }, --Stormbender Saber
	{ 199408, ITEMTYPE.WEAPON_1H_SWORD, 25 }, --Squallbreaker Longblade
	{ 199402, ITEMTYPE.WEAPON_CROSSBOW, 45 }, --Galepiercer Ballista
	{ 199399, ITEMTYPE.WEAPON_POLEARM, 45 }, --Galerider Poleaxe
	{ 199400, ITEMTYPE.WEAPON_2H_SWORD, 45 }, --Squallbreaker Greatsword
	{ 199407, ITEMTYPE.WEAPON_DAGGER, 25 }, --Galerider Shank
	{ 199401, ITEMTYPE.OFFHAND, 25 }, --Stormbender Scroll
	{ 199404, ITEMTYPE.SHIELD, 25 }, --Squallbreaker Shield
	{ 199405, ITEMTYPE.WEAPON_STAFF, 45 }, --Stormbender Rod
	{ 199351, ITEMTYPE.CLOTH_ARMOR, 45 }, --Cloudburst Hood
	{ 199359, ITEMTYPE.LEATHER_ARMOR, 45 }, --Dust Devil Mask
	{ 199367, ITEMTYPE.MAIL_ARMOR, 45 }, --Cyclonic Cowl
	{ 199375, ITEMTYPE.PLATE_ARMOR, 45 }, --Firestorm Greathelm
	{ 199348, ITEMTYPE.CLOTH_ARMOR, 45 }, --Cloudburst Robes
	{ 199356, ITEMTYPE.LEATHER_ARMOR, 45 }, --Dust Devil Raiment
	{ 199364, ITEMTYPE.MAIL_ARMOR, 45 }, --Cyclonic Chainmail
	{ 199372, ITEMTYPE.PLATE_ARMOR, 45 }, --Firestorm Chestplate
	{ 199352, ITEMTYPE.CLOTH_ARMOR, 45 }, --Cloudburst Breeches
	{ 199360, ITEMTYPE.LEATHER_ARMOR, 45 }, --Dust Devil Leggings
	{ 199368, ITEMTYPE.MAIL_ARMOR, 45 }, --Cyclonic Kilt
	{ 199376, ITEMTYPE.PLATE_ARMOR, 45 }, --Firestorm Greaves
	{ 199353, ITEMTYPE.CLOTH_ARMOR, 35 }, --Cloudburst Mantle
	{ 199361, ITEMTYPE.LEATHER_ARMOR, 35 }, --Dust Devil Epaulets
	{ 199369, ITEMTYPE.MAIL_ARMOR, 35 }, --Cyclonic Spaulders
	{ 199377, ITEMTYPE.PLATE_ARMOR, 35 }, --Firestorm Pauldrons
	{ 199349, ITEMTYPE.CLOTH_ARMOR, 35 }, --Cloudburst Slippers
	{ 199357, ITEMTYPE.LEATHER_ARMOR, 35 }, --Dust Devil Treads
	{ 199365, ITEMTYPE.MAIL_ARMOR, 35 }, --Cyclonic Striders
	{ 199373, ITEMTYPE.PLATE_ARMOR, 35 }, --Firestorm Stompers
	{ 199350, ITEMTYPE.CLOTH_ARMOR, 35 }, --Cloudburst Mitts
	{ 199358, ITEMTYPE.LEATHER_ARMOR, 35 }, --Dust Devil Gloves
	{ 199366, ITEMTYPE.MAIL_ARMOR, 35 }, --Cyclonic Gauntlets
	{ 199374, ITEMTYPE.PLATE_ARMOR, 35 }, --Firestorm Crushers
	{ 199354, ITEMTYPE.CLOTH_ARMOR, 25 }, --Cloudburst Sash
	{ 199362, ITEMTYPE.LEATHER_ARMOR, 25 }, --Dust Devil Cincture
	{ 199370, ITEMTYPE.MAIL_ARMOR, 25 }, --Cyclonic Cinch
	{ 199378, ITEMTYPE.PLATE_ARMOR, 25 }, --Firestorm Girdle
	{ 199355, ITEMTYPE.CLOTH_ARMOR, 25 }, --Cloudburst Bindings
	{ 199363, ITEMTYPE.LEATHER_ARMOR, 25 }, --Dust Devil Wristbands
	{ 199371, ITEMTYPE.MAIL_ARMOR, 25 }, --Cyclonic Bracers
	{ 199379, ITEMTYPE.PLATE_ARMOR, 25 }, --Firestorm Vambraces
	{ 199384, ITEMTYPE.CLOAK, 25 }, --Cloudburst Wrap
	{ 199385, ITEMTYPE.CLOAK, 25 }, --Dust Devil Cloak
	{ 199380, ITEMTYPE.CLOAK, 25 }, --Cyclonic Drape
	{ 199386, ITEMTYPE.CLOAK, 25 }, --Firestorm Cape
}
