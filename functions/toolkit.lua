--[[
		From ElvUI
--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

--[[
	
]]
local Kill = function(object)
	if (object.UnregisterAllEvents) then
		object:UnregisterAllEvents()
		object:SetParent(T.HiddenFrame)
	else
		object.Show = object.Hide
	end

	object:Hide()
end

local StripTextures = function(object, kill)
	for i = 1, object:GetNumRegions() do
		local region = select(i, object:GetRegions())

	if region and region:GetObjectType() == "Texture" then
			if (kill and type(kill) == "boolean") then
				region:Kill()
			elseif (region:GetDrawLayer() == kill) then
				region:SetTexture(nil)
			elseif (kill and type(kill) == "string" and region:GetTexture() ~= kill) then
				region:SetTexture(nil)
			else
				region:SetTexture(nil)
			end
		end
	end
end

local addapi = function(object)
	local mt = getmetatable(object).__index

	if not object.Kill then mt.Kill = Kill end
	if not object.StripTextures then mt.StripTextures = StripTextures end
end

local handled = {["Frame"] = true}
local object = CreateFrame("Frame")
addapi(object)
addapi(object:CreateTexture())
addapi(object:CreateFontString())

object = EnumerateFrames()
while (object) do
	if (not handled[object:GetObjectType()]) then
		addapi(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
end
