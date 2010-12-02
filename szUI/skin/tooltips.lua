--Tooltip functions
--Skins a tooltip. Adapted from Tukui

hooksecurefunc("GameTooltip_SetDefaultAnchor", function(self, parent)
	self:SetOwner(parent, "ANCHOR_NONE")
	self:SetPoint("BOTTOMRIGHT", pUI_RightFrame, "TOPRIGHT", 6, .25*42)
	self.default = 1
end)

GameTooltipStatusBar.Show = function() end
GameTooltipStatusBar:Hide()

local classification = {
	worldboss = "|cffAF5050Boss|r",
	rareelite = "|cffAF5050+ Rare|r",
	elite = "|cffAF5050+|r",
	rare = "|cffAF5050Rare|r",
}

local function Hex(color)
	return string.format('|cff%02x%02x%02x', color.r * 255, color.g * 255, color.b * 255)
end

local function GetColor(unit)
	if(UnitIsPlayer(unit) and not UnitHasVehicleUI(unit)) then
		local _, class = UnitClass(unit)
		local color = RAID_CLASS_COLORS[class]
		if not color then return end -- sometime unit too far away return nil for color :(
		local r,g,b = color.r, color.g, color.b
		return Hex(color), r, g, b	
	else
		local color = FACTION_BAR_COLORS[UnitReaction("player", unit)]
		if not color then return end -- sometime unit too far away return nil for color :(
		local r,g,b = color.r, color.g, color.b		
		return Hex(color), r, g, b		
	end
end

GameTooltip:HookScript("OnUpdate",function(self, ...)
	if self:GetAnchorType() == "ANCHOR_CURSOR" and self.n < 2 then
		-- h4x for world object tooltip border showing last border color 
		-- or showing background sometime ~blue :x
		FrameStyle(self)
		self.n = self.n + 1
	end
end)

WorldMapTooltip:HookScript("OnUpdate",function(self, ...)
	if self:GetAnchorType() == "ANCHOR_CURSOR_RIGHT" and self.n < 2 then
		-- h4x for world object tooltip border showing last border color 
		-- or showing background sometime ~blue :x
		FrameStyle(self)
		self.n = self.n + 1
	end
end)

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
	local lines = self:NumLines()
	local GMF = GetMouseFocus()
	local unit = (select(2, self:GetUnit())) or (GMF and GMF:GetAttribute("unit"))
	
	-- A mage's mirror images sometimes doesn't return a unit, this would fix it
	if (not unit) and (UnitExists("mouseover")) then
		unit = "mouseover"
	end
	
	-- Sometimes when you move your mouse quicky over units in the worldframe, we can get here without a unit
	if not unit then self:Hide() return end
	
	-- for hiding tooltip on unitframes
	--if (self:GetOwner() ~= UIParent and db.hideuf) then self:Hide() return end
	
	-- A "mouseover" unit is better to have as we can then safely say the tip should no longer show when it becomes invalid.
	if (UnitIsUnit(unit,"mouseover")) then
		unit = "mouseover"
	end

	local race = UnitRace(unit)
	local class = UnitClass(unit)
	local level = UnitLevel(unit)
	local guild, guildrank = GetGuildInfo(unit)
	local name, realm = UnitName(unit)
	local crtype = UnitCreatureType(unit)
	local classif = UnitClassification(unit)
	local title = UnitPVPName(unit)
	local r, g, b = GetQuestDifficultyColor(level).r, GetQuestDifficultyColor(level).g, GetQuestDifficultyColor(level).b

	local color = GetColor(unit)	
	if not color then color = "|CFFFFFFFF" end -- just safe mode for when GetColor(unit) return nil for unit too far away

	_G["GameTooltipTextLeft1"]:SetFormattedText("%s%s%s", color, title or name, realm and realm ~= "" and " - "..realm.."|r" or "|r")

	if(UnitIsPlayer(unit)) then
		if UnitIsAFK(unit) then
			self:AppendText((" %s"):format(CHAT_FLAG_AFK))
		elseif UnitIsDND(unit) then 
			self:AppendText((" %s"):format(CHAT_FLAG_DND))
		end

		local offset = 2
		if guild then
			_G["GameTooltipTextLeft2"]:SetFormattedText("%s", IsInGuild() and GetGuildInfo("player") == guild and "|cff0090ff<"..guild..">|r "..guildrank or "|cff00ff10<"..guild..">|r "..guildrank)
			offset = offset + 1
		end

		for i= offset, lines do
			if(_G["GameTooltipTextLeft"..i]:GetText():find("^"..LEVEL)) then
				_G["GameTooltipTextLeft"..i]:SetFormattedText("|cff%02x%02x%02x%s|r %s %s%s", r*255, g*255, b*255, level > 0 and level or "??", race, color, class.."|r")
				break
			end
		end
	else
		for i = 2, lines do
			if((_G["GameTooltipTextLeft"..i]:GetText():find("^"..LEVEL)) or (crtype and _G["GameTooltipTextLeft"..i]:GetText():find("^"..crtype))) then
				if level == -1 and classif == "elite" then classif = "worldboss" end
				_G["GameTooltipTextLeft"..i]:SetFormattedText("|cff%02x%02x%02x%s|r%s %s", r*255, g*255, b*255, classif ~= "worldboss" and level ~= 0 and level or "", classification[classif] or "", crtype or "")
				break
			end
		end
	end

	local pvpLine
	for i = 1, lines do
		local text = _G["GameTooltipTextLeft"..i]:GetText()
		if text and text == PVP_ENABLED then
			pvpLine = _G["GameTooltipTextLeft"..i]
			pvpLine:SetText()
			break
		end
	end

	-- ToT line
	if UnitExists(unit.."target") then
		local hex, r, g, b = GetColor(unit.."target")
		if not r and not g and not b then r, g, b = 1, 1, 1 end
		GameTooltip:AddLine("Target: "..UnitName(unit.."target"), r, g, b)
	--else
	--	GameTooltip:AddLine("Target: <NONE>", 1, 1, 1)
	end
	
	-- Sometimes this wasn't getting reset, the fact a cleanup isn't performed at this point, now that it was moved to "OnTooltipCleared" is very bad, so this is a fix
	self.fadeOut = nil
	

end)

function FrameStyle(self, ...)
	self:SetBackdrop({bgFile="Interface/Buttons/WHITE8X8", insets={top=3, bottom=3, left=3, right=3}})
	self:SetBackdropColor(0, 0, 0, .9)
	CreateBorder(self, 14, .5, 0, 0)
end

function TooltipStyle(self, ...)
	FrameStyle(self)
	
	local name = self:GetName()
	if name == "GameTooltip" then 
		GameTooltipStatusBar:Hide() 
	end

	self.n = 0
end

local Tooltips = {  GameTooltip,
					ItemRefTooltip,
					ItemRefShoppingTooltip1,
					ItemRefShoppingTooltip2,
					ItemRefShoppingTooltip3,
					ShoppingTooltip1,
					ShoppingTooltip2,
					ShoppingTooltip3,
					WorldMapTooltip
				}

for _, tip in pairs(Tooltips) do
	tip:HookScript("OnShow", TooltipStyle)
end

--Style the MultiTooltips
szCommon.ALStack:Register("szMultiTooltips", function(event, ...)
	szMultiTips.StyleFunc = function(self, Tip)
		Tip:SetBackdrop({bgFile="Interface/Buttons/WHITE8X8", insets={top=3, bottom=3, left=3, right=3}})
		Tip:SetBackdropColor(0, 0, 0, .9)
		CreateBorder(Tip, 14, .5, 0, 0)
	end
end)
