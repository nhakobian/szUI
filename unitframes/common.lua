szUnitFrames = CreateFrame("FRAME")

-- Right Click Menu
function szUnitFrames.SpawnMenu(self)
	local unit = self.unit:sub(1, -2)
	local cunit = self.unit:gsub("^%l", string.upper)

	if(cunit == 'Vehicle') then
		cunit = 'Pet'
	end

	if(unit == "party" or unit == "partypet") then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
	elseif(_G[cunit.."FrameDropDown"]) then
		ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
	end
end

-- Post Health Update
function szUnitFrames.PostUpdateHP(health, unit, min, max)
	local disconnnected = not UnitIsConnected(unit)
	local dead = UnitIsDead(unit)
	local ghost = UnitIsGhost(unit)
	local name = oUF.Tags['name'](unit)
		
	health.Name = name

	local text = health:GetParent().Name
	
	if (disconnnected or dead or ghost) then
		health:SetValue(0)	
		
		if(disconnnected) then
			text:SetText("offline")
		elseif(ghost) then
			text:SetText("ghost")
		elseif(dead) then
			text:SetText("dead")
		end
	else
		if min ~= max then
			text:SetText("-"..max-min)
		else
			health:GetParent().Name:UpdateTag()
		end
	end
end

--"Glow" red Unit frames that are are being attacked by mobs
function szUnitFrames.UpdateThreat(self, event, unit)
	if (self.unit ~= unit) or (unit == "target" or unit == "pet" or unit == "focus" or unit == "focustarget" or unit == "targettarget") then return end
	local threat = UnitThreatSituation(self.unit)
	if (threat == 3) then
			self:SetBackdropBorderColor(1,0,0)
	else
			self:SetBackdropBorderColor(0,0,0)
	end 
end

