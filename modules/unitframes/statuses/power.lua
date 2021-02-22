--[[

--]]
local DraeUI = select(2, ...)
local oUF = DraeUI.oUF or oUF

local UF = DraeUI:GetModule("UnitFrames")
local Status = UF:NewModule("StatusPower")

--
local UnitIsUnit, GetSpecialization, GetInspectSpecialization, GetSpecializationInfo, UnitPower, UnitPowerMax, UnitIsConnected = UnitIsUnit, GetSpecialization, GetInspectSpecialization, GetSpecializationInfo, UnitPower, UnitPowerMax, UnitIsConnected

--
local function Update(self, event, unit)
	if (self.unit ~= unit) then return end
	local element = self.RaidPower

	local pcur, pmax = UnitPower(unit), UnitPowerMax(unit)
	element:SetMinMaxValues(0, pmax)

	if (UnitIsConnected(unit)) then
		element:SetValue(pcur)
	else
		element:SetValue(pmax)
	end

	element.cur = pcur
	element.max = pmax
end

local Visibility
do
	local healerSpecs = {
		[65]	= true,	-- Holy Paladin
		[105]	= true,	-- Resto Druid
		[256]	= true,	-- Disc Priest
		[257]	= true,	-- Holy Priest
		[270]	= true,	-- Mistweaver Monk
		[264]	= true,	-- Resto Shaman
	}

	Visibility = function(frame, event, unit)
		if (unit and frame.unit ~= unit) then return end
		unit = unit or frame.unit

		local pp = frame.RaidPower
		if (not pp) then return end

		local hp = frame.Health
		local hpp = frame.HealthPrediction

		-- Current state of powerbar - enabled or not
		local oldState = pp.__state
		local newState

		local notPlayer		= UnitIsUnit(unit, "player")
		local spec 			= GetSpecialization()
		local specId 		= notPlayer and GetSpecializationInfo(spec) or GetInspectSpecialization(unit)
		local role 			= healerSpecs[specId] and "HEALER" or UnitGroupRolesAssigned(unit)
		local disconnected 	= not UnitIsConnected(unit)

		-- Disconnected or not showing mana? newState is false else true
		if (disconnected or role ~= "HEALER") then newState = "hidden" else newState = "visible" end

		if (newState ~= oldState) then
			if (newState == "visible") then
				local _, powerToken = UnitPowerType(unit)
				local pr, pg, pb = unpack(frame.colors.power[powerToken])

				hp:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, pp.__bar_height + 1.5)

				local bg = pp.bg
				if(bg) then
					local mu = bg.multiplier or 1
					bg:SetVertexColor(pr * mu, pg * mu, pb * mu)
				end
				pp:SetStatusBarColor(pr, pg, pb)
				pp:Show()
			else
				hp:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT")

				pp:Hide()
			end

			pp.__state = newState
		end

		hpp.myBar:SetHeight(hp:GetHeight())
		hpp.otherBar:SetHeight(hp:GetHeight())
		hpp.absorbBar:SetHeight(hp:GetHeight())
		hpp.healAbsorbBar:SetHeight(hp:GetHeight())
	end
end

local function Path(self, ...)
	Update(self, ...);
	Visibility(self, ...)
end

local function ForceUpdate(element)
	Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self)
	local element = self.RaidPower
	if(element) then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_POWER_UPDATE', Update)
--		self:RegisterEvent('UNIT_POWER_FREQUENT', Update)
		self:RegisterEvent('UNIT_MAXPOWER', Update)
		self:RegisterEvent('UNIT_DISPLAYPOWER', Visibility)
		self:RegisterEvent('UNIT_POWER_BAR_HIDE', Visibility)
		self:RegisterEvent('UNIT_POWER_BAR_SHOW', Visibility)
		self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", Visibility)
		self:RegisterEvent('PLAYER_ROLES_ASSIGNED', Visibility, true)
		self:RegisterEvent('GROUP_ROSTER_UPDATE', Visibility, true)
		self:RegisterEvent('UNIT_CONNECTION', Visibility)

		if(element:IsObjectType('StatusBar') and not (element:GetStatusBarTexture() or element:GetStatusBarAtlas())) then
			element:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
		end

		element:Show()

		return true
	end
end

local function Disable(self)
	local element = self.RaidPower
	if(element) then
		element:Hide()

		self:UnregisterEvent('UNIT_MAXPOWER', Update)
		self:UnregisterEvent('UNIT_POWER_UPDATE', Update)
--		self:UnregisterEvent('UNIT_POWER_FREQUENT', Update)
		self:UnregisterEvent('UNIT_DISPLAYPOWER', Visibility)
		self:UnregisterEvent('UNIT_POWER_BAR_HIDE', Visibility)
		self:UnregisterEvent('UNIT_POWER_BAR_SHOW', Visibility)
		self:UnregisterEvent('UNIT_CONNECTION', Visibility)
		self:UnregisterEvent("PLAYER_SPECIALIZATION_CHANGED", Visibility)
		self:UnregisterEvent('PLAYER_ROLES_ASSIGNED', Path)
		self:UnregisterEvent('GROUP_ROSTER_UPDATE', Path)
	end
end

oUF:AddElement('StatusRaidPower', Path, Enable, Disable)
