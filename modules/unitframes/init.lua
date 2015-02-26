--[[


--]]
local _, ns = ...
local oUF = ns.oUF or oUF

--
local T, C, G, P, U, _ = select(2, ...):UnPack()
local UF = T:NewModule("UnitFrames", "AceEvent-3.0", "AceTimer-3.0")

--[[
		Spawn the frames
--]]
UF.OnEnable = function(self)
	-- Player
	oUF:SetActiveStyle("DraePlayer")
	oUF:Spawn("player", "DraePlayer"):SetPoint("CENTER", UIParent, T.db["frames"].playerXoffset, T.db["frames"].playerYoffset)

	-- Target
	oUF:SetActiveStyle("DraeTarget")
	oUF:Spawn("target", "DraeTarget"):SetPoint("CENTER", UIParent, T.db["frames"].targetXoffset, T.db["frames"].targetYoffset)

	-- Target of target
	oUF:SetActiveStyle("DraeTargetTarget")
	oUF:Spawn("targettarget", "DraeTargetTarget"):Point("BOTTOMLEFT", "DraeTarget", "BOTTOMRIGHT", T.db["frames"].totXoffset, T.db["frames"].totYoffset)

	-- Focus
	oUF:SetActiveStyle("DraeFocus")
	oUF:Spawn("focus", "DraeFocus"):Point("TOPLEFT", "DraeTarget", "BOTTOMLEFT", T.db["frames"].focusXoffset, T.db["frames"].focusYoffset)

	-- Focus target
	oUF:SetActiveStyle("DraeFocus")
	oUF:Spawn("focustarget", "DraeFocusTarget"):Point("TOPRIGHT", "DraeTarget", "BOTTOMRIGHT", T.db["frames"].focusTargetXoffset, T.db["frames"].focusTargetYoffset)

	-- Pet
	oUF:SetActiveStyle("DraePet")
	oUF:Spawn("pet", "DraePet"):Point("TOPLEFT", "DraePlayer", "BOTTOMLEFT", T.db["frames"].petXoffset, T.db["frames"].petYoffset)

	-- Pet target
	oUF:SetActiveStyle("DraeFocus")
	oUF:Spawn("pettarget", "DraePetTarget"):Point("TOPRIGHT", "DraePlayer", "BOTTOMRIGHT", T.db["frames"].petTargetXoffset, T.db["frames"].petTargetYoffset)

	-- Boss frames
	if (T.db["frames"].showBoss) then
		oUF:SetActiveStyle("DraeBoss")

		local boss = {}
		for i = 1, MAX_BOSS_FRAMES do
			local frame = oUF:Spawn("boss" .. i, "DraeBoss" .. i)

			if (i == 1) then
				frame:Point("LEFT", "DraeTargetTarget", "RIGHT", T.db["frames"].bossXoffset, T.db["frames"].bossYoffset)
			else
				frame:Point("BOTTOM", boss[i - 1], "TOP", 0, 35)
			end

			boss[i] = frame
		end
	end

	-- Arena and arena prep frames
	if (T.db["frames"].showArena) then
		oUF:SetActiveStyle("DraeArenaPlayer")

		local arena = {}

		for i = 5, 1, -1 do
			local frame = oUF:Spawn("arena"..i, "DraeArenaPlayer"..i)

			if (i == 1) then
				frame:Point("LEFT", "DraePlayer", "LEFT", T.db["frames"].arenaXoffset, T.db["frames"].arenaYoffset)
			else
				frame:Point("BOTTOM", arena[i - 1], "TOP", 0, 35)
			end

			arena[i] = frame
		end

		Arena_LoadUI = function() end

		if (ArenaEnemyFrames) then
			ArenaEnemyFrames.Show = ArenaEnemyFrames.Hide
			ArenaEnemyFrames:UnregisterAllEvents()
			ArenaEnemyFrames:Hide()
		end
	end
end
