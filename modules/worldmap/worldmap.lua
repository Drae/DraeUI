--[[


--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

local M = T:GetModule("Worldmap")

--[[
--]]
local coordsTimer

--[[

--]]
function M:UpdateCoords()
	if(not WorldMapFrame:IsShown()) then return end

	local inInstance, _ = IsInInstance()
	local x, y = GetPlayerMapPosition("player")

	x = T.Round(100 * x, 2)
	y = T.Round(100 * y, 2)

	if x ~= 0 and y ~= 0 then
		CoordsHolder.playerCoords:SetText(PLAYER..":   "..x..", "..y)
	else
		CoordsHolder.playerCoords:SetText("")
	end

	local scale = WorldMapDetailFrame:GetEffectiveScale()
	local width = WorldMapDetailFrame:GetWidth()
	local height = WorldMapDetailFrame:GetHeight()
	local centerX, centerY = WorldMapDetailFrame:GetCenter()
	local x, y = GetCursorPosition()
	local adjustedX = (x / scale - (centerX - (width/2))) / width
	local adjustedY = (centerY + (height/2) - y / scale) / height

	if (adjustedX >= 0  and adjustedY >= 0 and adjustedX <= 1 and adjustedY <= 1) then
		adjustedX = T.Round(100 * adjustedX, 2)
		adjustedY = T.Round(100 * adjustedY, 2)
		CoordsHolder.mouseCoords:SetText(MOUSE_LABEL..":   "..adjustedX..", "..adjustedY)
	else
		CoordsHolder.mouseCoords:SetText("")
	end
end

function M:WorldMapFrame_OnShow()
	if (not coordsTimer) then
		coordsTimer = self:ScheduleRepeatingTimer('UpdateCoords', 0.05)
	end
end


function M:WorldMapFrame_OnHide()
	self:CancelTimer(coordsTimer)
	coordsTimer = nil
end
