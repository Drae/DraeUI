--[[
		From ElvUI
--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

local floor = math.floor
local backdropr, backdropg, backdropb, backdropa, borderr, borderg, borderb = 0, 0, 0, 1, 0, 0, 0

--Preload shit..
T.mult = 1

local Size = function(frame, width, height)
	frame:SetSize(T:Scale(width), T:Scale(height or width))
end

local Width = function(frame, width)
	frame:SetWidth(T:Scale(width))
end

local Height = function(frame, height)
	frame:SetHeight(T:Scale(height))
end

local Point = function(obj, arg1, arg2, arg3, arg4, arg5)
	-- anyone has a more elegant way for this?
	if type(arg1)=="number" then arg1 = T:Scale(arg1) end
	if type(arg2)=="number" then arg2 = T:Scale(arg2) end
	if type(arg3)=="number" then arg3 = T:Scale(arg3) end
	if type(arg4)=="number" then arg4 = T:Scale(arg4) end
	if type(arg5)=="number" then arg5 = T:Scale(arg5) end

	obj:SetPoint(arg1, arg2, arg3, arg4, arg5)
end

local SetOutside = function(obj, anchor, xOffset, yOffset)
	xOffset = xOffset or T.Border
	yOffset = yOffset or T.Border
	anchor = anchor or obj:GetParent()

	if (obj:GetPoint()) then
		obj:ClearAllPoints()
	end

	obj:Point("TOPLEFT", anchor, "TOPLEFT", -xOffset, yOffset)
	obj:Point("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", xOffset, -yOffset)
end

local SetInside = function(obj, anchor, xOffset, yOffset)
	xOffset = xOffset or T.Border
	yOffset = yOffset or T.Border
	anchor = anchor or obj:GetParent()

	if (obj:GetPoint()) then
		obj:ClearAllPoints()
	end

	obj:Point("TOPLEFT", anchor, "TOPLEFT", xOffset, -yOffset)
	obj:Point("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", -xOffset, yOffset)
end

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
	
	if not object.Size then mt.Size = Size end
	if not object.Point then mt.Point = Point end
	if not object.SetOutside then mt.SetOutside = SetOutside end
	if not object.SetInside then mt.SetInside = SetInside end
	if not object.Kill then mt.Kill = Kill end
	if not object.Width then mt.Width = Width end
	if not object.Height then mt.Height = Height end
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