--[[ See license.txt for license and copyright information ]]

assert(nop)
-- Fonts
assert(Game36Font_Shadow2)
assert(GameFontNormal)

-- Frame
assert(CreateFrame)
local frame = CreateFrame("Frame")
assert(frame.SetScript)
frame:GetScript("OnShow")
frame:GetScript("OnHide")
assert(frame.Hide)
assert(frame.SetPoint)
assert(frame.SetAllPoints)
assert(frame.SetFrameStrata)
assert(frame.Show)

-- Options panel
assert(Settings.RegisterAddOnCategory)
assert(Settings.RegisterCanvasLayoutCategory)
assert(SettingsPanel.Bg.TopSection)
