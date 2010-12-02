if szUI == nil then
	szUI = {}
end

szUI.unitframes = {
		general = {
			border_size = 14,
			inset = 3		
		},
		player = {
			x  = 336,
			y  = 210,
			width = 252,
			height = 63,
			PortraitFrame = true,
			VehicleSwitch = true
		},
		target = {
			width = 252,
			height = 63,
			PortraitFrame = true,
			PortraitLeft = false
		},
		targettarget = {
			width = 158,
			height = 42
		},
		pet = {
			width = 158,
			height = 42
		},
		focus = {
			width = 210,
			height = 52,
			PortraitFrame = true,
			PortraitLeft = true
		},
		focustarget = {
			width = 105,
			height = 32
		}
	}

szUI.castbar = {
		iconsize = 22,
		fontsize = 14,
		inset = 3,
		target_width = 350
	}


-- paradoxUI 0.01 alpha

--SetCVar("uiScale", 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)"))
--local mult = 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")
local mult = 1
local function scale(x) return mult*x end

-- Colors
	
oUF.colors.power = {
	["MANA"] = {26/255, 139/255, 255/255},
	["RAGE"] = {255/255, 26/255, 48/255},
	["FOCUS"] = {255/255, 150/255, 26/255},
	["ENERGY"] = {255/255, 225/255, 26/255},
	["HAPPINESS"] = {0.00, 1.00, 1.00},
	["RUNES"] = {0.50, 0.50, 0.50},
	["RUNIC_POWER"] = {0.00, 0.82, 1.00},
	["AMMOSLOT"] = {0.80, 0.60, 0.00},
	["FUEL"] = {0.0, 0.55, 0.5},
	["SOUL_SHARDS"] = {117/255, 82/255, 221/255},
}

oUF.colors.happiness = {
	[1] = {182/225, 34/255, 32/255},
	[2] = {220/225, 180/225, 52/225},
	[3] = {143/255, 194/255, 32/255},
}

--[[oUF.colors.reaction = {
	[1] = {182/255, 34/255, 32/255},
	[2] = {182/255, 34/255, 32/255},
	[3] = {182/255, 92/255, 32/255},
	[4] = {220/225, 180/255, 52/255},
	[5] = {143/255, 194/255, 32/255},
	[6] = {143/255, 194/255, 32/255},
	[7] = {143/255, 194/255, 32/255},
	[8] = {143/255, 194/255, 32/255},
}]]--

oUF.colors.smooth = { 1, 0, 0, 1, 1, 0, 1, 1, 1}
oUF.colors.runes = {{196/255, 30/255, 58/255};{173/255, 217/255, 25/255};{35/255, 127/255, 255/255};{178/255, 53/255, 240/255};}
	
--local font = "Interface\\AddOns\\paradoxUI\\media\\font.ttf"
local fill_texture = "Interface\\AddOns\\paradoxUI\\media\\Flat"
local bg_texture = "Interface\\AddOns\\paradoxUI\\media\\texture_bg"
local raid_texture = "Interface\\AddOns\\paradoxUI\\media\\texture"
local border = "Interface\\AddOns\\paradoxUI\\media\\border"
local spark_texture = "Interface\\AddOns\\paradoxUI\\media\\spark"
local white_square = "Interface\\AddOns\\paradoxUI\\media\\white"

local font = "Fonts\\ARIALN.TTF" --"Interface\\AddOns\\paradoxUI\\media\\expressway.ttf" --font = "Fonts/ARIALN.TTF"
local expressway = "Interface\\Addons\\szUnitFrames\\media\\expressway.ttf"
local myriad = "Interface\\Addons\\szUnitFrames\\media\\myriad.ttf"

-- Shortens Numbers
function ShortNumber(num)
	if num == nil then return end
	if(num >= 1e6) then
		return (math.floor((num/1e6)*10 + 0.5))/10 .."|cffb3b3b3m"
	elseif(num >= 1e3) then
		return (math.floor((num/1e3)*10 + 0.5))/10 .."|cffb3b3b3k"
	else
		return num
	end
end
	
-- Name
	
oUF.TagEvents["paradox:petname"] = "UNIT_PET"
oUF.Tags["paradox:petname"] = function(u, r)
	return UnitName(r or u)
end

for tag, func in pairs({
	['sz:currep'] = function()
		local _, _, min, _, value = GetWatchedFactionInfo()
		return value-min
	end,
	['sz:maxrep'] = function()
		local _, _, min, max = GetWatchedFactionInfo()
		return max-min
	end,
	['sz:standing'] = function()
		local _, standing = GetWatchedFactionInfo()
		return _G["FACTION_STANDING_LABEL"..standing]
	end,
	['sz:standingcolor'] = function()
		local _, standing = GetWatchedFactionInfo()
		return FACTION_BAR_COLORS[standing]
	end,
}) do
	oUF.Tags[tag] = func
	oUF.TagEvents[tag] = 'UPDATE_FACTION'
