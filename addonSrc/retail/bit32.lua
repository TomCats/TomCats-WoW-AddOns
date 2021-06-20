--[[ See license.txt for license and copyright information ]]
local _, addon = ...

local bit = bit

local Bit32S = { }

do
	local arshift = bit.arshift
	local band = bit.band
	local bnot = bit.bnot
	local bor = bit.bor
	local bxor = bit.bxor
	local lshift = bit.lshift
	local rshift = bit.rshift
	local s32

	function Bit32S.bor(val1, val2)
		return s32(bor(val1, val2))
	end

	function Bit32S.rshift(val, bits)
		return s32(rshift(val, bits))
	end

	function Bit32S.arshift(val, bits)
		return s32(arshift(val, bits))
	end

	function Bit32S.lshift(val, bits)
		return s32(lshift(val, bits))
	end

	function Bit32S.band(val1, val2)
		return s32(band(val1, val2))
	end

	function Bit32S.bnot(val1)
		return s32(bnot(val1))
	end

	function Bit32S.bxor(val1, val2)
		return s32(bxor(val1, val2))
	end

	function Bit32S.s32(val)
		if val > 2147483647 then
			return val - 4294967296
		end
		if val < -2147483648 then
			return val + 4294967296
		end
		return val
	end

	s32 = Bit32S.s32
end

addon.bit32 = Bit32S

