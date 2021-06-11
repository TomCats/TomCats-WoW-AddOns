local BaseMapPoiPinMixin = BaseMapPoiPinMixin
local C_EncounterJournal = TomCats_C_EncounterJournal
local CreateFromMixins = CreateFromMixins
local CVarMapCanvasDataProviderMixin = TomCats_CVarMapCanvasDataProviderMixin
local DungeonEntranceDataProviderMixin
local DungeonEntrancePinMixin
local EventRegistry = EventRegistry
local WorldMapFrame = WorldMapFrame

DungeonEntranceDataProviderMixin = CreateFromMixins(CVarMapCanvasDataProviderMixin);
DungeonEntranceDataProviderMixin:Init("showDungeonEntrancesOnMap", "SHOW_DUNGEON_ENTRANCES");

function DungeonEntranceDataProviderMixin:OnShow()
	EventRegistry:RegisterCallback("Supertracking.OnChanged", self.OnSuperTrackingChanged, self);
end

function DungeonEntranceDataProviderMixin:OnHide()
	EventRegistry:UnregisterCallback("Supertracking.OnChanged", self);
end


function DungeonEntranceDataProviderMixin:OnSuperTrackingChanged()
	for pin in self:GetMap():EnumeratePinsByTemplate("TomCats_DungeonEntrancePinTemplate") do
		pin:UpdateSupertrackedHighlight();
	end
end

function DungeonEntranceDataProviderMixin:RemoveAllData()
	self:GetMap():RemoveAllPinsByTemplate("TomCats_DungeonEntrancePinTemplate");
end

function DungeonEntranceDataProviderMixin:RefreshAllData(fromOnShow)
	self:RemoveAllData();

	if not self:IsCVarSet() then
		return;
	end

	local mapID = self:GetMap():GetMapID();
	local dungeonEntrances = C_EncounterJournal.GetDungeonEntrancesForMap(mapID);
	for i, dungeonEntranceInfo in ipairs(dungeonEntrances) do
		local pin = self:GetMap():AcquirePin("TomCats_DungeonEntrancePinTemplate", dungeonEntranceInfo);
		pin:UpdateSupertrackedHighlight();
	end
end

--[[ Pin ]]--
DungeonEntrancePinMixin = BaseMapPoiPinMixin:CreateSubPin("PIN_FRAME_LEVEL_DUNGEON_ENTRANCE");

function DungeonEntrancePinMixin:OnAcquired(dungeonEntranceInfo) -- override
	BaseMapPoiPinMixin.OnAcquired(self, dungeonEntranceInfo);
	self.journalInstanceID = dungeonEntranceInfo.journalInstanceID;
	self.uiMapID = dungeonEntranceInfo.uiMapID;
end

function DungeonEntrancePinMixin:OnMouseClickAction()
--	EncounterJournal_LoadUI();
--	EncounterJournal_OpenJournal(nil, self.journalInstanceID);
end

function DungeonEntrancePinMixin:UpdateSupertrackedHighlight()
	--local highlight = QuestSuperTracking_ShouldHighlightDungeons(self:GetMap():GetMapID());
	--MapPinHighlight_CheckHighlightPin(highlight, self, self.Texture);
end

-- override by TomCat
function DungeonEntrancePinMixin:OnClick()
	if (self.uiMapID) then
		WorldMapFrame:SetMapID(self.uiMapID)
	end
end

TomCats_DungeonEntranceDataProviderMixin = DungeonEntranceDataProviderMixin
TomCats_DungeonEntrancePinMixin = DungeonEntrancePinMixin
