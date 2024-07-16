--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("mopremix")

local SetChecked, SetOpts

function SetOpts(button, opts)
    button.opts = opts
    button.minWidth = 0
    if (opts) then
        button:SetText(opts.text or "")
        button.text:ClearAllPoints()
        button.minWidth = button.minWidth + button.text:GetStringWidth()
        if (opts.text2) then
            button.text2:SetText(opts.text2)
            button.minWidth = button.minWidth + button.text2:GetStringWidth() + 4
            button.text2:Show()
        else
            button.text2:Hide()
        end
        if (opts.notCheckable) then
            button.checkbox:Hide()
            button.text:SetPoint("LEFT", button, "LEFT", 8, 0)
        else
            button.checkbox:Show()
            button.text:SetPoint("LEFT", button, "LEFT", 28, 0)
            button.minWidth = button.minWidth + 20
        end
        button:SetEnabled((not opts.isTitle and true or false) and opts.enabled ~= false)
        if (opts.enabled == false) then
            button:SetDisabledFontObject("GameFontDisableSmallLeft")
            button:SetMotionScriptsWhileDisabled(true)
            button.checkbox:SetDesaturated(true)
        end
        button.arrow:SetShown(opts.hasArrow and true or false)
        if (opts.hasArrow) then
            button.minWidth = button.minWidth + 32
        end
    else
        button:SetText("")
        button.text2:Hide()
    end
    button:SetChecked(opts and opts.checked and opts.checked() or false)
end

function SetChecked(button, checked)
    if (checked) then
        button.checkbox:SetTexCoord(0.0, 0.5, 0.0, 0.5)
    else
        button.checkbox:SetTexCoord(0.5, 1.0, 0.0, 0.5)
    end
end

function CreateMenuButton(parent, opts)
    local button = CreateFrame("Button", nil, parent)
    button:SetSize(100, 16)
    button:SetFrameLevel(parent:GetFrameLevel() + 4)
    button.checkbox = button:CreateTexture(nil, "ARTWORK")
    button.checkbox:SetTexture("Interface/Common/UI-DropDownRadioChecks")
    button.checkbox:SetSize(16, 16)
    button.checkbox:SetPoint("LEFT", 8, 1)
    button.checkbox:SetTexCoord(0.5, 1.0, 0.0, 0.5)
    button.text = button:CreateFontString(nil, "ARTWORK")
    button.text:SetPoint("LEFT", button, "LEFT", 28, 0)
    button.text2 = button:CreateFontString(nil, "ARTWORK", "GameFontDisableTiny2")
    button.text2:SetPoint("LEFT", button.text, "RIGHT", 4, 0)
    button.text2:Hide()
    button.highlight = button:CreateTexture(nil, "BACKGROUND")
    button.highlight:SetTexture("Interface/QuestFrame/UI-QuestTitleHighlight")
    button.highlight:SetBlendMode("ADD");
    button.highlight:SetAllPoints();
    button.highlight:Hide();
    button:SetFontString(button.text)
    button:SetNormalFontObject("GameFontHighlightSmallLeft")
    button:SetHighlightFontObject("GameFontHighlightSmallLeft")
    button:SetDisabledFontObject("GameFontNormalSmallLeft")
    button.arrow = button:CreateTexture(nil,"ARTWORK");
    button.arrow:SetTexture("Interface/ChatFrame/ChatFrameExpandArrow")
    button.arrow:SetSize(16, 16)
    button.arrow:SetPoint("RIGHT", -4, 0)
    button.SetChecked = SetChecked
    button.SetOpts = SetOpts
    button.minWidth = 0
    button:SetOpts(opts)
    button:SetScript("OnClick", function(self)
        if (self.opts and self.opts.func) then
            self.opts.func()
            if (self.opts.checked) then
                self:SetChecked(self.opts.checked())
            end
        end
    end)
    button:SetScript("OnEnter", function(self)
        self.highlight:Show()
        if (parent.submenuFunc) then
            parent:submenuFunc(self, self.opts and self.opts.menuList)
        end
        if (self.opts.enterFunc) then
            self.opts.enterFunc(button)
        end
    end)
    button:SetScript("OnLeave", function(self)
        self.highlight:Hide()
        if (self.opts.leaveFunc) then
            self.opts.leaveFunc(button)
        end
    end)
    return button
end
