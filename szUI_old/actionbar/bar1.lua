local iconsize = 32
local padding = 0

frame = CreateFrame("FRAME", "pUI_ActionBar1", pUI_ActionBarBg, "SecureHandlerStateTemplate")
frame:SetPoint("BOTTOM", pUI_ActionBarAnchor, "BOTTOM", 0, 0)
frame:SetWidth(iconsize*12 + padding*11)
frame:SetHeight(iconsize)
frame:Show()

--pUI_ActionBarBg:SetPoint("TOPLEFT", pUI_BRightFrame)--, -1, 1)
--pUI_ActionBarBg:SetPoint("BOTTOMRIGHT", pUI_ActionBar1)--, 1, -1)


MakeBkgWindow(pUI_ActionBarBg)

for i = 1, 12 do
	button = _G["ActionButton"..i]
	icon = _G["ActionButton"..i.."Icon"]
	border = _G["ActionButton"..i.."Border"]
	button:ClearAllPoints()
	button:SetParent(frame)
	button:SetSize(iconsize, iconsize)
			
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT")
	else
		local p = _G["ActionButton"..i-1]
		button:SetPoint("LEFT", p, "RIGHT", padding, 0)
	end
end	

--[[ 
	Bonus bar classes id

	DRUID: Caster: 0, Cat: 1, Tree of Life: 0, Bear: 3, Moonkin: 4
	WARRIOR: Battle Stance: 1, Defensive Stance: 2, Berserker Stance: 3 
	ROGUE: Normal: 0, Stealthed: 1
	PRIEST: Normal: 0, Shadowform: 1
	
	When Possessing a Target: 5
]]--

local Page = {
	["DRUID"] = "[bonusbar:1,nostealth] 7; [bonusbar:1,stealth] 8; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;",
	["WARRIOR"] = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;",
	["PRIEST"] = "[bonusbar:1] 7;",
	["ROGUE"] = "[bonusbar:1] 7; [form:3] 7;",
	["DEFAULT"] = "[bar:2] 2; [bar:3] 3; [bar:4] 4; [bar:5] 5; [bar:6] 6; [bonusbar:5] 11;",
}

local function GetBar()
	local condition = Page["DEFAULT"]
	local _, class = UnitClass('player')
	local page = Page[class]
	if page then
		condition = condition.." "..page
	end
	condition = condition.." 1"
	return condition
end

pUI_ActionBar1:RegisterEvent("PLAYER_LOGIN")
pUI_ActionBar1:RegisterEvent("PLAYER_ENTERING_WORLD")
pUI_ActionBar1:RegisterEvent("PLAYER_TALENT_UPDATE")
pUI_ActionBar1:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
pUI_ActionBar1:RegisterEvent("KNOWN_CURRENCY_TYPES_UPDATE")
pUI_ActionBar1:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
pUI_ActionBar1:RegisterEvent("BAG_UPDATE")

local function pUI_ActionBarEvent(self, event, ...)
	if event == "PLAYER_LOGIN" then
		local button
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			button = _G["ActionButton"..i]
			self:SetFrameRef("ActionButton"..i, button)
		end	

		self:Execute([[
			buttons = table.new()
			for i = 1, 12 do
				table.insert(buttons, self:GetFrameRef("ActionButton"..i))
			end
		]])

		self:SetAttribute("_onstate-page", [[ 
			for i, button in ipairs(buttons) do
				button:SetAttribute("actionpage", tonumber(newstate))
			end
		]])
		
		RegisterStateDriver(self, "page", GetBar())	
		
		--Allow pUI_ActionBarBg to expand during combat.
		pUI_ActionBarBg:SetFrameRef("pUI_BRightFrame", pUI_BRightFrame)
		pUI_ActionBarBg:SetFrameRef("pUI_PetBar", pUI_PetBar)
		pUI_ActionBarBg:SetFrameRef("pUI_TotemBar", pUI_TotemBar)
		pUI_ActionBarBg:SetFrameRef("pUI_ActionBar1", pUI_ActionBar1)
		
		pUI_ActionBarBg:Execute([[
			pUI_BRightFrame = self:GetFrameRef("pUI_BRightFrame")
			pUI_PetBar = self:GetFrameRef("pUI_PetBar")
			pUI_TotemBar = self:GetFrameRef("pUI_TotemBar")	
			pUI_ActionBar1 = self:GetFrameRef("pUI_ActionBar1")
		]])
		
		pUI_ActionBarBg:SetAttribute("_onstate-petvis", [[
			if newstate == 'hide' then
				self:ClearAllPoints()
				self:SetPoint("BOTTOM", pUI_ActionBar1)
				self:SetPoint("TOPLEFT", pUI_BRightFrame)
				self:SetPoint("TOPRIGHT", pUI_BRightFrame)
			else
				self:ClearAllPoints()
				self:SetPoint("BOTTOM", pUI_ActionBar1)
				self:SetPoint("LEFT", pUI_ActionBar1)
				self:SetPoint("RIGHT", pUI_ActionBar1)
				self:SetPoint("TOP", pUI_PetBar)
			end
		]])
		
		RegisterStateDriver(pUI_ActionBarBg, "petvis", "[pet,novehicleui,nobonusbar:5] show; hide")
		
	elseif event == "PLAYER_TALENT_UPDATE" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
		if not InCombatLockdown() then -- Just to be safe
			--print("registering change")
			RegisterStateDriver(self, "page", GetBar())
		end
	else
		--MainMenuBar_OnEvent(self, event, ...)
	end	
	
end

frame:SetScript("OnEvent", pUI_ActionBarEvent)
