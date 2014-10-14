--[[


--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

local BB = T:NewModule("Buffbar")

--[[
		Load variables when addon loaded
--]]
BB.OnInitialize = function(self)
	self.db = T.db["buffbar"]
end
