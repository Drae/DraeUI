--[[
Name: DRList-1.0
Description: Diminishing returns database. Fork of DRData-1.0.
Website: https://www.curseforge.com/wow/addons/drlist-1-0
Documentation: https://wardz.github.io/DRList-1.0/
Version: @project-version@
Dependencies: LibStub
License: MIT
]]

--- DRList-1.0
-- @module DRList-1.0
local MAJOR, MINOR = "DRList-1.0", 18
local Lib = assert(LibStub, MAJOR .. " requires LibStub."):NewLibrary(MAJOR, MINOR)
if not Lib then return end -- already loaded

-------------------------------------------------------------------------------
-- *** LOCALIZATIONS ARE AUTOMATICALLY GENERATED ***
-- Please see Curseforge localization page if you'd like to help translate.
-- https://www.curseforge.com/wow/addons/drlist-1-0/localization
local L = {}
Lib.L = L
L["DISARMS"] = "Disarms"
L["DISORIENTS"] = "Disorients"
L["INCAPACITATES"] = "Incapacitates"
L["KNOCKBACKS"] = "Knockbacks"
L["ROOTS"] = "Roots"
L["SILENCES"] = "Silences"
L["STUNS"] = "Stuns"
L["TAUNTS"] = "Taunts"

-- Classic
L["FEARS"] = "Fears"
L["RANDOM_ROOTS"] = "Random roots"
L["RANDOM_STUNS"] = "Random stuns"
L["MIND_CONTROL"] = GetSpellInfo(605)
L["FROST_SHOCK"] = GetSpellInfo(8056) or GetSpellInfo(196840)
L["KIDNEY_SHOT"] = GetSpellInfo(408)

-- luacheck: push ignore 542
local locale = GetLocale()
if locale == "deDE" then
    L["FEARS"] = "Furchteffekte"
    L["KNOCKBACKS"] = "Rückstoßeffekte"
    L["ROOTS"] = "Bewegungsunfähigkeitseffekte"
    L["SILENCES"] = "Stilleeffekte"
    L["STUNS"] = "Betäubungseffekte"
    L["TAUNTS"] = "Spotteffekte"
elseif locale == "frFR" then
    L["FEARS"] = "Peurs"
    L["KNOCKBACKS"] = "Projections"
    L["ROOTS"] = "Immobilisations"
    L["SILENCES"] = "Silences"
    L["STUNS"] = "Etourdissements"
    L["TAUNTS"] = "Provocations"
