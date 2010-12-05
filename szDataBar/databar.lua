--hi

oUF.Tags['sz:gold'] = function()
	local copper = GetMoney()
	local text = ("%d|TInterface\\MoneyFrame\\UI-GoldIcon.png:0|t%d|TInterface\\MoneyFrame\\UI-SilverIcon.png:0|t%d|TInterface\\MoneyFrame\\UI-CopperIcon.png:0|t|c00000000X|||r"):format(copper / 100 / 100, (copper / 100) % 100, copper % 100)
	return text
end
oUF.TagEvents['sz:gold'] = "PLAYER_MONEY"
oUF.UnitlessTagEvents.PLAYER_MONEY = true

oUF.Tags['sz:latency'] = function()
	--no event sets this use self.frequentUpdates = 30 to refresh it every 30 seconds
	local _, _, lag = GetNetStats()
	return lag.."ms"
end

oUF.Tags['sz:framerate'] = function()
	return ("%.1ffps"):format(GetFramerate())
end

oUF.Tags['sz:memory'] = function()
	--local Mem, Total = 0, 0
	--UpdateAddOnMemoryUsage()
	--for i = 1, GetNumAddOns() do
	--	Mem = GetAddOnMemoryUsage(i)
		--Memory[i] = { select(2, GetAddOnInfo(i)), Mem, IsAddOnLoaded(i) }
	--	Total = Total + Mem
	--end
	--print(Total)
	return ("%.2f MiB"):format(gcinfo()/1024)
end

local makeFontString = function(frame, font, size, ...)
	local outline, justifyh, justifyv = ...
	
   	local fstring = frame:CreateFontString(nil, "OVERLAY")
	if outline == nil then
		fstring:SetFont(font, size, "THINOUTLINE")
	else
		fstring:SetFont(font, size, outline)
	end
   	fstring:SetShadowColor(0,0,0,1)
	fstring:SetShadowOffset(1,-1)
	if justifyh == nil then
		fstring:SetJustifyH("LEFT")
	else
		fstring:SetJustifyH(justifyh)
	end
	if justifyv == nil then
		fstring:SetJustifyV("CENTER")
	else
		fstring:SetJustifyV(justifyv)
	end

--[[	fstring.OldSetPoint = fstring.SetPoint
	fstring.SetPoint = function(self, ...)
		local fpoint, anchorframe, anchorpoint, x, y = ...
		if y == nil and x~= nil then
			y = x
			x = anchorpoint
			anchorpoint = fpoint
		end
		if y == nil and x == nil then
			x = 0
			y = 0
		end
		if anchorpoint == nil then
			anchorpoint = fpoint
		end
		if anchorframe == nil then
			anchorframe = self:GetParent()
		end
		
		if fpoint == "RIGHT" or fpoint =="TOPRIGHT" or fpoint=="BOTTOMRIGHT" then
			self:OldSetPoint(fpoint, anchorframe, anchorpoint, x+size/4.0, y)
		else
			self:OldSetPoint(fpoint, anchorframe, anchorpoint, x, y)
		end
	
	end
]]--
   	return fstring
end

local myriad = "Interface\\Addons\\szUnitFrames\\media\\myriad.ttf"

local function data(self, unit)
	self.gold = makeFontString(self, myriad, 14)
	self.gold:SetPoint("LEFT", self)
	self:Tag(self.gold, '[sz:gold]')
	
	self.latency = makeFontString(self, myriad, 14)
	self.latency:SetPoint("LEFT", self.gold, "RIGHT", 0, 0)
	self.latency.frequentUpdates = 30
	self:Tag(self.latency, '[sz:latency]')

	self.framerate = makeFontString(self, myriad, 14)
	self.framerate:SetPoint("LEFT", self.latency, "RIGHT", 0, 0)
	self.framerate.frequentUpdates = .25
	self:Tag(self.framerate, '[sz:framerate]')

	self.memory = makeFontString(self, myriad, 14)
	self.memory:SetPoint("LEFT", self.framerate, "RIGHT")
	self.memory.frequentUpdates = 1
	self:Tag(self.memory, '[sz:memory]')
	
	self:SetSize(200, 20)
end

oUF:RegisterStyle('szDataBar', data)
oUF:Factory(function(self)
	self:SetActiveStyle('szDataBar')
	
	self:Spawn('player'):SetPoint("LEFT", szDataPanel, 6, -2)
end)