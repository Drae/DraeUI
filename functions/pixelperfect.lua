--[[
		From ElvUI
--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

-- Setup the pixel perfect script.
local scale
local match = string.match
local abs, floor, min, max = math.abs, math.floor, math.min, math.max

T.UIScale = function(self, event)
	if (IsMacClient() and self.global.screenHeight and self.global.screenWidth and (self.screenHeight ~= self.global.screenHeight or self.screenWidth ~= self.global.screenWidth)) then
		self.screenHeight = self.global.screenHeight
		self.screenWidth = self.global.screenWidth
	end

	scale = max(0.64, min(1.15, 768 / self.screenHeight))

	if (self.screenWidth < 1600) then
		self.lowversion = true
	end

	self.mult = 768 / GetScreenHeight() / scale

	--Set UIScale, NOTE: SetCVar for UIScale can cause taints so only do this when we need to..
	if (T.Round and T.Round(UIParent:GetScale(), 5) ~= T.Round(scale, 5) and (event == "PLAYER_LOGIN")) then
		SetCVar("useUiScale", 1)
		SetCVar("uiScale", scale)

		WorldMapFrame.hasTaint = true
	end

	if (event == "PLAYER_LOGIN" or event == "UI_SCALE_CHANGED") then
		if (IsMacClient()) then
			T.dbGlobal.screenHeight = floor(GetScreenHeight()*100+.5)/100
			T.dbGlobal.screenWidth = floor(GetScreenWidth()*100+.5)/100
		end

		self.UIParent:SetSize(UIParent:GetSize())

		self.UIParent:ClearAllPoints()
		self.UIParent:SetPoint("CENTER")

		local change
		if (T.Round) then
			change = abs((T.Round(UIParent:GetScale(), 5) * 100) - (T.Round(scale, 5) * 100))
		end

		self:UnregisterEvent("PLAYER_LOGIN")
	end
end

-- pixel perfect script of custom ui scale.
T.Scale = function(self, x)
    return self.mult * floor(x / self.mult + .5)
end
