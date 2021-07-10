--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local proxies = { }

function AddProxy(target, mixin, initFunction, ...)
	assert(mixin)
	if (target) then
		local proxy = proxies[target]
		if (not proxy) then
			proxy = CreateFromMixins(mixin)
			proxy.target = target
			proxies[target] = proxy
			if (initFunction) then
				if (type(initFunction) == "function") then
					initFunction(proxy, ...)
				elseif (type(initFunction) == "string") then
					proxy[initFunction](proxy, ...)
				end
			end
		end
		return proxy
	end
end

function CreateProxyMixinFunctions(mixin, proxyFunctionNames, passthruFunctionNames)
	if (proxyFunctionNames) then
		for _, functionName in ipairs(proxyFunctionNames) do
			mixin[functionName] = function(self, ...)
				return self.target[functionName](self, ...)
			end
		end
	end
	if (passthruFunctionNames) then
		for _, functionName in ipairs(passthruFunctionNames) do
			mixin[functionName] = function(self, ...)
				return self.target[functionName](self.target, ...)
			end
		end
	end
end

function GetProxy(target)
	assert(target)
	return proxies[target]
end
