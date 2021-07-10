--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local renamedVariablePattern = addonName .. "_%s"

local mappedTemplateNames = {
	["DungeonEntrancePinTemplate"] = renamedVariablePattern:format("DungeonEntrancePinTemplate"),
}

local MapCanvasProxyMixin = { }

local function getPinTemplate(pinTemplate)
	local newName = mappedTemplateNames[pinTemplate]
	if (newName) then
		pinTemplate = newName
	else
		error(("Pin template not allowed: %s"):format(pinTemplate))
	end
	return pinTemplate
end

function MapCanvasProxyMixin:AcquirePin(pinTemplate, ...)
	return self.target:AcquirePin(getPinTemplate(pinTemplate), ...)
end

function MapCanvasProxyMixin:AddDataProvider(dataProvider)
	self.target:AddDataProvider(dataProvider)
	dataProvider:OnAdded(self)
end

function MapCanvasProxyMixin:RemoveAllPinsByTemplate(pinTemplate)
	self.target:RemoveAllPinsByTemplate(getPinTemplate(pinTemplate))
end

CreateProxyMixinFunctions(
		MapCanvasProxyMixin,
		{
			--"AcquirePin",
			--"ApplyPinPosition",
			--"CallMethodOnPinsAndDataProviders",
			--"EnumerateAllPins",
			--"IsShown",
			--"RemovePin",
			--"SetPinPosition",
		},
		{
			--"GetCanvas",
			--"GetCanvasScale",
			--"GetCanvasZoomPercent",
			--"GetGlobalPinScale",
			"GetMapID",
			--"GetName",
			--"GetPinFrameLevelsManager",
			--"IsShown",
			--"ProcessGlobalPinMouseActionHandlers",
			--"SetMapID",
			--"TriggerEvent"
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
		AddProxy(WorldMapFrame, MapCanvasProxyMixin, init)
	end
end

RegisterEvent("ADDON_LOADED", OnEvent)
