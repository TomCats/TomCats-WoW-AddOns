--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local eventHandlers = { }

local eventFrame = CreateFrame("FRAME")

local function OnEvent(_, event, ...)
	local handlers = eventHandlers[event]
	if (handlers) then
		for _, handler in ipairs(handlers) do
			handler(event, ...)
		end
	end
end

function RegisterEvent(event, handler)
	eventHandlers[event] = eventHandlers[event] or { }
	local handlers = eventHandlers[event]
	if (#handlers == 0) then
		eventFrame:RegisterEvent(event)
	end
	table.insert(handlers, handler)
end

function UnregisterEvent(event, handler)
	local handlers = eventHandlers[event]
	if (handlers) then
		local newHandlers = { }
		for _, v in ipairs(handlers) do
			if (v ~= handler) then
				table.insert(newHandlers, v)
			end
		end
		if (#newHandlers == 0) then
			eventHandlers[event] = nil
			eventFrame:UnregisterEvent(event)
		else
			eventHandlers[event] = newHandlers
		end
	end
end

eventFrame:SetScript("OnEvent", OnEvent)
