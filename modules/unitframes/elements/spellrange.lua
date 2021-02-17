--[[


--]]
local _, ns = ...
local oUF = ns.oUF or oUF

local T, C, G, P, U, _ = select(2, ...):UnPack()

local Element = T:NewModule("ElementRange")
local SpellRange = LibStub("SpellRange-1.0", true)

-- Localise a bunch of functions
local pairs, ipairs, assert, type, tonumber, next = pairs, ipairs, assert, type, tonumber, next
local CreateFrame, UnitIsConnected,  UnitCanAttack, UnitIsUnit, UnitPlayerOrPetInRaid, UnitIsDead, UnitOnTaxi, UnitInRange, IsSpellInRange, CheckInteractDistance,  UnitPlayerOrPetInParty, UnitCanAssist = CreateFrame, UnitIsConnected,  UnitCanAttack, UnitIsUnit, UnitPlayerOrPetInRaid, UnitIsDead, UnitOnTaxi, UnitInRange, IsSpellInRange, CheckInteractDistance,  UnitPlayerOrPetInParty, UnitCanAssist

--
local spellRangeCheck = {
	DEATHKNIGHT = {
		enemySpells = {
			[49576] = true -- Death Grip
		},
		longEnemySpells = {
			[47541] = true -- Death Coil (Unholy) (40 yards)
		},
		friendlySpells = {},
		resSpells = {
			[61999] = true -- Raise Ally (40 yards)
		},
		petSpells = {}
	},
	DEMONHUNTER = {
		enemySpells = {
			[183752] = true -- Consume Magic (20 yards)
		},
		longEnemySpells = {
			[185123] = true, -- Throw Glaive (Havoc) (30 yards)
			[204021] = true -- Fiery Brand (Vengeance) (30 yards)
		},
		friendlySpells = {},
		resSpells = {},
		petSpells = {}
	},
	DRUID = {
		enemySpells = {
			[8921] = true -- Moonfire (40 yards, all specs, lvl 3)
		},
		longEnemySpells = {},
		friendlySpells = {
			[8936] = true -- Regrowth (40 yards, all specs, lvl 5)
		},
		resSpells = {
			[50769] = true -- Revive (40 yards, all specs, lvl 14)
		},
		petSpells = {}
	},
	HUNTER = {
		enemySpells = {
			[75] = true -- Auto Shot (40 yards)
		},
		longEnemySpells = {},
		friendlySpells = {},
		resSpells = {},
		petSpells = {
			[982] = true -- Mend Pet (45 yards)
		}
	},
	MAGE = {
		enemySpells = {
			[118] = true -- Polymorph (30 yards)
		},
		longEnemySpells = {
			[116] = true, -- Frostbolt (Frost) (40 yards)
			[44425] = true, -- Arcane Barrage (Arcane) (40 yards)
			[133] = true -- Fireball (Fire) (40 yards)
		},
		friendlySpells = {
			[130] = true -- Slow Fall (40 yards)
		},
		resSpells = {},
		petSpells = {}
	},
	MONK = {
		enemySpells = {
			[115546] = true -- Provoke (30 yards)
		},
		longEnemySpells = {
			[117952] = true -- Crackling Jade Lightning (40 yards)
		},
		friendlySpells = {
			[116670] = true -- Vivify (40 yards)
		},
		resSpells = {
			[115178] = true -- Resuscitate (40 yards)
		},
		petSpells = {}
	},
	PALADIN = {
		enemySpells = {
			[62124] = true, -- Hand of Reckoning (30 yards)
			[183218] = true, -- Hand of Hindrance (30 yards)
			[20271] = true, -- Judgement (30 yards) Retribution, (does not work for retribution below lvl 78)
			[275779] = true, -- Judgement (30 yards) Tank
			[275773] = true -- Judgement (30 yards) Heal
		},
		longEnemySpells = {
			[20473] = true -- Holy Shock (40 yards)
		},
		friendlySpells = {
			[19750] = true -- Flash of Light (40 yards)
		},
		resSpells = {
			[7328] = true -- Redemption (40 yards)
		},
		petSpells = {}
	},
	PRIEST = {
		enemySpells = {
			[585] = true, -- Smite (40 yards)
			[589] = true -- Shadow Word: Pain (40 yards)
		},
		longEnemySpells = {},
		friendlySpells = {
			[2061] = true, -- Flash Heal (40 yards)
			[17] = true -- Power Word: Shield (40 yards)
		},
		resSpells = {
			[2006] = true -- Resurrection (40 yards)
		},
		petSpells = {}
	},
	ROGUE = {
		enemySpells = {
			[185565] = true, -- Poisoned Knife (Assassination) (30 yards)
			[185763] = true, -- Pistol Shot (Outlaw) (20 yards)
			[114014] = true, -- Shuriken Toss (Sublety) (30 yards)
			[1725] = true -- Distract (30 yards)
		},
		longEnemySpells = {},
		friendlySpells = {
			[57934] = true -- Tricks of the Trade (100 yards)
		},
		resSpells = {},
		petSpells = {}
	},
	SHAMAN = {
		enemySpells = {
			[188196] = true, -- Lightning Bolt (Elemental) (40 yards)
			[187837] = true, -- Lightning Bolt (Enhancement) (40 yards)
			[403] = true -- Lightning Bolt (Resto) (40 yards)
		},
		longEnemySpells = {},
		friendlySpells = {
			[8004] = true, -- Healing Surge (Resto/Elemental) (40 yards)
			[188070] = true -- Healing Surge (Enhancement) (40 yards)
		},
		resSpells = {
			[2008] = true -- Ancestral Spirit (40 yards)
		},
		petSpells = {}
	},
	WARLOCK = {
		enemySpells = {
			[5782] = true -- Fear (30 yards)
		},
		longEnemySpells = {
			[234153] = true, -- Drain Life (40 yards)
			[198590] = true, --Drain Soul (40 yards)
			[232670] = true, --Shadow Bolt (40 yards, lvl 1 spell)
			[686] = true --Shadow Bolt (Demonology) (40 yards, lvl 1 spell)
		},
		friendlySpells = {
			[20707] = true -- Soulstone (40 yards)
		},
		resSpells = {},
		petSpells = {
			[755] = true -- Health Funnel (45 yards)
		}
	},
	WARRIOR = {
		enemySpells = {
			[5246] = true, -- Intimidating Shout (Arms/Fury) (8 yards)
			[100] = true -- Charge (Arms/Fury) (8-25 yards)
		},
		longEnemySpells = {
			[355] = true -- Taunt (30 yards)
		},
		friendlySpells = {},
		resSpells = {},
		petSpells = {}
	},
}

