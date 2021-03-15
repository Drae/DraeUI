--[[
		Common event handling, specific events are handled
		in their local functions
--]]
local DraeUI = select(2, ...)
local oUF = DraeUI.oUF or oUF

local UF = DraeUI:GetModule("UnitFrames")

-- Localise a bunch of functions
local select, min, max = select, math.min, math.max
local UnitHealth, UnitHealthMax, UnitPower, UnitPowerMax, UnitPowerType = UnitHealth, UnitHealthMax, UnitPower, UnitPowerMax, UnitPowerType
local UnitIsPlayer, UnitIsConnected, UnitIsAFK, UnitIsDead, UnitIsDeadOrGhost, UnitIsGhost = UnitIsPlayer, UnitIsConnected, UnitIsAFK, UnitIsDead, UnitIsDeadOrGhost, UnitIsGhost
local UnitHasVehicleUI, UnitIsCharmed, UnitClass, UnitName, UnitPlayerControlled = UnitHasVehicleUI, UnitIsCharmed, UnitClass, UnitName, UnitPlayerControlled
local GetDisplayPower, UnitGroupRolesAssigned, UnitIsTapDenied, UnitReaction = GetDisplayPower, UnitGroupRolesAssigned, UnitIsTapDenied, UnitReaction
local PowerBarColor = PowerBarColor
local ALTERNATE_POWER_INDEX, UNKNOWN = ALTERNATE_POWER_INDEX, UNKNOWN

--[[

	Non-raid frame events

--]]
UF.OverridePower = function(self, event, unit)
	local arenaPrep = event == 'ArenaPreparation'
	if (self.unit ~= unit and not arenaPrep) then return end

	local power = self.Power

	if (power.PreUpdate) then power:PreUpdate(unit) end

	local _, powerToken, altR, altG, altB = UnitPowerType(unit)
	local info = PowerBarColor[powerToken]

	local displayType, pmin
	if (power.displayAltPower) then
		displayType, pmin = GetDisplayPower(unit)
	end

	local pcur, pmax
	if (arenaPrep) then
		pcur, pmax = 1, 1
	else
		pcur, pmax = UnitPower(unit, displayType), UnitPowerMax(unit, displayType)
	end

	local disconnected = not UnitIsConnected(unit)
	power:SetMinMaxValues(pmin or 0, pmax)

	if (disconnected) then
		power:SetValue(pmax)
	else
		power:SetValue(pcur)
	end

	power.disconnected = disconnected

	local r, g, b, t

	if (info and info.atlas) then
		power:SetStatusBarAtlas(info.atlas)
		power:GetStatusBarTexture():SetDesaturated(disconnected)
		power:SetStatusBarColor(1, 1, 1)
	else
		power:SetStatusBarTexture(power.__bar_texture)

		local colors = oUF.colors

		if (power.colorClass and arenaPrep) then
			local _, _, _, _, _, _, class = GetSpecializationInfoByID(GetArenaOpponentSpec(self.id))
			t = colors.class[class]
		elseif (power.colorDisconnected and disconnected) then
			t = colors.disconnected
		elseif (displayType == ALTERNATE_POWER_INDEX and power.altPowerColor) then
			t = power.altPowerColor
		elseif (power.colorPower) then
			t = colors.power[ptoken]
			if (not t) then
				if (power.GetAlternativeColor) then
					r, g, b = power:GetAlternativeColor(unit, ptype, ptoken, altR, altG, altB)
				elseif (altR) then
					r, g, b = altR, altG, altB
				else
					t = colors.power[ptype]
				end
			end
		elseif (power.colorClass and UnitIsPlayer(unit)) or
			(power.colorClassNPC and not UnitIsPlayer(unit)) or
			(power.colorClassPet and UnitPlayerControlled(unit) and not UnitIsPlayer(unit)) then
			local _, class = UnitClass(unit)
			t = colors.class[class]
		elseif (power.colorReaction and UnitReaction(unit, 'player') and (not UnitPlayerControlled(unit) and not UnitIsTapDenied(unit))) then
			t = colors.reaction[UnitReaction(unit, "player")]
		elseif (power.colorTapping and not UnitPlayerControlled(unit) and
			UnitIsTapDenied(unit)) then
			t = colors.tapped
		elseif (power.colorSmooth) then
			local adjust = 0 - (min or 0)
			r, g, b = self.ColorGradient(cur + adjust, max + adjust, unpack(power.smoothGradient or colors.smooth))
		end
	end

	if (t) then
		r, g, b = t[1], t[2], t[3]
	end

	if (b) then
		power:SetStatusBarColor(r, g, b)

		local bg = power.bg
		if(bg) then
			local mu = bg.multiplier or 1
			bg:SetVertexColor(r * mu, g * mu, b * mu)
		end
	end

	if (power.PostUpdate) then
		return power:PostUpdate(unit, pcur, pmax, pmin)
	end
end

