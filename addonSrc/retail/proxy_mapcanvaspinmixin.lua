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
			"CheckMouseButtonPassthrough",
			"GetMap",
			"GetNudgeSourceRadius",
			"GetNudgeTargetFactor",
			"GetNudgeVector",
			"IgnoresNudging",
			"IsIgnoringGlobalPinScale",
			"OnClick",
			"OnMouseUp",
			"SetOwningMap",
			"SetPosition",
			"SetScaleStyle",
			"ShouldMouseButtonBePassthrough"
		},
		{
			"DisableInheritedMotionScriptsWarning",
			"IsPinSuppressor"
		}
)

addon.AddProxy(MapCanvasPinMixin, MapCanvasPinMixinProxyMixin)
