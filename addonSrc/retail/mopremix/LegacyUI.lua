--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("mopremix")

BACKDROP_GLUE_TOOLTIP_16_16 = {
	bgFile = "Interface\\Glues\\Common\\Glue-Tooltip-Background",
	edgeFile = "Interface\\Glues\\Common\\Glue-Tooltip-Border",
	tile = true,
	tileEdge = true,
	tileSize = 16,
	edgeSize = 16,
	insets = { left = 10, right = 5, top = 4, bottom = 9 },
};

GLUE_BACKDROP_COLOR = CreateColor(0.09, 0.09, 0.09);

GLUE_BACKDROP_BORDER_COLOR = CreateColor(0.8, 0.8, 0.8);
