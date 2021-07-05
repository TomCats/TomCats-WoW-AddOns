local addonName, addon = ...

local GetDifficultyInfo = GetDifficultyInfo
local GetInstanceInfo = GetInstanceInfo
local MiniMapInstanceDifficulty
local MiniMapInstanceDifficultyText
local MiniMapInstanceDifficultyTexture
local MiniMapInstanceDifficulty_Update

function MiniMapInstanceDifficulty_Update()
	local _, instanceType, difficulty, _, maxPlayers, playerDifficulty, isDynamicInstance, _, instanceGroupSize = GetInstanceInfo();
	local _, _, isHeroic, isChallengeMode, displayHeroic, displayMythic = GetDifficultyInfo(difficulty);

	if ( instanceType == "raid" or isHeroic or displayMythic or displayHeroic ) then
		MiniMapInstanceDifficultyText:SetText(instanceGroupSize);
		-- the 1 looks a little off when text is centered
		local xOffset = 0;
		if ( instanceGroupSize >= 10 and instanceGroupSize <= 19 ) then
			xOffset = -1;
		end
		if ( displayMythic ) then
			MiniMapInstanceDifficultyTexture:SetTexCoord(0.25, 0.5, 0.0703125, 0.4296875);
			MiniMapInstanceDifficultyText:SetPoint("CENTER", xOffset, -9);
		elseif ( isHeroic or displayHeroic ) then
			MiniMapInstanceDifficultyTexture:SetTexCoord(0, 0.25, 0.0703125, 0.4296875);
			MiniMapInstanceDifficultyText:SetPoint("CENTER", xOffset, -9);
		else
			MiniMapInstanceDifficultyTexture:SetTexCoord(0, 0.25, 0.5703125, 0.9296875);
			MiniMapInstanceDifficultyText:SetPoint("CENTER", xOffset, 5);
		end
		MiniMapInstanceDifficulty:Show();
		--GuildInstanceDifficulty:Hide();
		--MiniMapChallengeMode:Hide();
	else
		MiniMapInstanceDifficulty:Hide();
		--GuildInstanceDifficulty:Hide();
		--MiniMapChallengeMode:Hide();
	end
end

local function OnEvent(event, arg1)
	if (event == "ADDON_LOADED") then
		if (addonName == arg1) then
			MiniMapInstanceDifficulty = TomCats_MiniMapInstanceDifficulty
			MiniMapInstanceDifficultyText = TomCats_MiniMapInstanceDifficultyText
			MiniMapInstanceDifficultyTexture = TomCats_MiniMapInstanceDifficultyTexture
		end
	end
end

addon.RegisterEvent("ADDON_LOADED", OnEvent)

TomCats_MiniMapInstanceDifficulty_Update = MiniMapInstanceDifficulty_Update
