--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope()

Image = { }

setmetatable(Image, {
	__index = function(tbl, key)
		local val = rawget(tbl, key)
		return val == nil and string.format("Interface\\AddOns\\%s\\images\\%s", addonName, key) or val
	end
})

ImagePNG = { }

setmetatable(ImagePNG, {
	__index = function(tbl, key)
		local val = rawget(tbl, key)
		return val == nil and string.format("Interface\\AddOns\\%s\\images\\%s.png", addonName, key) or val
	end
})
