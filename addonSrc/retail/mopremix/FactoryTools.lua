--[[
FactoryTools.lua
Copyright (C) 2018-2023 TomCat's Tours
All rights reserved.

For more information, contact via email at tomcat@tomcatstours.com
(or visit https://www.tomcatstours.com)
]]
select(2, ...).SetScope("mopremix")

function CreateFactory(createFunc, mixin)
	local array = { }
	local lookup = mixin and Mixin({ }, mixin) or { }
	local function GetIndex(self)
		return lookup[self]
	end
	local function GetNext(self, create)
		local idx = lookup[self]
		if (idx and (create or self:HasNext())) then
			return array[idx + 1]
		end
	end
	local function GetPrevious(self)
		local idx = lookup[self]
		if (idx and idx > 1) then
			return array[idx - 1]
		end
	end
	local function HasNext(self)
		local idx = lookup[self]
		return (idx and #array > idx) or false
	end
	local function HasPrevious(self)
		local idx = lookup[self]
		return (idx and idx > 1) or false
	end
	setmetatable(array, {
		__index = function(t, k)
			if (type(k) == "number") then
				if (k > 0) then
					if (k > #array) then
						local e
						for i = #array + 1, k do
							local callback
							e, callback = createFunc()
							e.GetIndex = GetIndex
							e.GetNext = GetNext
							e.GetPrevious = GetPrevious
							e.HasNext = HasNext
							e.HasPrevious = HasPrevious
							rawset(t, i, e)
							lookup[e] = i
							if (callback) then
								callback(e)
							end
						end
						return e
					end
					return rawget(t, k)
				end
			else
				return lookup[k]
			end
		end,
		__newindex = nop,
	})
	return array
end
