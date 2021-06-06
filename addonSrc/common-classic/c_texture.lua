local C_Texture = CreateFromMixins(C_Texture)

local GetAtlasInfo = C_Texture.GetAtlasInfo

local atlasInfoOverrides = {
	["UI-Frame-Metal-CornerBottomLeft"] =  {["rightTexCoord"]=0.2587890625,["topTexCoord"]=0.0009765625,["width"]=264,["leftTexCoord"]=0.0009765625,["tilesHorizontally"]=false,["height"]=264,["file"]=2406979,["bottomTexCoord"]=0.2587890625,["tilesVertically"]=false,["scale"]=0.5},
	["!UI-Frame-Metal-EdgeRight"] =  {["rightTexCoord"]=0.5185546875,["topTexCoord"]=0,["width"]=264,["leftTexCoord"]=0.2607421875,["tilesHorizontally"]=false,["height"]=256,["file"]=2406984,["bottomTexCoord"]=1,["tilesVertically"]=true,["scale"]=0.5},
	["_UI-Frame-Metal-EdgeTop"] =  {["rightTexCoord"]=1,["topTexCoord"]=0.2607421875,["width"]=256,["leftTexCoord"]=0,["tilesHorizontally"]=true,["height"]=264,["file"]=2406987,["bottomTexCoord"]=0.5185546875,["tilesVertically"]=false,["scale"]=0.5},
	["_UI-Frame-Metal-EdgeBottom"] =  {["rightTexCoord"]=1,["topTexCoord"]=0.0009765625,["width"]=256,["leftTexCoord"]=0,["tilesHorizontally"]=true,["height"]=264,["file"]=2406987,["bottomTexCoord"]=0.2587890625,["tilesVertically"]=false,["scale"]=0.5},
	["UI-Frame-Metal-CornerTopRightDouble"] =  {["rightTexCoord"]=0.2587890625,["topTexCoord"]=0.5205078125,["width"]=264,["leftTexCoord"]=0.0009765625,["tilesHorizontally"]=false,["height"]=264,["file"]=2406979,["bottomTexCoord"]=0.7783203125,["tilesVertically"]=false,["scale"]=0.5},
	["UI-Frame-PortraitMetal-CornerTopLeft"] =  {["rightTexCoord"]=0.5185546875,["topTexCoord"]=0.2607421875,["width"]=264,["leftTexCoord"]=0.2607421875,["tilesHorizontally"]=false,["height"]=264,["file"]=2406979,["bottomTexCoord"]=0.5185546875,["tilesVertically"]=false,["scale"]=0.5},
	["!UI-Frame-Metal-EdgeLeft"] =  {["rightTexCoord"]=0.2587890625,["topTexCoord"]=0,["width"]=264,["leftTexCoord"]=0.0009765625,["tilesHorizontally"]=false,["height"]=256,["file"]=2406984,["bottomTexCoord"]=1,["tilesVertically"]=true,["scale"]=0.5},
	["UI-Frame-Metal-CornerBottomRight"] =  {["rightTexCoord"]=0.5185546875,["topTexCoord"]=0.0009765625,["width"]=264,["leftTexCoord"]=0.2607421875,["tilesHorizontally"]=false,["height"]=264,["file"]=2406979,["bottomTexCoord"]=0.2587890625,["tilesVertically"]=false,["scale"]=0.5},
	["UI-Frame-Metal-CornerTopLeft"] = {["rightTexCoord"]=0.7783203125,["topTexCoord"]=0.0009765625,["width"]=264,["leftTexCoord"]=0.5205078125,["tilesHorizontally"]=false,["height"]=264,["file"]=2406979,["bottomTexCoord"]=0.2587890625,["tilesVertically"]=false,["scale"]=0.5}
}

function C_Texture.GetAtlasInfo(atlasName)
	return atlasInfoOverrides[atlasName] or GetAtlasInfo(atlasName)
end

function C_Texture.IsOverridden(atlasName)
	return atlasInfoOverrides[atlasName] ~= nil
end

TomCats_C_Texture = C_Texture
