local font = "Fonts\\ARIALN.TTF" --"Interface\\AddOns\\paradoxUI\\media\\expressway.ttf"

szUnitFrames = CreateFrame("FRAME")

function pfix(pos)
	local apos = pos - floor(pos)
	if apos > .5 then
		return floor(pos) + 1
	else
		return floor(pos)
	end
end


oUF.Tags["sz:ricon"] = function(unit)
	local index = GetRaidTargetIndex(unit)
		
	if (index) then
		return "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_"..index..":0|t"
	end
end
oUF.TagEvents["sz:ricon"] = "RAID_TARGET_UPDATE"
oUF.UnitlessTagEvents.RAID_TARGET_UPDATE = true

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


local dropdown = CreateFrame("Frame", "MyAddOnUnitDropDownMenu", UIParent, "UIDropDownMenuTemplate")

UIDropDownMenu_Initialize(dropdown, function(self)
	local unit = self:GetParent().unit
	if not unit then return end

	local menu, name, id
	if UnitIsUnit(unit, "player") then
		menu = "SELF"
	elseif UnitIsUnit(unit, "vehicle") then
		menu = "VEHICLE"
	elseif UnitIsUnit(unit, "pet") then
		menu = "PET"
	elseif UnitIsPlayer(unit) then
		id = UnitInRaid(unit)
		if id then
			menu = "RAID_PLAYER"
			name = GetRaidRosterInfo(id)
		elseif UnitInParty(unit) then
			menu = "PARTY"
		else
			menu = "PLAYER"
		end
	else
		menu = "TARGET"
		name = RAID_TARGET_ICON
	end
	if menu then
		UnitPopup_ShowMenu(self, menu, unit, name, id)
	end
end, "MENU")

local menu = function(self)
	dropdown:SetParent(self)
	ToggleDropDownMenu(1, nil, dropdown, "cursor", 0, 0)
end


-- Post Health Update
function szUnitFrames.PostUpdateHP(health, unit, min, max)
	local disconnnected = not UnitIsConnected(unit)
	local dead = UnitIsDead(unit)
	local ghost = UnitIsGhost(unit)
	local name = oUF.Tags['name'](unit)
		
	health.Name = name

	local text = health:GetParent().HP
	
	if (disconnnected or dead or ghost) then
		health:SetValue(0)	
		
		if(disconnnected) then
			text:SetText("offline")
		elseif(ghost) then
			text:SetText("ghost")
		elseif(dead) then
			text:SetText("dead")
		end
	end
end

--"Glow" red Unit frames that are are being attacked by mobs
function szUnitFrames.UpdateThreat(self, event, unit)
	if (self.unit ~= unit) or (unit == "target" or unit == "pet" or unit == "focus" or unit == "focustarget" or unit == "targettarget") then return end
	local threat = UnitThreatSituation(self.unit)
	if (threat == 3) then
			ColorBorder(self, 1, 0, 0)
	else
			ColorBorder(self, .3, .3, .3)
	end 
end

