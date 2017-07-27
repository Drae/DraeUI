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
local min, max, abs, pairs = math.min, math.max, math.abs, pairs
local UnitHealth, UnitHealthMax, UnitPower, UnitPowerMax, UnitPowerType = UnitHealth, UnitHealthMax, UnitPower, UnitPowerMax, UnitPowerType
local UnitIsPlayer, UnitIsConnected, UnitIsAFK, UnitIsDead, UnitIsDeadOrGhost, UnitIsGhost = UnitIsPlayer, UnitIsConnected, UnitIsAFK, UnitIsDead, UnitIsDeadOrGhost, UnitIsGhost
local UnitHasVehicleUI, UnitIsCharmed, UnitClass, UnitName, UnitClass, UnitPlayerControlled = UnitHasVehicleUI, UnitIsCharmed, UnitClass, UnitName, UnitClass, UnitPlayerControlled
local select, format, gsub, gupper = select, string.format, string.gsub, string.upper
local UNKNOWN = UNKNOWN
local GetFramerate = GetFramerate

--[[

--]]
UF.OverridePower = function(self, event, unit)
	local arenaPrep = event == 'ArenaPreparation'

	if(self.unit ~= unit and not arenaPrep) then return end

	local power = self.Power

	if(power.PreUpdate) then power:PreUpdate(unit) end

	local powerType, powerToken, altR, altG, altB = UnitPowerType(unit)
	local info = PowerBarColor[powerToken]

	local displayType, min
	if power.displayAltPower then
		displayType, min = GetDisplayPower(unit)
	end

	local cur, max
	if(arenaPrep) then
		cur, max = 1, 1
	else
		cur, max = UnitPower(unit, displayType), UnitPowerMax(unit, displayType)
	end

	local disconnected = not UnitIsConnected(unit)
	power:SetMinMaxValues(min or 0, max)

	if(disconnected) then
		power:SetValue(max)
	else
		power:SetValue(cur)
	end

	power.disconnected = disconnected

	local r, g, b, t

	if (info and info.atlas) then
		power:SetStatusBarAtlas(info.atlas)
		power:GetStatusBarTexture():SetDesaturated(disconnected)
		power:SetStatusBarColor(1, 1, 1)
	else
		power:SetStatusBarTexture("Interface\\AddOns\\draeUI\\media\\statusbars\\Striped")

		if(power.colorClass and arenaPrep) then
			local _, _, _, _, _, _, class = GetSpecializationInfoByID(GetArenaOpponentSpec(self.id))
			t = self.colors.class[class]
		elseif(power.colorDisconnected and disconnected) then
			t = self.colors.disconnected
		elseif(displayType == ALTERNATE_POWER_INDEX and power.altPowerColor) then
			t = power.altPowerColor
		elseif(power.colorPower) then
			local ptype, ptoken, altR, altG, altB = UnitPowerType(unit)

			t = self.colors.power[ptoken]
			if(not t) then
				if(power.GetAlternativeColor) then
					r, g, b = power:GetAlternativeColor(unit, ptype, ptoken, altR, altG, altB)
				elseif(altR) then
					r, g, b = altR, altG, altB
				else
					t = self.colors.power[ptype]
				end
			end
		elseif(power.colorClass and UnitIsPlayer(unit)) or
			(power.colorClassNPC and not UnitIsPlayer(unit)) or
			(power.colorClassPet and UnitPlayerControlled(unit) and not UnitIsPlayer(unit)) then
			local _, class = UnitClass(unit)
			t = self.colors.class[class]
		elseif(power.colorReaction and UnitReaction(unit, 'player') and (not UnitPlayerControlled(unit) and not UnitIsTapDenied(unit))) then
			t = self.colors.reaction[UnitReaction(unit, "player")]
		elseif(power.colorTapping and not UnitPlayerControlled(unit) and
			UnitIsTapDenied(unit)) then
			t = self.colors.tapped
		elseif(power.colorSmooth) then
			local adjust = 0 - (min or 0)
			r, g, b = self.ColorGradient(cur + adjust, max + adjust, unpack(power.smoothGradient or self.colors.smooth))
		end
	end

	if(t) then
		r, g, b = t[1], t[2], t[3]
	end

	if(b) then
		power:SetStatusBarColor(r, g, b)

		local bg = power.bg
		if(bg) then
			local mu = bg.multiplier or 1
			bg:SetVertexColor(r * mu, g * mu, b * mu)
		end
	end

	if(power.PostUpdate) then
		return power:PostUpdate(unit, cur, max, min)
	end
end

