--[[ See license.txt for license and copyright information ]]
local _, addon = ...

local MapCanvasProxyMixin = { }

function MapCanvasProxyMixin:AddDataProvider(dataProvider)
	self.dataProviders[dataProvider] = true
	dataProvider:OnAdded(self)
end

function MapCanvasProxyMixin:OnCanvasScaleChanged()
	self:CallMethodOnPinsAndDataProviders("OnCanvasScaleChanged")
end

addon.CreateProxyMixinFunctions(
		MapCanvasProxyMixin,
		{
			"AcquirePin",
			"ApplyPinPosition",
			"CallMethodOnPinsAndDataProviders",
			"ExecuteOnAllPins",
			"IsShown",
			"RemovePin",
			"SetPinPosition",
		},
		{
			"CallMethodOnDataProviders",
			"GetCanvas",
			"GetCanvasScale",
			"GetCanvasZoomPercent",
			"GetGlobalPinScale",
			"GetMapID",
			"GetName",
			"GetPinFrameLevelsManager",
			"GetPinTemplateType",
			"IsShown",
			"ProcessGlobalPinMouseActionHandlers",
			"RegisterPin",
			"SetMapID",
			"TriggerEvent",
			"UnregisterPin"
		}
)

local function init(proxy)
	proxy.dataProviders = { }
	proxy.pinPools = { }
	proxy.pinTemplateTypes = { }
	hooksecurefunc(proxy.target, "OnMapChanged", function()
		for dataProvider in pairs(proxy.dataProviders) do
			dataProvider:OnMapChanged()
		end
	end)
	hooksecurefunc(proxy.target, "OnCanvasScaleChanged", function()
		proxy:OnCanvasScaleChanged()
	end)
	proxy.ScrollContainer = proxy.target.ScrollContainer
end

local function OnEvent(event)
	if (event == "ADDON_LOADED") then
		addon.AddProxy(WorldMapFrame, MapCanvasProxyMixin, init)
		addon.AddProxy(BattlefieldMapFrame, MapCanvasProxyMixin, init)
		addon.AddProxy(FlightMapFrame, MapCanvasProxyMixin, init)
	end
end

addon.RegisterEvent("ADDON_LOADED", OnEvent)
