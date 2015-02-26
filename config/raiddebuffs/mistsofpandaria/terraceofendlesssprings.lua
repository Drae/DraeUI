local T, C, G, P, U, _ = unpack(select(2, ...))
local UF = T:GetModule("UnitFrames")

-- Terrace of Endless Spring

UF["raiddebuffs"]["instances"]["Terrace of Endless Spring"] = function()
	-- Protector Kaolan
	UF:AddRaidDebuff(true, 117519, 7, true) -- Touch of Sha
	UF:AddRaidDebuff(true, 111850, 3) -- Lightning Prison: Targeted
	UF:AddRaidDebuff(true, 117436, 3) -- Lightning Prison: Stunned
	UF:AddRaidDebuff(true, 118191, 6, true) -- Corrupted Essence
	UF:AddRaidDebuff(true, 117986, 6) -- Defiled Ground: Stacks
	UF:AddRaidDebuff(true, 117353, 7, true) -- Overwhelming corruption

	-- Tsulong
	UF:AddRaidDebuff(true, 122768, 3) -- Dread Shadows
	UF:AddRaidDebuff(true, 122777, 5) -- Nightmares (dispellable)
	UF:AddRaidDebuff(true, 122752, 6) -- Shadow Breath
	UF:AddRaidDebuff(true, 122789, 6) -- Sunbeam
	UF:AddRaidDebuff(true, 123012, 8, true) -- Terrorize: 5% (dispellable)
	UF:AddRaidDebuff(true, 123011, 8, true) -- Terrorize: 10% (dispellable)
	UF:AddRaidDebuff(true, 122858, 6) -- Bathed in Light

	-- Lei Shi
	UF:AddRaidDebuff(true, 123121, 4) -- Spray
	UF:AddRaidDebuff(true, 123705, 3, true) -- Scary Fog

	-- Sha of Fear
	UF:AddRaidDebuff(true, 119414, 6) -- Breath of Fear
	UF:AddRaidDebuff(true, 129147, 3, true) -- Onimous Cackle
	UF:AddRaidDebuff(true, 119983, 4) -- Dread Spray
	UF:AddRaidDebuff(true, 120669, 3) -- Naked and Afraid
	UF:AddRaidDebuff(true, 75683, 6) -- Waterspout
	UF:AddRaidDebuff(true, 120629, 7, true) -- Huddle in Terror
	UF:AddRaidDebuff(true, 132608, 7, true) -- Huddle in Terror
	UF:AddRaidDebuff(true, 120394, 6) -- Eternal Darkness
	UF:AddRaidDebuff(true, 119086, 4) -- Penetrating Bolt
	UF:AddRaidDebuff(true, 120268, 6, true) -- Champion of the Light
end