elseif locale == "itIT" then
    --@localization(locale="itIT", namespace="Categories", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "koKR" then
    L["DISORIENTS"] = "방향 감각 상실"
    L["INCAPACITATES"] = "행동 불가"
    L["KNOCKBACKS"] = "밀쳐내기"
    L["ROOTS"] = "이동 불가"
    L["SILENCES"] = "침묵"
    L["STUNS"] = "기절"
elseif locale == "ptBR" then
    --@localization(locale="ptBR", namespace="Categories", format="lua_additive_table", handle-unlocalized="ignore")@
elseif locale == "ruRU" then
    L["DISARMS"] = "Разоружение"
    L["DISORIENTS"] = "Дезориентация"
    L["FEARS"] = "Опасения"
    L["INCAPACITATES"] = "Паралич"
    L["KNOCKBACKS"] = "Отбрасывание"
    L["ROOTS"] = "Сковывание"
    L["SILENCES"] = "Немота"
    L["STUNS"] = "Оглушение"
    L["TAUNTS"] = "Насмешки"
elseif locale == "esES" then
    L["DISARMS"] = "Desarmar"
    L["DISORIENTS"] = "Desorientar"
    L["FEARS"] = "Miedos"
    L["INCAPACITATES"] = "Incapacitar"
    L["KNOCKBACKS"] = "Derribos"
    L["RANDOM_ROOTS"] = "Raíces aleatorias"
    L["RANDOM_STUNS"] = "Aturdir aleatorio"
    L["ROOTS"] = "Raíces"
    L["SILENCES"] = "Silencios"
    L["STUNS"] = "Aturdimientos"
    L["TAUNTS"] = "Provocaciones"
elseif locale == "esMX" then
    L["FEARS"] = "Miedos"
    L["KNOCKBACKS"] = "Derribos"
    L["ROOTS"] = "Raíces"
    L["SILENCES"] = "Silencios"
    L["STUNS"] = "Aturdimientos"
    L["TAUNTS"] = "Provocaciones"
elseif locale == "zhCN" then
    L["DISARMS"] = "缴械"
    L["DISORIENTS"] = "迷惑"
    L["FEARS"] = "恐惧"
    L["INCAPACITATES"] = "瘫痪"
    L["KNOCKBACKS"] = "击退"
    L["RANDOM_ROOTS"] = "随机定身"
    L["RANDOM_STUNS"] = "随机眩晕"
    L["ROOTS"] = "定身"
    L["SILENCES"] = "沉默"
    L["STUNS"] = "昏迷"
    L["TAUNTS"] = "嘲讽"
elseif locale == "zhTW" then
    L["DISARMS"] = "繳械"
    L["DISORIENTS"] = "迷惑"
    L["FEARS"] = "恐懼"
    L["INCAPACITATES"] = "癱瘓"
    L["KNOCKBACKS"] = "擊退"
    L["RANDOM_ROOTS"] = "隨機定身"
    L["RANDOM_STUNS"] = "隨機昏迷"
    L["ROOTS"] = "定身"
    L["SILENCES"] = "沉默"
    L["STUNS"] = "昏迷"
    L["TAUNTS"] = "嘲諷"
end
-- luacheck: pop
-------------------------------------------------------------------------------

-- Whether we're running Classic or Retail WoW
Lib.gameExpansion = select(4, GetBuildInfo()) < 80000 and "classic" or "retail"

-- How long it takes for a DR to expire
Lib.resetTimes = {
    retail = {
        ["default"] = 18.5,
        ["knockback"] = 10.5, -- Knockbacks are immediately immune and only DRs for 10s
    },

    classic = {
        ["default"] = 18.5,
    },
}

-- List of all DR categories, english -> localized.
-- Note: unlocalized categories used for the API are always singular,
-- and localized user facing categories are always plural. (Except spell names in classic)
Lib.categoryNames = {
    retail = {
        ["disorient"] = L.DISORIENTS,
        ["incapacitate"] = L.INCAPACITATES,
        ["silence"] = L.SILENCES,
        ["stun"] = L.STUNS,
        ["root"] = L.ROOTS,
        ["disarm"] = L.DISARMS,
        ["taunt"] = L.TAUNTS,
        ["knockback"] = L.KNOCKBACKS,
    },

    classic = {
        ["incapacitate"] = L.INCAPACITATES,
        ["silence"] = L.SILENCES,
        ["stun"] = L.STUNS, -- controlled stun
        ["root"] = L.ROOTS, -- controlled root
        ["random_stun"] = L.RANDOM_STUNS, -- random proc stun, usually short (<3s)
        ["random_root"] = L.RANDOM_ROOTS,
        ["fear"] = L.FEARS,
        ["mind_control"] = L.MIND_CONTROL,
        ["frost_shock"] = L.FROST_SHOCK,
        ["kidney_shot"] = L.KIDNEY_SHOT,
    },
}

-- Categories that have DR against mobs (not pets).
-- Note that only elites and quest bosses usually have root/taunt DR.
Lib.categoriesPvE = {
    retail = {
        ["taunt"] = L.TAUNTS,
        ["stun"] = L.STUNS,
        ["root"] = L.ROOTS,
    },

    classic = {
        ["stun"] = L.STUNS,
        ["kidney_shot"] = L.KIDNEY_SHOT,
    },
}

-- Successives diminished durations
Lib.diminishedDurations = {
    retail = {
        -- Decreases by 50%, immune at the 4th application
        ["default"] = { 0.50, 0.25 },
        -- Decreases by 35%, immune at the 5th application
        ["taunt"] = { 0.65, 0.42, 0.27 },
        -- Immediately immune
        ["knockback"] = {},
    },

    classic = {
        ["default"] = { 0.50, 0.25 },
    },
}

-------------------------------------------------------------------------------
-- Spell list
-------------------------------------------------------------------------------

if Lib.gameExpansion == "retail" then
    -- SpellID list for Retail WoW
    Lib.spellList = {
        -- Disorients
        [207167]  = "disorient",       -- Blinding Sleet
        [207685]  = "disorient",       -- Sigil of Misery
        [33786]   = "disorient",       -- Cyclone
        [1513]    = "disorient",       -- Scare Beast
        [31661]   = "disorient",       -- Dragon's Breath
        [198909]  = "disorient",       -- Song of Chi-ji
        [202274]  = "disorient",       -- Incendiary Brew
        [105421]  = "disorient",       -- Blinding Light
        [10326]   = "disorient",       -- Turn Evil (For Lichborne?)
        [605]     = "disorient",       -- Mind Control
        [8122]    = "disorient",       -- Psychic Scream
        [226943]  = "disorient",       -- Mind Bomb
        [2094]    = "disorient",       -- Blind
        [118699]  = "disorient",       -- Fear
        [5484]    = "disorient",       -- Howl of Terror
        [261589]  = "disorient",       -- Seduction (Grimoire of Sacrifice)
        [6358]    = "disorient",       -- Seduction (Succubus)
        [5246]    = "disorient",       -- Intimidating Shout
        [316593]  = "disorient",       -- Intimidating Shout 2 (not sure which one is correct in 9.0.1)
        [316595]  = "disorient",       -- Intimidating Shout 3
        [35474]   = "disorient",       -- Drums of Panic (Item)
        [269186]  = "disorient",       -- Holographic Horror Projector (Item)
        [280062]  = "disorient",       -- Unluckydo (Item)
        [267026]  = "disorient",       -- Giant Flower (Item)
        [243576]  = "disorient",       -- Sticky Starfish (Item)
        [331866]  = "disorient",       -- Agent of Chaos (Venthyr Covenant)

        -- Incapacitates
        [217832]  = "incapacitate",    -- Imprison
        [221527]  = "incapacitate",    -- Imprison (Honor talent)
        [2637]    = "incapacitate",    -- Hibernate
        [99]      = "incapacitate",    -- Incapacitating Roar
        [3355]    = "incapacitate",    -- Freezing Trap
        [203337]  = "incapacitate",    -- Freezing Trap (Honor talent)
        [213691]  = "incapacitate",    -- Scatter Shot
        [118]     = "incapacitate",    -- Polymorph
        [28271]   = "incapacitate",    -- Polymorph (Turtle)
        [28272]   = "incapacitate",    -- Polymorph (Pig)
        [61025]   = "incapacitate",    -- Polymorph (Snake)
        [61305]   = "incapacitate",    -- Polymorph (Black Cat)
        [61780]   = "incapacitate",    -- Polymorph (Turkey)
        [61721]   = "incapacitate",    -- Polymorph (Rabbit)
        [126819]  = "incapacitate",    -- Polymorph (Porcupine)
        [161353]  = "incapacitate",    -- Polymorph (Polar Bear Cub)
        [161354]  = "incapacitate",    -- Polymorph (Monkey)
        [161355]  = "incapacitate",    -- Polymorph (Penguin)
        [161372]  = "incapacitate",    -- Polymorph (Peacock)
        [277787]  = "incapacitate",    -- Polymorph (Baby Direhorn)
        [277792]  = "incapacitate",    -- Polymorph (Bumblebee)
        [82691]   = "incapacitate",    -- Ring of Frost
        [115078]  = "incapacitate",    -- Paralysis
        [20066]   = "incapacitate",    -- Repentance
        [9484]    = "incapacitate",    -- Shackle Undead
        [200196]  = "incapacitate",    -- Holy Word: Chastise
        [1776]    = "incapacitate",    -- Gouge
        [6770]    = "incapacitate",    -- Sap
        [51514]   = "incapacitate",    -- Hex
        [196942]  = "incapacitate",    -- Hex (Voodoo Totem)
        [210873]  = "incapacitate",    -- Hex (Raptor)
        [211004]  = "incapacitate",    -- Hex (Spider)
        [211010]  = "incapacitate",    -- Hex (Snake)
        [211015]  = "incapacitate",    -- Hex (Cockroach)
        [269352]  = "incapacitate",    -- Hex (Skeletal Hatchling)
        [309328]  = "incapacitate",    -- Hex (Living Honey)
        [277778]  = "incapacitate",    -- Hex (Zandalari Tendonripper)
        [277784]  = "incapacitate",    -- Hex (Wicker Mongrel)
        [197214]  = "incapacitate",    -- Sundering
        [710]     = "incapacitate",    -- Banish
        [6789]    = "incapacitate",    -- Mortal Coil
        [107079]  = "incapacitate",    -- Quaking Palm (Pandaren racial)
        [89637]   = "incapacitate",    -- Big Daddy (Item)
        [255228]  = "incapacitate",    -- Polymorphed (Organic Discombobulation Grenade) (Item)
        [71988]   = "incapacitate",    -- Vile Fumes (Item)

        -- Silences
        [47476]   = "silence",         -- Strangulate
        [204490]  = "silence",         -- Sigil of Silence
--      [78675]   = "silence",         -- Solar Beam (doesn't seem to DR)
        [202933]  = "silence",         -- Spider Sting
        [217824]  = "silence",         -- Shield of Virtue
        [15487]   = "silence",         -- Silence
        [1330]    = "silence",         -- Garrote
        [196364]  = "silence",         -- Unstable Affliction Silence Effect

        -- Stuns
        [210141]  = "stun",            -- Zombie Explosion
        [334693]  = "stun",            -- Absolute Zero (Breath of Sindragosa)
        [108194]  = "stun",            -- Asphyxiate (Unholy)
        [221562]  = "stun",            -- Asphyxiate (Blood)
        [91800]   = "stun",            -- Gnaw (Ghoul)
        [91797]   = "stun",            -- Monstrous Blow (Mutated Ghoul)
        [287254]  = "stun",            -- Dead of Winter
        [179057]  = "stun",            -- Chaos Nova
--      [213491]  = "stun",            -- Demonic Trample (Only DRs with itself once)
        [205630]  = "stun",            -- Illidan's Grasp (Primary effect)
        [208618]  = "stun",            -- Illidan's Grasp (Secondary effect)
        [211881]  = "stun",            -- Fel Eruption
        [200166]  = "stun",            -- Metamorphosis (PvE stun effect)
        [203123]  = "stun",            -- Maim
        [163505]  = "stun",            -- Rake (Prowl)
        [5211]    = "stun",            -- Mighty Bash
        [202244]  = "stun",            -- Overrun
        [24394]   = "stun",            -- Intimidation
        [119381]  = "stun",            -- Leg Sweep
        [202346]  = "stun",            -- Double Barrel
        [853]     = "stun",            -- Hammer of Justice
        [64044]   = "stun",            -- Psychic Horror
        [200200]  = "stun",            -- Holy Word: Chastise Censure
        [1833]    = "stun",            -- Cheap Shot
        [408]     = "stun",            -- Kidney Shot
        [118905]  = "stun",            -- Static Charge (Capacitor Totem)
        [118345]  = "stun",            -- Pulverize (Primal Earth Elemental)
        [305485]  = "stun",            -- Lightning Lasso
        [89766]   = "stun",            -- Axe Toss
        [171017]  = "stun",            -- Meteor Strike (Infernal)
        [171018]  = "stun",            -- Meteor Strike (Abyssal)
--      [22703]   = "stun",            -- Infernal Awakening (doesn't seem to DR)
        [30283]   = "stun",            -- Shadowfury
        [46968]   = "stun",            -- Shockwave
        [132168]  = "stun",            -- Shockwave (Protection)
        [145047]  = "stun",            -- Shockwave (Proving Grounds PvE)
        [132169]  = "stun",            -- Storm Bolt
        [199085]  = "stun",            -- Warpath
--      [213688]  = "stun",            -- Fel Cleave (doesn't seem to DR)
        [20549]   = "stun",            -- War Stomp (Tauren)
        [255723]  = "stun",            -- Bull Rush (Highmountain Tauren)
        [287712]  = "stun",            -- Haymaker (Kul Tiran)
        [280061]  = "stun",            -- Brainsmasher Brew (Item)
        [245638]  = "stun",            -- Thick Shell (Item)

        -- Roots
        -- Note: Short roots (<= 2s) usually have no DR, e.g Thunderstruck.
        [204085]  = "root",            -- Deathchill (Chains of Ice)
        [233395]  = "root",            -- Deathchill (Remorseless Winter)
        [339]     = "root",            -- Entangling Roots
        [170855]  = "root",            -- Entangling Roots (Nature's Grasp)
--      [45334]   = "root",            -- Immobilized (Wild Charge, doesn't seem to DR)
        [102359]  = "root",            -- Mass Entanglement
        [117526]  = "root",            -- Binding Shot (Note: debuff says stun but it's actually a root)
        [162480]  = "root",            -- Steel Trap
--      [190927]  = "root_harpoon",    -- Harpoon (TODO: check if DRs with itself)
        [212638]  = "root",            -- Tracker's Net
        [201158]  = "root",            -- Super Sticky Tar
        [122]     = "root",            -- Frost Nova
        [33395]   = "root",            -- Freeze
        [198121]  = "root",            -- Frostbite
        [220107]  = "root",            -- Frostbite (Water Elemental? needs testing)
        [342375]  = "root",            -- Tormenting Backlash (Torghast pve, needs confirmation)
        [233582]  = "root",            -- Entrenched in Flame
        [116706]  = "root",            -- Disable
        [64695]   = "root",            -- Earthgrab (Totem effect)
        [39965]   = "root",            -- Frost Grenade (Item)
        [75148]   = "root",            -- Embersilk Net (Item)
        [55536]   = "root",            -- Frostweave Net (Item)
        [268966]  = "root",            -- Hooked Deep Sea Net (Item)
        [270399]  = "root",            -- Unleashed Roots (Item)
        [270196]  = "root",            -- Chains of Light (Item)
        [267024]  = "root",            -- Stranglevines (Item)

        -- Disarms
        [209749]  = "disarm",          -- Faerie Swarm (Balance Honor Talent)
        [207777]  = "disarm",          -- Dismantle
        [233759]  = "disarm",          -- Grapple Weapon
        [236077]  = "disarm",          -- Disarm

        -- Taunts (PvE)
        [56222]   = "taunt",           -- Dark Command
        [51399]   = "taunt",           -- Death Grip
        [185245]  = "taunt",           -- Torment
        [6795]    = "taunt",           -- Growl (Druid)
        [2649]    = "taunt",           -- Growl (Hunter Pet) -- TODO: verify if DRs
        [20736]   = "taunt",           -- Distracting Shot
        [116189]  = "taunt",           -- Provoke
        [118635]  = "taunt",           -- Provoke (Black Ox Statue)
        [196727]  = "taunt",           -- Provoke (Niuzao)
        [204079]  = "taunt",           -- Final Stand
        [62124]   = "taunt",           -- Hand of Reckoning
        [17735]   = "taunt",           -- Suffering (Voidwalker)
        [355]     = "taunt",           -- Taunt
--      [36213]   = "taunt",           -- Angered Earth (Earth Elemental, has no debuff)

        -- Knockbacks (Experimental)
        [108199]  = "knockback",        -- Gorefiend's Grasp (Note: has no debuff)
        [202249]  = "knockback",        -- Overrun TODO: verify
        [61391]   = "knockback",        -- Typhoon
        [102793]  = "knockback",        -- Ursol's Vortex (Warning: May only be tracked on SPELL_AURA_REFRESH afaik)
        [186387]  = "knockback",        -- Bursting Shot
        [236777]  = "knockback",        -- Hi-Explosive Trap
        [157981]  = "knockback",        -- Blast Wave
        [237371]  = "knockback",        -- Ring of Peace (Note: has no debuff)
        [204263]  = "knockback",        -- Shining Force
        [51490]   = "knockback",        -- Thunderstorm
--      [287712]  = "knockback",        -- Haywire (Kul'Tiran Racial)
    }

else

    -- Spell list for Classic (WIP)
    -- In Classic the spell ID payload is gone from the combat log, so we need the key here to be
    -- spell name instead. We also provide spell ID in the table value so it's possible to retrieve
    -- for example spell icon using GetSpellTexture(spellID) later on. (These functions only accept
    -- spell names if the player has the spell in their spell book)
    Lib.spellList = {
        -- Controlled roots
        [GetSpellInfo(339)]     = { category = "root", spellID = 339 },      -- Entangling Roots
        [GetSpellInfo(19306)]   = { category = "root", spellID = 19306 },    -- Counterattack
        [GetSpellInfo(122)]     = { category = "root", spellID = 122 },      -- Frost Nova
    --  [GetSpellInfo(13099)]   = { category = "root", spellID = 13099 },    -- Net-o-Matic (These doesn't seem to DR here, maybe only with itself?)
    --  [GetSpellInfo(8312)]    = { category = "root", spellID = 8312 },     -- Trap

        -- Controlled stuns
        [GetSpellInfo(5211)]    = { category = "stun", spellID = 5211 },     -- Bash
        [GetSpellInfo(24394)]   = { category = "stun", spellID = 24394 },    -- Intimidation
        [GetSpellInfo(853)]     = { category = "stun", spellID = 853 },      -- Hammer of Justice
        [GetSpellInfo(22703)]   = { category = "stun", spellID = 22703 },    -- Inferno Effect (Summon Infernal) TODO: confirm
        [GetSpellInfo(9005)]    = { category = "stun", spellID = 9005 },     -- Pounce
        [GetSpellInfo(1833)]    = { category = "stun", spellID = 1833 },     -- Cheap Shot
        [GetSpellInfo(12809)]   = { category = "stun", spellID = 12809 },    -- Concussion Blow
        [GetSpellInfo(20253)]   = { category = "stun", spellID = 20253 },    -- Intercept Stun
        [GetSpellInfo(7922)]    = { category = "stun", spellID = 7922 },     -- Charge Stun (Afaik this now DRs with stuns but it shouldn't? may be a bug)
        [GetSpellInfo(20549)]   = { category = "stun", spellID = 20549 },    -- War Stomp (Racial)
        [GetSpellInfo(4068)]    = { category = "stun", spellID = 4068 },     -- Iron Grenade
        [GetSpellInfo(19769)]   = { category = "stun", spellID = 19769 },    -- Thorium Grenade
        [GetSpellInfo(13808)]   = { category = "stun", spellID = 13808 },    -- M73 Frag Grenade
        [GetSpellInfo(4069)]    = { category = "stun", spellID = 4069 },     -- Big Iron Bomb
        [GetSpellInfo(12543)]   = { category = "stun", spellID = 12543 },    -- Hi-Explosive Bomb
        [GetSpellInfo(4064)]    = { category = "stun", spellID = 4064 },     -- Rough Copper Bomb
        [GetSpellInfo(12421)]   = { category = "stun", spellID = 12421 },    -- Mithril Frag Bomb
        [GetSpellInfo(19784)]   = { category = "stun", spellID = 19784 },    -- Dark Iron Bomb
        [GetSpellInfo(4067)]    = { category = "stun", spellID = 4067 },     -- Big Bronze Bomb
        [GetSpellInfo(4066)]    = { category = "stun", spellID = 4066 },     -- Small Bronze Bomb
        [GetSpellInfo(4065)]    = { category = "stun", spellID = 4065 },     -- Large Copper Bomb
        [GetSpellInfo(13237)]   = { category = "stun", spellID = 13237 },    -- Goblin Mortar
        [GetSpellInfo(835)]     = { category = "stun", spellID = 835 },      -- Tidal Charm
        [GetSpellInfo(12562)]   = { category = "stun", spellID = 12562 },    -- The Big One

        -- Incapacitates
        [GetSpellInfo(2637)]    = { category = "incapacitate", spellID = 2637 },    -- Hibernate
        [GetSpellInfo(3355)]    = { category = "incapacitate", spellID = 3355 },    -- Freezing Trap
        [GetSpellInfo(19503)]   = { category = "incapacitate", spellID = 19503 },   -- Scatter Shot
        [GetSpellInfo(19386)]   = { category = "incapacitate", spellID = 19386 },   -- Wyvern Sting
        [GetSpellInfo(28271)]   = { category = "incapacitate", spellID = 28271 },   -- Polymorph: Turtle
        [GetSpellInfo(28272)]   = { category = "incapacitate", spellID = 28272 },   -- Polymorph: Pig
        [GetSpellInfo(118)]     = { category = "incapacitate", spellID = 118 },     -- Polymorph
        [GetSpellInfo(20066)]   = { category = "incapacitate", spellID = 20066 },   -- Repentance
        [GetSpellInfo(1776)]    = { category = "incapacitate", spellID = 1776 },    -- Gouge
        [GetSpellInfo(6770)]    = { category = "incapacitate", spellID = 6770 },    -- Sap
        [GetSpellInfo(1090)]    = { category = "incapacitate", spellID = 1090 },    -- Sleep
        [GetSpellInfo(13327)]   = { category = "incapacitate", spellID = 13327 },   -- Reckless Charge (Rocket Helmet)
        [GetSpellInfo(26108)]   = { category = "incapacitate", spellID = 26108 },   -- Glimpse of Madness

        -- Fears
        [GetSpellInfo(1513)]    = { category = "fear", spellID = 1513 },          -- Scare Beast
        [GetSpellInfo(8122)]    = { category = "fear", spellID = 8122 },          -- Psychic Scream
        [GetSpellInfo(5782)]    = { category = "fear", spellID = 5782 },          -- Fear
        [GetSpellInfo(5484)]    = { category = "fear", spellID = 5484 },          -- Howl of Terror
        [GetSpellInfo(6358)]    = { category = "fear", spellID = 6358 },          -- Seduction
        [GetSpellInfo(5246)]    = { category = "fear", spellID = 5246 },          -- Intimidating Shout
        [GetSpellInfo(5134)]    = { category = "fear", spellID = 5134 },          -- Flash Bomb Fear

        -- Random/short roots (TODO: confirm category exists)
        [GetSpellInfo(19229)]   = { category = "random_root", spellID = 19229 },   -- Improved Wing Clip
        [GetSpellInfo(23694)]   = { category = "random_root", spellID = 23694 },   -- Improved Hamstring
        [GetSpellInfo(27868)]   = { category = "random_root", spellID = 27868 },   -- Freeze (Item proc and set bonus)

        -- Random/short stuns (TODO: confirm category exists)
        [GetSpellInfo(16922)]   = { category = "random_stun", spellID = 16922 },   -- Improved Starfire
        [GetSpellInfo(19410)]   = { category = "random_stun", spellID = 19410 },   -- Improved Concussive Shot
        [GetSpellInfo(12355)]   = { category = "random_stun", spellID = 12355 },   -- Impact
        [GetSpellInfo(20170)]   = { category = "random_stun", spellID = 20170 },   -- Seal of Justice Stun
        --[GetSpellInfo(15269)]   = { category = "random_stun", spellID = 15269 }, -- Blackout
        [GetSpellInfo(18093)]   = { category = "random_stun", spellID = 18093 },   -- Pyroclasm
        [GetSpellInfo(12798)]   = { category = "random_stun", spellID = 12798 },   -- Revenge Stun
        [GetSpellInfo(5530)]    = { category = "random_stun", spellID = 5530 },    -- Mace Stun Effect (Mace Specialization)
        [GetSpellInfo(15283)]   = { category = "random_stun", spellID = 15283 },   -- Stunning Blow (Weapon Proc)
        [GetSpellInfo(56)]      = { category = "random_stun", spellID = 56 },      -- Stun (Weapon Proc)
        [GetSpellInfo(21152)]   = { category = "random_stun", spellID = 21152 },   -- Earthshaker (Weapon Proc)

        -- Silences (TODO: confirm category exists)
        [GetSpellInfo(18469)]   = { category = "silence", spellID = 18469 },      -- Counterspell - Silenced
        [GetSpellInfo(15487)]   = { category = "silence", spellID = 15487 },      -- Silence
        [GetSpellInfo(18425)]   = { category = "silence", spellID = 18425 },      -- Kick - Silenced
        [GetSpellInfo(24259)]   = { category = "silence", spellID = 24259 },      -- Spell Lock
        [GetSpellInfo(18498)]   = { category = "silence", spellID = 18498 },      -- Shield Bash - Silenced
        [GetSpellInfo(19821)]   = { category = "silence", spellID = 19821 },      -- Arcane Bomb Silence

        -- Spells that DRs with itself only
        --[GetSpellInfo(19675)] = { category = "feral_charge", spellID = 19675 },  -- Feral Charge Effect
        [GetSpellInfo(408)]     = { category = "kidney_shot", spellID = 408 },     -- Kidney Shot
        [GetSpellInfo(605)]     = { category = "mind_control", spellID = 605 },    -- Mind Control
        [GetSpellInfo(13181)]   = { category = "mind_control", spellID = 13181 },  -- Gnomish Mind Control Cap
        [GetSpellInfo(8056)]    = { category = "frost_shock", spellID = 8056 },    -- Frost Shock
    }
end

-------------------------------------------------------------------------------
-- Public API
-------------------------------------------------------------------------------

--- Get table of all spells that DRs.
-- Key is the spellID, and value is the unlocalized DR category.
-- For Classic the key is the localized spell name instead, and value
-- is a table containing both the DR category and spell ID.
-- @see IterateSpellsByCategory
-- @treturn ?table {number=string}|table {string=table}
function Lib:GetSpells()
    return Lib.spellList
end

--- Get table of all DR categories.
-- Key is unlocalized name used for API functions, value is localized name used for UI.
-- @treturn table {string=string}
function Lib:GetCategories()
    return Lib.categoryNames[Lib.gameExpansion]
end

--- Get table of all categories that DRs in PvE only.
-- Key is unlocalized name used for API functions, value is localized name used for UI.
-- Tip: you can combine :GetPvECategories() and :IterateSpellsByCategory() to get spellIDs only for PvE aswell.
-- @treturn table {string=string}
function Lib:GetPvECategories()
    return Lib.categoriesPvE[Lib.gameExpansion]
end

--- Get constant for how long a DR lasts.
-- @tparam[opt="default"] string category Unlocalized category name
-- @treturn number
function Lib:GetResetTime(category)
    return Lib.resetTimes[Lib.gameExpansion][category or "default"] or Lib.resetTimes[Lib.gameExpansion].default
end

--- Get unlocalized DR category by spell ID.
-- For Classic you should pass in the spell name instead of ID.
-- For Classic you also get an optional second return value
-- which is the spell ID of the spell name you passed in.
-- @tparam number spellID
-- @treturn[1] string|nil The category name.
-- @treturn[2] number|nil The spell ID. (Classic only)
function Lib:GetCategoryBySpellID(spellID)
    if Lib.gameExpansion == "retail" then
        return Lib.spellList[spellID]
    end

    local data = Lib.spellList[spellID]
    if data then return data.category, data.spellID end
end

--- Get localized category from unlocalized category name, case sensitive.
-- @tparam string category Unlocalized category name
-- @treturn ?string|nil The localized category name.
function Lib:GetCategoryLocalization(category)
    return Lib.categoryNames[Lib.gameExpansion][category]
end

--- Check if a category has DR against mobs.
-- Note that this is only for mobs, player pets have DR on all categories.
-- Also taunt, root & cyclone only have DR against special mobs.
-- See UnitClassification() and UnitIsQuestBoss().
-- @tparam string category Unlocalized category name
-- @treturn bool
function Lib:IsPvECategory(category)
    return Lib.categoriesPvE[Lib.gameExpansion][category] and true or false -- make sure bool is always returned here
end

--- Get next successive diminished duration
-- @tparam number diminished How many times the DR has been applied so far
-- @tparam[opt="default"] string category Unlocalized category name
-- @usage local reduction = DRList:GetNextDR(1) -- returns 0.50, half duration on debuff
-- @treturn number DR percentage in decimals. Returns 0 if max DR is reached or arguments are invalid.
function Lib:GetNextDR(diminished, category)
    local durations = Lib.diminishedDurations[Lib.gameExpansion][category or "default"]
    if not durations and Lib.categoryNames[Lib.gameExpansion][category] then
        -- Redirect to default when "stun", "root" etc is passed
        durations = Lib.diminishedDurations[Lib.gameExpansion]["default"]
    end

    return durations and durations[diminished] or 0
end

do
    local next = _G.next

    local function CategoryIterator(category, index)
        local newCat
        repeat
            index, newCat = next(Lib.spellList, index)
            if index then
                if newCat == category or newCat.category == category then
                    return index, category
                end
            end
        until not index
    end

    --- Iterate through the spells of a given category.
    -- @tparam string category Unlocalized category name
    -- @usage for spellID in DRList:IterateSpellsByCategory("root") do print(spellID) end
    -- @warning Slow function, do not use for combat related stuff unless you cache results.
    -- @return Iterator function
    function Lib:IterateSpellsByCategory(category)
        assert(Lib.categoryNames[Lib.gameExpansion][category], "invalid category")
        return CategoryIterator, category
    end
end

-- keep same API as DRData-1.0 for easier transitions
Lib.GetCategoryName = Lib.GetCategoryLocalization
Lib.IsPVE = Lib.IsPvECategory
Lib.NextDR = Lib.GetNextDR
Lib.GetSpellCategory = Lib.GetCategoryBySpellID
Lib.IterateSpells = Lib.IterateSpellsByCategory
Lib.RESET_TIME = Lib.resetTimes[Lib.gameExpansion].default
Lib.pveDR = Lib.categoriesPvE
