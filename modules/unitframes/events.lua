--[[
		Common event handling, specific events are handled
		in their local functions
--]]
local _, ns = ...
local oUF = ns.oUF or oUF

--
local T, C, G, P, U, _ = select(2, ...):UnPack()
local UF = T:GetModule("UnitFrames")

-- Localise a bunch of functions
local _G = _G
local UnitHealth, UnitHealthMax, UnitPower, UnitPowerMax, UnitPowerType = UnitHealth, UnitHealthMax, UnitPower, UnitPowerMax, UnitPowerType
local UnitIsPlayer, UnitIsConnected, UnitIsAFK, UnitIsDead, UnitIsDeadOrGhost, UnitIsGhost = UnitIsPlayer, UnitIsConnected, UnitIsAFK, UnitIsDead, UnitIsDeadOrGhost, UnitIsGhost
local UnitHasVehicleUI, UnitIsCharmed, UnitClass, UnitName, UnitClass, UnitPlayerControlled = UnitHasVehicleUI, UnitIsCharmed, UnitClass, UnitName, UnitClass, UnitPlayerControlled
local select, format, gsub, gupper = select, string.format, string.gsub, string.upper
local UNKNOWN = UNKNOWN

--[[

--]]
-- This is the unitframe health
UF.PostUpdateHealth = function(health, u, min, max)
	local self = health:GetParent()

	if (not UnitIsConnected(u)) then
		health.value:SetText("|cffaaaaaaOffline|r")
	elseif (UnitIsGhost(u)) then
		health.value:SetText("|cffaaaaaaGhost|r")
	elseif (UnitIsDead(u)) then
		health.value:SetText("|cffaaaaaaDead|r")
	else
		local hpvalue = min ~= max and ("|cffB62220%s|r.%d|cff0090ff%%|r"):format(T.ShortVal(min - max), min / max * 100) or ("|cffffffff%s"):format(T.ShortVal(min))
		health.value:SetText(hpvalue)
	end
end

UF.UpdateText2 = function(self, state)
	local health = self.Health
	local text2 = self.Text2

	if (not text2) then return end

	local status = state == "DISCONNECTED" and "Offline"
		or state == "CHARMED" and "Charm"
		or state == "FEIGN" and "Feign"
		or state == "GHOST" and "Ghost"
		or state == "DEAD" and "Dead"
		or state == "AFK" and "AFK"
		or nil

	local text
	if (status) then
		text2.__locked = true
		text = "|cffaaaaaa"..status.."|r"
	elseif (self.realUnit and UnitHasVehicleUI(self.realUnit)) then
		text2.__locked = true
		local realName = UnitName(SecureButton_GetUnit(self) or self.unit) or "Unknown"
		text = T.UTF8(realName, 6, false)
	elseif (health.__min ~= health.__max) then
		if (T.db["raidframes"].showRaidHealthPct) then
			local pct = max == 0 and 0 or ((max - min) / max) * 100
			text = ("%.1f"):format(pct)
		else
			text = T.ShortVal(health.__min - health.__max)
		end

		text2.__locked = nil
	else
		text2.__locked = nil
		text = ""
	end

	text2:SetText(text)

	return status
end