end

oUF.Tags['sz:curxp'] = function(unit)
	if(unit == 'pet') then
		return ShortNumber(GetPetExperience())
	else
		return ShortNumber(UnitXP(unit))
	end
end
oUF.TagEvents['sz:curxp'] = 'PLAYER_XP_UPDATE PLAYER_LEVEL_UP UNIT_PET_EXPERIENCE UPDATE_EXHAUSTION'

oUF.Tags['sz:maxxp'] = function(unit)
	if(unit == 'pet') then
		local _, max = ShortNumber(GetPetExperience())
		return max
	else
		return ShortNumber(UnitXPMax(unit))
	end
end
oUF.TagEvents['sz:maxxp'] = 'PLAYER_XP_UPDATE PLAYER_LEVEL_UP UNIT_PET_EXPERIENCE UPDATE_EXHAUSTION'

oUF.Tags['sz:currested'] = function()
	return ShortNumber(GetXPExhaustion())
end
oUF.TagEvents['sz:currested'] = 'PLAYER_XP_UPDATE PLAYER_LEVEL_UP UNIT_PET_EXPERIENCE UPDATE_EXHAUSTION'

	
-- Post Health Update
local PostUpdateHP = function(health, unit, min, max)
	local disconnnected = not UnitIsConnected(unit)
	local dead = UnitIsDead(unit)
	local ghost = UnitIsGhost(unit)
	local name = oUF.Tags['name'](unit)
		
	health.Name = name

	if (disconnnected or dead or ghost) then
	
		health:SetValue(0)	
		
		if(disconnnected and unit == "target") then
			health.value:SetText("offline")
		elseif(ghost and (unit == "player" or unit == "target")) then
			health.value:SetText("ghost")
		elseif(dead and (unit == "player" or unit == "target")) then
			health.value:SetText("dead ("..ShortNumber(max)..")")
		end
			
	else
		if (min ~= max) then
			local r, g, b = oUF.ColorGradient(min / max, unpack(oUF.colors.smooth))				
		
			if (unit == "player" or unit=='vehicle') then
				--health.value:SetText("|cmin.." ("..floor(min / max * 100).."%"..")")
				health.value:SetFormattedText("|cff%02x%02x%02x %s (%d%%)", r*255, g*255, b*255, min, floor(min / max * 100))
				print(gsub(health.value:GetText(), "|", "||"))
			elseif(unit == "target" or unit == "pet") then				
				health.value:SetText(ShortNumber(min).."|r ("..floor(min / max * 100).."%"..")")
				--if unit ~= 'pet' then
				--	health.percent:SetText(floor(min / max * 100).."%")
				--	health.percent:SetTextColor(r,g,b)
				--end
			elseif(unit == "targettarget" or unit == "focus") then
				health.value:SetText(floor(min / max * 100).."%")
			end				
		elseif (min == max) then
			if (unit == "player" or unit=='vehicle' or unit == "focus") then
				health.value:SetText(max)
			elseif(unit == "target") then		
				health.value:SetText(ShortNumber(max))
				--health.percent:SetText()
			elseif(unit == 'pet') then
				health.value:SetText(ShortNumber(max))
				--health.percent:SetText()
			elseif(unit == "targettarget") then
				health.value:SetText(floor(min / max * 100).."%")
			end
		end	
	end
end
	
-- Post Power Update
local PostUpdatePower = function(power, unit, min, max)
	local smin = ""
	local smax = ""

	if (unit ~= "player") then
		smin = ShortNumber(min)
		smax = ShortNumber(max)
	else
		smin = min
		smax = max
	end

	local _, ptype = UnitPowerType(unit)
	
	if UnitIsDead(unit) or UnitIsGhost(unit) then
		power:SetValue(0)
		min = 0
		smin = 0
	end
	
	if(unit == "player" or unit == "target" or unit == "pet" or unit=='vehicle') then
		if(ptype == "MANA") then
			local r, g, b = oUF.ColorGradient(min / max, unpack(power.bg.smoothGradient or oUF.colors.smooth))
			if min ~= max then
				power.value:SetText(smin.."|r/"..smax.."("..floor(min / max * 100).."%)")
			else
				power.value:SetText(smax)
			end
			---if (unit ~= "target" and unit ~= 'pet') then
			--	power.percent:SetText()
			--	power.percent:SetTextColor(r,g,b)
			--end
		elseif(ptype == "FOCUS" or ptype == "ENERGY") then
			if min ~= max then
				power.value:SetText(smin.."/"..smax)
			else
				power.value:SetText(smax)
			end
		elseif(ptype == "RAGE" or ptype == "RUNIC_POWER") then
			if min ~= max then
				power.value:SetText(smin.."/"..smax)
			else
				power.value:SetText(smax)
			end
		end
	end
	
end



-- Right Click Menu
local SpawnMenu = function(self)
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

-- Mouseover highlight
local OnEnter = function(self)
	UnitFrame_OnEnter(self)
	self.Highlight:Show()	
end

local OnLeave = function(self)
	UnitFrame_OnLeave(self)
	self.Highlight:Hide()	
end


-----FROMTUKUI
local FormatTime = function(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", ceil(s / hour))
	elseif s >= hour then
		return format("%dh", ceil(s / hour))
	elseif s >= minute then
		return format("%dm", ceil(s / minute))
	elseif s >= minute / 12 then
		return floor(s)
	end
	return format("%.1f", s)
end

local CreateAuraTimer = function(self, elapsed)
	if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 then
				local time = FormatTime(self.timeLeft)
				self.remaining:SetText(time)
				if self.timeLeft <= 5 then
					self.remaining:SetTextColor(0.99, 0.31, 0.31)
				else
					self.remaining:SetTextColor(1, 1, 1)
				end
			else
				self.remaining:Hide()
				self:SetScript("OnUpdate", nil)
			end
			self.elapsed = 0
		end
	end
end

local CancelAura = function(self, button)
	if button == "RightButton" and not self.debuff then
		-- CancelUnitBuff("player", self:GetID()) -- protected in cata?
	end
end

function SetTemplate(f)
	local mult = 1
	f:SetBackdrop({
	  bgFile = fill_texture, 
	  edgeFile = fill_texture, 
	  tile = false, tileSize = 0, edgeSize = mult, 
	  insets = { left = -mult, right = -mult, top = -mult, bottom = -mult}
	})
	f:SetBackdropColor(0,0,0,1)
	f:SetBackdropBorderColor(1,1,1,1)
end

SetFontString = function(parent, fontName, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(fontName, fontHeight, fontStyle)
	fs:SetJustifyH("LEFT")
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(1.25, -1.25)
	return fs
end

function PostCreateAura(element, button)
	SetTemplate(button)
	
	button.remaining = SetFontString(button, font, 8, "THINOUTLINE")
	button.remaining:SetPoint("CENTER", 1, 0)
	
	button.cd.noOCC = true		 	-- hide OmniCC CDs
	button.cd.noCooldownCount = true	-- hide CDC CDs
	
	button.cd:SetReverse()
	button.icon:SetPoint("TOPLEFT", 2, -2)
	button.icon:SetPoint("BOTTOMRIGHT", -2, 2)
	button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	button.icon:SetDrawLayer('ARTWORK')
	
	button.count:SetPoint("BOTTOMRIGHT", 3, 1.5)
	button.count:SetJustifyH("RIGHT")
	button.count:SetFont(font, 9, "THICKOUTLINE")
	button.count:SetTextColor(0.84, 0.75, 0.65)
	
	button.overlayFrame = CreateFrame("frame", nil, button, nil)
	button.cd:SetFrameLevel(button:GetFrameLevel() + 1)
	button.cd:ClearAllPoints()
	button.cd:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
	button.cd:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
	button.overlayFrame:SetFrameLevel(button.cd:GetFrameLevel() + 1)	   
	button.overlay:SetParent(button.overlayFrame)
	button.count:SetParent(button.overlayFrame)
	button.remaining:SetParent(button.overlayFrame)

	button.Glow = CreateFrame("Frame", nil, button)
	button.Glow:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
	button.Glow:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
	button.Glow:SetFrameStrata("BACKGROUND")	
	button.Glow:SetBackdrop{edgeFile = fill_texture, edgeSize = 1, insets = {left = 0, right = 0, top = 0, bottom = 0}}
	button.Glow:SetBackdropColor(0, 0, 0, 0)
	button.Glow:SetBackdropBorderColor(1, 1, 1)
end

function PostUpdateAura(icons, unit, icon, index, offset, filter, isDebuff, duration, timeLeft)
	local _, _, _, _, dtype, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, icon.filter)

	--show only players own applied buffs/debuffs to the focus target
	if ((unit == "focus") and ((icon.owner ~="player"))) then icon:Hide(); return; end
	

	if(icon.owner ~= "player" and icon.owner ~= "pet" and icon.owner ~= "vehicle") then
		icon:SetBackdropBorderColor(1,1,1,1)
		icon.icon:SetDesaturated(true)

	else
		local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
		icon:SetBackdropBorderColor(color.r * 0.6, color.g * 0.6, color.b * 0.6)
		icon.icon:SetDesaturated(false)
	end
	
	if duration and duration > 0 then
		icon.remaining:Show()
	else
		icon.remaining:Hide()
	end
 
	icon.duration = duration
	icon.timeLeft = expirationTime
	icon.first = true
	icon:SetScript("OnUpdate", CreateAuraTimer)
end

--------ENDFROMTUKUI


	-- Fontstring Function
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
		fstring:SetJustifyV("MIDDLE")
	else
		fstring:SetJustifyV(justifyv)
	end

	fstring.OldSetPoint = fstring.SetPoint
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

   	return fstring
end


local aStyle = function(self, unit)
	self:SetFrameLevel(3)
	local settings = szUI.unitframes[unit]
	local inset = szUI.unitframes.general.inset

	local _, class = UnitClass(unit)

	local hbar_texture = self:CreateTexture(nil)
	hbar_texture:SetTexture(.6,.6,.6,1)

	local pbar_texture = self:CreateTexture(nil)
	pbar_texture:SetTexture(.6,.6,.6,1)

	self.unit = unit
	self.menu = SpawnMenu
	self:SetScript("OnEnter", OnEnter)
	self:SetScript("OnLeave", OnLeave)
	self:RegisterForClicks('AnyDown')
	self:SetBackdrop({bgFile="Interface/Buttons/WHITE8X8", insets={top=3, bottom=3, left=3, right=3}})
	self:SetBackdropColor(0, 0, 0, 1)
	self:SetBackdropBorderColor(0, 0, 0, 1)

	CreateBorder(self, szUI.unitframes.general.border_size, .3, .3, .3)
	
	-- HP Bar
	self.Health = CreateFrame("StatusBar", nil, self)
	self.Health:SetStatusBarTexture(hbar_texture)
	self.Health.frequentUpdates = true
	self.Health.bg = self.Health:CreateTexture(nil, "BORDER")
	self.Health.bg:SetAllPoints(self.Health)
	self.Health.bg:SetAlpha(0.1)
	self.Health.bg:SetTexture(1,1,1,1)
	self.Health:SetFrameLevel(self:GetFrameLevel())
	
	-- Power Bar
	self.Power = CreateFrame("StatusBar", nil, self)
	self.Power:SetStatusBarTexture(pbar_texture)
    self.Power:SetPoint("TOP", self.Health, "BOTTOM", 0, -1)
	self.Power.bg = self.Power:CreateTexture(nil, "BORDER")
	self.Power.bg:SetAllPoints(self.Power)
	self.Power.bg:SetTexture(1,1,1,1)
	self.Power.bg:SetAlpha(0.1)
	self.Power:SetFrameLevel(self:GetFrameLevel())		
	
	-- Mouseover Highlight
	local HL = self.Health:CreateTexture(nil, "OVERLAY")
	HL:SetAllPoints(self)
	HL:SetTexture(white_square)
	HL:SetVertexColor(1,1,1,.05)
	HL:SetBlendMode("ADD")
	HL:Hide()
	self.Highlight = HL
		
	-- Colors
	self.Health.colorClass = true
	self.Health.colorClassPet = true
	self.Health.colorReaction = true
	self.Health.colorDisconnected = false
	self.Health.colorTapping = false
	self.Power.colorTapping = false
	self.Power.colorDisconnected = false
	self.Power.colorPower = true
	self.Power.colorHappiness = false

	self.Power.frequentUpdates = 0.1

	local PortraitFrame = false
	local portrait_offset = 0
	local portrait_left = true

	self:SetSize(settings.width, settings.height)
	
	if settings.PortraitFrame ~= nil then
		PortraitFrame = settings.PortraitFrame
	end
	if settings.VehicleSwitch ~= nil then
		self.VehicleSwitch = settings.VehicleSwitch
	end
	if settings.PortraitLeft ~= nil then
		portrait_left = settings.PortraitLeft
	end
	
	if (unit == "pet") then
		self:RegisterEvent("UNIT_PET", function(self, unit, ...)
			if self.Name then self.Name:UpdateTag(self.unit) end
		end)
		self:RegisterEvent("PLAYER_ALIVE", function(self, unit, ...)
			if self.Name then self.Name:UpdateTag(self.unit) end
		end)
	end

	if (PortraitFrame == true) then
		-- Portrait Frame
		self.Portrait = CreateFrame("PlayerModel", nil, self)

		portrait_offset = self:GetWidth()*(2/7.5)				
		self.Portrait:SetWidth(portrait_offset - 1)
		self.Portrait:SetHeight(self:GetHeight() - inset)		
		self.Portrait:SetFrameLevel(self:GetFrameLevel())
		if (portrait_left == true) then
			self.Portrait:SetPoint("TOPLEFT", inset, -inset)
			self.Health:SetPoint("TOPLEFT", self, "TOPLEFT", portrait_offset +inset, -inset)
		else
			self.Portrait:SetPoint("TOPRIGHT", -inset, -inset)
			self.Health:SetPoint("TOPLEFT", self, "TOPLEFT", inset, -inset)
		end
	else
		self.Health:SetPoint("TOPLEFT", self, "TOPLEFT", inset, -inset)
	end
		
	-- Size
	--self.Health:SetHeight((self:GetHeight()-2*inset)*.75)
	self.Health:SetHeight((self:GetHeight()-2*inset)-6-inset)
	self.Health:SetWidth(self:GetWidth() - portrait_offset - 2*inset)
	--self.Power:SetHeight((self:GetHeight()-2*inset)*.25 - 1)
	self.Power:SetHeight(6+inset)
	self.Power:SetWidth(self:GetWidth() - portrait_offset - 2*inset)
	
	-- Fontstrings
	
--local makeFontString = function(frame, font, size, ...)
--	local outline, justifyh, justifyv = ...

	local fsize = 12
	if (unit == 'pet') then
		fsize = 8
	end


	-- Generates the Power Value String
	self.Power.value = makeFontString(self.Power, myriad, fsize)
	self.Power.value:SetPoint("BOTTOMRIGHT", self.Health, -inset, -(fsize)/2+1)
	
	--Print out unit info on player/target
	--if (unit == "player" or unit == "target") then
		self.Power.info = makeFontString(self.Power, myriad, fsize)
		self.Power.info:SetPoint("BOTTOMLEFT", self.Health, inset, -(fsize)/2+1)
		self.Power.info:SetPoint("RIGHT", self.Power.value, "LEFT", -2, 0)
		self.Power.info:SetJustifyH("LEFT")
		self:Tag(self.Power.info, "[difficulty][smartlevel][ >classification]|r[ >race][raidcolor][ >smartclass]|r")
	--end

		--HP Value String
	self.Health.value = makeFontString(self.Health, myriad, fsize+2)
	self.Health.value:SetPoint("TOPRIGHT", self.Health, -inset, -inset)
	self.Health.value:SetPoint("BOTTOM", self.Power.info, "TOP")
	self.Health.value:SetJustifyH("RIGHT")

		
	
	--Name string
	self.Name = makeFontString(self.Health, myriad, fsize+2)
	--self.Name:SetPoint("TOPLEFT", self.Health, inset, -((self.Health:GetHeight()-self.Power.info:GetHeight())/2)+(fsize/2))
	--self.Name:SetPoint("RIGHT", self.Health.value, "LEFT", 0, 0)
	self.Name:SetPoint("TOPLEFT", self.Health, inset, -inset)
	self.Name:SetPoint("BOTTOM", self.Power.info, "TOP")
	self.Name:SetPoint("RIGHT", self.Health.value, "LEFT", -inset, 0)
	if self.unit == "pet" then
		self:Tag(self.Name, "[paradox:petname]")
	else
		self:Tag(self.Name, "[name]")
	end


	-- Health & Power Updates
	self.Health.PostUpdate = PostUpdateHP
	self.Power.PostUpdate = PostUpdatePower
	
	if (unit == "target") or (unit == "focus") then
		local buffs = CreateFrame("Frame", nil, self)
		buffs:SetHeight(20)
		buffs:SetWidth(3.5*42)
		buffs.size = 20
		buffs.num = 9

		buffs.spacing = 3
		if unit == "focus" then
			buffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 3)				
			buffs.initialAnchor = 'BOTTOMRIGHT'
			buffs["growth-y"] = "UP"
			buffs["growth-x"] = "LEFT"
		else
			buffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 3)
			buffs.initialAnchor = 'TOPLEFT'
		end
		buffs.PostCreateIcon = PostCreateAura
		buffs.PostUpdateIcon = PostUpdateAura
		self.Buffs = buffs		
			
		local debuffs = CreateFrame("Frame", nil, self)
		debuffs:SetHeight(20)
		debuffs:SetWidth(3.5*42)
		debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 3)
		debuffs.size = 20
		debuffs.num = 27

		debuffs.spacing = 3
		debuffs.initialAnchor = 'BOTTOMRIGHT'
		debuffs["growth-y"] = "UP"
		debuffs["growth-x"] = "LEFT"
		debuffs.PostCreateIcon = PostCreateAura
		debuffs.PostUpdateIcon = PostUpdateAura
		self.Debuffs = debuffs
	end
	
	--Castbar
	if unit == "player" or unit == "target" or unit == "focus" then
		-- castbar of player and target
		local iconsize = szUI.castbar.iconsize
		local fontsize = szUI.castbar.fontsize
		local borderpad = szUI.castbar.inset

		local castbar = CreateFrame("StatusBar", self:GetName().."_Castbar", self)
		local texture = castbar:CreateTexture(nil, "ARTWORK")
		texture:SetTexture(1, 1, 1, 1)
		castbar:SetStatusBarTexture(texture)
		castbar:SetStatusBarColor(.6,.4,0,1)

		if unit == "focus" then 
			iconsize = iconsize/2.0 
			fontsize = fontsize - 4
		end

		castbar.frequentUpdates = true
		castbar.bg = castbar:CreateTexture(nil, "BORDER")
		if unit == "target" then
			castbar.bg:SetPoint("TOPLEFT", castbar, 0, 0)
			castbar.bg:SetPoint("BOTTOMRIGHT", castbar, iconsize, 0)
			CreateBorder(castbar, 12, .3,.3, .3, borderpad, borderpad, borderpad+iconsize, borderpad, borderpad, borderpad, borderpad+iconsize, borderpad)			
		else
			castbar.bg:SetPoint("TOPLEFT", castbar, -iconsize, 0)
			castbar.bg:SetPoint("BOTTOMRIGHT", castbar, 0, 0)
			CreateBorder(castbar, 12, .3,.3, .3, iconsize+borderpad, borderpad, borderpad, borderpad, iconsize+borderpad, borderpad, borderpad, borderpad)
		end
		castbar.bg:SetTexture(0,0,0,1)
		castbar.bg:SetVertexColor(0.15, 0.15, 0.15)
		castbar:SetFrameLevel(6)
		
		castbar.button = CreateFrame("Frame", nil, castbar)
		castbar.button:SetHeight(iconsize)
		castbar.button:SetWidth(iconsize)
		castbar.button:SetFrameLevel(castbar:GetFrameLevel())
			
		castbar.Icon = castbar.button:CreateTexture(nil, "ARTWORK")
		castbar.Icon:SetPoint("TOPLEFT", castbar.button, 1, -1)
		castbar.Icon:SetPoint("BOTTOMRIGHT", castbar.button, -1 , 1)
		castbar.Icon:SetTexCoord(0.08, 0.92, 0.08, .92)
			
		if unit == "player" or unit == "focus" then
			castbar.button:SetPoint("RIGHT", castbar, "LEFT")
		elseif unit == "target" then
			castbar.button:SetPoint("LEFT", castbar, "RIGHT")
		end
			
		if unit == "target" then
			castbar:SetPoint("BOTTOM", UIParent, "BOTTOM", -(castbar.button:GetWidth()/2.0), 7*42)
			castbar:SetHeight(iconsize - borderpad)
			castbar:SetWidth(szUI.castbar.target_width)
		elseif unit == "player" then
			castbar:SetPoint("BOTTOMLEFT", self, "TOPLEFT", iconsize+borderpad, 8)
			castbar:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -borderpad, 8)
			castbar:SetHeight(iconsize-borderpad)
		elseif unit == "focus" then
			castbar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", iconsize+borderpad, -4)
			castbar:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", -borderpad, -4)
			castbar:SetHeight(iconsize - borderpad)				
		end
			
		castbar.CustomTimeText = function(self, duration)
			self.Time:SetText(("%.1f / %.1f"):format(self.channeling and duration or self.max - duration, self.max))
		end

		castbar.CustomDelayText = function(self, duration)
			self.Time:SetText(("%.1f |cffaf5050%s %.1f|r / %.1f"):format(self.channeling and duration or self.max - duration, self.channeling and "-" or "+", self.delay, self.max))
		end
			
		castbar.Time = SetFontString(castbar, font, fontsize, "OUTLINE")
		castbar.Time:SetPoint("RIGHT", castbar, "RIGHT", -4, 0)
		castbar.Time:SetTextColor(1, 1, 1)
		castbar.Time:SetJustifyH("RIGHT")

		castbar.Text = SetFontString(castbar, font, fontsize, "OUTLINE")
		castbar.Text:SetPoint("LEFT", castbar, "LEFT", 4, 0)
		castbar.Text:SetTextColor(1, 1, 1)
			
		castbar.lag = castbar:CreateTexture(nil)
		castbar.lag:SetTexture(.6, 0, 0, 1)
		castbar.lagstring = SetFontString(castbar, font, fontsize-4)
		castbar.lagstring:SetTextColor(.65, .65, .65)
		castbar.lagstring:SetPoint("TOPRIGHT", castbar.lag, "BOTTOMRIGHT", -5, 5)
			
		castbar.PostCastStart = (function(self, unit, name, rank, castid)
			local width = self:GetWidth()
			local _, _, latency = GetNetStats()
			local latency_width = latency/(self.max * 1000) * width
			self.lag:SetWidth(latency_width)
			self.lagstring:SetText(latency.."ms")
			castbar.lag:SetDrawLayer("BORDER")
			castbar.lag:ClearAllPoints()
			castbar.lag:SetPoint("TOPRIGHT", castbar)
			castbar.lag:SetPoint("BOTTOMRIGHT", castbar)
		
		end)
			
		castbar.PostChannelStart = (function(self, unit, name)
			self.lag:SetDrawLayer("ARTWORK")
			self.lag:ClearAllPoints()
			self.lag:SetPoint("TOPLEFT", castbar)
			self.lag:SetPoint("BOTTOMLEFT", castbar)
		end)
			
		castbar.Spark = castbar:CreateTexture()
		castbar.Spark:SetTexCoord(0, 1, 0.1, 0.9)
		castbar.Spark:SetBlendMode("ADD")
		castbar.Spark:SetHeight(castbar:GetHeight()*2)
		castbar.Shield = castbar:CreateTexture()
		self.Castbar = castbar		
	end

	--heal prediction
	local myheals = CreateFrame('StatusBar', nil, self.Health)
	myheals:SetPoint("TOPLEFT", self.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
	myheals:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
	myheals:SetWidth(self.Health:GetWidth())
	myheals.text = myheals:CreateTexture()
	myheals.text:SetTexture(1, 1, 1, 1)
	myheals:SetStatusBarTexture(myheals.text)
	myheals:SetStatusBarColor(0, .5, 0, .75)
	myheals.frequentUpdates = true
	myheals:SetMinMaxValues(0, 1)
	myheals:SetFrameLevel(self:GetFrameLevel())
	
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

	--resting indicator on player
	if (unit == 'player') then
		local restingframe = CreateFrame("Frame", self)
		local resting = restingframe:CreateTexture(nil, "OVERLAY")
		resting:SetPoint("TOPLEFT", self, -6, 6)
		resting:SetSize(16, 16)
		restingframe:SetFrameLevel(self:GetFrameLevel()+1)
		self.Resting = resting
	end
	
	--totembar
	if (unit == 'player') and (class == "SHAMAN") then
		local TotemBar = CreateFrame("FRAME", nil, self)
		local padding = 2
		TotemBar:SetPoint("BOTTOM", oUF_paradoxPlayer, "TOP", 0, 0)
		TotemBar:SetWidth(self.Health:GetWidth())
		TotemBar:SetHeight(20)
		
		TotemBar.UpdateColors = true
		TotemBar.AbbreviateNames = true
		TotemBar.Destroy = true
		
		TotemBar.bg = TotemBar:CreateTexture(nil, "BACKGROUND")
		TotemBar.bg:SetPoint("TOPLEFT", 3, -3)
		TotemBar.bg:SetPoint("BOTTOMRIGHT", -3, 0)
		TotemBar.bg:SetTexture(0,0,0, 0.8)
		CreateBorder(TotemBar, 14, .8, 0, 0,0,0,0,0,0,14,0,14,true)
		for i= 1, 4 do
			local totem = CreateFrame("FRAME", nil, TotemBar)
			if i==1 then
				totem:SetPoint("LEFT", TotemBar, padding, 0)
			else
				totem:SetPoint("LEFT", TotemBar[i-1], "RIGHT", padding, 0)
			end
			
			totem:SetWidth((TotemBar:GetWidth()-5*padding)/4.0 )
			totem:SetHeight(TotemBar:GetHeight() - (2*padding))
			totem:SetFrameLevel(TotemBar:GetFrameLevel())
			
			local bar = CreateFrame("StatusBar", nil, totem)
			bar:SetWidth(totem:GetWidth())
			bar:SetHeight(totem:GetHeight())
			bar:SetPoint("CENTER", totem)
			local texture = bar:CreateTexture(nil)
			texture:SetTexture(0.6,0.6,0.6)
			bar:SetStatusBarTexture(texture)
			totem.StatusBar = bar
			bar:SetFrameLevel(TotemBar:GetFrameLevel())
			
			local text = bar:CreateFontString(nil, "OVERLAY")
			text:SetPoint("CENTER", bar)
			text:SetFontObject("GameFontNormal")
			text:SetTextColor(1,1,1)
			totem.Text = text
		
			totem.bg = totem:CreateTexture(nil, "BACKGROUND")
			totem.bg:SetAllPoints()
			totem.bg:SetTexture(1, 1, 1)
			totem.bg.multiplier = 0
			
		
			TotemBar[i] = totem
		end
	
		self.TotemBar = TotemBar
	end
	
	--experience bar
	if (unit == 'player') then
		-- Position and size
		local Experience = CreateFrame('StatusBar', nil, self)
		Experience:SetStatusBarTexture("Interface\\PaperDollInfoFrame\\UI-Character-Skills-Bar")
		Experience:SetStatusBarColor(0,1,1)
		Experience:SetPoint("BOTTOM", self, "TOP")
		Experience:SetHeight(7)
		Experience:SetWidth(self.Health:GetWidth())
		CreateBorder(Experience, 14, .3, .3, .3, 2, 2, 2, 2, 2, 2, 2, 2, true)
		Experience:SetFrameLevel(self:GetFrameLevel()-1)
		
		-- Position and size the Rested background-bar
		local Rested = CreateFrame('StatusBar', nil, Experience)
		Rested:SetAllPoints(Experience)
		Rested:SetStatusBarTexture("Interface\\PaperDollInfoFrame\\UI-Character-Skills-Bar")
		Rested:SetStatusBarColor(1,0,1)
		
		-- Text display
		local Value = makeFontString(self.Health, myriad, 12)
		Value:SetAllPoints(Experience)
		Value:SetJustifyH("CENTER")
		self:Tag(Value, '[sz:curxp]|r / [sz:maxxp]|r[  (+>sz:currested<)]|r')
		Experience.value = Value
		Experience.value:SetAlpha(0)
		
		local Value2 = makeFontString(self.Health, myriad, 12)
		Value2:SetAllPoints(Experience)
		Value2:SetJustifyH("CENTER")
		self:Tag(Value2, '[perxp<%] [  (+>perrested<%)]')
		Experience.value2 = Value2
		Experience.value2:SetAlpha(0)
		
		Experience:SetScript("OnEnter", function(self, ...)
			self.value:SetAlpha(1)
			self.leftflag = false
		end)
		
		Experience:SetScript("OnLeave", function(self, ...)
			self.value:SetAlpha(0)
			self.value2:SetAlpha(0)
			self.leftflag = true
		end)
		
		Experience:SetScript("OnMouseDown", function(self, ...)
			self.value:SetAlpha(0)
			self.value2:SetAlpha(1)
		end)
		
		Experience:SetScript("OnMouseUp", function(self, ...)
			self.value2:SetAlpha(0)
			if not(self.leftflag) then
				self.value:SetAlpha(1)
			end
		end)
		
		-- Add a background
		local bg = Rested:CreateTexture(nil, 'BACKGROUND')
		bg:SetAllPoints(Experience)
		bg:SetTexture(0,0,0,1)

		-- Register it with oUF
		self.Experience = Experience
		self.Experience.Rested = Rested
	end
	
	--reputation bar
	if (unit == 'player') then
		-- Position and size
		local Reputation = CreateFrame('StatusBar', nil, self)
		Reputation:SetPoint('TOP', self, "BOTTOM", 0, 0)
		Reputation:SetHeight(7)
		Reputation:SetWidth(self.Health:GetWidth())

		CreateBorder(Reputation, 14, .3, .3, .3, 2, 2, 2, 2, 2, 2, 2, 2, false, true)
		Reputation:SetFrameLevel(self:GetFrameLevel()-1)
		
		local texture = Reputation:CreateTexture(nil)
		texture:SetTexture(.5,.5,.5,1)
		Reputation:SetStatusBarTexture("Interface\\PaperDollInfoFrame\\UI-Character-Skills-Bar")
		
		Reputation.PostUpdate = function(self, unit, min, max)
			local _, standing = GetWatchedFactionInfo()
			self:SetStatusBarColor(FACTION_BAR_COLORS[standing].r, FACTION_BAR_COLORS[standing].g, FACTION_BAR_COLORS[standing].b)
		end
		
		Reputation:SetScript("OnEnter", function(self, ...)
			self.value:SetAlpha(1)
		end)
		
		Reputation:SetScript("OnLeave", function(self, ...)
			self.value:SetAlpha(0)
		end)
		
		Reputation:SetScript("OnMouseDown", function(self, ...)
			self.value:SetText(GetWatchedFactionInfo())		
		end)
		
		Reputation:SetScript("OnMouseUp", function(self, ...)
			self.value:UpdateTag()		
		end)
		
		-- Text display
		local Value = makeFontString(self.Health, myriad, 12)
		Value:SetAllPoints(Reputation)
		Value:SetJustifyH("CENTER")
		self:Tag(Value, '[sz:currep] / [sz:maxrep] [sz:standing]')
		Reputation.value = Value
		Value:SetAlpha(0)
		
		-- Add a background
		local bg = Reputation:CreateTexture(nil, 'BACKGROUND')
		bg:SetAllPoints(Reputation)
		bg:SetTexture(0,0,0,1)

		-- Register it with oUF
		self.Reputation = Reputation
	end
	
end

oUF:RegisterStyle('paradox', aStyle)
oUF:Factory(function(self)
	self:SetActiveStyle('paradox')
	self:Spawn('player'):SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", szUI.unitframes.player.x, szUI.unitframes.player.y)
	self:Spawn('target'):SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", scale(-8*42), scale(5*42))
	self:Spawn('targettarget'):SetPoint("BOTTOMLEFT", UIParent, "BOTTOMRIGHT", -14*42, 3.75*42-.5)
	self:Spawn('focus'):SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0.5*42, 7*42)
	self:Spawn('focustarget'):SetPoint("BOTTOMLEFT", oUF_paradoxFocus, "TOPLEFT", 0, 0.25*42) 
	self:Spawn('pet'):SetPoint("TOPRIGHT", oUF_paradoxPlayer, "BOTTOMRIGHT", 0, -.25*42)
end)

--Adjust PopupMenus
UnitPopupMenus["PET"] = { "PET_PAPERDOLL", "PET_RENAME", "PET_ABANDON", "PET_DISMISS", "CANCEL" };