--[[


--]]
local DraeUI, db, dbGlobal, dbClass, dbChar = select(2, ...):UnPack()

--[[
		Default configuration settings
--]]
DraeUI.defaults.profile = {
	general = {
		-- Textures
		statusbar = "striped",
		font = "Proza",
		fontsize0 = 16,
		fontsize1 = 13,
		fontsize2 = 12,
		fontsize3 = 10,
		fontsize4 = 9,
		texcoords = {0.1, 0.9, 0.1, 0.9}
	},

	-- Unit Frame settings
	frames = {
		numFormatLong = false,
		-- Display or hide frames
		showBoss = true, -- Boss frames
		showArena = false,
		-- Player and Target are positioned relative to center of screen,
		-- all other frames are positioned relative to those
		playerXoffset = -360,
		playerYoffset = -250,
		targetXoffset = 360,
		targetYoffset = -250,
		totXoffset = 30, -- Relative to right of target
		totYoffset = 0,
		focusXoffset = 0, -- Relative to left of target
		focusYoffset = -120,
		focusTargetXoffset = 30, -- Relative to right of focus target
		focusTargetYoffset = 0,
		petXoffset = 0, --62, 	-- Relative to left of player
		petYoffset = -120, ---100,
		bossXoffset = 0, -- Relative to left of target
		bossYoffset = 300,
		arenaXoffset = 0, -- Relative to left of target
		arenaYoffset = 300,
		largeScale = 1.0,
		mediumScale = 1.0,
		smallScale = 1.0,
		-- Dimension of frames, large applies to player/target, small everything else
		-- don't change these, change the scale
		largeWidth = 260,
		largeHeight = 20,
		mediumWidth = 180,
		mediumHeight = 20,
		smallWidth = 120,
		smallHeight = 20,
		-- Aura settings
		auras = {
			-- Large are debuffs on players, buffs on targets, Sml are buffs on player,
			-- debuffs on target and tiny are buffs/debuffs on other units
			auraHge = 28,
			auraLrg = 25,
			auraSml = 22,
			auraTny = 18,
			auraMag = 1.8, -- Multiplier for the magnified view of auras
			maxPlayerBuff = 8,
			maxPlayerDebuff = 6,
			maxPetBuff = 3,
			maxPetDebuff = 3,
			maxTargetBuff = 8,
			maxTargetDebuff = 6,
			maxFocusBuff = 3,
			maxFocusDebuff = 3,
			maxFocusTargetBuff = 3,
			maxOtherBuff = 3,
			maxOtherDebuff = 3,
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
			showDebuffsOnEnemies = true,
			showStealableBuffs = true,
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

	raidframes = {
		-- General frame parameters
		width = 50,
		height = 50,
		petHeight = 25,
		gridLayout = "HORIZONTAL", -- groups are arranged horizontally - one above (or below) the other,
		-- VERTICAL would have groups appear to the right (or left) of each other
		gridGroupsAnchor = "BOTTOMRIGHT", -- This is the anchor point for each group - groups will grow from this point
		padding = 10, -- Distance between frames - the highlight border is 3px, so keep it >3
		petOffset = 16, -- Offset from player frames for pet/vehicle frames
		showPets = true, -- Pets will be shown as seperate units, vehicles will appear as pets if enabled
		powerHeight = 4,	-- Height of power bar (shown only for healers)
		colorSmooth = false,
		colorPet = false,
		colorCharmed = true,
		indicatorLrg = 5,
		-- X, Y position of frames - the 1, 2, 3, etc. tables
		-- Equates to the total number of groups in the raid (not each group!). If you do not
		-- specify a position for a total number of groups the position of the last highest
		-- will be used
		position = {
			[1] = {"BOTTOMRIGHT", UIParent, "CENTER", -228, -150}, --275
			[6] = {"BOTTOMLEFT", UIParent, "LEFT", 50, -150}
		},
		scale = {
			[1] = 1,
			[6] = 0.8
		},
		-- Button parameters
		raidnamelength = 4,
		showRaidHealthPct = false, -- Show health as a "remaining percentage" rather than an "absolute deficit"
		showOnlyDispellable = true, -- true to only show dispellable unknown debuffs
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
	},

	-- Player, target and focus castbar
	castbar = {
		player = {
			width = 150,
			height = 7,
			xOffset = 0,
			yOffset = 40,
			anchor = "DraePlayer",
			anchorat = "RIGHT",
			anchorto = "RIGHT"
		},
		target = {
			width = 150,
			height = 7,
			xOffset = 0,
			yOffset = 40,
			anchor = "DraeTarget",
			anchorat = "LEFT",
			anchorto = "LEFT"
		},
		focus = {
			width = 150,
			height = 7,
			xOffset = 2,
			yOffset = 35,
			anchor = "DraeFocus",
			anchorat = "LEFT",
			anchorto = "LEFT"
		},
		boss = {
			width = 150,
			height = 7,
			xOffset = 2,
			yOffset = 10,
			anchorat = "RIGHT",
			anchorto = "LEFT"
		},
		arena = {
			width = 150,
			height = 7,
			xOffset = 2,
			yOffset = 10,
			anchorat = "RIGHT",
			anchorto = "LEFT"
		}
	},

	infobar = {
		xp = {
			enable = true,
			altxp = "reputation"
		}
	}
}
