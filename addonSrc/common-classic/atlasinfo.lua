--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local atlasInfo = {
    ["!UI-Frame-Metal-EdgeLeft"] = {
        ["rightTexCoord"] = 0.2587890625,
        ["topTexCoord"] = 0,
        ["width"] = 264,
        ["leftTexCoord"] = 0.0009765625,
        ["tilesVertically"] = true,
        ["height"] = 256,
        ["file"] = 2406984,
        ["bottomTexCoord"] = 1,
        ["tilesHorizontally"] = false,
        ["scale"] = 0.5,
    },
    ["UI-Frame-Metal-CornerTopRightDouble"] = {
        ["rightTexCoord"] = 0.2587890625,
        ["topTexCoord"] = 0.5205078125,
        ["width"] = 264,
        ["leftTexCoord"] = 0.0009765625,
        ["tilesVertically"] = false,
        ["height"] = 264,
        ["file"] = 2406979,
        ["bottomTexCoord"] = 0.7783203125,
        ["tilesHorizontally"] = false,
        ["scale"] = 0.5,
    },
    ["_UI-Frame-Metal-EdgeBottom"] = {
        ["rightTexCoord"] = 1,
        ["topTexCoord"] = 0.0009765625,
        ["width"] = 256,
        ["leftTexCoord"] = 0,
        ["tilesVertically"] = false,
        ["height"] = 264,
        ["file"] = 2406987,
        ["bottomTexCoord"] = 0.2587890625,
        ["tilesHorizontally"] = true,
        ["scale"] = 0.5,
    },
    ["UI-Frame-PortraitMetal-CornerTopLeft"] = {
        ["rightTexCoord"] = 0.5185546875,
        ["topTexCoord"] = 0.2607421875,
        ["width"] = 264,
        ["leftTexCoord"] = 0.2607421875,
        ["tilesVertically"] = false,
        ["height"] = 264,
        ["file"] = 2406979,
        ["bottomTexCoord"] = 0.5185546875,
        ["tilesHorizontally"] = false,
        ["scale"] = 0.5,
    },
    ["UI-Frame-Metal-CornerBottomLeft"] = {
        ["rightTexCoord"] = 0.2587890625,
        ["topTexCoord"] = 0.0009765625,
        ["width"] = 264,
        ["leftTexCoord"] = 0.0009765625,
        ["tilesVertically"] = false,
        ["height"] = 264,
        ["file"] = 2406979,
        ["bottomTexCoord"] = 0.2587890625,
        ["tilesHorizontally"] = false,
        ["scale"] = 0.5,
    },
    ["UI-Frame-Metal-CornerBottomRight"] = {
        ["rightTexCoord"] = 0.5185546875,
        ["topTexCoord"] = 0.0009765625,
        ["width"] = 264,
        ["leftTexCoord"] = 0.2607421875,
        ["tilesVertically"] = false,
        ["height"] = 264,
        ["file"] = 2406979,
        ["bottomTexCoord"] = 0.2587890625,
        ["tilesHorizontally"] = false,
        ["scale"] = 0.5,
    },
    ["UI-Frame-Metal-CornerTopLeft"] = {
        ["rightTexCoord"] = 0.7783203125,
        ["topTexCoord"] = 0.0009765625,
        ["width"] = 264,
        ["leftTexCoord"] = 0.5205078125,
        ["tilesVertically"] = false,
        ["height"] = 264,
        ["file"] = 2406979,
        ["bottomTexCoord"] = 0.2587890625,
        ["tilesHorizontally"] = false,
        ["scale"] = 0.5,
    },
    ["_UI-Frame-Metal-EdgeTop"] = {
        ["rightTexCoord"] = 1,
        ["topTexCoord"] = 0.2607421875,
        ["width"] = 256,
        ["leftTexCoord"] = 0,
        ["tilesVertically"] = false,
        ["height"] = 264,
        ["file"] = 2406987,
        ["bottomTexCoord"] = 0.5185546875,
        ["tilesHorizontally"] = true,
        ["scale"] = 0.5,
    },
    ["!UI-Frame-Metal-EdgeRight"] = {
        ["rightTexCoord"] = 0.5185546875,
        ["topTexCoord"] = 0,
        ["width"] = 264,
        ["leftTexCoord"] = 0.2607421875,
        ["tilesVertically"] = true,
        ["height"] = 256,
        ["file"] = 2406984,
        ["bottomTexCoord"] = 1,
        ["tilesHorizontally"] = false,
        ["scale"] = 0.5,
    },
}

local FileNameLookup = {
    [2406984] = "Interface\\AddOns\\TomCats\\BlizzardInterfaceArt\\interface\\framegeneral\\uiframemetalvertical2x",
    [2406979] = "Interface\\AddOns\\TomCats\\BlizzardInterfaceArt\\interface\\framegeneral\\uiframemetal2x",
    [2406987] = "Interface\\AddOns\\TomCats\\BlizzardInterfaceArt\\interface\\framegeneral\\uiframemetalhorizontal2x"
}

function TomCatsGetAtlasInfo(atlasName)
    return atlasInfo[atlasName]
end

function TomCatsSetAtlas(texture, atlasName, useAtlasScale)
    local info = TomCatsGetAtlasInfo(atlasName)
    texture:SetTexture(FileNameLookup[info.file])
    texture:SetTexCoord(info.leftTexCoord, info.rightTexCoord, info.topTexCoord, info.bottomTexCoord)
    if useAtlasScale then
        texture:SetSize(info.width * (info.scale or 1), info.height * (info.scale or 1))
    else
        texture:SetSize(info.width, info.height)
    end
    texture:SetHorizTile(info.tilesHorizontally)
    texture:SetVertTile(info.tilesVertically)
end
