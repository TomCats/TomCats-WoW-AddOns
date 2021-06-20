--[[ See license.txt for license and copyright information ]]
local _, addon = ...
local bit = bit

local function buildCodeword(consumedBitLength, codeword, tables, codewords)
	local activeBitLength = codeword[2] - consumedBitLength
	if (activeBitLength <= 8) then
		local jcount = bit.lshift(1, (8 - activeBitLength))
		for j = 0, jcount - 1 do
			local index = bit.bor(bit.lshift(j, activeBitLength), bit.arshift(codeword[1], consumedBitLength))
			codewords[index + 1] = codeword
		end
	else
		local index = bit.band(bit.arshift(codeword[1], consumedBitLength), 255) + 1
		local subtable = tables[index]
		if (subtable == nil) then
			subtable = { { }, { } }
			tables[index] = subtable
		end
		buildCodeword(consumedBitLength + 8, codeword, subtable[2], subtable[1])
	end
end

local decoderCache
local cacheEnabled = false
do
	if (addon.newCache) then
		decoderCache = addon.newCache(120,30)
		cacheEnabled = true
	else
		decoderCache = {
			get = function() end,
			add = function() end
		}
	end
end

local function buildDecoder(encodingF)
	local decoder = decoderCache.get(encodingF)
	if (decoder) then
		return decoder[1], decoder[2]
	end
	local encoding = loadstring(encodingF)()
	local decoding = { }
	for i = 0, 4 do
		local decodeTable = { { }, { } }
		for _, codeword in ipairs(encoding[i+1]) do
			buildCodeword(0, codeword, decodeTable[2], decodeTable[1])
		end
		decoding[i+1] = decodeTable
	end
	decoderCache.add(encodingF, { encoding[1], decoding })
	return encoding[1], decoding
end

local function decode(codewords, tables, value)
	local index = bit.band(value, 255)
	local codeword = codewords[index + 1]
	if (codeword ~= nil) then
		return codeword
	else
		return decode(tables[index + 1][1], tables[index + 1][2], bit.arshift(value,8))
	end
end

local function nextSymbol(decoderStream, encoding, decoding)
	local decodeTable = decoding[decoderStream.state + 1]
	while (decoderStream.availableBits < 32) do
		local newBit = 0
		if (decoderStream.count == 0) then
			if (decoderStream.pos == #decoderStream.compressed) then
				decoderStream.buffer = -1
			else
				decoderStream.buffer = bit.band(
						string.byte(string.sub(decoderStream.compressed, decoderStream.pos + 1, decoderStream.pos + 1)), 255)
				decoderStream.pos = decoderStream.pos + 1
			end
			if (decoderStream.buffer == -1) then
				newBit = -1
			else
				decoderStream.count = 8
			end
		end
		if (newBit == 0) then
			local b = bit.band(decoderStream.buffer, 1)
			decoderStream.buffer = bit.arshift(decoderStream.buffer, 1)
			decoderStream.count = decoderStream.count - 1
			newBit = b
		end
		if (newBit == -1) then
			break
		end
		if (newBit == 1) then
			decoderStream.bitBuf = bit.bor(decoderStream.bitBuf,bit.lshift(1, decoderStream.availableBits))
		end
		decoderStream.availableBits = decoderStream.availableBits +1
	end
	local decoded = decode(
			decodeTable[1],
			decodeTable[2],
			decoderStream.bitBuf
	)
	if (decoderStream.state == 4) then
		decoderStream.state = 0
	else
		if (decoderStream.state ~= 0 or decoded[3] > 255) then
			decoderStream.state = decoderStream.state + 1
		end
	end
	local codeword = encoding[#encoding]
	if (decoderStream.state == 1 and codeword[1] == decoded[1] and codeword[2] == decoded[2] and codeword[3] == decoded[3]) then
		return -1
	end
	decoderStream.bitBuf = bit.rshift(decoderStream.bitBuf, decoded[2])
	decoderStream.availableBits = decoderStream.availableBits - decoded[2]
	return decoded[3]
end

addon.compression = {
	decompress = function(data, dictionary, encodingF)
		local encoding, decoding = buildDecoder(encodingF)
		local decoderStream = {
			bitBuf        = 0,
			availableBits = 0,
			buffer        = 0,
			count         = 0,
			state         = 0,
			pos           = 0,
			compressed    = data
		}
		local bytesOut = { }
		local symbol = nextSymbol(decoderStream, encoding, decoding)
		while (symbol ~= -1) do
			if (symbol > 255) then
				local length = symbol - 256
				local offset = bit.bor(bit.bor(nextSymbol(decoderStream, encoding, decoding),
						bit.lshift(nextSymbol(decoderStream, encoding, decoding), 4)),
						bit.bor(bit.lshift(nextSymbol(decoderStream, encoding, decoding), 8),
								bit.lshift(nextSymbol(decoderStream, encoding, decoding), 12)))
				offset = 0 - offset
				local currentIndex = #bytesOut
				if (currentIndex + offset < 1) then
					local startDict = currentIndex + offset + #dictionary
					local endDict = startDict + length
					for i = startDict + 1, endDict do
						table.insert(bytesOut, string.sub(dictionary, i, i))
					end
				else
					local i = currentIndex + offset
					local count = currentIndex + offset + length
					while (i < count) do
						local b = bytesOut[i + 1]
						table.insert(bytesOut, b)
						i = i + 1
					end
				end
			else
				table.insert(bytesOut, string.char(symbol))
			end
			symbol = nextSymbol(decoderStream, encoding, decoding)
		end
		return table.concat(bytesOut)
	end
}
