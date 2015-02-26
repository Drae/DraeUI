--[[
		From ElvUI
--]]
local T, C, G, P, U, _ = select(2, ...):UnPack()

--Determine if Eyefinity is being used, setup the pixel perfect script.
local scale
local match = string.match
local abs, floor, min, max = math.abs, math.floor, math.min, math.max

T.UIScale = function(self, event)
	if (IsMacClient() and self.global.screenHeight and self.global.screenWidth and (self.screenHeight ~= self.global.screenHeight or self.screenWidth ~= self.global.screenWidth)) then
		self.screenHeight = self.global.screenHeight
		self.screenWidth = self.global.screenWidth
	end

	if (T.dbGlobal.autoScale) then
		scale = max(0.64, min(1.15, 768 / self.screenHeight))
	else
		scale = max(0.64, min(1.15, GetCVar("uiScale") or UIParent:GetScale() or 768 / self.screenHeight))
	end

	if (self.screenWidth < 1600) then
		self.lowversion = true
	elseif (self.screenWidth >= 3840 and T.dbGlobal.eyefinity) then
		local width = self.screenWidth
		local height = self.screenHeight

		-- because some user enable bezel compensation, we need to find the real width of a single monitor.
		-- I don"t know how it really work, but i"m assuming they add pixel to width to compensate the bezel. :P

		-- HQ resolution
		
		-- WQSXGA
		if (width >= 9840) then 
			width = 3280
		end
		
		-- WQXGA
		if (width >= 7680 and width < 9840) then 
			width = 2560
		end     
		
		-- WUXGA & HDTV
		if (width >= 5760 and width < 7680) then 
			width = 1920 
		end
		
		-- WSXGA+
		if (width >= 5040 and width < 5760) then 
			width = 1680 
		end 	                

		-- adding height condition here to be sure it work with bezel compensation because WSXGA+ and UXGA/HD+ got approx same width
		-- UXGA & HD+
		if (width >= 4800 and width < 5760 and height == 900) then 
			width = 1600 
		end   

		-- low resolution screen
		if (width >= 4320 and width < 4800) then 
			width = 1440 end 	 
		
		-- WSXGA
		if (width >= 4080 and width < 4320) then 
			width = 1360 
		end 	
		
		-- WXGA
		if (width >= 3840 and width < 4080) then 
			width = 1224 
		end 	                

		-- yep, now set ElvUI to lower resolution if screen #1 width < 1600
		if (width < 1600) then
			self.lowversion = true
		end

		-- register a constant, we will need it later for launch.lua
		self.eyefinity = width
	end

	self.mult = 768 / match(GetCVar("gxResolution"), "%d+x(%d+)") / scale

	--Set UIScale, NOTE: SetCVar for UIScale can cause taints so only do this when we need to..
	if (T.Round and T.Round(UIParent:GetScale(), 5) ~= T.Round(scale, 5) and (event == "PLAYER_LOGIN")) then
		SetCVar("useUiScale", 1)
		SetCVar("uiScale", scale)
		
		WorldMapFrame.hasTaint = true
	end

	if (event == "PLAYER_LOGIN" or event == "UI_SCALE_CHANGED") then
		if (IsMacClient()) then
			T.dbGlobal.screenHeight = floor(GetScreenHeight()*100+.5)/100
			T.dbGlobal.screenWidth = floor(GetScreenWidth()*100+.5)/100
		end

		--Resize self.UIParent if Eyefinity is on.
		if (self.eyefinity) then
			local width = self.eyefinity
			local height = self.screenHeight

			-- if autoscale is off, find a new width value of self.UIParent for screen #1.
			if (not T.dbGlobal.autoScale or height > 1200) then
				local h = UIParent:GetHeight()
				local ratio = self.screenHeight / h
				local w = self.eyefinity / ratio

				width = w
				height = h
			end

			self.UIParent:SetSize(width, height)
		else
			self.UIParent:SetSize(UIParent:GetSize())
		end

		self.UIParent:ClearAllPoints()
		self.UIParent:SetPoint("CENTER")

		local change
		if (T.Round) then
			change = abs((T.Round(UIParent:GetScale(), 5) * 100) - (T.Round(scale, 5) * 100))
		end

		self:UnregisterEvent("PLAYER_LOGIN")
	end
end

-- pixel perfect script of custom ui scale.
T.Scale = function(self, x)
    return self.mult * floor(x / self.mult + .5)
end