function szUnitFrames.LargeButtonStyle(self, unit)
	local frameinset = 3

	local hbar_texture = self:CreateTexture(nil)
	hbar_texture:SetTexture(.6,.6,.6,1)

	local pbar_texture = self:CreateTexture(nil)
	pbar_texture:SetTexture(.6,.6,.6,1)	
	
	self:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	--self.menu = szUnitFrames.SpawnMenu
	self.menu = menu
	self:SetAttribute("*type2", "menu")
	
	self:SetBackdrop({bgFile="Interface/Buttons/WHITE8X8",insets = {left=3, right=3, top=3, bottom=3}})--, edgeFile="Interface/Buttons/WHITE8X8", edgeSize=frameinset-1})--, insets = {left=3, right=3, top=3, bottom=3}})
	self:SetBackdropColor(0, 0, 0, 1)
	self:SetBackdropBorderColor(0, 0, 0)
	
	local health = CreateFrame('StatusBar', nil, self)
	
	CreateBorder(self, 14, .3, .3, .3)
	health:SetStatusBarTexture(hbar_texture)
	self.Health = health
	self.Health:SetFrameLevel(self:GetFrameLevel())

	health.bg = self.Health:CreateTexture(nil, 'BORDER')
	health.bg:SetAllPoints(self.Health)
	health.bg:SetTexture(1,1,1,1)
	health.bg:SetAlpha(0.1)
	health.bg:SetVertexColor(0,0,0)
	self.Health.bg = health.bg

	--health.PostUpdate = TukuiDB.PostUpdatePetColor
	health.PostUpdate = szUnitFrames.PostUpdateHP
	health.frequentUpdates = true
	health.colorDisconnected = true	
	health.colorClass = true
	health.colorReaction = true			
	
	local power = CreateFrame("StatusBar", nil, self)
	power:SetHeight(5)
	power:SetPoint("BOTTOMLEFT", frameinset, frameinset)
	power:SetPoint("BOTTOMRIGHT", -frameinset, frameinset)
	power:SetStatusBarTexture(pbar_texture)
	power:SetFrameLevel(self:GetFrameLevel())
	self.Power = power
	
	--power.frequentUpdates = true

	power.bg = self.Power:CreateTexture(nil, "BORDER")
	power.bg:SetAllPoints(power)
	power.bg:SetTexture(1,1,1,1)
	power.bg:SetAlpha(.1)
	self.Power.bg = power.bg

	health:SetPoint("TOPLEFT", frameinset, -frameinset)
	health:SetWidth(self:GetWidth()-(2*frameinset))
	health:SetPoint("BOTTOM", self.Power, "TOP", 0, 1)
	
	power.colorPower = true
		
	local name = self.Health:CreateFontString(nil, 'OVERLAY')
	name:SetFont(font, 10, "THINOUTLINE")
	name:SetPoint("TOPLEFT", self, frameinset, -2*frameinset)
	name:SetPoint("TOPRIGHT", self, -frameinset, -2*frameinset)
	name:SetShadowOffset(1,-1)
	name:SetHeight(10)
	name.colorClass = true
	self:Tag(name, '[sz:ricon][name]')
	self.Name = name
	
	local neghp = health:CreateFontString(nil, "OVERLAY")
	neghp:SetFont(font, 10, "THINOUTLINE")
	neghp:SetPoint("BOTTOM", self.Health, 0, frameinset)
	neghp:SetShadowOffset(1,-1)
	self:Tag(neghp, '[->missinghp]')
	self.HP = neghp
	
	table.insert(self.__elements, szUnitFrames.UpdateThreat)
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
		
	local dbh = self:CreateTexture(nil, "OVERLAY")
	dbh:SetPoint("TOPLEFT", frameinset, -frameinset)
	dbh:SetPoint("BOTTOMRIGHT", self.Health, "TOPRIGHT", 0, frameinset)
	dbh:SetTexture(1,1,1,1)
	dbh:SetBlendMode("ADD")
	dbh:SetVertexColor(0,0,0,0) -- set alpha to 0 to hide the texture
	self.DebuffHighlight = dbh
	self.DebuffHighlightAlpha = 0.5
	self.DebuffHighlightFilter = true

	return self
end
oUF:RegisterStyle('szGroup', szUnitFrames.LargeButtonStyle)

function szUnitFrames.PartyTargets(self, unit)
	local hbar_texture = self:CreateTexture(nil)
	hbar_texture:SetTexture(.6,.6,.6,1)

	self:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	self.menu = szUnitFrames.SpawnMenu
	
	self:SetBackdrop({bgFile="Interface/Buttons/WHITE8X8", insets = {left=3, right=3, top=3, bottom=3}})--, edgeFile="Interface/Tooltips/UI-Tooltip-Border", edgeSize=16, insets = {left=3, right=3, top=3, bottom=3}})
	self:SetBackdropColor(0, 0, 0)
	self:SetBackdropBorderColor(0, 0, 0)

	CreateBorder(self, 14, .3, .3, .3)
	
	local health = CreateFrame('StatusBar', nil, self)

	health:SetStatusBarTexture(hbar_texture)
	health.frequentUpdates = true
	health.colorDisconnected = true	
	health.colorClass = true
	health.colorReaction = true	
	health.colorClassPet = true
	health:SetPoint("TOPLEFT", 3, -3)
	health:SetWidth(self:GetWidth()-6)
	health:SetPoint("BOTTOMRIGHT", -3, 3)
	health:SetFrameLevel(self:GetFrameLevel())

	self.Health = health

	health.bg = self.Health:CreateTexture(nil, 'BORDER')
	health.bg:SetAllPoints(self.Health)
	health.bg:SetTexture(1,1,1,1)
	health.bg:SetAlpha(0.1)
	self.Health.bg = health.bg

	local name = health:CreateFontString(nil, 'OVERLAY')
	name:SetFont(font, 12, "THINOUTLINE")
	name:SetPoint("TOPLEFT", self.Health, 3, 0)
	name:SetPoint("BOTTOMRIGHT", self.Health, -3, 0)
	name:SetJustifyV("MIDDLE")
	name:SetJustifyH("CENTER")
	name:SetShadowOffset(1,-1)
	name:SetHeight(12)
	self:Tag(name, '[sz:ricon][name]')
	self.Name = name

	return self
end
oUF:RegisterStyle('szGroupTargets', szUnitFrames.PartyTargets)


















