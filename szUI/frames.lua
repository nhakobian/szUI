local alpha = .8

chat = CreateFrame("FRAME", "pUI_ChatDock", UIParent)
chat:SetFrameStrata("LOW")
chat:SetPoint("BOTTOMLEFT", UIParent, 0, 0)
chat:SetWidth(350)--399
chat:SetHeight(155)--178.5
MakeBkgWindow(chat)

info = CreateFrame("FRAME", "pUI_InfoDock", UIParent)
info:SetFrameStrata("LOW")
info:SetPoint("BOTTOMRIGHT", UIParent, 0, 0)
info:SetWidth(350)
info:SetHeight(155)
MakeBkgWindow(info)

data = CreateFrame("FRAME", "szDataPanel", UIParent)
data:SetFrameStrata("LOW")
data:SetPoint("BOTTOM", UIParent)
data:SetWidth(920)
data:SetHeight(25)
data.bkg = data:CreateTexture(nil, "BORDER")
data.bkg:SetPoint("TOPLEFT", data, 3, -3)
data.bkg:SetPoint("TOPRIGHT", data, -3, -3)
data.bkg:SetPoint("BOTTOM", data)
data.bkg:SetTexture(0,0,0,.9)
CreateBorder(data, 14, .5, 0,0)
SetBorderVis(data, nil, true, nil, nil)

szCommon.ALStack:Register("szActionBars", function(event, ...)
	-- Post-hook the "PLAYER_LOGIN" event for the action bar frames to position them correctly
	-- Since szUI is loaded before the szActionBars, these hooks will still function, if we make sure
	-- they are not loaded until szActionBars is loaded

	--Hook for pUI_LeftFrame
	pUI_LeftFrame:HookScript("OnEvent", function(self, event, ...)
		self:ClearAllPoints()
		self:SetPoint("BOTTOMLEFT", pUI_ActionBar1, "BOTTOMRIGHT", (pUI_InfoDock:GetLeft()-pUI_ActionBar1:GetRight()-self:GetWidth())/2.0, 0)
		MakeBkgWindow(self)
	end)
		
	--Hook for pUI_RightFrame
	pUI_RightFrame:HookScript("OnEvent", function(self, event, ...)
		self:ClearAllPoints()
		self:SetPoint("BOTTOMRIGHT", pUI_InfoDock, "TOPRIGHT", 0, .4*42)
		MakeBkgWindow(self)
	end)
		
	--Hook for pUI_BLeftFrame
	pUI_BLeftFrame:HookScript("OnEvent", function(self, event, ...)
		self:ClearAllPoints()
		self:SetPoint("BOTTOMRIGHT", pUI_ActionBar1, "BOTTOMLEFT", -(pUI_ActionBar1:GetLeft()-pUI_ChatDock:GetRight()-self:GetWidth())/2.0, 0)
		MakeBkgWindow(self)
		SetBorderVis(pUI_BLeftFrame.bkg, nil, true, nil, nil)
	end)
	
	--place actionbars above the databar
	pUI_ActionBarAnchor:RegisterEvent("PLAYER_LOGIN")
	pUI_ActionBarAnchor:HookScript("OnEvent", function(self, event, ...)
		self:ClearAllPoints()
		self:SetPoint("CENTER", UIParent, "BOTTOM", 0, 28)
	end)

	--Hide some borders
	--
end)

szCommon.ALStack:Register("szActionBars", function(event, ...)
	-- Adjust size of the background of pUI_BLeftFrame depending on the presence of the stance bar.
	--handler:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
		
	pUI_StanceBar:HookScript("OnEvent", function(self, event, ...)
		if event ~= ("UPDATE_SHAPESHIFT_FORMS") then return end
		if InCombatLockdown() then return end -- > just to be safe ;p
		local lasticon = 0
		for i = 1, NUM_SHAPESHIFT_SLOTS do
			local _, name = GetShapeshiftFormInfo(i)
			if name then
				lasticon = i
			end
		end

		local _, class = UnitClass('player')
		if class ~= "SHAMAN" then
			if lasticon ~= 0 then
				pUI_BLeftFrame.bkg:SetBkgPoints(pUI_StanceBar)
			else
				pUI_BLeftFrame.bkg:SetBkgPoints(pUI_BLeftFrame)
			end
		end
	end)
end)
