--[[

--]]
local _, ns = ...
local oUF = ns.oUF or draeUF

--
local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

local Status = UF:NewModule("StatusHealth")
local Roster =  T:GetModule("Roster")

--
local UnitName, UnitIsPlayer, UnitIsAFK, UnitIsDead, UnitIsGhost, UnitHasVehicleUI, UnitIsCharmed, UnitIsConnected, UnitIsDeadOrGhost, UnitPlayerControlled, UnitHealth, UnitHealthMax = UnitName, UnitIsPlayer, UnitIsAFK, UnitIsDead, UnitIsGhost, UnitHasVehicleUI, UnitIsCharmed, UnitIsConnected, UnitIsDeadOrGhost, UnitPlayerControlled, UnitHealth, UnitHealthMax
local SecureButton_GetUnit = SecureButton_GetUnit

--
local color_grey = { 0.6, 0.6, 0.6, 1.0 }

--
local SetColors = function(self, state, color)
	local hp = self.RaidHealth
	local text1	= self.Text1

	-- Colour both hp and info text as hp bar colour
	if (text1) then
		text1:SetTextColor(color[1], color[2], color[3])
	end

	local bg = hp.bg
	if (state == "DISCONNECTED") then
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
end

local ColorPath
do
	local colors = oUF.colors

	ColorPath = function(self, event, unit)
		if (unit and unit ~= self.unit and unit ~= self.realUnit) then return end
		unit = unit or self.unit or self.realUnit

		local hp = self.RaidHealth

		local old_state = self.__state_unit
		local new_state

		if (UnitIsPlayer(unit)) then
			if (not UnitIsConnected(unit)) then
				new_state = "DISCONNECTED"
			elseif (UnitIsAFK(unit)) then
				new_state = "AFK"
			elseif (UnitIsDead(unit)) then
				new_state = "DEAD"
			elseif (UnitIsGhost(unit)) then
				new_state = "GHOST"
			else
				new_state = Roster:GetUnitClass(unit)
			end
		else
			if (UnitIsDeadOrGhost(unit)) then
				new_state = "DEAD"
			end
		end

		if (new_state ~= old_state) then
			local color, status, status_text

			if (new_state == "DISCONNECTED") then
				color, status, status_text = color_grey, "alert_dc", "Offline"

				SetColors(self, new_state, color)
			elseif (new_state == "FEIGN") then
				color, status, status_text = color_grey, "alert_feign", "Feign"
			elseif (new_state == "GHOST") then
				color, status, status_text = color_grey, "alert_ghost", "Ghost"
			elseif (new_state == "DEAD") then
				color, status, status_text = color_grey, "alert_dead", "Dead"
			elseif (new_state == "AFK") then
				color, status, status_text = color_grey, "alert_afk", "AFK"
			else
				color = (UnitIsPlayer(unit) or (hp.colorClassPet and UnitPlayerControlled(unit) and not UnitIsPlayer(unit))) and colors.class[new_state] or colors.health

				SetColors(self, new_state, color)
			end

			if (status) then
				self:GainedStatus(status, color, nil, status_text)
			end

			if (old_state == "DISCONNECTED") then
				self:LostStatus("alert_dc")
			elseif (old_state == "FEIGN") then
				self:LostStatus("alert_feign")
			elseif (old_state == "GHOST") then
				self:LostStatus("alert_ghost")
			elseif (old_state == "DEAD") then
				self:LostStatus("alert_dead")
			elseif (old_state == "AFK") then
				self:LostStatus("alert_afk")
			end

			self.__state_unit = new_state
		end
	end
end

local Update
do
	local colors = oUF.colors

	Update = function(self, event, unit)
		if (unit and unit ~= self.unit and unit ~= self.realUnit) then return end
		unit = unit or self.unit or self.realUnit

		local hp = self.RaidHealth

		local unit_state = self.__state_unit
		local old_state = self.__state
		local new_state

		if (UnitHasVehicleUI(unit)) then
			new_state = "INVEHICLE"
		elseif (UnitIsCharmed(unit)) then
			new_state = "CHARMED"
		else
			new_state = Roster:GetUnitClass(unit)
		end

		if (new_state ~= old_state) then
			local color

			if (new_state == "INVEHICLE" and self.realUnit and UnitHasVehicleUI(self.realUnit)) then
				color = colors.health
				local real_name = T.UTF8((UnitName(SecureButton_GetUnit(self) or self.unit) or "Unknown"), 7, false)
				self:GainedStatus("unit_vehicle", color, nil, real_name)
			elseif (new_state == "CHARMED") then
				color = colors.charmed
				self:GainedStatus("alert_charmed", color_grey, nil, "Charm")
			else
				color = (UnitIsPlayer(unit) or (hp.colorClassPet and UnitPlayerControlled(unit) and not UnitIsPlayer(unit))) and colors.class[new_state] or colors.health
				self:GainedStatus("unit_health", color)
			end

			SetColors(self, new_state, color)

			if (old_state == "INVEHICLE") then
				self:LostStatus("unit_vehicle")
			elseif (old_state == "CHARMED") then
				self:LostStatus("alert_charmed")
			end

			self.__state = new_state
		end

		local hcurrent, hmax = UnitHealth(unit), UnitHealthMax(unit)
		hp:SetMinMaxValues(0, hmax)

		if (unit_state ~= "DISCONNECTED") then
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

local Path = function(self, ...)
	Update(self, ...)
	ColorPath(self, ...)
end

local ForceUpdate = function(element)
	Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local Enable = function(self)
	local element = self.RaidHealth
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_HEALTH', Update)
		self:RegisterEvent('UNIT_MAXHEALTH', Update)
		self:RegisterEvent('UNIT_CONNECTION', ColorPath)
		self:RegisterEvent('UNIT_FACTION', ColorPath)
		self:RegisterEvent('UNIT_FLAGS', ColorPath)
		self:RegisterEvent("PLAYER_FLAGS_CHANGED", ColorPath, true) -- AFK status changes
		self:RegisterEvent("PLAYER_CONTROL_LOST", ColorPath, true) -- Mind control, fear, taxi, etc.

		if(element:IsObjectType('StatusBar') and not (element:GetStatusBarTexture() or element:GetStatusBarAtlas())) then
			element:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
		end

		element:Show()

		return true
	end
end

local Disable = function(self)
	local element = self.RaidHealth
	if(element) then
		element:Hide()

		self:UnregisterEvent('UNIT_HEALTH', Path)
		self:UnregisterEvent('UNIT_MAXHEALTH', Path)
		self:UnregisterEvent('UNIT_CONNECTION', ColorPath)
		self:UnregisterEvent('UNIT_FACTION', ColorPath)
		self:UnregisterEvent('UNIT_FLAGS', ColorPath)
		self:UnregisterEvent('PLAYER_FLAGS_CHANGED', ColorPath)
		self:UnregisterEvent('PLAYER_CONTROL_LOST', ColorPath)
	end
end

oUF:AddElement('StatusRaidHealth', Path, Enable, Disable)
