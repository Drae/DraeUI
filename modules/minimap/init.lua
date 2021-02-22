--[[


--]]
local DraeUI = select(2, ...)

local MM = DraeUI:NewModule("Minimap", "AceEvent-3.0")

--[[
		Load variables when addon loaded
--]]
MM.OnInitialize = function(self)
	DraeUI.dbGlobal.minimap = DraeUI.dbGlobal.minimap or {}

	self.db = DraeUI.dbGlobal["minimap"]
	self.db.dragPositions = self.db.dragPositions or {}
end
