--code testing file

--[[

local function StyleBuffs(buttonName, index, debuff)
	local buff		= _G[buttonName..index]
	local icon		= _G[buttonName..index.."Icon"]
	local border	= _G[buttonName..index.."Border"]
	local duration	= _G[buttonName..index.."Duration"]
	local count 	= _G[buttonName..index.."Count"]
	if icon and not _G[buttonName..index.."Panel"] then
		icon:SetTexCoord(.08, .92, .08, .92)
		--icon:SetPoint("TOPLEFT", buff, 2, -2)
		--icon:SetPoint("BOTTOMRIGHT", buff, -2, 2)
		
		--buff:SetHeight(TukuiDB.Scale(30))
		--buff:SetWidth(TukuiDB.Scale(30))
				
		duration:ClearAllPoints()
		duration:SetPoint("TOP", icon, "BOTTOM", 0, -2)
		duration:SetJustifyH("LEFT")
		--duration:SetFont(TukuiCF["media"].font, 12)
		
		--count:ClearAllPoints()
		--count:SetPoint("TOPLEFT", TukuiDB.Scale(1), TukuiDB.Scale(-2))
		--count:SetFont(TukuiCF["media"].font, 12, "OUTLINE")
		
		--local panel = CreateFrame("Frame", buttonName..index.."Panel", buff)
		--TukuiDB.CreatePanel(panel, 30, 30, "CENTER", buff, "CENTER", 0, 0)
		--panel:SetFrameLevel(buff:GetFrameLevel() - 1)
		--panel:SetFrameStrata(buff:GetFrameStrata())
	end
	--if border then border:Hide() end
end

function szBuff_SetBuffPos(value)
	local isvis = ConsolidatedBuffs:IsVisible()

	if value ~= nil then isvis = value end
	
	if tostring(isvis) == "1" then
		--print("Buff icon visible")
		ConsolidatedBuffs:ClearAllPoints()
		ConsolidatedBuffs:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -0.25*42, 0)

		BuffFrame:ClearAllPoints()
		BuffFrame:SetPoint("TOPRIGHT", ConsolidatedBuffs, "TOPLEFT", 0, 0)
	else
		BuffFrame:ClearAllPoints()
		BuffFrame:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -0.25*42, 0)
	end
	
	if (TemporaryEnchantFrame:GetWidth() ~= 0) then
			TemporaryEnchantFrame:ClearAllPoints()
			TemporaryEnchantFrame:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -0.25*42, 0)
	end
	
end

function UpdateBuffs()
	for i=1, BUFF_ACTUAL_DISPLAY do
		local button = _G["BuffButton"..i]
		StyleBuffs("BuffButton", i, false)
		
		if i > BUFFS_PER_ROW then
			button:ClearAllPoints()
			
			local anchor = i % BUFFS_PER_ROW
			if anchor == 0 then anchor = BUFFS_PER_ROW end
			button:SetPoint("TOPLEFT", _G["BuffButton"..anchor], "BOTTOMLEFT", 0, -(_G["BuffButton"..anchor.."Duration"]:GetHeight() + 6))
			BuffFrame:SetHeight(BuffFrame:GetTop() - (button:GetBottom()-12))
		end
	end
	szBuff_SetBuffPos()
end

function UpdateDebuffs(button, index)
	StyleBuffs(button,index, true)
	local bname = _G[button..index]

	local yoff = (1/2)*Minimap:GetHeight()
	
	if BuffFrame:GetHeight() > yoff then
		yoff = BuffFrame:GetHeight()
	end

	bname:ClearAllPoints()
	if index == 1 then
		if BUFF_ACTUAL_DISPLAY > BUFFS_PER_ROW then
			bname:SetPoint("TOPRIGHT", BuffFrame, "BOTTOMRIGHT", 0, -4)
		else
			bname:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -0.25*42, -(yoff+4))
		end
	else
		bname:SetPoint("RIGHT", _G[button..(index-1)], "LEFT", -4, 0)
	end
end