do
	local r, g, b

	local GetFrameUnitState = function(self)
		local unit = self.realUnit or self.unit

		if (UnitIsPlayer(unit)) then
			if (not UnitIsConnected(unit)) then
				return "DISCONNECTED"
			elseif (UnitIsAFK(unit)) then
				return "AFK"
			elseif (UnitIsDead(unit)) then
				return "DEAD"
			elseif (UnitIsGhost(unit)) then
				return "GHOST"
			elseif (UnitHasVehicleUI(unit)) then
				return "INVEHICLE"
			elseif (UnitIsCharmed(unit)) then
				return "CHARMED"
			end
		else
			return UnitIsDeadOrGhost(unit) and "DEAD" or nil
		end
	end

	UF.UpdateRaidHealth = function(self, event, unit)
		if (unit and unit ~= self.unit and unit ~= self.realUnit) then return end
		unit = unit or self.unit or self.realUnit

		local health = self.Health
		local text1	= self.Text1
		local text2	= self.Text2 or nil

		local refUnit = (self.realUnit or unit):gsub("pet", "")

		-- "pet"
		if (refUnit == "") then
			refUnit = "player"
		end

		local class = UnitName(refUnit) ~= UNKNOWN and select(2, UnitClass(refUnit))

		local hcurrent, hmax = UnitHealth(unit), UnitHealthMax(unit)
		health:SetMinMaxValues(0, hmax)

		local newState = GetFrameUnitState(self) or class or ""
		local oldState = self.__stateColor

		if (newState ~= oldState) then
			local t

			if (newState == "DISCONNECTED") then
				t = oUF.colors.disconnected
			elseif (newState == "CHARMED") then
				t = oUF.colors.charmed
			elseif (newState == "INVEHICLE") then
				t = oUF.colors.health
			elseif (UnitIsPlayer(unit) or (health.colorClassPet and UnitPlayerControlled(unit) and not UnitIsPlayer(unit))) then
				t = oUF.colors.class[class]
			else
				t = oUF.colors.health
			end

			if (t) then
				r, g, b = t[1], t[2], t[3]
			else
				r, g, b = 0.5, 0.5, 0.5
			end

			-- Colour both hp and info text as hp bar colour
			if (text1) then
				text1:SetTextColor(r, g, b)
			end

			if (text2) then
				text2:SetTextColor(r, g, b)
			end

			if (newState == "DISCONNECTED") then
				health:SetValue(0)
				health.bg:Hide()

				self.Backdrop:SetBackdropColor(0, 0, 0, 0.33)
			else
				health:SetStatusBarColor(r, g, b)

				if (oldState == "DISCONNECTED") then
					self.Backdrop:SetBackdropColor(0, 0, 0, 1)
					health.bg:Show()
				end

				if (health.bg) then
					local mu = health.bg.multiplier or 1
					health.bg:SetVertexColor(r * mu, g * mu, b * mu)
				end
			end

			self.__stateColor = newState

			UF.UpdateText2(self, newState)
		end

		if (newState ~= "DISCONNECTED") then
			health:SetValue(hcurrent)

			if (text2 and not text2.__locked) then
				if (hcurrent ~= hmax) then
					if (T.db["raidframes"].showHealthPct) then
						local pct = hmax == 0 and 0 or ((hmax - hcurrent) / hmax) * 100

						text2:SetText(("%.1f%%"):format(pct))
					else
						text2:SetText(T.ShortVal(hcurrent - hmax))
					end
				else
					text2:SetText("")
				end
			end
		end
	end
end

UF.PostUpdateHealPrediction = function(hp, unit, overAbsorb, overHealAbsorb)
	if (overAbsorb) then
		hp.overHealAbsorb:Show()
	else
		hp.overHealAbsorb:Hide()
	end
end

UF.UpdateRaidPower = function(self, event, unit)
	if (unit and self.unit ~= unit and unit ~= self.realUnit) then return end
	unit = unit or self.unit or self.realUnit

	local power = self.Power

	if (not power) then return end

	local _, ptype = UnitPowerType(unit)
	local min, max = UnitPower(unit), UnitPowerMax(unit)

	local disconnected = not UnitIsConnected(unit)

	if (disconnected) then
		power:Hide()
	else
		if (power.__disconnected ~= disconnected) then
			power:Show()
		end

		if (power.__ptype ~= ptype) then
			if (ptype ~= "MANA") then
				self.Health:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -1, 1)
				power:Hide()
			else
				local powerBarSize = 4 + 1 -- height of the powerbars + 1

				self.Health:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -1, 5)
				power:Show()
			end

			power.__ptype = ptype
		end
	end

	if (ptype == "MANA") then
		power:SetMinMaxValues(0, max)
		power:SetValue(min)
	end

	power.__disconnected = disconnected
end
