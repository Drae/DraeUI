--[[


--]]
local T, C, G, P, U, _ = select(2, ...):unpack()

local BB = T:NewModule("Buffbar")

--[[
		Load variables when addon loaded
--]]
BB.OnInitialize = function(self)
	self.db = T.db["buffbar"]
end
