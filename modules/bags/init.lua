--[[


--]]
local T, C, G, P, U, _ = select(2, ...):unpack()

local B = T:NewModule("Bags", "AceEvent-3.0", "AceHook-3.0")

--[[

--]]
B.OnEnable = function(self)
	if (C["bags"].enable) then
		self.Bags:Enable()
	end

	-- Bag Filter
	if C["bags"].filter then
		self.BagFilter:Enable()
	end
end
