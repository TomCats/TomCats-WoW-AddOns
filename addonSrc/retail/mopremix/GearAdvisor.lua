--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("mopremix")

local eventFrame

local component = {
	Name = "GearAdvisor"
}

-- 4362 --> 4696 (+) --> 4862 (++) --> 5029 (+++)
-- + = 334, ++ = 500, +++ = 667
local slots = {
	1,  -- Head
	2,  -- Neck
	3,  -- Shoulder
	4,  -- Shirt
	5,  -- Chest
	6,  -- Waist
	7,  -- Legs
	8,  -- Feet
	9,  -- Wrist
	10, -- Hands
	11, -- Finger 1
	12, -- Finger 2
	13, -- Trinket 1
	14, -- Trinket 2
	15, -- Back
	16, -- Main Hand
	17, -- Off Hand
	18, -- Ranged or Relic
	19  -- Tabard
}

local function OnEvent(_, event, ...)
	--if (event == "BAG_UPDATE") then
	--	for _, slotID in ipairs(slots) do
	--		local itemID = GetInventoryItemID("player", slotID)
	--		if itemID then
	--			local itemName = GetItemInfo(itemID)
	--			print("Slot " .. slotID .. ": " .. (itemName or "Unknown"))
	--		else
	--			print("Slot " .. slotID .. ": Empty")
	--		end
	--	end
	--end
end

function component.Init()
	eventFrame = CreateFrame("Frame")
	eventFrame:RegisterEvent("BAG_UPDATE")
	eventFrame:SetScript("OnEvent", OnEvent)
end

AddComponent(component)
