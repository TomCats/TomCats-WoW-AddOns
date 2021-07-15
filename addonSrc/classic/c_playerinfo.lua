--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

C_PlayerInfo = CreateFromMixins(getglobal("C_PlayerInfo"))

function C_PlayerInfo.GetContentDifficultyQuestForPlayer(questID)
	local questInfo = QuestInfoCache[questID]
	if (questInfo) then
		local levelDiff = questInfo.level - UnitLevel("player")
		if ( levelDiff >= 5 ) then
			return Enum.RelativeContentDifficulty.Impossible
		elseif ( levelDiff >= 3 ) then
			return Enum.RelativeContentDifficulty.Difficult
		elseif ( levelDiff >= -2 ) then
			return Enum.RelativeContentDifficulty.Fair
		elseif ( -levelDiff <= GetQuestGreenRange() ) then
			return Enum.RelativeContentDifficulty.Easy
		else
			return Enum.RelativeContentDifficulty.Trivial
		end
	else
		return Enum.RelativeContentDifficulty.Trivial
	end
end