local SR = {}
local objectRanges = {}

--[[

--]]
local UpdateRangeCheckSpells
do
	local AddTable = function(tbl)
		SR[T.playerClass][tbl] = {}
	end

	local AddSpell = function(tbl, spellID)
		SR[T.playerClass][tbl][#SR[T.playerClass][tbl] + 1] = spellID
	end

	UpdateRangeCheckSpells = function()
		if not SR[T.playerClass] then SR[T.playerClass] = {} end

		for tbl, spells in pairs(spellRangeCheck[T.playerClass]) do
			AddTable(tbl) --Create the table holding spells, even if it ends up being an empty table

			for spellID in pairs(spells) do
				if (spells[spellID]) then --We will allow value to be false to disable this spell from being used
					AddSpell(tbl, spellID, enabled)
				end
			end
		end
	end
end

local FriendlyIsInRange = function(unit)
	-- Unit is player unit and not in the same phase
	if (UnitIsPlayer(unit) and UnitPhaseReason(unit)) then return false end

	local in_range, checked_range = UnitInRange(unit)
	-- blizz checked and said the unit is out of range
	if (checked_range and not in_range) then return false end

	-- within 28 yards (arg2 as 1 is Compare Achievements distance)
	if CheckInteractDistance(unit, 1) then return true end

	local object = SR[T.playerClass]

	if (object) then
		-- dead with rez spells
		if (object.resSpells and #object.resSpells > 0 and UnitIsDeadOrGhost(unit)) then
			for _, spellID in ipairs(object.resSpells) do
				if (SpellRange.IsSpellInRange(spellID, unit) == 1) then return true end
			end

			return false -- dead but no spells are in range
		end

		-- you have some healy spell
		if (object.friendlySpells and #object.friendlySpells > 0) then
			for _, spellID in ipairs(object.friendlySpells) do
				if (SpellRange.IsSpellInRange(spellID, unit) == 1) then return true end
			end
		end
	end

	return false -- not within 28 yards and no spells in range
end

local PetIsInRange = function(unit)
	-- within 8 yards (arg2 as 2 is Trade distance)
	if (CheckInteractDistance(unit, 2)) then return true end

	local object = SR[T.playerClass]

	if (object) then
		if (object.friendlySpells and #object.friendlySpells > 0) then -- you have some healy spell
			for _, spellID in ipairs(object.friendlySpells) do
				if (SpellRange.IsSpellInRange(spellID, unit) == 1) then return true end
			end
		end

		if (object.petSpells and #object.petSpells > 0) then -- you have some pet spell
			for _, spellID in ipairs(object.petSpells) do
				if (SpellRange.IsSpellInRange(spellID, unit) == 1) then return true end
			end
		end
	end

	return false -- not within 8 yards and no spells in range
end

local EnemyIsInRange = function(unit)
	-- within 8 yards (arg2 as 2 is Trade distance)
	if (CheckInteractDistance(unit, 2)) then return true end

	local object = SR[T.playerClass]

	if (object and object.enemySpells and #object.enemySpells > 0) then -- you have some damage spell
		for _, spellID in ipairs(object.enemySpells) do
			if (SpellRange.IsSpellInRange(spellID, unit) == 1) then return true end
		end
	end

	return false -- not within 8 yards and no spells in range
end

local EnemyIsInLongRange = function(unit)
	local object = SR[T.playerClass]

	if (object and object.longEnemySpells and #object.longEnemySpells > 0) then -- you have some 30+ range damage spell
		for _, spellID in ipairs(object.longEnemySpells) do
			if (SpellRange.IsSpellInRange(spellID, unit) == 1) then return true end
		end
	end

	return false
end

--- Rechecks range for a unit frame, and fires callbacks when the unit passes in or out of range.
local UpdateRange = function (self)
	local in_range

	if (UnitIsUnit(self.unit, "player")) then
		in_range = true
	elseif (self.unit and UnitIsConnected(self.unit)) then
		if (UnitIsUnit(self.unit, "pet")) then
			in_range = PetIsInRange(self.unit) and true or false
		elseif (UnitCanAssist("player", self.unit)) then
			in_range = FriendlyIsInRange(self.unit) and true or false
		elseif (UnitCanAttack("player", self.unit)) then
			in_range = (EnemyIsInRange(self.unit) or EnemyIsInLongRange(self.unit)) and true or false
		else
			in_range = CheckInteractDistance(self.unit, 4) and true or false
		end
	else
		in_range = true
	end

	if (objectRanges[self] ~= in_range) then -- Range state changed
		objectRanges[self] = in_range

		local sr = self.SpellRange

		if (sr.Update) then
			sr.Update(self, in_range)
		else
			self:SetAlpha(sr[in_range and "insideAlpha" or "outsideAlpha"])
		end
	end
end

-- Called by oUF when the unit frame's unit changes or
-- otherwise needs a complete update.
local Update = function(self, event, unit)
	-- OnTargetUpdate is fired on a timer for *target units that don't have real events
	if (event ~= "OnTargetUpdate") then
		objectRanges[self] = nil
		UpdateRange(self)
	end
end

local ForceUpdate = function(self)
	return Update(self.__owner, "ForceUpdate", self.__owner.unit)
end

local Enable, Disable
do
	local objects = {}
	local updateFrame = CreateFrame("Frame")
	local updateRate = 0.25
	local updated = 0

	--- Updates the range display for all visible oUF unit frames on an interval.
	local OnUpdate = function(self, elapsed)
		updated = updated + elapsed

		if (updated >= updateRate) then
			updated = 0

			for object in pairs(objects) do
				if (object:IsVisible()) then
					UpdateRange(object)
				end
			end
		end
	end

	Enable = function(self, unit)
		local sr = self.SpellRange

		if (sr) then
			assert(type(sr) == "table", "Layout using invalid SpellRange element.")
			assert(type(sr.Update) == "function" or (tonumber(sr.insideAlpha) and tonumber(sr.outsideAlpha)), "Layout omitted required SpellRange properties.")

			-- Disable default range checking
			if (self.Range) then
				self:DisableElement("Range")
				self.Range = nil -- Prevent range element from enabling, since enable order isn't stable
			end

			sr.__owner = self
			sr.ForceUpdate = ForceUpdate

			updateFrame:SetScript("OnUpdate", OnUpdate)

			-- First object
			if (not next(objects)) then
				updateFrame:Show()
			end

			objects[self] = true

			return true
		end
	end

	Disable = function(self)
		objects[self] = nil
		objectRanges[self] = nil

		if (not next(objects)) then -- Last object
			updateFrame:Hide()
		end
	end
end

oUF:AddElement("SpellRange", Update, Enable, Disable)

Element.OnEnable = function(self)
	UpdateRangeCheckSpells()
end
