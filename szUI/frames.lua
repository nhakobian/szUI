local alpha = .8

chat = CreateFrame("FRAME", "pUI_ChatDock", UIParent)
chat:SetFrameStrata("LOW")
chat:SetPoint("BOTTOMLEFT", UIParent, .25*42, 0.25*42)
chat:SetWidth(9.5*42)
chat:SetHeight(4.25*42)
MakeBkgWindow(chat)

info = CreateFrame("FRAME", "pUI_InfoDock", UIParent)
info:SetFrameStrata("LOW")
info:SetPoint("BOTTOMRIGHT", UIParent, -10, 10)
info:SetWidth(9.5*42)
info:SetHeight(178)
MakeBkgWindow(info)


local handler = CreateFrame("FRAME")

local OnEvent = function(self, event, ...)
	if(not self:IsShown()) then return end
	return self[event](self, event, ...)
end

handler:SetScript("OnEvent", OnEvent)


handler:RegisterEvent("ADDON_LOADED")
function handler:ADDON_LOADED(event, ...)
	local arg1 = ...
print(event)
	if (event == "ADDON_LOADED" and arg1 == "szActionBars") then
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
		end)

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
		
		self:UnregisterEvent("ADDON_LOADED")
	end
end

function UPDATE_SHAPESHIFT_FORMS(self, event, ...)
end

handler:Show()