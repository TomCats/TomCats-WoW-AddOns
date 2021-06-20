--[[ See license.txt for license and copyright information ]]
--[[ See readme.txt for information on how to use this file ]]
bit = require("bit")
local addonName, addon = "TomCats", { }

function readAll(file)
	local f = assert(io.open(file, "rb"))
	local content = f:read("*all")
	f:close()
	return content
end
loadstring(readAll("compression.lua"))(addonName, addon)
loadstring(readAll("db_vignette_info.lua"))(addonName, addon)
for k, v in pairs(addon.vignette_info.data) do
	local val = addon.compression.decompress(v, addon.vignette_info.dictionary, addon.vignette_info.encodingF)
	print("Contents of addon.vignette_info.data[" .. k .. "]:")
	print(val)
	print("========================================================================================================================")
end
loadstring(readAll("db_vignette_names.lua"))(addonName, addon)
for lang, vignette_names in pairs(addon.vignette_names) do
	for k, v in pairs(vignette_names.data) do
		local val = addon.compression.decompress(v, vignette_names.dictionary, vignette_names.encodingF)
		print("Contents of vignette_names." .. lang .. "[" .. k .. "]:")
		print(val)
		print("========================================================================================================================")
	end
end
