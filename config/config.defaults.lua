--[[


--]]
local T, C, G, P, U, _ = select(2, ...):unpack()

-- Register with SharedMedia
local LSM = LibStub("LibSharedMedia-3.0")

--[[
		Default configuration settings
--]]

-- Media and font sizing
C["media"] = {
	texture = LSM:Fetch("statusbar", "Striped"),

	-- Fonts
	font = LSM:Fetch("font", "Diavlo"),
	fontOther = LSM:Fetch("font", "Liberation Sans"),
	fontsize1 = 13,
	fontsize2 = 12,
	fontsize3 = 10,
	fontsize4 = 9,

	-- Unitframe border colour
	color_rb = 0.40,	-- default 0.40
	color_gb = 0.40,	-- default 0.40
	color_bb = 0.40,	-- default 0.40
	color_ab = 1.00,	-- default 1.00
}

-- Unit Frame settings
C["frames"] = {
	-- Display or hide frames
	showBoss			= true, 	-- Boss frames
	showArena			= true,

	-- Player and Target are positioned relative to center of screen,
	-- all other frames are positioned relative to those
	playerXoffset		= -420,
	playerYoffset		= -140,
	targetXoffset		= 420,
	targetYoffset		= -140,
	totXoffset			= 20, 	-- Relative to right side of target
	totYoffset			= 0,
	focusXoffset		= 0,  	-- Relative to left of target
	focusYoffset		= -40,
	focusTargetXoffset	= 0, 	-- Relative to right of target
	focusTargetYoffset	= -40,
	petXoffset			= 0, 	-- Relative to left of player
	petYoffset			= -40,
	petTargetXoffset	= 0,  	-- Relative to right of player
	petTargetYoffset	= -40,
	bossXoffset			= 20,	-- Relative to target of target
	bossYoffset			= 0,
	arenaXoffset		= 0, -- Relative to player
	arenaYoffset		= 140,

	largeScale 			= 1.0,
	mediumScale 		= 1.0,
	smallScale 			= 1.0,

	-- Dimension of frames, large applies to player/target, small everything else
	-- don't change these, change the scale
	largeWidth 			= 200,
	largeHeight 		= 20,
	mediumWidth			= 140,
	mediumHeight		= 20,
	smallWidth 			= 90,
	smallHeight 		= 20,

	-- Aura settings
	auras = {
		-- Large are debuffs on players, buffs on targets, Sml are buffs on player,
		-- debuffs on target and tiny are buffs/debuffs on other units
		auraHge = 26,
		auraLrg = 24,
		auraSml = 22,
		auraTny = 18,

		auraMag = 1.8, -- Multiplier for the magnified view of auras

		maxPlayerBuff		 	= 10,
		maxPlayerDebuff 		= 4,
		maxTargetBuff			= 4,
		maxTargetDebuff			= 10,
		maxOtherBuff			= 2, -- focus, focus target, pet, etc.
		maxOtherDebuff			= 2,
		maxBossBuff				= 1,
		maxArenaBuff			= 4,

		buffs_per_row = {
			["player"]	= 4,
			["target"]	= 2,
			["boss"]	= 2,
			["other"]	= 2, -- focus, focus target, pet, etc.
		},

		debuffs_per_row = {
			["player"]	= 2,
			["target"]	= 4,
			["other"]	= 2,
		},

		showBuffsOnMe 			= true, -- Short term buffs on myself or my pet
		showDebuffsOnMe 		= true, -- Debuffs on myself or pet
		showBuffsOnFriends		= true, -- Buffs on friends (excluding 0 duration auras)
		showDebuffsOnFriends	= true,
		showBuffsOnEnemies		= true,
		showDebuffsOnEnemies	= true,

		showStealableBuffs		= true,

		-- These auras are never displayed regardless of any other settings
		blacklistAuraFilter = {
			["Chill of the Throne"] = true,
			["Strength of Wrynn"] 	= true,
		},

		filterType = "WHITELIST", -- dictates which filter we"ll use

		-- If debuff filtering is enabled only the debuffs in the following list will appear on targets
		whiteListFilter = {
			["DEBUFF"] = {
				["Repentance"]				= true,
				["Cyclone"]					= true,
				["Polymorph"]				= true,
				["Hex"]						= true,
				["Chilled"]					= true,
				["Ice Trap"]				= true,
				["Wyvern Sting"]			= true,
				["Mortal Strike"] 			= true,
				["Unbound Plague"]			= true, -- Putricide plague
				["Plague Sickness"]			= true, -- Putricide plague
				["Necrotic Plague"]			= true, -- Lick King P1
				["Feedback"]				= true,
				["Destabilize"]				= true,
				["Scary Fog"]				= true,
				["Weakened Soul"]			= true,
			},
			["BUFF"] = {
				["Vengeance"]				= true,
				["Beacon of Light"]			= true,
				["Thorns"]					= true,
				["Hand of Protection"]		= true,
				["Hand of Freedom"]			= true,
				["Hand of Sacrifice"]		= true,
				["Hand of Salvation"]		= true,
				["Illuminated Healing"]		= true,
				["Power Word: Barrier"]		= true,
				["Aspect of the Hawk"]		= true,
				["Aspect of the Fox"]		= true,
				["Aspect of the Pack"]		= true,
				["Aspect of the Cheetah"]	= true,
				["Aspect of the Wild"]		= true,
				["Rune of Power"]			= true,
				["Light of the Ancient Kings"] = true, -- Haste buff from Holy GoAK
				["Invoker's Energy"]		= true, -- Invocation buff
				["The Light of Day"]		= true,
				["Renewing Mist"]			= true,
			}
		},
		blackListFilter = {
			["DEBUFF"] = {
			},
			["BUFF"] = {
			}
		},
	},
}

