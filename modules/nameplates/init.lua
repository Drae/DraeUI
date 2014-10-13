--[[


--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

-- Saved Variables
local PL = T:NewModule("Nameplates", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")


--[[
		Load variables when addon loaded
--]]
PL.OnInitialize = function(self)
	self.db = T.db["nameplates"]

	self.numFrames = 0
	self.frameList = {}

end
