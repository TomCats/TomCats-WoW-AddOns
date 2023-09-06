-- adapted from Blizzard UI
local addonName, addon = ...

WardrobeSetsDetailsModelMixin = { };

addon.WardrobeSetsDetailsModelMixin = WardrobeSetsDetailsModelMixin

function WardrobeSetsDetailsModelMixin:OnLoad()
	self:SetAutoDress(false);
	self:SetUnit("player", false, PlayerUtil.ShouldUseNativeFormInModelScene());
	self:UpdatePanAndZoomModelType();

	local lightValues = { omnidirectional = false, point = CreateVector3D(-1, 0, 0), ambientIntensity = .7, ambientColor = CreateColor(.7, .7, .7), diffuseIntensity = .6, diffuseColor = CreateColor(1, 1, 1) };
	local enabled = true;
	self:SetLight(enabled, lightValues);
end

function WardrobeSetsDetailsModelMixin:OnShow()
	self:SetUnit("player", false, PlayerUtil.ShouldUseNativeFormInModelScene());
end

function WardrobeSetsDetailsModelMixin:UpdatePanAndZoomModelType()
	local hasAlternateForm, inAlternateForm = C_PlayerInfo.GetAlternateFormInfo();
	if ( not self.panAndZoomModelType or self.inAlternateForm ~= inAlternateForm ) then
		local _, race = UnitRace("player");
		local sex = UnitSex("player");
		if ( inAlternateForm ) then
			self.panAndZoomModelType = race..sex.."Alt";
		else
			self.panAndZoomModelType = race..sex;
		end
		self.inAlternateForm = inAlternateForm;
	end
end

function WardrobeSetsDetailsModelMixin:GetPanAndZoomLimits()
	return SET_MODEL_PAN_AND_ZOOM_LIMITS[self.panAndZoomModelType];
end

function WardrobeSetsDetailsModelMixin:OnUpdate(elapsed)
	if ( IsUnitModelReadyForUI("player") ) then
		if ( self.rotating ) then
			if ( self.yaw ) then
				local x = GetCursorPosition();
				local diff = (x - self.rotateStartCursorX) * MODELFRAME_DRAG_ROTATION_CONSTANT;
				self.rotateStartCursorX = GetCursorPosition();
				self.yaw = self.yaw + diff;
				if ( self.yaw < 0 ) then
					self.yaw = self.yaw + (2 * PI);
				end
				if ( self.yaw > (2 * PI) ) then
					self.yaw = self.yaw - (2 * PI);
				end
				self:SetRotation(self.yaw, false);
			end
		elseif ( self.panning ) then
			if ( self.defaultPosX ) then
				local cursorX, cursorY = GetCursorPosition();
				local modelX = self:GetPosition();
				local panSpeedModifier = 100 * sqrt(1 + modelX - self.defaultPosX);
				local modelY = self.panStartModelY + (cursorX - self.panStartCursorX) / panSpeedModifier;
				local modelZ = self.panStartModelZ + (cursorY - self.panStartCursorY) / panSpeedModifier;
				local limits = self:GetPanAndZoomLimits();
				modelY = Clamp(modelY, limits.panMaxLeft, limits.panMaxRight);
				modelZ = Clamp(modelZ, limits.panMaxBottom, limits.panMaxTop);
				self:SetPosition(modelX, modelY, modelZ);
			end
		end
	end
end

function WardrobeSetsDetailsModelMixin:OnMouseDown(button)
	if ( button == "LeftButton" ) then
		self.rotating = true;
		self.rotateStartCursorX = GetCursorPosition();
	elseif ( button == "RightButton" ) then
		self.panning = true;
		self.panStartCursorX, self.panStartCursorY = GetCursorPosition();
		local modelX, modelY, modelZ = self:GetPosition();
		self.panStartModelY = modelY;
		self.panStartModelZ = modelZ;
	end
end

function WardrobeSetsDetailsModelMixin:OnMouseUp(button)
	if ( button == "LeftButton" ) then
		self.rotating = false;
	elseif ( button == "RightButton" ) then
		self.panning = false;
	end
end

function WardrobeSetsDetailsModelMixin:OnMouseWheel(delta)
	local posX, posY, posZ = self:GetPosition();
	posX = posX + delta * 0.5;
	local limits = self:GetPanAndZoomLimits();
	posX = Clamp(posX, self.defaultPosX, limits.maxZoom);
	self:SetPosition(posX, posY, posZ);
end

function WardrobeSetsDetailsModelMixin:OnModelLoaded()
	if ( self.cameraID ) then
		Model_ApplyUICamera(self, self.cameraID);
	end
end