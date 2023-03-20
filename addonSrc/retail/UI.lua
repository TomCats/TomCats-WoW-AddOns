--[[ See license.txt for license and copyright information ]]
select(2, ...).SetScope()

UI = { }

local reserved = {
	AddChild = true,
	IsDirty = true,
	MarkClean = true,
	MarkDirty = true,
	RefreshFunc = true,
	UpdateFunc = true,
	children = true,
	idx = true,
}

local delegates = {
	Refresh = true,
	Update = true,
}

local UIMetaTable

UIMetaTable = {
	__index = {
		AddChild = function(self, child, name)
			setmetatable(child, UIMetaTable)
			child.parent = self
			table.insert(self.children, child)
			rawset(child, "idx", #self.children)
			if (name) then
				self[name] = child
			end
			return child
		end,
		AfterRefresh = nop,
		AfterUpdate = nop,
		GetHeight = function()
			return 0
		end,
		GetSize = function()
			return 0, 0
		end,
		GetWidth = function()
			return 0
		end,
		IsDirty = function(self)
			return self.isDirty or false
		end,
		MarkClean = function(self)
			self.isDirty = false
		end,
		MarkDirty = function(self)
			self.isDirty = true
			for _, child in ipairs(self.children) do
				child:MarkDirty()
			end
		end,
		New = nop,
		Refresh = function(self)
			self:RefreshFunc()
			for _, child in ipairs(self.children) do
				child:Refresh()
			end
			self:AfterRefresh()
		end,
		RefreshFunc = nop,
		Update = function(self, elapsed)
			local updateChildren = self:UpdateFunc(elapsed)
			if (updateChildren ~= false) then
				for _, child in ipairs(self.children) do
					child:Update(elapsed)
				end
			end
			self:AfterUpdate()
		end,
		UpdateFunc = nop
	},
	__newindex = function(tbl, key, val)
		if (delegates[key]) then
			rawset(tbl, key .. "Func", val)
		elseif (reserved[key]) then
			return
		else
			rawset(tbl, key, val)
		end
	end
}

function UI.New(prototype, ...)
	local o = CreateFromMixins(prototype)
	for reserve in pairs(reserved) do
		if (o[reserve]) then
			error("Cannot use reserved field")
		end
	end
	for delegate in pairs(delegates) do
		if (o[delegate]) then
			o[delegate .. "Func"] = o[delegate]
			o[delegate] = nil
		end
	end
	setmetatable(o, UIMetaTable)
	rawset(o, "children", { })
	o:New(...)
	return o
end
