--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

function securecall(fn, ...)
	if (type(fn) == "string") then
		fn = _G[fn]
	end
	fn(...)
end
