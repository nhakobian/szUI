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

oUF.Tags['sz:bn'] = function()
	if BNConnected() then
		local total, online = BNGetNumFriends()
		return ("|TInterface\\FriendsFrame\\UI-Toast-FriendOnlineIcon:0|t"..online.."/"..total)
	else
		return("|TInterface\\FriendsFrame\\UI-Toast-FriendOnlineIcon:0|tdc")
	end
end
oUF.TagEvents['sz:bn'] = "BN_FRIEND_INVITE_ADDED BN_FRIEND_ACCOUNT_OFFLINE BN_FRIEND_ACCOUNT_ONLINE BN_CONNECTED BN_DISCONNECTED"

oUF.Tags['sz:guild'] = function()
	local total, online = GetNumGuildMembers()
	local faction, _ = UnitFactionGroup('player')
	return "|TInterface\\FriendsFrame\\PlusManz-"..faction..":0|t"..online.."/"..total
end
oUF.TagEvents['sz:guild'] = "GUILD_ROSTER_UPDATE"
oUF.UnitlessTagEvents.GUILD_ROSTER_UPDATE = true
--oUF.UnitlessTagEvents.PLAYER_ALIVE = true

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

	self.memory = makeFontString(self, myriad, 14)
	self.memory:SetPoint("RIGHT", self, "RIGHT")
	self.memory.frequentUpdates = 1
	self:Tag(self.memory, '[sz:memory]')

	self.framerate = makeFontString(self, myriad, 14)
	self.framerate:SetPoint("RIGHT", self.memory, "LEFT", 0, 0)
	self.framerate.frequentUpdates = .25
	self:Tag(self.framerate, '[sz:framerate]')
	
	self.latency = makeFontString(self, myriad, 14)
	self.latency:SetPoint("RIGHT", self.framerate, "LEFT", 0, 0)
	self.latency.frequentUpdates = 30
	self:Tag(self.latency, '[sz:latency]')


	
	self.bn_frame = CreateFrame("Frame", nil, self)
	self.bn = makeFontString(self.bn_frame, myriad, 14)
	self.bn:SetPoint("RIGHT", self, "CENTER")
	self.bn_frame:SetAllPoints(self.bn)
	self:Tag(self.bn, '[sz:bn]')
	self.bn_frame:SetScript("OnMouseUp", function(self, button, ...)
		if button == "LeftButton" then
			ToggleFriendsFrame()
		end
	end)
	
	self.guild_frame = CreateFrame("Frame", nil, self)
	self.guild = makeFontString(self.guild_frame, myriad, 14)
	self.guild:SetPoint("LEFT", self, "CENTER")
	self.guild_frame:SetAllPoints(self.guild)
	self:Tag(self.guild, '[sz:guild]')
	self.guild_frame:SetScript("OnMouseUp", function(self, button, ...)
		if button == "LeftButton" then
			ToggleGuildFrame()
		end
	end)
	

	--LoadAddOn("Blizzard_GuildUI")
	--hooksecurefunc("GuildFrame_OnEvent", function(...)
		--force the update here so it doesnt fire before the guild fontstring has
		--been setup
	--	print("updateguildinfo")
	--	self.guild:UpdateTag()
	--end)
	
	self:SetSize(200, 20)
end

oUF:RegisterStyle('szDataBar', data)
oUF:Factory(function(self)
	self:SetActiveStyle('szDataBar')
	
	self:Spawn('player'):SetPoint("LEFT", szDataPanel, 6, -2)
	oUF_szDataBarPlayer:SetPoint("RIGHT", szDataPanel, -6, -2)
	
end)