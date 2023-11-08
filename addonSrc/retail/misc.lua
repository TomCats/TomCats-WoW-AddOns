--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope("osd")

function startsWith(str, start)
	return string.sub(str, 1, string.len(start)) == start
end