function TimeToString(tleft, auraButton)
	local w, d, h, m, s = 0, 0, 0, 0, 0
	
	s = floor(tleft)
	m = floor(s / 60.0)
	h = floor(m / 60.0)
	d = floor(h / 24.0)
	w = floor(d / 7.0)
	
	s = s - (m*60)
	m = m - (h *60)
	h = h - (d *24)
	d = d - (w *24)
	
	if (w ~= 0) then
		return string.format("%dw %dd", w, d)
	elseif (d ~= 0) then
		return string.format("%dd %dh", d, h)
	elseif (h ~= 0) then
		return string.format("%dh %dm", h, m)
	elseif (m ~= 0) then
		if m < 20 and m > 9 then
			auraButton.duration:ClearAllPoints()
			auraButton.duration:SetPoint("TOPLEFT", auraButton, "BOTTOMLEFT", -2.5, -2)		
		else
			auraButton.duration:ClearAllPoints()
			auraButton.duration:SetPoint("TOPLEFT", auraButton, "BOTTOMLEFT", -1, -2)
		end
		
		return string.format("%02d:%02d", m, s)
	elseif (s ~= 0) then
		return string.format("%d s", s)
	else
		return ""
	end
end

function HookTimeRewrite(auraButton, timeLeft)
	local duration = auraButton.duration;
	if ( SHOW_BUFF_DURATIONS == "1" and timeLeft ) then
		duration:SetFormattedText(TimeToString(timeLeft, auraButton));
		if ( timeLeft < BUFF_DURATION_WARNING_TIME ) then
			duration:SetVertexColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
		else
			duration:SetVertexColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
		end
		duration:Show();
	else
		duration:Hide();
	end
end

hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", UpdateBuffs)
hooksecurefunc("DebuffButton_UpdateAnchors", UpdateDebuffs)
hooksecurefunc("AuraButton_UpdateDuration", HookTimeRewrite)
]]--










	
--	for i = 2, 8 do
--		local frame = _G["oUF_szGroup"..i]
--		local pframe = _G["oUF_szGroup"..i-1]
--		frame:SetPoint("BOTTOM", pframe, "TOP", 0, 0)
--	end
	
	--raid:SetBackdrop({bgFile="Interface/Buttons/WHITE8X8", edgeFile="Interface/Tooltips/UI-Tooltip-Border", edgeSize=16, insets = {left=3, right=3, top=3, bottom=3}})
	--raid:SetBackdropColor(0,0,0)
	--raid:SetBackdropBorderColor(0.7, 0, 0)
	

--[[	local RaidMove = CreateFrame("Frame")
	RaidMove:RegisterEvent("PLAYER_LOGIN")
	RaidMove:RegisterEvent("RAID_ROSTER_UPDATE")
	RaidMove:RegisterEvent("PARTY_LEADER_CHANGED")
	RaidMove:RegisterEvent("PARTY_MEMBERS_CHANGED")
	RaidMove:SetScript("OnEvent", function(self)
		if InCombatLockdown() then
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
		else
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
			local numraid = GetNumRaidMembers()
			local numparty = GetNumPartyMembers()
			if numparty > 0 and numraid == 0 or numraid > 0 and numraid <= 5 then
				raid:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 15, -399)
				for i,v in ipairs(pets) do v:Enable() end
			elseif numraid > 5 and numraid < 11 then
				raid:SetPoint('TOPLEFT', UIParent, 15, -350)
				for i,v in ipairs(pets) do v:Disable() end
			elseif numraid > 10 and numraid < 16 then
				raid:SetPoint('TOPLEFT', UIParent, 15, -280)
				for i,v in ipairs(pets) do v:Disable() end
			elseif numraid > 15 and numraid < 26 then
				raid:SetPoint('TOPLEFT', UIParent, 15, -172)
				for i,v in ipairs(pets) do v:Disable() end
			elseif numraid > 25 then
				for i,v in ipairs(pets) do v:Disable() end
			end
		end
	end)--]]

