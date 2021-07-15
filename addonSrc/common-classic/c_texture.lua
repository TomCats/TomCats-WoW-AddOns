--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

C_Texture = CreateFromMixins(getglobal("C_Texture"))

local atlasInfoOverrides = {
	["Campaign_HeaderIcon_Closed"] =  {["rightTexCoord"]=0.560546875,["topTexCoord"]=0.9453125,["width"]=22,["leftTexCoord"]=0.5390625,["tilesHorizontally"]=false,["height"]=22,["file"]=904010,["bottomTexCoord"]=0.966796875,["tilesVertically"]=false},
	["Campaign_HeaderIcon_ClosedPressed"] =  {["rightTexCoord"]=0.560546875,["topTexCoord"]=0.9697265625,["width"]=22,["leftTexCoord"]=0.5390625,["tilesHorizontally"]=false,["height"]=22,["file"]=904010,["bottomTexCoord"]=0.9912109375,["tilesVertically"]=false},
	["Campaign_HeaderIcon_Open"] =  {["rightTexCoord"]=0.869140625,["topTexCoord"]=0.173828125,["width"]=22,["leftTexCoord"]=0.84765625,["tilesHorizontally"]=false,["height"]=22,["file"]=904010,["bottomTexCoord"]=0.1953125,["tilesVertically"]=false},
	["Campaign_HeaderIcon_OpenPressed"] =  {["rightTexCoord"]=0.869140625,["topTexCoord"]=0.197265625,["width"]=22,["leftTexCoord"]=0.84765625,["tilesHorizontally"]=false,["height"]=22,["file"]=904010,["bottomTexCoord"]=0.21875,["tilesVertically"]=false},
	["NoQuestsBackground"] = {["rightTexCoord"]=0.28125,["topTexCoord"]=0.0009765625,["width"]=287,["leftTexCoord"]=0.0009765625,["tilesHorizontally"]=false,["height"]=510,["file"]=904010,["bottomTexCoord"]=0.4990234375,["tilesVertically"]=false},
	["QuestLogBackground"] = {["rightTexCoord"]=0.28125,["topTexCoord"]=0.5009765625,["width"]=287,["leftTexCoord"]=0.0009765625,["tilesHorizontally"]=false,["height"]=510,["file"]=904010,["bottomTexCoord"]=0.9990234375,["tilesVertically"]=false},
	["UI-Frame-Metal-CornerBottomLeft"] =  {["rightTexCoord"]=0.2587890625,["topTexCoord"]=0.0009765625,["width"]=264,["leftTexCoord"]=0.0009765625,["tilesHorizontally"]=false,["height"]=264,["file"]=2406979,["bottomTexCoord"]=0.2587890625,["tilesVertically"]=false,["scale"]=0.5},
	["!UI-Frame-Metal-EdgeRight"] =  {["rightTexCoord"]=0.5185546875,["topTexCoord"]=0,["width"]=264,["leftTexCoord"]=0.2607421875,["tilesHorizontally"]=false,["height"]=256,["file"]=2406984,["bottomTexCoord"]=1,["tilesVertically"]=true,["scale"]=0.5},
	["_UI-Frame-Metal-EdgeTop"] =  {["rightTexCoord"]=1,["topTexCoord"]=0.2607421875,["width"]=256,["leftTexCoord"]=0,["tilesHorizontally"]=true,["height"]=264,["file"]=2406987,["bottomTexCoord"]=0.5185546875,["tilesVertically"]=false,["scale"]=0.5},
	["_UI-Frame-Metal-EdgeBottom"] =  {["rightTexCoord"]=1,["topTexCoord"]=0.0009765625,["width"]=256,["leftTexCoord"]=0,["tilesHorizontally"]=true,["height"]=264,["file"]=2406987,["bottomTexCoord"]=0.2587890625,["tilesVertically"]=false,["scale"]=0.5},
	["UI-Frame-Metal-CornerTopRightDouble"] =  {["rightTexCoord"]=0.2587890625,["topTexCoord"]=0.5205078125,["width"]=264,["leftTexCoord"]=0.0009765625,["tilesHorizontally"]=false,["height"]=264,["file"]=2406979,["bottomTexCoord"]=0.7783203125,["tilesVertically"]=false,["scale"]=0.5},
	["UI-Frame-PortraitMetal-CornerTopLeft"] =  {["rightTexCoord"]=0.5185546875,["topTexCoord"]=0.2607421875,["width"]=264,["leftTexCoord"]=0.2607421875,["tilesHorizontally"]=false,["height"]=264,["file"]=2406979,["bottomTexCoord"]=0.5185546875,["tilesVertically"]=false,["scale"]=0.5},
	["!UI-Frame-Metal-EdgeLeft"] =  {["rightTexCoord"]=0.2587890625,["topTexCoord"]=0,["width"]=264,["leftTexCoord"]=0.0009765625,["tilesHorizontally"]=false,["height"]=256,["file"]=2406984,["bottomTexCoord"]=1,["tilesVertically"]=true,["scale"]=0.5},
	["UI-Frame-Metal-CornerBottomRight"] =  {["rightTexCoord"]=0.5185546875,["topTexCoord"]=0.0009765625,["width"]=264,["leftTexCoord"]=0.2607421875,["tilesHorizontally"]=false,["height"]=264,["file"]=2406979,["bottomTexCoord"]=0.2587890625,["tilesVertically"]=false,["scale"]=0.5},
	["UI-Frame-Metal-CornerTopLeft"] = {["rightTexCoord"]=0.7783203125,["topTexCoord"]=0.0009765625,["width"]=264,["leftTexCoord"]=0.5205078125,["tilesHorizontally"]=false,["height"]=264,["file"]=2406979,["bottomTexCoord"]=0.2587890625,["tilesVertically"]=false,["scale"]=0.5},
}

local GetAtlasInfo = C_Texture.GetAtlasInfo
function C_Texture.GetAtlasInfo(atlasName)
	return atlasInfoOverrides[atlasName] or GetAtlasInfo(atlasName)
end

function C_Texture.IsOverridden(atlasName)
	return atlasInfoOverrides[atlasName] ~= nil
end