function szUnitFrames.LargeButtonStyle(self, unit)
	self:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	self.menu = szUnitFrames.SpawnMenu
	
	self:SetBackdrop({bgFile="Interface/Buttons/WHITE8X8", edgeFile="Interface/Tooltips/UI-Tooltip-Border", edgeSize=16, insets = {left=3, right=3, top=3, bottom=3}})
	self:SetBackdropColor(0, 0, 0)
	self:SetBackdropBorderColor(0, 0, 0)
	
	local health = CreateFrame('StatusBar', nil, self)

	health:SetStatusBarTexture("Interface\\AddOns\\paradoxUI\\media\\Flat")
	self.Health = health

	health.bg = self.Health:CreateTexture(nil, 'BORDER')
	health.bg:SetAllPoints(self.Health)
	health.bg:SetTexture("Interface\\AddOns\\paradoxUI\\media\\Flat")
	health.bg:SetAlpha(0.2)
	self.Health.bg = health.bg

	--health.PostUpdate = TukuiDB.PostUpdatePetColor
	health.PostUpdate = szUnitFrames.PostUpdateHP
	health.frequentUpdates = true
	health.colorDisconnected = true	
	health.colorClass = true
	health.colorReaction = true			
	
	local power = CreateFrame("StatusBar", nil, self)
	power:SetHeight(2)
	power:SetPoint("BOTTOMLEFT", 5, 5)
	power:SetPoint("BOTTOMRIGHT", -5, 5)
	power:SetStatusBarTexture("Interface\\AddOns\\paradoxUI\\media\\Flat")
	self.Power = power
	
	power.frequentUpdates = true

	power.bg = self.Power:CreateTexture(nil, "BORDER")
	power.bg:SetAllPoints(power)
	power.bg:SetTexture("Interface\\AddOns\\paradoxUI\\media\\Flat")
	power.bg:SetAlpha(.2)
	power.bg.multiplier = 0.4
	self.Power.bg = power.bg

	health:SetPoint("TOPLEFT", 5, -5)
	health:SetWidth(self:GetWidth()-10)
	health:SetPoint("BOTTOM", self.Power, "TOP", 0, 2)
	
	power.colorPower = true
		
	local name = health:CreateFontString(nil, 'OVERLAY')
	name:SetFont("Fonts/ARIALN.TTF", 12, "THINOUTLINE")
	name:SetPoint("CENTER", self.Health, 0, 0)
	self:Tag(name, '[name]')
	self.Name = name
	
	RaidIcon = health:CreateTexture(nil, 'OVERLAY')
	RaidIcon:SetHeight(16)
	RaidIcon:SetWidth(16)
	RaidIcon:SetPoint("BOTTOM", self, "TOP", 0, 2)
	self.RaidIcon = RaidIcon
	
	table.insert(self.__elements, UpdateThreat)
	self:RegisterEvent('PLAYER_TARGET_CHANGED', szUnitFrames.UpdateThreat)
	self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', szUnitFrames.UpdateThreat)
	self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', szUnitFrames.UpdateThreat)
	
	local LFDRole = health:CreateTexture(nil, "OVERLAY")
    LFDRole:SetHeight(16)
    LFDRole:SetWidth(16)
	LFDRole:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
	self.LFDRole = LFDRole
	
	--local ReadyCheck = health:CreateTexture(nil, "OVERLAY")
	--ReadyCheck:SetHeight(TukuiDB.Scale(12*TukuiDB.raidscale))
	--ReadyCheck:SetWidth(TukuiDB.Scale(12*TukuiDB.raidscale))
	--ReadyCheck:SetPoint('CENTER')
	--self.ReadyCheck = ReadyCheck
	
	--local picon = self.Health:CreateTexture(nil, 'OVERLAY')
	--picon:SetPoint('CENTER', self.Health)
	--picon:SetSize(16, 16)
	--picon:SetTexture"Interface\AddOns\Tukui\media\textures\picon"
	--picon.Override = TukuiDB.Phasing
	--self.PhaseIcon = picon
	


	health.Smooth = true
	
	local range = {insideAlpha = 1, outsideAlpha = .3}
	self.Range = range
	
	--heal prediction
	local myheals = CreateFrame('StatusBar', self:GetName().."myheals", self.Health)
	myheals:SetPoint("TOPLEFT", self.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
	myheals:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
	myheals:SetWidth(self.Health:GetWidth())
	myheals.text = myheals:CreateTexture()
	myheals.text:SetTexture(1, 1, 1, 1)
	myheals:SetStatusBarTexture(myheals.text)
	myheals:SetStatusBarColor(0, .5, 0, .75)
	myheals.frequentUpdates = true
	myheals:SetMinMaxValues(0, 1)
	
	local otherheals = CreateFrame('StatusBar', nil, self.Health)
	otherheals:SetPoint("TOPLEFT", self.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
	otherheals:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
	otherheals:SetWidth(self.Health:GetWidth())
	otherheals.text = otherheals:CreateTexture()
	otherheals.text:SetTexture(1, 1, 1, 1)
	otherheals:SetStatusBarTexture(otherheals.text)
	otherheals:SetStatusBarColor(1, .5, 0, .75)
	otherheals.frequentUpdates = true
	otherheals:SetMinMaxValues(0, 1)
	
	self.HealPrediction = { myBar = myheals, otherBar = otherheals, maxOverflow=1.1}
	
	
	local dbh = self.Health:CreateTexture(nil, "OVERLAY")
	dbh:SetAllPoints(self.Health)
	dbh:SetTexture(1,1,1,1)
	dbh:SetBlendMode("ADD")
	dbh:SetVertexColor(0,0,0,0) -- set alpha to 0 to hide the texture
	self.DebuffHighlight = dbh

		self.DebuffHighlightAlpha = 0.5
	--self.DebuffHighlightBackdrop = true
	self.DebuffHighlightFilter = true
	
	
	
	
	
	return self
end
oUF:RegisterStyle('szGroup', szUnitFrames.LargeButtonStyle)

function szUnitFrames.PartyTargets(self, unit)
	self:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	self.menu = szUnitFrames.SpawnMenu
	
	self:SetBackdrop({bgFile="Interface/Buttons/WHITE8X8", edgeFile="Interface/Tooltips/UI-Tooltip-Border", edgeSize=16, insets = {left=3, right=3, top=3, bottom=3}})
	self:SetBackdropColor(0, 0, 0)
	self:SetBackdropBorderColor(0, 0, 0)
	
	local health = CreateFrame('StatusBar', nil, self)

	health:SetStatusBarTexture("Interface\\AddOns\\paradoxUI\\media\\Flat")
	self.Health = health

	health.bg = self.Health:CreateTexture(nil, 'BORDER')
	health.bg:SetAllPoints(self.Health)
	health.bg:SetTexture("Interface\\AddOns\\paradoxUI\\media\\Flat")
	health.bg:SetAlpha(0.2)
	self.Health.bg = health.bg

	--health.PostUpdate = TukuiDB.PostUpdatePetColor
	--health.PostUpdate = szUnitFrames.PostUpdateHP
	health.frequentUpdates = true
	health.colorDisconnected = true	
	health.colorClass = true
	health.colorReaction = true	
	health.colorClassPet = true
	
	health:SetPoint("TOPLEFT", 5, -5)
	health:SetWidth(self:GetWidth()-10)
	health:SetPoint("BOTTOMRIGHT", -5, 5)
	
	local name = health:CreateFontString(nil, 'OVERLAY')
	name:SetFont("Fonts/ARIALN.TTF", 12, "THINOUTLINE")
	name:SetPoint("TOPLEFT", self.Health, 1, 0)
	name:SetPoint("BOTTOMRIGHT", self.Health, -1, 0)
	self:Tag(name, '[name]')
	self.Name = name
	
	RaidIcon = health:CreateTexture(nil, 'OVERLAY')
	RaidIcon:SetHeight(16)
	RaidIcon:SetWidth(16)
	RaidIcon:SetPoint("BOTTOM", self, "TOP", 0, 2)
	self.RaidIcon = RaidIcon
	
	self.DebuffHighlightAlpha = 1
	self.DebuffHighlightBackdrop = true
	self.DebuffHighlightFilter = true

	health.Smooth = true
	
	--local range = {insideAlpha = 1, outsideAlpha = .3}
	--self.Range = range
	
	--heal prediction
	local myheals = CreateFrame('StatusBar', self:GetName().."myheals", self.Health)
	myheals:SetPoint("TOPLEFT", self.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
	myheals:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
	myheals:SetWidth(self.Health:GetWidth())
	myheals.text = myheals:CreateTexture()
	myheals.text:SetTexture(1, 1, 1, 1)
	myheals:SetStatusBarTexture(myheals.text)
	myheals:SetStatusBarColor(0, .5, 0, .75)
	myheals.frequentUpdates = true
	myheals:SetMinMaxValues(0, 1)
	
	local otherheals = CreateFrame('StatusBar', nil, self.Health)
	otherheals:SetPoint("TOPLEFT", self.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
	otherheals:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
	otherheals:SetWidth(self.Health:GetWidth())
	otherheals.text = otherheals:CreateTexture()
	otherheals.text:SetTexture(1, 1, 1, 1)
	otherheals:SetStatusBarTexture(otherheals.text)
	otherheals:SetStatusBarColor(1, .5, 0, .75)
	otherheals.frequentUpdates = true
	otherheals:SetMinMaxValues(0, 1)
	
	self.HealPrediction = { myBar = myheals, otherBar = otherheals, maxOverflow=1.1}
	
	return self
end
oUF:RegisterStyle('szGroupTargets', szUnitFrames.PartyTargets)


















