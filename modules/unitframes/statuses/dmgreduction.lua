--[[
		Inspired by Grid, Aptcheka and others
--]]
local _, ns = ...
local oUF = ns.oUF or draeUF

--
local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

local I = UF:NewModule("StatusDmgReduction")

-- Localise a bunch of functions
local UnitAura, GetSpellInfo, UnitIsVisible, UnitIsDeadOrGhost = UnitAura, GetSpellInfo, UnitIsVisible, UnitIsDeadOrGhost
local pairs = pairs

--
local priority = 80

local cooldowns = {
	-- Deathknight
	["Icebound Fortitude"] 			= { id = 48792,  type = "HELPFUL", pr = 6, color = { r = 1.0, g = 1.0, b = 1.0 } },

	-- Druid
	["Survival Instincts"] 			= { id = 61336,  type = "HELPFUL", pr = 6, color = { r = 1.0, g = 1.0, b = 1.0 } },

	-- Hunter
	["Deterrence"] 					= { id = 19263,  type = "HELPFUL", pr = 7, color = { r = 1.0, g = 1.0, b = 1.0 } },

	-- Monk
	["Fortifying Brew"] 			= { id = 115203, type = "HELPFUL", pr = 7, color = { r = 1.0, g = 1.0, b = 1.0 } },
	["Heavy Stagger"] 				= { id = 124273, type = "HARMFUL", pr = 6, color = { r = 0.9, g = 0.0, b = 0.0 } },
	["Moderate Stagger"] 			= { id = 124274, type = "HARMFUL", pr = 5, color = { r = 0.9, g = 0.5, b = 0.0 } },
	["Light Stagger"] 				= { id = 124275, type = "HARMFUL", pr = 4, color = { r = 0.0, g = 0.9, b = 0.0 } },

	-- Mage
	["Ice Block"] 					= { id = 45438,  type = "HELPFUL", pr = 7, color = { r = 1.0, g = 1.0, b = 1.0 } },
	["Cauterize"] 					= { id = 86949,  type = "HARMFUL", pr = 8, color = { r = 1.0, g = 0.7, b = 0.0 } },

	-- Paladin
	["Divine Shield"] 				= { id = 642,    type = "HELPFUL", pr = 8, color = { r = 1.0, g = 1.0, b = 1.0 } },
	["Divine Protection"] 			= { id = 498,    type = "HELPFUL", pr = 7, color = { r = 1.0, g = 1.0, b = 1.0 } },
	["Ardent Defender"] 			= { id = 31850,  type = "HELPFUL", pr = 7, color = { r = 1.0, g = 1.0, b = 1.0 } },
	["Guardian of Ancient Kings"] 	= { id = 86659,  type = "HELPFUL", pr = 6, color = { r = 1.0, g = 1.0, b = 1.0 } },

	-- Priest
	["Guardian Spirit"] 			= { id = 47788,  type = "HELPFUL", pr = 9, color = { r = 1.0, g = 1.0, b = 1.0 } },

	-- Warrior
	["Shield Wall"] 				= { id = 871,    type = "HELPFUL", pr = 6, color = { r = 1.0, g = 1.0, b = 1.0 } },
}

--[[

--]]
local UpdateCooldownList = function()
	for name, settings in pairs(cooldowns) do
		if (not settings.name) then
			local spellName = GetSpellInfo(settings.id)

			if (spellName) then
				settings.name = spellName
			else
				T.Print("[ DEBUG ] Could not find name for spell with id ", settings.id, "in dmgreduction")
			end
		end
	end
end

--[[

--]]
local Update
do
	local name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable

	Update = function(self, event, unit)
		if (unit and self.unit ~= unit) then return end
		unit = unit or self.unit

		local cooldownSeen

		if (UnitIsVisible(unit) and not UnitIsDeadOrGhost(unit)) then
			-- scan for buffs
			for _, settings in pairs(cooldowns) do
				if (settings.name) then
					name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable = UnitAura(unit, settings.name, nil, settings.type)

					if (name) then
						cooldownSeen = name
						break
					end
				end
			end
		end

		if (cooldownSeen) then
			local start = expirationTime and (expirationTime - duration)

			self:GainedStatus(unit, "status_dmgred", priority, cooldowns[cooldownSeen].color, icon, nil, nil, nil, start, duration, count, false)
		else
			self:LostStatus(unit, "status_dmgred")
		end
	end
end

local Enable = function(self)
	if (self.statuscache) then
		self:RegisterEvent("UNIT_AURA", Update)
		return true
	end
end

local Disable = function(self)
	if (self.statuscache) then
		self:UnregisterEvent("UNIT_AURA", Update)
	end
end

oUF:AddElement("StatusDmgReduction", Update, Enable, Disable)

--[[

--]]
I.OnEnable = function(self)
	UpdateCooldownList()
end