UF.PostUpdateHealth = function(health, u, min, max)
	local self = health:GetParent()

	if (not UnitIsConnected(u)) then
		health.value:SetText("|cffaaaaaaOffline|r")
		self.__state = "DISCONNECTED"
	elseif (UnitIsGhost(u)) then
		health.value:SetText("|cffaaaaaaGhost|r")
		self.__state = "GHOST"
	elseif (UnitIsDead(u)) then
		health.value:SetText("|cffaaaaaaDead|r")
		self.__state = "DEAD"
	elseif (DraeUI.db["frames"].numFormatLong) then
		local left, num, right = string.match(min ~= max and (min - max) or min,'^([^%d]*%d)(%d*)(.-)$')

		local hpvalue = ("|cffffffff%s"):format(left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right)
		health.value:SetText(hpvalue)
	else
		local hpvalue = min ~= max and ("|cffB62220%s|r.%d|cff0090ff%%|r"):format(DraeUI.ShortVal(min - max), min / max * 100) or ("|cffffffff%s"):format(DraeUI.ShortVal(min))
		health.value:SetText(hpvalue)

		if (self.__state) then
			self.__state = nil
		end
	end
end

UF.AdditionalPowerPostVisibility = function(self, visible)
	local frame = self:GetParent()

	frame.backdrop:SetPoint("BOTTOMRIGHT", (visible) and frame.AdditionalPower or frame.Power, "BOTTOMRIGHT", 2.25, -2.5)
end

--[[

	Raid frame related events

--]]
do
	local color
	local color_grey = {0.66, 0.66, 0.66, 1.0}

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
			elseif (self.realUnit and UnitHasVehicleUI(self.realUnit)) then
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

		local hp = self.Health
		local text1	= self.Text1

		local refUnit = (self.realUnit or unit):gsub("pet", "")

		-- "pet"
		if (refUnit == "") then
			refUnit = "player"
		end

		local class = UnitName(refUnit) ~= UNKNOWN and select(2, UnitClass(refUnit))

		local hcurrent, hmax = UnitHealth(unit), UnitHealthMax(unit)
		hp:SetMinMaxValues(0, hmax)

		local new_state = GetFrameUnitState(self) or class or ""
		local old_state = self.__state_unit

		if (new_state ~= old_state) then
			local colors = oUF.colors

			if (new_state == "DISCONNECTED") then
				color = colors.disconnected
			elseif (new_state == "CHARMED") then
				color = colors.charmed
			elseif (new_state == "INVEHICLE") then
				color = colors.health
			elseif (UnitIsPlayer(unit) or (hp.colorClassPet and UnitPlayerControlled(unit) and not UnitIsPlayer(unit))) then
				color = colors.class[class] or colors.health
			else
				color = colors.health
			end

			-- Colour both hp and info text as hp bar colour
			if (text1) then
				text1:SetTextColor(color[1], color[2], color[3])
			end

			local bg = hp.bg
			if (new_state == "DISCONNECTED") then
				hp:SetValue(0)

				if (bg) then
					bg:SetVertexColor(0, 0, 0, 0)
				end

				self.bg:SetBackdropColor(0, 0, 0, 0.66)
			else
				hp:SetStatusBarColor(color[1], color[2], color[3])

				if (bg) then
					local mu = bg.multiplier or 1
					bg:SetVertexColor(color[1] * mu, color[2] * mu, color[3] * mu, 1)
				end

				self.bg:SetBackdropColor(0, 0, 0, 1)
			end

			if (new_state == "DISCONNECTED") then
				self:GainedStatus("alert_dc", color_grey, nil, "Offline")
			elseif (new_state == "CHARMED") then
				self:GainedStatus("alert_charmed", color_grey, nil, "Charm")
			elseif (new_state == "FEIGN") then
				self:GainedStatus("alert_feign", color_grey, nil, "Feign")
			elseif (new_state == "GHOST") then
				self:GainedStatus("alert_ghost", color_grey, nil, "Ghost")
			elseif (new_state == "DEAD") then
				self:GainedStatus("alert_dead", color_grey, nil, "Dead")
			elseif (new_state == "AFK") then
				self:GainedStatus("alert_afk", color_grey, nil, "AFK")
			elseif (new_state == "INVEHICLE") then
				local real_name = DraeUI.UTF8(UnitName(SecureButton_GetUnit(self) or self.unit) or "Unknown", 7, false)
				self:GainedStatus("unit_vehicle", color, nil, real_name)
			else
				self:GainedStatus("unit_health", color)
			end

			if (old_state == "DISCONNECTED") then
				self:LostStatus("alert_dc")
			elseif (old_state == "CHARMED") then
				self:LostStatus("alert_charmed")
			elseif (old_state == "FEIGN") then
				self:LostStatus("alert_feign")
			elseif (old_state == "GHOST") then
				self:LostStatus("alert_ghost")
			elseif (old_state == "DEAD") then
				self:LostStatus("alert_dead")
			elseif (old_state == "AFK") then
				self:LostStatus("alert_afk")
			elseif (old_state == "INVEHICLE") then
				self:LostStatus("unit_vehicle")
			end

			self.__state_unit = new_state
		end

		if (new_state ~= "DISCONNECTED") then
			hp:SetValue(hcurrent)

			if (hcurrent ~= hmax) then
				local pct = hcurrent == 0 and 0 or ("%.1f%%"):format(((hcurrent / hmax) * 100))
				-- status, color, texture, text, value, maxValue, start, duration, stack, notMine, pulse, flash, glow
				self:GainedStatus("unit_health", nil, nil, pct)
			else
				self:LostStatus("unit_health")
			end
		end
	end
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
