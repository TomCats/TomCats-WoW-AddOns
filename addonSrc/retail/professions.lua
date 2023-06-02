--[[ See license.txt for license and copyright information ]]
local _, addon = ...

local eventFrame = CreateFrame("Frame")
local isDirty = false
local skillLinesLUT
local skills = { }

-- This will only work for primary professions and is only capable of identifying the most recent version of that
-- profession, such as Dragon Isles Alchemy.  This will break if attempting to lookup professions from prior xpacs!

function addon.PlayerHasSkillID(skillID)
    return skills[skillID] or false
end

local function OnUpdate()
    if (isDirty) then
        isDirty = false
        if (not skillLinesLUT) then
            skillLinesLUT = { }
            local skillLines = C_TradeSkillUI.GetAllProfessionTradeSkillLines()
            for _, skillLine in ipairs(skillLines) do
                skillLinesLUT[C_TradeSkillUI.GetTradeSkillDisplayName(skillLine)] = skillLine
            end
        end
        local professions = { GetProfessions() }
        skills = { }
        for i = 1, 2 do
            local profidx = professions[i]
            if (profidx) then
                local profname = select(11, GetProfessionInfo(profidx))
                skills[skillLinesLUT[profname]] = true
            end
        end
    end
end

local function UpdatePlayerSkills()
    isDirty = true
end

eventFrame:SetScript("OnEvent", UpdatePlayerSkills)
eventFrame:SetScript("OnUpdate", OnUpdate)
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("SKILL_LINES_CHANGED")
