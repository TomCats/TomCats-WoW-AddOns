local addonName, addon = ...
if (not addon.loveisintheair.IsEventActive()) then return end

local hooksecurefunc = hooksecurefunc
local ButtonFrameTemplate_HideAttic = ButtonFrameTemplate_HideAttic
local ButtonFrameTemplate_HideButtonBar = ButtonFrameTemplate_HideButtonBar
local GetLFGRoles = GetLFGRoles
local HideUIPanel = HideUIPanel
local INSTANCE_ROLE_WARNING_TITLE = INSTANCE_ROLE_WARNING_TITLE
local LFDQueueFrameFindGroupButton = LFDQueueFrameFindGroupButton
local ShowUIPanel = ShowUIPanel
local UIPanelWindows = UIPanelWindows

local TourGuideFrame
local P, AP
local currentChapter = 1

local function UpdateLFDButton()
    TourGuideFrame.dungeon.findGroupButton:SetText(LFDQueueFrameFindGroupButton:GetText())
    if (TourGuideFrame.dungeon.roles.tank.checkButton:GetChecked() or
            TourGuideFrame.dungeon.roles.healer.checkButton:GetChecked() or
            TourGuideFrame.dungeon.roles.dps.checkButton:GetChecked()) then
        if (LFDQueueFrameFindGroupButton:IsEnabled()) then
            TourGuideFrame.dungeon.findGroupButton:Enable()
        else
            if (LFDQueueFrameFindGroupButton.tooltip == INSTANCE_ROLE_WARNING_TITLE) then
                TourGuideFrame.dungeon.findGroupButton:Enable()
            else
                TourGuideFrame.dungeon.findGroupButton.tooltip = LFDQueueFrameFindGroupButton.tooltip
                TourGuideFrame.dungeon.findGroupButton:Disable()
            end
        end
        TourGuideFrame.dungeon.findGroupButton.tooltip = nil
    else
        TourGuideFrame.dungeon.findGroupButton.tooltip = INSTANCE_ROLE_WARNING_TITLE
        TourGuideFrame.dungeon.findGroupButton:Disable()
    end
end
local function ADDON_LOADED(_, arg1)
    if (addonName == arg1) then
        P = TomCats_Character.loveisintheair.preferences
        AP = TomCats_Account.loveisintheair.preferences
        function TourGuideFrame.toggle()
            if (TourGuideFrame:IsShown()) then
                HideUIPanel(TourGuideFrame)
            else
                ShowUIPanel(TourGuideFrame)
                TourGuideFrame.chapterButtons["button" .. currentChapter]:SetChecked(true)
            end
        end

        ButtonFrameTemplate_HideButtonBar(TourGuideFrame);
        ButtonFrameTemplate_HideAttic(TourGuideFrame);
        addon.UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
        hooksecurefunc("LFDQueueFrameFindGroupButton_Update", UpdateLFDButton)
    end
end
addon.RegisterEvent("ADDON_LOADED", ADDON_LOADED)
local TourGuideFrameMixin = {}
_G["TomCats-LoveIsInTheAirTourGuideFrameMixin"] = TourGuideFrameMixin
local function RoleButton_OnClick(button)
    if(button.checkButton) then
        button.checkButton:SetChecked(not button.checkButton:GetChecked())
    else
        button = button:GetParent()
    end
    if (button.role == "TANK") then
        P["roles"][1] = button.checkButton:GetChecked()
    elseif (button.role == "HEALER") then
        P["roles"][2] = button.checkButton:GetChecked()
    else
        P["roles"][3] = button.checkButton:GetChecked()
    end
    UpdateLFDButton()
end
function TourGuideFrameMixin:OnLoad()
    _G["TomCats-LoveIsInTheAirTourGuideFrameMixin"] = nil
    TourGuideFrame = self
    UIPanelWindows[self:GetName()] = {
        area = "left",
        height = 545,
        pushable = 1,
        whileDead = 1,
        width = 575
    }
    self.portrait:SetTexture("Interface\\AddOns\\TomCats\\loveisintheair\\images\\liith-icon")
    self.portrait:SetTexCoord(0, 1, 0, 1)
    self:SetTitle("TomCat's Tours: Love is in the Air")
    --PortraitFrameTemplate_SetTitle(self, "TomCat's Tours: Love is in the Air");
    self.dungeon.roles.tank.OnClick = RoleButton_OnClick
    self.dungeon.roles.tank.checkButton.onClick = RoleButton_OnClick
    self.dungeon.roles.healer.OnClick = RoleButton_OnClick
    self.dungeon.roles.healer.checkButton.onClick = RoleButton_OnClick
    self.dungeon.roles.dps.OnClick = RoleButton_OnClick
    self.dungeon.roles.dps.checkButton.onClick = RoleButton_OnClick
end
function TourGuideFrameMixin:OnShow()
    if (not P["roles"]) then
        P["roles"] = { select(2,GetLFGRoles()) }
    end
    local tankRole, healerRole, dpsRole = unpack(P["roles"])
    self.dungeon.roles.tank.checkButton:SetChecked(tankRole)
    self.dungeon.roles.healer.checkButton:SetChecked(healerRole)
    self.dungeon.roles.dps.checkButton:SetChecked(dpsRole)
    UpdateLFDButton()
end
