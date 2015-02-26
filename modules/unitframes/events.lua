--[[
		Common event handling, specific events are handled
		in their local functions
--]]
local _, ns = ...
local oUF = ns.oUF or oUF

--
local T, C, G, P, U, _ = select(2, ...):UnPack()
local UF = T:GetModule("UnitFrames")

-- Localise a bunch of functions
local _G = _G
local UnitIsDead, UnitIsGhost, UnitIsConnected, UnitCanAttack = UnitIsDead, UnitIsGhost, UnitIsConnected, UnitCanAttack
local select, format, gsub, gupper = select, string.format, string.gsub, string.upper

--[[

--]]
-- This is the unitframe health
UF.PostUpdateHealth = function(health, u, min, max)
	local self = health:GetParent()

	if (not UnitIsConnected(u)) then
		health.value:SetText("|cffaaaaaaOffline|r")
	elseif (UnitIsGhost(u)) then
		health.value:SetText("|cffaaaaaaGhost|r")
	elseif (UnitIsDead(u)) then
		health.value:SetText("|cffaaaaaaDead|r")
	else
		local hpvalue = min ~= max and ("|cffB62220%s|r.%d|cff0090ff%%|r"):format(T.ShortVal(min - max), min / max * 100) or ("|cffffffff%s"):format(T.ShortVal(min))
		health.value:SetText(hpvalue)
	end
end
