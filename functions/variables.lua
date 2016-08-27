--[[


--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

-- Localize some vars
local match = string.match

-- "Constants"
T.playerClass = select(2, UnitClass("player"))
T.playerName = UnitName("player")
T.playerRealm = GetRealmName()

T.screenHeight = floor(GetScreenHeight()*100+.5)/100
T.screenWidth = floor(GetScreenWidth()*100+.5)/100
T.uiScale = tonumber(GetCVar("uiScale"))
