--[[


--]]
local _, ns = ...
local oUF = ns.oUF or oUF

local T, C, G, P, U, _ = select(2, ...):UnPack()
local UF = T:GetModule("UnitFrames")

-- Localise a bunch of functions
local _G = _G
local format, unpack = string.format, unpack
local CreateFrame, GetSpecialization = CreateFrame, GetSpecialization

--[[
		Mage
		Hijack Blizzards bar
--]]
do
	local mageStatusColour = {
		[1] = { 0.32, 1.00, 0.00 },
		[2] = { 1.00, 0.99, 0.00 },
		[3] = { 1.00, 0.73, 0.00 },
		[4] = { 1.00, 0.32, 0.00 },
		[5] = { 1.00, 0.00, 0.00 },
	}

	local UpdateMageManaColor = function(pp, unit, curMana, maxMana)
		local pct = curMana / maxMana

		local r, g, b, t

		if (pct >= 0.95) then
			t = mageStatusColour[1]
		elseif (pct >= 0.9) then
			t = mageStatusColour[2]
		elseif (pct >= 0.85) then
			t = mageStatusColour[3]
		elseif (pct >= 0.8) then
			t = mageStatusColour[4]
		else
			t = mageStatusColour[5]
		end

		r, g, b = unpack(t)

		pp:SetStatusBarColor(r, g, b)
	end

	local PlayerSpecChanged = function(self)
		local spec = GetSpecialization()

		if (spec == SPEC_MAGE_ARCANE) then
			self.resourceBar:Show()
			self.Power.PostUpdate = UpdateMageManaColor

			if (not self.Power.evoPos) then
				local maxMana = UnitPowerMax("player")
				local width = self.Health:GetWidth()

				local evoPos = width - (width * ((maxMana * 0.4) / maxMana))

				self.Power.evoUse = self.Power:CreateTexture(nil, "OVERLAY")
				self.Power.evoUse:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
				self.Power.evoUse:SetVertexColor(1.0, 1.0, 1.0)
				self.Power.evoUse:Width(1)
				self.Power.evoUse:Height(self.Power:GetHeight())
				self.Power.evoUse:ClearAllPoints()
				self.Power.evoUse:Point("BOTTOMRIGHT", self.Power, "BOTTOMRIGHT", -evoPos, 0)
				self.Power.evoUse:Show()
			end
		else
			self.Power.PostUpdate = nil
			self.resourceBar:Hide()
			if (self.Power.evoPos) then
				self.Power.evoUse:Hide()
			end
		end
	end

	UF.CreateMageClassBar = function(self, point, anchor, relpoint, xOffset, yOffset)
		local spec = GetSpecialization()

		if (T.playerClass ~= "MAGE" or (T.playerClass == "MAGE" and spec ~= SPEC_MAGE_ARCANE)) then return end

		local rs = CreateFrame("Frame", nil, self)
		rs:SetFrameLevel(12)
		rs:Point(point, anchor, relpoint, xOffset + 5, yOffset + 8)
		rs:Size(210, 20)
		rs:SetFrameLevel(12)
		rs.unit = "player"

		_G["MageArcaneChargesFrame"]:SetParent(rs)
		_G["MageArcaneChargesFrame"]:EnableMouse(false)
		_G["MageArcaneChargesFrame"]:ClearAllPoints()
		_G["MageArcaneChargesFrame"]:Point(point, anchor, relpoint, xOffset + 5, yOffset + 8)
		_G["MageArcaneChargesFrame"]:SetScale(0.8)

		_G["MageArcaneChargesFrame"].Background:Hide()

		self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", PlayerSpecChanged, true)
		self:RegisterEvent("PLAYER_ENTERING_WORLD", PlayerSpecChanged, true)

		self.resourceBar = rs
	end
end
