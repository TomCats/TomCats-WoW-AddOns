--[[ See license.txt for license and copyright information ]]
local _, addon = ...

local Bit32S = addon.bit32

local Base64 = { }

do
	local concat = table.concat;
	local b = string.byte;
	local tblinsert = table.insert
	local strchar = string.char
	local arshift = Bit32S.arshift
	local band = Bit32S.band
	local bor = Bit32S.bor
	local lshift = Bit32S.lshift
	local rshift = Bit32S.rshift
	local floor = math.floor

	local function length(str)
		return #str;
	end

	local base64LU = {
		65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81,
		82, 83, 84, 85, 86, 87, 88, 89, 90, 97, 98, 99, 100, 101, 102, 103,
		104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116,
		117, 118, 119, 120, 121, 122, 48, 49, 50, 51, 52, 53, 54, 55, 56,
		57, 43, 47
	};

	local function toBase64(idx)
		return base64LU[idx + 1];
	end

	local base64RLU = {
		-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
		-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
		-1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63, 52, 53, 54, 55, 56, 57,
		58, 59, 60, 61, -1, -1, -1, -2, -1, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8,
		9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1,
		-1, -1, -1, -1, -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38,
		39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, -1,
		-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
		-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
		-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
		-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
		-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
		-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
		-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
		-1, -1
	};

	local function fromBase64(idx)
		return base64RLU[idx + 1];
	end

	local function append(tbl, val)
		tblinsert(tbl, strchar(val));
	end

	function Base64.encode(src)
		local dst = { };
		local n1 = 0;
		local n2 = length(src) - length(src) % 3;
		local n3 = 0;
		while (n1 < n2) do
			local n4 = n1;
			while (n4 < n2) do
				local bits = bor(bor(lshift(b(src, n4 + 1), 16), lshift(b(src, n4 + 2), 8)),
						b(src, n4 + 3));
				n4 = n4 + 3;
				append(dst, toBase64(band(rshift(bits, 18), 63)));
				append(dst, toBase64(band(rshift(bits, 12), 63)));
				append(dst, toBase64(band(rshift(bits, 6), 63)));
				append(dst, toBase64(band(bits, 63)));
			end
			local n5 = floor((n2 - n1) / 3) * 4;
			n3 = n3 + n5;
			n1 = n2;
		end
		if (n1 < length(src)) then
			local n4 = b(src, n1 + 1);
			n1 = n1 + 1;
			append(dst, toBase64(arshift(n4, 2)));
			if (n1 == length(src)) then
				append(dst, toBase64(band(lshift(n4, 4), 63)));
				append(dst, 61);
			else
				local n5 = b(src, n1 + 1);
				append(dst, toBase64(bor(band(lshift(n4, 4), 63), arshift(n5, 4))));
				append(dst, toBase64(band(lshift(n5, 2), 63)));
			end
			append(dst, 61);
		end
		return concat(dst);
	end

	function Base64.decode(src)
		local dst = { };
		pcall(function()
			local n1 = 0;
			local n2 = 0;
			local n3 = 18;
			while (n1 < length(src)) do
				if ((n3 == 18) and (n1 + 4 < length(src))) then
					local n4 = n1 + band((length(src) - n1), 12);
					while (n1 < n4) do
						local b1 = fromBase64(b(src, n1 + 1));
						local b2 = fromBase64(b(src, n1 + 2));
						local b3 = fromBase64(b(src, n1 + 3));
						local b4 = fromBase64(b(src, n1 + 4));
						if ((b1 < 0) or (b2 < 0) or (b3 < 0) or (b4 < 0)) then
							break ;
						end
						n1 = n1 + 4;
						local n5 = bor(bor(lshift(b1, 18), lshift(b2, 12)),
								bor(lshift(b3, 6), b4));
						append(dst, band(arshift(n5, 16), 255));
						append(dst, band(arshift(n5, 8), 255));
						append(dst, band(n5, 255));
					end
					if (n1 >= length(src)) then
						break ;
					end
				end
				n1 = n1 + 1;
				local n4 = b(src, n1);
				if (n4 == 61) then
					break ;
				end
				n4 = fromBase64(n4);
				n2 = bor(n2, lshift(n4, n3));
				n3 = n3 - 6;
				if (n3 < 0) then
					append(dst, band(arshift(n2, 16), 255));
					append(dst, band(arshift(n2, 8), 255));
					append(dst, band(n2, 255));
					n3 = 18;
					n2 = 0;
				end
			end
			if (n3 == 6) then
				append(dst, band(arshift(n2, 16), 255));
			elseif (n3 == 0) then
				append(dst, band(arshift(n2, 16), 255));
				append(dst, band(arshift(n2, 8), 255));
			end
		end)
		return concat(dst);
	end

end

addon.base64 = Base64
