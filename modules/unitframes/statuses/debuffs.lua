--[[
		Inspired by Grid, Aptcheka and others
--]]
local _, ns = ...
local oUF = ns.oUF or draeUF

--
local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

local Status = UF:NewModule("StatusRaidDebuffs", "AceEvent-3.0")

--
local UnitDebuff, UnitIsDeadOrGhost, GetSpellInfo = UnitDebuff, UnitIsDeadOrGhost, GetSpellInfo
local wipe = table.wipe

--
local loaded = {}
local debuffList = {}

--[[

--]]
local LoadDungeonDebuffs = function()
	-- enable, spell, priority, secondary, pulse, flash,  glow

	-- Mythic+
	UF:AddRaidDebuff(true, 209858, 9, true) -- Necrotic Rot
	UF:AddRaidDebuff(true, 240443, 10) -- Bursting
	UF:AddRaidDebuff(true, 240449, 9, true) -- Grievous
	UF:AddRaidDebuff(true, 340880, 5, true) -- Prideful (SL - Season 1)
end

local LoadPVPDebuffs = function()
	local flash = {
		magic 	= UF.dispellClasses[T.playerClass]["Magic"] and true or false,
		disease = UF.dispellClasses[T.playerClass]["Disease"] and true or false,
		poison 	= UF.dispellClasses[T.playerClass]["Poison"] and true or false,
		curse	= UF.dispellClasses[T.playerClass]["Curse"] and true or false,
	}

	-- Highest prirority for dangerous effects which should be dispelled (or not)
	-- remaining debuffs depend on whether dispellable by this class and whether they
	-- limit movement

	-- enable, spell, priority, secondary, pulse, flash, glow

	-- Dangerous debuffs (glow)
	UF:AddRaidDebuff(true, 316099, 	9, false, false, false, true) -- Unstable Affliction [warlock - affliction]
	UF:AddRaidDebuff(true, 323673, 	9, false, false, false, true) -- Mindgames [priest - venthyr]

	-- Roots
	UF:AddRaidDebuff(true, 122, 	8, false, nil, flash.magic)	-- Frost Nova
	UF:AddRaidDebuff(true, 339, 	8, false, nil, flash.magic)	-- Entangling roots
	UF:AddRaidDebuff(true, 33395, 	8, false, nil, flash.magic)	-- Freeze
	UF:AddRaidDebuff(true, 102359, 	8, false, nil, flash.magic)	-- Mass Entangling roots

	-- Incapacitates
	UF:AddRaidDebuff(true, 118, 	8, false, nil, flash.magic)	-- Polymorph
	UF:AddRaidDebuff(true, 6789, 	8, false, nil, flash.magic)	-- Mortal Coil
	UF:AddRaidDebuff(true, 19386, 	8, false, nil, flash.magic)	-- Wyvern Sting
	UF:AddRaidDebuff(true, 20066, 	8, false, nil, flash.magic)	-- Repentance
	UF:AddRaidDebuff(true, 51514, 	8, false, nil, flash.curse)	-- Hex
	UF:AddRaidDebuff(true, 64044, 	8, false, nil, flash.magic)	-- Psychic Horror [priest - shadow]
	UF:AddRaidDebuff(true, 113724, 	4)	-- Ring of frost (undispellable)
	UF:AddRaidDebuff(true, 187650, 	4)	-- Freezing Trap (undispellable) [hunter]

	-- Disorients
	UF:AddRaidDebuff(true, 31661, 	8, false, nil, flash.magic)	-- Dragon's Breath
	UF:AddRaidDebuff(true, 115750, 	8, false, nil, flash.magic)	-- Blinding Light
	UF:AddRaidDebuff(true, 198898, 	4) -- Song of Chi'Ji (undispellable) [monk - mistweaver]

	-- Stuns
	UF:AddRaidDebuff(true, 109248, 	6, false, nil, flash.magic)	-- Binding shot

	-- Silences

	-- Knockbacks

	-- Slows [undispellable - not daze type]
	UF:AddRaidDebuff(true, 15407, 	6, true)	-- Mind Flay
	UF:AddRaidDebuff(true, 26679, 	6, true)	-- Deadly Throw
	UF:AddRaidDebuff(true, 12323, 	6, true)	-- Piercing Howl
	UF:AddRaidDebuff(true, 1715, 	6, true)	-- Hamstring
	UF:AddRaidDebuff(true, 45524, 	6, true)	-- Chains of Ice

	-- Healing reductions
--[[	UF:AddRaidDebuff(true, 8679, prDefault, true) 	-- Wound Poison [rogue - ass]
	UF:AddRaidDebuff(true, 12294, prDefault, true) 	-- Mortal Strike [warrior]
	UF:AddRaidDebuff(true, 30213, prDefault, true) 	-- Legion Strike [warlock - felguard]
	UF:AddRaidDebuff(true, 73975, prDefault, true) 	-- Necrotic Strike [deathknight]
	UF:AddRaidDebuff(true, 107428, prDefault, true) -- Rising Sun Kick [monk]
	UF:AddRaidDebuff(true, 115804, prDefault, true) -- Mortal Wounds [hunter - pet]
	UF:AddRaidDebuff(true, 195452, prDefault, true) -- Nightblade [rogue - sub]
--]]
end

--[[

]]
UF.AddRaidDebuff = function(self, enable, spell, priority, secondary, pulse, flash, glow)
	local name, _, icon = GetSpellInfo(spell)

	debuffList[name] = {
		enable 		= enable or false, -- NOTE: By setting this to false you effectively blacklist that debuff
		icon 		= icon or nil,
		priority 	= priority or 5,
		secondary 	= secondary or false,
		pulse 		= pulse or false,
		flash 		= flash or false,
		glow		= glow or false
	}
