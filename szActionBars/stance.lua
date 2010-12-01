local settings = szUI.actionbars

-- create the shapeshift bar if we enabled it
local bar = CreateFrame("Frame", "pUI_StanceBar", pUI_ActionBarBg, "SecureHandlerStateTemplate")
pUI_StanceBar:ClearAllPoints()
pUI_StanceBar:SetPoint("BOTTOMLEFT", pUI_BLeftFrame, "TOPLEFT", 0, 0)
pUI_StanceBar:SetWidth(NUM_SHAPESHIFT_SLOTS * settings.iconsize + (NUM_SHAPESHIFT_SLOTS-1) *settings.padding)
pUI_StanceBar:SetHeight(settings.iconsize)

--MakeBkgWindow(bar)

local States = {
	["DRUID"] = "show",
	["WARRIOR"] = "show",
	["PALADIN"] = "show",
	["DEATHKNIGHT"] = "show",
	["ROGUE"] = "show,",
	["PRIEST"] = "show,",
	["HUNTER"] = "show,",
}

function style(self)
	local name = self:GetName()
	if name:match("MultiCastActionButton") then return end
	local action = self.action
	local Button = self
	local Icon = _G[name.."Icon"]
	local Count = _G[name.."Count"]
	local Flash	 = _G[name.."Flash"]
	local HotKey = _G[name.."HotKey"]
	local Border  = _G[name.."Border"]
	local Btname = _G[name.."Name"]
	local normal  = _G[name.."NormalTexture"]

	Button:SetNormalTexture("")
	Icon:SetTexCoord(.08, .92, .08, .92)
	Icon:SetPoint("TOPLEFT", Button, 2, -2)
	Icon:SetPoint("BOTTOMRIGHT", Button, -2, 2)
	

	HotKey:ClearAllPoints()
	HotKey:SetPoint("TOPRIGHT", Button, "TOPRIGHT", 1, -3)

	normal:ClearAllPoints()
	normal:SetPoint("TOPLEFT", 0, 0)
	normal:SetPoint("BOTTOMRIGHT")

	normal:SetBlendMode("ADD")
	normal:SetDrawLayer("BACKGROUND")
end

function StyleShift()
	for i = 1,10 do
		style(_G["ShapeshiftButton"..i])
	end

end

function ShiftBarUpdate()
	local numForms = GetNumShapeshiftForms()
	local texture, name, isActive, isCastable
	local button, icon, cooldown
	local start, duration, enable
	for i = 1, NUM_SHAPESHIFT_SLOTS do
		button = _G["ShapeshiftButton"..i]
		icon = _G["ShapeshiftButton"..i.."Icon"]
		if i <= numForms then
			texture, name, isActive, isCastable = GetShapeshiftFormInfo(i)
			icon:SetTexture(texture)
			
			cooldown = _G["ShapeshiftButton"..i.."Cooldown"]
			if texture then
				cooldown:SetAlpha(1)
			else
				cooldown:SetAlpha(0)
			end
			
			start, duration, enable = GetShapeshiftFormCooldown(i)
			CooldownFrame_SetTimer(cooldown, start, duration, enable)
			
			if isActive then
				ShapeshiftBarFrame.lastSelected = button:GetID()
				button:SetChecked(1)
			else
				button:SetChecked(0)
			end

			if isCastable then
				icon:SetVertexColor(1.0, 1.0, 1.0)
			else
				icon:SetVertexColor(0.4, 0.4, 0.4)
			end
		end
	end
end

pUI_StanceBar:RegisterEvent("PLAYER_LOGIN")
pUI_StanceBar:RegisterEvent("PLAYER_ENTERING_WORLD")
pUI_StanceBar:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
pUI_StanceBar:RegisterEvent("UPDATE_SHAPESHIFT_USABLE")
pUI_StanceBar:RegisterEvent("UPDATE_SHAPESHIFT_COOLDOWN")
pUI_StanceBar:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
pUI_StanceBar:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
pUI_StanceBar:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		local button
		local lasticon = 0
		for i = 1, NUM_SHAPESHIFT_SLOTS do
			button = _G["ShapeshiftButton"..i]
			button:ClearAllPoints()
			button:SetParent(self)
			button:SetSize(settings.iconsize, settings.iconsize)
			if i == 1 then
				button:SetPoint("BOTTOMLEFT", 0, 0)
			else
				local previous = _G["ShapeshiftButton"..i-1]
				button:SetPoint("LEFT", previous, "RIGHT", settings.padding, 0)
			end
			local _, name = GetShapeshiftFormInfo(i)
			
			if name then
				button:Show()
				lasticon = i
			end
		end
		
		bar:SetWidth(lasticon*settings.iconsize + (lasticon-1) * settings.padding)
		
		local _, class = UnitClass('player')
		RegisterStateDriver(self, "visibility", States[class] or "hide")
	elseif event == "UPDATE_SHAPESHIFT_FORMS" then
		-- Update Shapeshift Bar Button Visibility
		-- I seriously don't know if it's the best way to do it on spec changes or when we learn a new stance.
		if InCombatLockdown() then return end -- > just to be safe ;p
		local button
		local lasticon = 0
		for i = 1, NUM_SHAPESHIFT_SLOTS do
			button = _G["ShapeshiftButton"..i]
			local _, name = GetShapeshiftFormInfo(i)
			if name then
				button:Show()
				lasticon = i
			else
				button:Hide()
			end
		end

		local _, class = UnitClass('player')
		if class ~= "SHAMAN" then
			if lasticon ~= 0 then
				print("shifting")
				pUI_BLeftFrame.bkg:SetBkgPoints(pUI_StanceBar)
			else
				print("notshifting")
				pUI_BLeftFrame.bkg:SetBkgPoints(pUI_BLeftFrame)
			end
		end
		
		ShiftBarUpdate()
		ShapeshiftBar_UpdateState()
	elseif event == "PLAYER_ENTERING_WORLD" then
		StyleShift()
		local script = self:GetScript("OnEvent")
		script(self, "UPDATE_SHAPESHIFT_FORMS")
	else
		--ShapeshiftBar_UpdateState()
		ShiftBarUpdate()
	end
end)