-- Player, target and focus castbar
C["castbar"] = {
	player = {
		width	 = 200,
		height	 = 18,
		xOffset  = 0,
		yOffset  = -140,
		anchor 	 = "UIParent",
		anchorat = "CENTER",
		anchorto = "CENTER",
	},
	target = {
		width	 = 200,
		height	 = 14,
		xOffset  = 0,
		yOffset  = -165,
		anchor 	 = "UIParent",
		anchorat = "CENTER",
		anchorto = "CENTER",
	},
	focus = {
		width	 = 200,
		height	 = 14,
		xOffset  = 0,
		yOffset  = -188,
		anchor 	 = "UIParent",
		anchorat = "CENTER",
		anchorto = "CENTER",
	},
	arena = {
		height	 = 8,
		xOffset  = 0,
		yOffset  = -15,
	},

	showLatency		= true,
	showIcon		= false,
}

-- Secondary resource bar
C["resourcebar"] = {
	xOffset  = -400,
	yOffset  = -45,
}

-- Equipment set mappings
C["equipSets"] = {
	["PALADIN"]	= {
		[1] = "Holy",
		[2] = "Protection",
		[3] = "Retribution",
	},
	["MAGE"]	= {
		[1] = "Arcane",
		[2] = "Fire",
		[3] = "Frost",
	},
	["MONK"]	= {
		[1]	= "Brewmaster",
		[2]	= "Mistweaver",
		[3]	= "Windwalker",
	},
}

-- Information bar (fps, mem use, etc.)
C["infobar"] = {
	showXP = true,
	showReputation = true,
}

-- Buff bar
C["buffbar"] = {
	buffAnchor 		= { "TOPRIGHT", Minimap, "TOPLEFT", -30, 10 },
	buffGrowDir 	= 1,	-- growth direction: 0 -> from left to right, 1 -> from right to left
	buffXoffset 	= 42,	-- horizontal distance between icons
	buffScale		= 0.95,

	iconsPerRow 	= 10,		-- maximum number of icons in one row before a new row starts
	sortMethod 		= "NAME",	-- how to sort the buffs/debuffs, possible values are "NAME", "INDEX" or "TIME"
	sortReverse 	= false,	-- reverse sort order
	showWeaponEnch 	= true,		-- show or hide temporary weapon enchants
	colorBorderItem = true,		-- Colour border of item enchants
}

