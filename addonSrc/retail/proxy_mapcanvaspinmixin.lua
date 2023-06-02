--[[ See license.txt for license and copyright information ]]
local _, addon = ...

local MapCanvasPinMixin = MapCanvasPinMixin

local MapCanvasPinMixinProxyMixin = { }

function MapCanvasPinMixinProxyMixin:OnCanvasScaleChanged()
	self.target.ApplyCurrentScale(self)
end

addon.CreateProxyMixinFunctions(
		MapCanvasPinMixinProxyMixin,
		{
			"ApplyCurrentPosition",
			"ApplyCurrentScale",
			"GetMap",
			"GetNudgeSourceRadius",
			"GetNudgeTargetFactor",
			"GetNudgeVector",
			"IgnoresNudging",
			"IsIgnoringGlobalPinScale",
			"OnClick",
			"OnMouseUp",
			"SetPosition",
			"SetScaleStyle"
		},
		{
			"DisableInheritedMotionScriptsWarning"
		}
)

addon.AddProxy(MapCanvasPinMixin, MapCanvasPinMixinProxyMixin)
