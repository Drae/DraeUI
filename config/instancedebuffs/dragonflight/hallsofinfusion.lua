local DraeUI = select(2, ...)
local UF = DraeUI:GetModule("UnitFrames")

UF["raiddebuffs"]["instances"]["Halls of Infusion"] = function()
	--Trash
	UF:AddRaidDebuff(true, 374020, 5) --containment-beam
	UF:AddRaidDebuff(true, 393444, 5) --gushing-wound
	UF:AddRaidDebuff(true, 374706, 5) --pyretic-burst
	UF:AddRaidDebuff(true, 374149, 5) --tailwind
	UF:AddRaidDebuff(true, 374615, 5) --cheap-shot
	UF:AddRaidDebuff(true, 374563, 5) --dazzle
	UF:AddRaidDebuff(true, 374724, 5) --molten-subduction

	-- Watcher Irideus
	UF:AddRaidDebuff(true, 384524, 5) --titanic-fist
	UF:AddRaidDebuff(true, 383935, 5) --spark-volley
	UF:AddRaidDebuff(true, 389179, 5) --power-overload
	UF:AddRaidDebuff(true, 389181, 5) --power-field

	-- Gulping Goliath
	UF:AddRaidDebuff(true, 374389, 5) --gulp-swog-toxin
	UF:AddRaidDebuff(true, 385551, 5) --gulp
	UF:AddRaidDebuff(true, 385451, 5) --toxic-effluvia

	-- Khajin the Unyielding
	UF:AddRaidDebuff(true, 385963, 5) --frost-shock
	UF:AddRaidDebuff(true, 386741, 5) --polar-winds

	-- Primal Tsunami
	UF:AddRaidDebuff(true, 387359, 5) --waterlogged
	UF:AddRaidDebuff(true, 387571, 5) --focused-deluge
end