end

UF.IsRaidDebuff = function(self, spell)
	local name = type(spell) == "number" and GetSpellInfo(spell) or spell

	return debuffList[name] and debuffList[name].enable and true or false
end

--[[
	- Don't reload list each time this event fires because minor zone changes don't change the overall zone/zonetype
	- Reload list if zoneName or zoneType changes
	- Wipe debuff list before any changes

	Three debuff sets to load - specific, dungeon and pvp
	- in a raid load > specific
	- in a dungeon load > specific + dungeon
	- in pvp (bg/arena) load > pvp
--]]
local LoadDebuffs = function()
	local zoneName, zoneType, difficultyID = GetInstanceInfo()

	if (loaded.zoneName == zoneName and loaded.zonetype == zoneType) then return end

	wipe(debuffList)

	local displayText = ""

	if (zoneType == "raid") then
		local add = UF["raiddebuffs"].instances[zoneName] or nil

		if  (add) then
			add()

			displayText = zoneName
		end
	elseif (zoneType =="party" and difficultyID) then
		local add = UF["raiddebuffs"].instances[zoneName] or nil

		if  (add) then
			add()

			displayText = zoneName.. " and "
		end

		LoadDungeonDebuffs()

		displayText = displayText .. "Mythic Plus"
	elseif (zoneType =="pvp" or zoneType == "arena") then
		displayText = " PvP"

		LoadPVPDebuffs()
	end

	if (displayText ~= "") then
		T.Print("Debuff indicators loaded for |cff00dd00" .. displayText .. "|r")
	end

	-- TESTING
	-- enable, spell, priority, secondary, pulse, flash, glow
--	UF:AddRaidDebuff(true, 325966, 	5, nil, nil, nil, true) -- Glimmer of Light
--	UF:AddRaidDebuff(true, 337825, 6)	-- Shock Barrier

	loaded.zoneType = zoneType
	loaded.zoneName = zoneName
end

--[[

--]]
local Update
do
	local debuffPriorities = {
		["Magic"]  	= 4,
		["Disease"] = 3,
		["Poison"] 	= 2,
		["Curse"] 	= 1,
		["none"]	= 0,
		[""]		= 0
	}

	local index, name, icon, stack, dtype, duration, expires, isBossDebuff, wasCastByPlayer
	local store_one = {}
	local store_two = {}
	local top_pri_one = 0
	local top_pri_two = 0

	local store = {}
	local testPriority = {}

	Update = function(self, event, unit)
		if (unit and self.unit ~= unit) then return end
		unit = unit or self.unit

		if (UnitIsDeadOrGhost(unit)) then
			for k, _ in pairs(store) do
				self:LostStatus("status_raiddebuff_" .. k)
			end

			return
		end

		index = 1

		while (true) do
			name, icon, stack, dtype, duration, expires, _, _, _, _, _, isBossDebuff, wasCastByPlayer =	UnitDebuff(unit, index)

			if (not name) then break end

			if (debuffList[name]) then
				if (debuffList[name].enable) then
					local debuff = debuffList[name]
					local subType = debuff.secondary and "two" or "one"

					if (not store[subType]) then
						store[subType] =  {}
					end

					if (not testPriority[subType] or testPriority[subType] < debuff.priority) then
						testPriority[subType] = debuff.priority

						store[subType].name 	= name
						store[subType].color 	= oUF.colors.debuffTypes[dtype] and oUF.colors.debuffTypes[dtype] or {}
						store[subType].icon 	= icon
						store[subType].start 	= expires - duration
						store[subType].duration = duration
						store[subType].stack	= stack
						store[subType].pulse 	= debuff.pulse or false
						store[subType].flash 	= debuff.flash or false
						store[subType].glow		= debuff.glow or false
					end
				end
			elseif (isBossDebuff or not wasCastByPlayer) then
				-- Boss or mob debuff that we don't automatically prioritise so we'll go by standard debuff priorities
				local bossPriority =  dtype and debuffPriorities[dtype] or 1

				if (not store["one"]) then
					store["one"] = {}
				end

				if (not testPriority["one"] or testPriority["one"] < bossPriority) then
					testPriority["one"] = bossPriority

					store["one"].name 	  = name
					store["one"].color 	  = oUF.colors.debuffTypes[dtype] and oUF.colors.debuffTypes[dtype] or {}
					store["one"].icon 	  = icon
					store["one"].start 	  = expires - duration
					store["one"].duration = duration
					store["one"].stack	  = stack
					store["one"].pulse 	  = false
					store["one"].flash 	  = false
					store["one"].glow 	  = false
				end
			end

			index = index + 1
		end

		for k, _ in pairs(store) do
			if (store[k].name) then
				self:GainedStatus("status_raiddebuff_" .. k, store[k].color, store[k].icon, nil, nil, nil, store[k].start, store[k].duration, store[k].stack, nil, store[k].pulse, store[k].flash, store[k].glow)
			else
				self:LostStatus("status_raiddebuff_" .. k)
			end

			wipe(store[k])
			testPriority[k] = nil
		end
	end
end

local Enable = function(self)
	if (self.__is_grid) then
		self:RegisterEvent("UNIT_AURA", Update)
		return true
	end
end

local Disable = function(self)
	if (self.__is_grid) then
		self:UnregisterEvent("UNIT_AURA", Update)
	end
end

oUF:AddElement("StatusRaidDebuffs", Update, Enable, Disable)

--[[

--]]
Status.OnEnable = function(self)
	self:RegisterEvent("PLAYER_ENTERING_WORLD", LoadDebuffs)
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", LoadDebuffs)
end