UF.PostUpdateHealth = function(health, u, min, max)
	local self = health:GetParent()

	if (not UnitIsConnected(u)) then
		health.value:SetText("|cffaaaaaaOffline|r")
	--	self.Portrait:SetVertexColor(0.5, 0.5, 0.5, 0.7)
		self.__state = "DISCONNECTED"
	elseif (UnitIsGhost(u)) then
		health.value:SetText("|cffaaaaaaGhost|r")
	--	self.Portrait:SetVertexColor(0.3, 0.3, 0.9, 0.7)
		self.__state = "GHOST"
	elseif (UnitIsDead(u)) then
		health.value:SetText("|cffaaaaaaDead|r")
	--	self.Portrait:SetVertexColor(0.35, 0.35, 0.35, 0.7)
		self.__state = "DEAD"
	elseif (T.db["frames"].numFormatLong) then
		local left, num, right = string.match(min ~= max and (min - max) or min,'^([^%d]*%d)(%d*)(.-)$')

		local hpvalue = ("|cffffffff%s"):format(left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right)
		health.value:SetText(hpvalue)
	else
		local hpvalue = min ~= max and ("|cffB62220%s|r.%d|cff0090ff%%|r"):format(T.ShortVal(min - max), min / max * 100) or ("|cffffffff%s"):format(T.ShortVal(min))
		health.value:SetText(hpvalue)

		if (self.__state) then
	--		self.Portrait:SetVertexColor(1, 1, 1, 1)
			self.__state = nil
		end
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
		text = T.UTF8(realName, 7, false)
	else
		text2.__locked = nil
		text = ""
	end

	text2:SetText(text)
end

do
	local r, g, b
	local diffThreshold = 0.1

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

				self.Border:SetBackdropColor(0, 0, 0, 0.33)
			else
				health:SetStatusBarColor(r, g, b)

				if (oldState == "DISCONNECTED") then
					self.Border:SetBackdropColor(0, 0, 0, 1)
				end

				if (health.bg) then
					local mu = health.bg.multiplier or 1
				end
			end

			self.__stateColor = newState

			UF.UpdateText2(self, newState)
		end

		if (newState ~= "DISCONNECTED") then
			health:SetValue(hcurrent)

			if (text2 and not text2.__locked) then
				if (hcurrent ~= hmax) then
					local pct = hcurrent == 0 and 0 or ((hcurrent / hmax) * 100)
					text2:SetText(("%.1f%%"):format(pct))
				else
					text2:SetText("")
				end
			end
		end
	end
end

--[[
UF.PostUpdateHealPrediction = function(hp, unit, overAbsorb, overHealAbsorb)
	if (overAbsorb) then
		hp.overHealAbsorb:Show()
	else
		hp.overHealAbsorb:Hide()
	end
end
]]

UF.UpdateRaidPower = function(self, event, unit)
	if (unit and self.unit ~= unit and unit ~= self.realUnit) then return end
	unit = unit or self.unit or self.realUnit

	local power = self.Power

	if (not power) then return end

	local role = UnitGroupRolesAssigned(unit)
	local _, ptype = UnitPowerType(unit)
	local min, max = UnitPower(unit), UnitPowerMax(unit)

	local disconnected = not UnitIsConnected(unit)

	if (disconnected) then
		power:Hide()
	else
		if (power.__disconnected ~= disconnected) then
			power:Show()
		end

		if (power.__ptype ~= ptype or power.__prole ~= role) then
			if (ptype ~= "MANA" or (role ~= "HEALER" and role ~= "NONE")) then
				self.Health:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -1, 1)
				self.HealthPrediction.myBar:SetHeight(self.Health:GetHeight())
				self.HealthPrediction.healAbsorbBar:SetHeight(self.Health:GetHeight())
				self.HealthPrediction.otherBar:SetHeight(self.Health:GetHeight())
				self.HealthPrediction.absorbBar:SetHeight(self.Health:GetHeight())

				power:Hide()
			else
				self.Health:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -1, self.powerBarSize + 1)
				self.HealthPrediction.myBar:SetHeight(self.Health:GetHeight() - self.powerBarSize)
				self.HealthPrediction.healAbsorbBar:SetHeight(self.Health:GetHeight() - self.powerBarSize)
				self.HealthPrediction.otherBar:SetHeight(self.Health:GetHeight() - self.powerBarSize)
				self.HealthPrediction.absorbBar:SetHeight(self.Health:GetHeight() - self.powerBarSize)

				power:Show()
			end

			power.__ptype = ptype
			power.__prole = role
		end
	end

	if (ptype == "MANA") then
		power:SetMinMaxValues(0, max)
		power:SetValue(min)
	end

	power.__disconnected = disconnected
end

UF.OverrideGroupRoleIndicator = function(self, event)
	local lfdrole = self.GroupRoleIndicator

	local role = UnitGroupRolesAssigned(self.unit)
	if(role == 'TANK' or role == 'HEALER') then
		lfdrole:SetTexCoord(GetTexCoordsForRoleSmallCircle(role))
		lfdrole:Show()
	else
		lfdrole:Hide()
	end
end
