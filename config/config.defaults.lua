--[[


--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

--[[
		Default configuration settings

		Try not to change settings in this file, instead create
		a new file in this folder called config.lua. Then copy
		the section/s containing the variables you want to alter
		into that new file. You don't need to copy the entire
		section just the variable/s you want to change.
--]]
C["general"] = {
	-- Textures
	statusbar = "Striped",
	font = "Proza",
	fontsize0 = 16,
	fontsize1 = 13,
	fontsize2 = 12,
	fontsize3 = 10,
	fontsize4 = 9
}

-- Unit Frame settings
C["frames"] = {
	numFormatLong = false,
	-- Display or hide frames
	showBoss = true, -- Boss frames
	showArena = true,
	-- Player and Target are positioned relative to center of screen,
	-- all other frames are positioned relative to those
	playerXoffset = -350,
	playerYoffset = -250,
	targetXoffset = 350,
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
	arenaXoffset = 0, -- Relative to left of player
	arenaYoffset = 140,
	largeScale = 1.0,
	mediumScale = 1.0,
	smallScale = 1.0,
	-- Dimension of frames, large applies to player/target, small everything else
	-- don't change these, change the scale
	largeWidth = 250,
	largeHeight = 20,
	mediumWidth = 180,
	mediumHeight = 20,
	smallWidth = 120,
	smallHeight = 20,
	-- Aura settings
	auras = {
		-- Large are debuffs on players, buffs on targets, Sml are buffs on player,
		-- debuffs on target and tiny are buffs/debuffs on other units
		auraHge = 24,
		auraLrg = 22,
		auraSml = 20,
		auraTny = 18,
		auraMag = 1.8, -- Multiplier for the magnified view of auras
		maxPlayerBuff = 6,
		maxPlayerDebuff = 3,
		maxPetBuff = 3,
		maxPetDebuff = 2,
		maxTargetBuff = 2,
		maxTargetDebuff = 6,
		maxFocusBuff = 3,
		maxFocusDebuff = 3,
		maxFocusTargetBuff = 3,
		maxOtherBuff = 3,
		maxOtherDebuff = 3,
		maxBossBuff = 1,
		maxArenaBuff = 3,
		buffs_per_row = {
			["player"] = 6,
			["target"] = 3,
			["focus"] = 3,
			["focustarget"] = 3,
			["boss"] = 3,
			["other"] = 3 -- focus, focus target, pet, etc.
		},
		debuffs_per_row = {
			["player"] = 3,
			["target"] = 6,
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
}

C["raidframes"] = {
	-- General frame parameters
	width = 45,
	height = 45,
	gridLayout = "HORIZONTAL", -- groups are arranged horizontally - one above (or below) the other,
	-- VERTICAL would have groups appear to the right (or left) of each other
	gridGroupsAnchor = "BOTTOMRIGHT", -- This is the anchor point for each group - groups will grow from this point
	padding = 2, -- Distance between frames - the highlight border is 3px, so keep it >3
	showPets = true, -- Pets will be shown as seperate units, vehicles will appear as pets if enabled
	colorSmooth = true,
	colorPet = false,
	colorCharmed = true,
	indicatorLrg = 5,
	indicatorSml = 3,
	-- X, Y position of frames - the 1, 2, 3, etc. tables
	-- Equates to the total number of groups in the raid (not each group!). If you do not
	-- specify a position for a total number of groups the position of the last highest
	-- will be used
	position = {
		[1] = {"BOTTOMRIGHT", UIParent, "CENTER", -223, -170}, --275
		[6] = {"BOTTOMRIGHT", UIParent, "CENTER", -223, -170}
	},
	-- Button parameters
	raidnamelength = 4,
	showRaidHealthPct = false, -- Show health as a "remaining percentage" rather than an "absolute deficit"
	showOnlyDispellable = false -- true to only show dispellable unknown debuffs
}

-- Player, target and focus castbar
C["castbar"] = {
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
		anchorat = "LEFT",
		anchorto = "RIGHT"
	}
}

C["infobar"] = {
	xp = {
		enable = true,
		altxp = "reputation"
	}
}

