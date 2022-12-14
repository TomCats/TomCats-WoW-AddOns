--[[ See license.txt for license and copyright information ]]
local addonName, addon = ...

local errorLog
local expireAt
local eventFrame = CreateFrame("Frame")
local TomCats_Config = TomCats_Config
local TomCats_ConfigSupport = TomCats_ConfigSupport
local forceEnabled

do
	TomCats_ConfigSupport.name = "Support"
	TomCats_ConfigSupport.parent = "TomCat's Tours"
	TomCats_ConfigSupport.controls = { }
	TomCats_ConfigSupport.Header.Text:SetFont(TomCats_ConfigSupport.Header.Text:GetFont(), 64)
	local subcategory = Settings.RegisterCanvasLayoutSubcategory(TomCats_Config.category, TomCats_ConfigSupport, TomCats_ConfigSupport.name);
	TomCats_ConfigSupport.category = subcategory
end

local function serializeTable(val, key)
	local tmp
	if (key) then
		if (type(key) == "string") then
			tmp = "[\"" .. key .. "\"]="
		else
			tmp = "[" .. key .. "]="
		end
	else
		tmp = ""
	end
	if type(val) == "table" then
		tmp = tmp .. "{"
		for k, v in pairs(val) do
			tmp =  tmp .. serializeTable(v, k) .. ","
		end
		tmp = tmp .. "}"
	elseif type(val) == "number" then
		tmp = tmp .. tostring(val)
	elseif type(val) == "string" then
		tmp = tmp .. string.format("%q", val)
	elseif type(val) == "boolean" then
		tmp = tmp .. (val and "true" or "false")
	else
		tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
	end
	return tmp
end

local function OnHyperlinkClick(self, link)
	if (self.popup:IsShown() and link == self.popup.lastLink) then
		self.popup.lastLink = nil
		self.popup:Hide()
		return
	end
	self.popup.lastLink = link
	if (link == "errors") then
		self.popup.editbox.text = addon.base64.encode(serializeTable(TomCats_Account.errorLog))
		self.popup.info:SetText("Press Control-C to copy the data")
	else
		self.popup.editbox.text = "https://" .. link
		self.popup.info:SetText("Press Control-C to copy the link")
	end
	self.popup.editbox:SetText(self.popup.editbox.text)
	self.popup.editbox:HighlightText()
	self.popup:Show()
	self.popup.editbox:SetFocus()
	self.popup:SetFrameStrata("TOOLTIP")
end

local function OnHyperlinkEnter(self, link, _, fontString)
	self.linksHighlight = self.linksHighlight or self:CreateFontString()
	self.links = fontString
	self.linksHighlight:ClearAllPoints()
	self.linksHighlight:SetFont(self.links:GetFont())
	local text = self.links:GetText()
	text = string.gsub(text, "(|H.-|h)", "")
	text = string.gsub(text, "(|h)", "")
	text = string.gsub(text, link, "|cFFFFD100" .. link .. "|r")
	self.linksHighlight:SetText(text)
	self.linksHighlight:Show()
	for i = 1, self.links:GetNumPoints() do
		self.linksHighlight:SetPoint(self.links:GetPoint(i))
	end
	self.linksHighlight:SetSpacing(self.links:GetSpacing())
	self.linksHighlight:SetJustifyH(self.links:GetJustifyH())
	self.linksHighlight:SetShadowOffset(self.links:GetShadowOffset())
	self.linksHighlight:SetSize(self.links:GetSize())
	self.links:SetAlpha(0.1)
end

local function OnHyperlinkLeave(self)
	self.linksHighlight:Hide()
	self.links:SetAlpha(1.0)
end

TomCats_ConfigSupport.html:SetScript("OnHyperlinkClick", OnHyperlinkClick)
TomCats_ConfigSupport.html:SetScript("OnHyperlinkEnter", OnHyperlinkEnter)
TomCats_ConfigSupport.html:SetScript("OnHyperlinkLeave", OnHyperlinkLeave)
TomCats_ConfigSupport.errorsButton:SetScript("OnClick", function()
	OnHyperlinkClick(TomCats_ConfigSupport.html, "errors")
end)

local function OnEvent(_, event, arg1, arg2)
	if (event == "ADDON_LOADED") then
		if (addonName == arg1) then
			local errorLogDurationSeconds = tonumber("@errorLogDurationSeconds@")
			local currentTS = tonumber("@currentTS@")
			expireAt =  currentTS + errorLogDurationSeconds
			if (TomCats_Account.errorLog.version ~= "@version@") then
				TomCats_Account.errorLog = { }
				TomCats_Account.errorLog.version = "@version@"
			end
			errorLog = TomCats_Account.errorLog
			local enableButtons = (expireAt > GetServerTime()) and #TomCats_Account.errorLog > 0
			TomCats_ConfigSupport.errorsButton:SetEnabled(enableButtons)
			TomCats_Config.errorsButton:SetEnabled(enableButtons)
			addon.UnregisterEvent("ADDON_LOADED", OnEvent)
		end
	end
	if ((event == "ADDON_ACTION_FORBIDDEN" or event == "ADDON_ACTION_BLOCKED") and arg1 == addonName) then
		if (expireAt > GetServerTime()) then
			local error = {
				ts = date(),
				func = arg2,
				stack = debugstack(3),
				buildInfo = { GetBuildInfo() }
			}
			local numAddons = GetNumAddOns()
			local addons = { }
			for i = 1, numAddons do
				local name, _, _, enabled = GetAddOnInfo(i)
				if (enabled) then
					addons[name] = GetAddOnMetadata(i, "version") or "unspecified"
				end
			end
			error.addons = addons
			table.insert(errorLog, error)
			TomCats_ConfigSupport.errorsButton:SetEnabled(true)
			TomCats_Config.errorsButton:SetEnabled(true)
		end
	end
end

local timeSinceLastUpdate = 0
local interval = 1

local function OnUpdate(self, elapsed)
	timeSinceLastUpdate = timeSinceLastUpdate + elapsed
	if (timeSinceLastUpdate > interval) then
		timeSinceLastUpdate = 0
		if (GetServerTime() > expireAt) then
			TomCats_ConfigSupport.errorsButton:SetEnabled(forceEnabled or false)
			TomCats_Config.errorsButton:SetEnabled(forceEnabled or false)
			self:SetScript("OnUpdate", nil)
		end
	end
end

function addon.SetErrorButtonsEnabled()
	forceEnabled = true
	TomCats_ConfigSupport.errorsButton:SetEnabled(true)
	TomCats_Config.errorsButton:SetEnabled(true)
end

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("ADDON_ACTION_FORBIDDEN")
eventFrame:RegisterEvent("ADDON_ACTION_BLOCKED")

eventFrame:SetScript("OnEvent", OnEvent)
eventFrame:SetScript("OnUpdate", OnUpdate)
