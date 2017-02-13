--[[


--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

local M = T:NewModule("Worldmap", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")

--[[

--]]
M.OnInitialize = function(self)
	-- Foglight init
	M.FogLightSetMode(T.db["worldMap"].fogLightMode)
end

M.OnEnable = function(self)
	local CoordsHolder = CreateFrame('Frame', 'CoordsHolder', WorldMapFrame)
	CoordsHolder:SetFrameLevel(WorldMapDetailFrame:GetFrameLevel() + 1)
	CoordsHolder:SetFrameStrata(WorldMapDetailFrame:GetFrameStrata())

	CoordsHolder.playerCoords = CoordsHolder:CreateFontString(nil, 'OVERLAY')
	CoordsHolder.playerCoords:SetFontObject(NumberFontNormal)
	CoordsHolder.playerCoords:SetTextColor(1, 1 ,0)
	CoordsHolder.playerCoords:SetPoint("BOTTOMLEFT", WorldMapDetailFrame, "BOTTOMLEFT", 8, 8)
	CoordsHolder.playerCoords:SetText(PLAYER..":   0, 0")

	CoordsHolder.mouseCoords = CoordsHolder:CreateFontString(nil, 'OVERLAY')
	CoordsHolder.mouseCoords:SetFontObject(NumberFontNormal)
	CoordsHolder.mouseCoords:SetTextColor(1, 1 ,0)
	CoordsHolder.mouseCoords:SetPoint("BOTTOMLEFT", CoordsHolder.playerCoords, "BOTTOMRIGHT", 20, 0)
	CoordsHolder.mouseCoords:SetText(MOUSE_LABEL..":   0, 0")

	M:RegisterEvent("ZONE_CHANGED_NEW_AREA", "EnableCoords")

	M:EnableCoords()
end
