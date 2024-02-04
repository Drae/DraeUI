--[[


--]]
local DraeUI = select(2, ...)

--[[
		Default configuration settings
--]]
DraeUI.config = {
	general = {
		-- Textures
		statusbar = "striped",
		statusbar_power = "striped",
		statusbar_raid = "striped",
		statusbar_raid_power = "striped",

		font = "Proza",
		fontSmall = "LiberationSans",
		fontTitles = "Vollkorn",

		fontsize0 = 16,
		fontsize1 = 14,
		fontsize2 = 12,
		fontsize3 = 10,

		texcoords = { 0.1, 0.9, 0.1, 0.9 }
	},

	colors = {
		power = {
			ENERGY	    = { 1, 	  0.96, 0.41 },
			FOCUS 		= { 1, 	  0.50, 0.25 },
			FURY 		= { 0.79, 0.26, 0.99,  atlas = '_DemonHunter-DemonicFuryBar' },
			INSANITY 	= { 0.4,  0,    0.8,   atlas = '_Priest-InsanityBar' },
			LUNAR_POWER = { 0.3,  0.52, 0.9,   atlas = '_Druid-LunarBar' },
			MAELSTROM 	= { 0, 	  0.5,  1,     atlas = '_Shaman-MaelstromBar' },
			MANA 		= { 0, 	  0.56, 1.0 },
			PAIN 		= { 1, 	  0.61, 0,     atlas = '_DemonHunter-DemonicPainBar' },
			RAGE 		= { 0.78, 0.25, 0.25 },
			RUNIC_POWER = { 0, 	  0.82, 1 },
			ALT_POWER 	= { 0.2,  0.4,  0.8 },
		},
		reaction = {
			BAD 	= { 1, 0, 0 },
			NEUTRAL = { 1, 1, 0 },
			GOOD 	= { 0, 1, 0 },
		},
		charmed = { 1.0, 0, 0.4 },
		disconnected = { 0.9, 0.9, 0.9 },
		tapped = { 0.6, 0.6, 0.6 },
		debuffTypes = {
			["Magic"]	= { 0.2, 0.6, 1.0 },
			["Curse"]	= { 0.6, 0.0, 1.0 },
			["Disease"]	= { 0.6, 0.4, 0.0 },
			["Poison"]	= { 0.0, 0.6, 0.0 },
		},
	},

	infobar = {
		xp = {
			enable = true,
			altxp = "reputation"
		}
	},

	-- Unit Frame settings
	frames = {
		numFormatLong = false,
		-- Display or hide frames
		showBoss = true, -- Boss frames
		-- Player and Target are positioned relative to center of screen,
		-- all other frames are positioned relative to those
		playerXoffset = -430,
		playerYoffset = -205,
		targetXoffset = 430,
		targetYoffset = -205,
		totXoffset = 30, -- Relative to right of target
		totYoffset = 0,
		focusXoffset = 0, -- Relative to left of target
		focusYoffset = -150,
		focusTargetXoffset = 30, -- Relative to right of focus target
		focusTargetYoffset = 0,
		petXoffset = 0, --62, 	-- Relative to left of player
		petYoffset = -150, ---100,
		bossXoffset = 0, -- Relative to left of target
		bossYoffset = 200,
		arenaXoffset = 0, -- Relative to left of target
		arenaYoffset = 300,
		largeScale = 1.0,
		mediumScale = 1.0,
		smallScale = 1.0,
		-- Dimension of frames, large applies to player/target, small everything else
		-- don't change these, change the scale
		largeWidth = 280,
		smallWidth = 140,
		-- Aura settings
		auras = {
			-- Large are debuffs on players, buffs on targets, Sml are buffs on player,
			-- debuffs on target and tiny are buffs/debuffs on other units
			auraHge = 26,
			auraLrg = 22,
			auraSml = 20,
			auraTny = 18,
			maxPlayerBuff = 7,
			maxPlayerDebuff = 5,
			maxPetBuff = 2,
			maxPetDebuff = 2,
			maxTargetBuff = 7,
			maxTargetDebuff = 5,
			maxFocusBuff = 5,
			maxFocusDebuff = 3,
			maxFocusTargetBuff = 3,
			maxOtherBuff = 2,
			maxOtherDebuff = 2,
			maxBossBuff = 2,
			buffs_per_row = {
				["player"] = 4,
				["target"] = 4,
				["focus"] = 3,
				["focustarget"] = 3,
				["boss"] = 3,
				["other"] = 3 -- focus, focus target, pet, etc.
			},
			debuffs_per_row = {
				["player"] = 3,
				["target"] = 3,
				["focus"] = 3,
				["other"] = 3
			},
			showBuffsOnMe = true, -- Short term buffs on myself or my pet
			showDebuffsOnMe = true, -- Debuffs on myself or pet
			showBuffsOnFriends = true, -- Buffs on friends (excluding 0 duration auras)
			showDebuffsOnFriends = true,
			showBuffsOnEnemies = true,
			showDebuffsOnEnemies = false,
			-- These auras are never displayed regardless of any other settings
			blacklistAuraFilter = {
				["Chill of the Throne"] = true,
				["Strength of Wrynn"] = true,
				["Grasping Tendrils"] = true
			},
			filterType = "WHITELIST", -- dictates which filter we"ll use
			-- If debuff filtering is enabled only the debuffs in the following list will appear on targets
			whiteListFilter = {
				["DEBUFF"] = {},
				["BUFF"] = {}
			},
			blackListFilter = {
				["DEBUFF"] = {},
				["BUFF"] = {}
			}
		}
	},
}
