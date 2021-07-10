--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local WorldMapProxyMixin = CreateFromMixins()

CreateProxyMixinFunctions(
		WorldMapProxyMixin,
		{
		},
		{
		}
)

local function init()
end

local function SetupWorldMapFrame()
	WorldMapFrame.target.BorderFrame:SetParent(nil)
	WorldMapFrame.target.BorderFrame:Hide()
	WorldMapFrame.target.BorderFrame = CreateFrame("Frame", nil, WorldMapFrame.target, "WorldMapFrameBorderFrameTemplate")
end

local function OnEvent(event, arg1)
	if (event == "ADDON_LOADED") then
		if (addonName == arg1) then
			WorldMapFrame = AddProxy(getglobal("WorldMapFrame"), WorldMapProxyMixin, init)
			SetupWorldMapFrame()
		end
	end
end

RegisterEvent("ADDON_LOADED", OnEvent)
