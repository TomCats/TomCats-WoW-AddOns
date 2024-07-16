--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("mopremix")

ScreenSide = { }

function ScreenSide.GetCurrentSide(frame)
	local l1, _, w1 = frame:GetScaledRect()
	local l2, _, w2 = UIParent:GetScaledRect()
	local left = l1 - l2
	local right = w2 - (l1 + w1)
	return left > right and SCREEN_RIGHT or SCREEN_LEFT
end