-- Nameplates
C["nameplates"] = {
	fontsize = 10,
	fontsize2 = 8,

	hpHeight = 9,
	hpWidth = 120,
	cbHeight = 4,

	iconSize = 16, --Size of all Icons, RaidIcon/Castbar Icon

	auranum = 3,
	auraiconsize = 18,

	fadeIn = true, -- Fade plates in as they are shown
	fadeAlways = false, -- Always cause non-target frameplates to appear slightly faded
	combat = false,
	enhancethreat = true,

	showtrivial = false,

	display = {
		pulsate = true,
		decimal = true,
		timerThreshold = 60,
		lengthMin = 0,
		lengthMax = -1,
	},

	behav = {
		useWhitelist = true,
	},

	blacklist = {
		--Shaman Totems (Ones that don"t matter)
		["Earth Elemental Totem"] = true,
		["Fire Elemental Totem"] = true,
		["Fire Resistance Totem"] = true,
		["Flametongue Totem"] = true,
		["Frost Resistance Totem"] = true,
		["Healing Stream Totem"] = true,
		["Magma Totem"] = true,
		["Mana Spring Totem"] = true,
		["Nature Resistance Totem"] = true,
		["Searing Totem"] = true,
		["Stoneclaw Totem"] = true,
		["Stoneskin Totem"] = true,
		["Strength of Earth Totem"] = true,
		["Windfury Totem"] = true,
		["Totem of Wrath"] = true,
		["Wrath of Air Totem"] = true,
		["Air Totem"] = true,
		["Water Totem"] = true,
		["Fire Totem"] = true,
		["Earth Totem"] = true,

		--Army of the Dead
		["Army of the Dead Ghoul"] = true,
	},

	auras = {
		whitelist = {
		--[[ Important spells ----------------------------------------------------------
			Target auras which the player needs to keep track of.

			-- LEGEND --
			gp = guaranteed passive
			nd = no damage
			td = tanking dot
			ma = modifies another ability when active
		]]
			DRUID = { -- 5.2 COMPLETE
				[770] = true, -- faerie fire
				[1079] = true, -- rip
				[1822] = true, -- rake
				[8921] = true, -- moonfire
				[9007] = true, -- pounce bleed
				[77758] = true, -- bear thrash; td ma
				[106830] = true, -- cat thrash
				[93402] = true, -- sunfire
				[33745] = true, -- lacerate
				[102546] = true, -- pounce

				[339] = true, -- entangling roots
				[2637] = true, -- hibernate
				[6795] = true, -- growl
				[16914] = true, -- hurricane
				[19975] = true, -- nature's grasp roots
				[22570] = true, -- maim
				[33786] = true, -- cyclone
				--[58180] = true, -- infected wounds; gp nd
				[78675] = true, -- solar beam silence
				[102795] = true, -- bear hug

				[1126] = true, -- mark of the wild
				[29166] = true, -- innervate
				[110309] = true, -- symbiosis

				[774] = true, -- rejuvenation
				[8936] = true, -- regrowth
				[33763] = true, -- lifebloom
				[48438] = true, -- wild growth
				[102342] = true, -- ironbark

				-- talents
				--[16979] = true, -- wild charge: bear; gp nd
				--[49376] = true, -- wild charge: cat; gp nd
				[102351] = true, -- cenarion ward
				[102355] = true, -- faerie swarm
				[102359] = true, -- mass entanglement
				[61391] = true, -- typhoon daze
				[99] = true, -- disorienting roar
				[5211] = true, -- mighty bash
			},
			HUNTER = { -- 5.2 COMPLETE
				[1130] = true, -- hunter's mark
				[3674] = true, -- black arrow
				[53301] = true, -- explosive shot
				[63468] = true, -- piercing shots
				[118253] = true, -- serpent sting

				[5116] = true, -- concussive shot
				[19503] = true, -- scatter shot
				[20736] = true, -- distracting shot
				[24394] = true, -- intimidation
				[35101] = true, -- concussive barrage
				[64803] = true, -- entrapment
				[82654] = true, -- widow venom
				[131894] = true, -- murder by way of crow

				[3355] = true, -- freezing trap
				[13812] = true, -- explosive trap
				[135299] = true, -- ice trap TODO isn't classed as caused by player

				[34477] = true, -- misdirection

				-- talents
				[136634] = true, -- narrow escape
				[34490] = true, -- silencing shot
				[19386] = true, -- wyvern sting
				[117405] = true, -- binding shot
				[117526] = true, -- binding shot stun
				[120761] = true, -- glaive toss slow
				[121414] = true, -- glaive toss slow 2
			},
			MAGE = { -- 5.2 COMPLETE
				[116] = true, -- frostbolt debuff
				[11366] = true, -- pyroblast
				[12654] = true, -- ignite
				[31589] = true, -- slow
				[83853] = true, -- combustion
				[132210] = true, -- pyromaniac

				[118] = true, -- polymorph
				[28271] = true, -- polymorph: turtle
				[28272] = true, -- polymorph: pig
				[61305] = true, -- polymorph: cat
				[61721] = true, -- polymorph: rabbit
				[61780] = true, -- polymorph: turkey
				[44572] = true, -- deep freeze

				[1459] = true, -- arcane brilliance

				-- talents
				[111264] = true, -- ice ward
				[114923] = true, -- nether tempest
				[44457] = true, -- living bomb
				[112948] = true, -- frost bomb
			},
			DEATHKNIGHT = { -- 5.2 COMPLETE
				[55095] = true, -- frost fever
				[55078] = true, -- blood plague
				[114866] = true, -- soul reaper

				[43265] = true, -- death and decay
				[45524] = true, -- chains of ice
				[49560] = true, -- death grip taunt
				[50435] = true, -- chillblains
				[56222] = true, -- dark command
				[108194] = true, -- asphyxiate stun

				[3714] = true, -- path of frost
				[57330] = true, -- horn of winter

				-- talents
				[115000] = true, -- remorseless winter slow
				[115001] = true, -- remorseless winter stun
			},
			WARRIOR = { -- 5.2 COMPLETE
				[86346] = true,  -- colossus smash
				[113746] = true, -- weakened armour

				[355] = true,    -- taunt
				[676] = true,    -- disarm
				[1160] = true,   -- demoralizing shout
				[1715] = true,   -- hamstring
				[5246] = true,   -- intimidating shout
				[7922] = true,   -- charge stun
				[18498] = true,  -- gag order
				[64382] = true,  -- shattering throw
				[115767] = true, -- deep wounds; td
				[137637] = true, -- warbringer slow

				[469] = true,    -- commanding shout
				[3411] = true,   -- intervene
				[6673] = true,   -- battle shout

								 -- talents
				[12323] = true,  -- piercing howl
				[107566] = true, -- staggering shout
				[132168] = true, -- shockwave debuff
				[114029] = true, -- safeguard
				[114030] = true, -- vigilance
				[113344] = true, -- bloodbath debuff
				[132169] = true, -- storm bolt debuff
			},
			PALADIN = { -- 5.2 COMPLETE
				[114163] = true, -- eternal flame
				[53563] = { colour = {1,.5,0} },  -- beacon of light
				[20925] = { colour = {1,1,.3} },  -- sacred shield

				[19740] = { colour = {.2,.2,1} }, -- blessing of might
				[20217] = { colour = {1,.3,.3} }, -- blessing of kings

				[26573] = true,  -- consecration; td
				[31803] = true,  -- censure; td

								 -- hand of...
				[114039] = true, -- purity
				[6940] = true,   -- sacrifice
				[1044] = true,   -- freedom
				[1038] = true,   -- salvation
				[1022] = true,   -- protection

				[853] = true,    -- hammer of justice
				[2812] = true,   -- denounce
				[10326] = true,  -- turn evil
				[20066] = true,  -- repentance
				[31935] = true,  -- avenger's shield silence
				[62124] = true,  -- reckoning
				[105593] = true, -- fist of justice
				[119072] = true, -- holy wrath stun

				[114165] = true, -- holy prism
				[114916] = true, -- execution sentence dot
				[114917] = true, -- stay of execution hot

				[20217] = true,

			},
			WARLOCK = { -- 5.2 COMPLETE
				[5697]  = true,  -- unending breath
				[20707]  = true, -- soulstone
				[109773] = true, -- dark intent

				[172] = true,    -- corruption, demo. version
				[146739] = true, -- corruption
				[114790] = true,  -- Soulburn: Seed of Corruption
				[348] = true,    -- immolate
				[108686] = true, -- immolate (aoe)
				[980] = true,    -- agony
				[27243] = true,  -- seed of corruption
				[30108] = true,  -- unstable affliction
				[47960] = true,  -- shadowflame
				[48181] = true,  -- haunt
				[80240] = true,  -- havoc

				[1490] = true,   -- curse of the elements
				[18223] = true,  -- curse of exhaustion
				[109466] = true, -- curse of enfeeblement

				[710] = true,    -- banish
				[1098] = true,   -- enslave demon
				[5782] = true,   -- fear

								 -- metamorphosis:
				[603] = true,    -- doom
				[124915] = true, -- chaos wave
				[116202] = true, -- aura of the elements
				[116198] = true, -- aura of enfeeblement

								 -- talents:
				[5484] = true,   -- howl of terror
				[111397] = true, -- blood fear
			},
			SHAMAN = { -- 5.2 COMPLETE
				[8050] = true,   -- flame shock
				[8056] = true,   -- frost shock slow
				[63685] = true,  -- frost shock root
				[51490] = true,  -- thunderstorm slow
				[17364] = true,  -- stormstrike
				[61882] = true,  -- earthquake

				[3600] = true,   -- earthbind totem passive
				[64695] = true,   -- earthgrap totem root
				[116947] = true,   -- earthgrap totem slow

				[546] = true,    -- water walking
				[974] = true,    -- earth shield
				[51945] = true,  -- earthliving
				[61295] = true,  -- riptide

				[51514] = true,  -- hex
				[76780] = true,  -- bind elemental
			},
			PRIEST = { -- 5.2 COMPLETE
				[139] = true,    -- renew
				[6346] = true,   -- fear ward
				[33206] = true,  -- pain suppression
				[41635] = true,  -- prayer of mending buff
				[47753] = true,  -- divine aegis
				[47788] = true,  -- guardian spirit
				[114908] = true, -- spirit shell shield

				[17] = true,     -- power word: shield
				[21562] = true,  -- power word: fortitude

				[2096] = true,   -- mind vision
				[8122] = true,   -- psychic scream
				[9484] = true,   -- shackle undead
				[64044] = true,  -- psychic horror
				[111759] = true, -- levitate

				[589] = true,    -- shadow word: pain
				[2944] = true,   -- devouring plague
				[14914] = true,  -- holy fire
				[34914] = true,  -- vampiric touch

								 -- talents:
				[605] = true,    -- dominate mind
				[114404] = true, -- void tendril root
				[113792] = true, -- psychic terror
				[129250] = true, -- power word: solace
			},
			ROGUE = { -- 5.2 COMPLETE
				[703] = true,    -- garrote
				[1943] = true,   -- rupture
				[79140] = true,  -- vendetta
				[84617] = true,  -- revealing strike
				[89775] = true,  -- hemorrhage
				[113746] = true, -- weakened armour
				[122233] = true, -- crimson tempest

				[2818] = true,   -- deadly poison
				[3409] = true,   -- crippling poison
				[115196] = true, -- debilitating poison
				[5760] = true,   -- mind numbing poison
				[115194] = true, -- mind paralysis
				[8680] = true,   -- wound poison

				[408] = true,    -- kidney shot
				[1776] = true,   -- gouge
				[1833] = true,   -- cheap shot
				[2094] = true,   -- blind
				[6770] = true,   -- sap
				[26679] = true,  -- deadly throw
				[51722] = true,  -- dismantle
				[88611] = true,  -- smoke bomb

				[57934] = true,  -- tricks of the trade

								 -- talents:
				[112961] = true, -- leeching poison
				[113952] = true, -- paralytic poison
				[113953] = true, -- paralysis
				[115197] = true, -- partial paralysis
				[137619] = true, -- marked for death
			},
			MONK = { -- 5.2 COMPLETE
				[116189] = true, -- provoke taunt
				[116330] = true, -- dizzying haze debuff
				[123727] = true, -- keg smash - dizzying haze debuff
				[123725] = true, -- breath of fire
				[120086] = true, -- fists of fury stun
				[122470] = true, -- touch of karma
				[128531] = true, -- blackout kick debuff
				[130320] = true, -- rising sun kick debuff

				[116781] = true, -- legacy of the white tiger
				[116844] = true, -- ring of peace
				[117666] = true, -- legacy of the emperor group
				[117667] = true, -- legacy of the emperor target (um.)

				[116849] = true, -- life cocoon
				[132120] = true, -- enveloping mist
				[119611] = true, -- renewing mist

				[117368] = true, -- grapple weapon
				[116095] = true, -- disable
				[115078] = true, -- paralysis

								 -- talents:
				[116841] = true, -- tiger's lust
				[124081] = true, -- zen sphere
				[119392] = true, -- charging ox wave
				[119381] = true, -- leg sweep
			},

			GlobalSelf = {
				[28730] = true, -- arcane torrent
				[25046] = true,
				[50613] = true,
				[69179] = true,
				[80483] = true,
				[129597] = true,
				--[155145] = true, -- seems to not be implemented
				[20549] = true, -- war stomp
				[107079] = true, -- quaking palm
			},

		-- Important auras regardless of caster (cc, flags...) -------------------------
		--[[
			Global = {
				-- PVP --
				[34976] = true, -- Netherstorm Flag
				[23335] = true, -- Alliance Flag
				[23333] = true, -- Horde Flag
			},
		]]
		},
	},
}

-- Minimap (global variable space)
G["minimap"] = {
	buttons	= {
		["MiniMapTracking"] 			= { angle = 10 },  -- The tracking button/menu
		["MiniMapMailFrame"] 			= { angle = 310 }, -- New mail alert
		["QueueStatusMinimapButton"] 	= { angle = 235 }, -- Dungeon Finder
		["GameTimeFrame"] 				= { angle = 45 },  -- The Calendar
		["MiniMapInstanceDifficulty"] 	= { angle = 126 }, -- Instance difficulty
		["GuildInstanceDifficulty"] 	= { angle = 126 }, -- As above when in guild group
		["MiniMapChallengeMode"] 		= { angle = 126 }, -- As above when in doing challenge modes
		["TimeManagerClockButton"] 		= { anchorat = "BOTTOM", anchorto = "BOTTOM", posx = 0, posy = -11 }, -- The clock
	},
}

C["combatText"] = {
	showHealing = true,
	hideDebuffs = true,
}
