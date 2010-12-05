--Register Group Unit Frames
local pets = {}
local partytargets = {}
	
oUF:Factory(function(self)
	oUF:SetActiveStyle("szGroup")

	local raid = self:SpawnHeader("oUF_szGroup", nil, "party,solo,raid",
		'oUF-initialConfigFunction', [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute('initial-width'))
			self:SetHeight(header:GetAttribute('initial-height'))
		]],
		'initial-width', 90,
		'initial-height', 45,	
		"showParty", true, 
		"showPlayer", true, 
		--"showRaid", true, 
		--"showSolo", true,
		"groupFilter", "1", 
		--"groupingOrder", "7",
		"sortMethod", "INDEX",
		--"groupBy", "PARTY",
		"point", "LEFT",
		"xOffset", 10
		--"maxColumns", 8,
		--"unitsPerColumn", 5,
		--"columnSpacing", -3,
		--"columnAnchorPoint", "TOP"
	)
	
	local xpos, ypos = oUF_paradoxPlayer:GetCenter()
	local _, cypos = UIParent:GetCenter()
	oUF_szGroup:SetPoint('LEFT', UIParent, "CENTER", -(90*5 + 10*4)/2, pfix(-(cypos-ypos)))
	

	--oUF:SetActiveStyle("szGroupPets")
	oUF:SetActiveStyle("szGroupTargets")

	do
		pets[1] = oUF:Spawn('playerpet') 

		pets[1]:SetSize(79, 25)
	end
	for i = 1, 4 do 
		pets[i+1] = oUF:Spawn('partypet'..i)
		pets[i+1]:SetSize(79, 25)
	end

	oUF:SetActiveStyle("szGroupTargets")

	do
		partytargets[1] = oUF:Spawn('player'..'target')
		partytargets[1]:SetSize(79,25)
	end
	for i = 1, 4 do
		partytargets[i+1] = oUF:Spawn('party'..i..'target')
		partytargets[i+1]:SetSize(79,25)
	end
end)

local PartyFrames = CreateFrame("Frame")
PartyFrames:RegisterEvent("PLAYER_LOGIN")
PartyFrames:RegisterEvent("RAID_ROSTER_UPDATE")
PartyFrames:RegisterEvent("PARTY_LEADER_CHANGED")
PartyFrames:RegisterEvent("PARTY_MEMBERS_CHANGED")
PartyFrames:SetScript("OnEvent", function(self)
	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
	else
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")

		--pets[1]:SetPoint('TOP', oUF_szGroupUnitButton1, 'BOTTOM', 0, 3)
		--partytargets[1]:SetPoint("BOTTOM", oUF_szGroupUnitButton1, "TOP", 0, -3)
		--partytargets[1]:SetParent(oUF_szGroupUnitButton1)
		--pets[1]:SetParent(oUF_szGroupUnitButton1)
		
		for i= 1, 5 do
			local parent = _G["oUF_szGroupUnitButton"..i]
			if parent ~= nil then
			partytargets[i]:SetParent(parent)
			pets[i]:SetParent(parent)
			pets[i]:SetPoint('TOP', parent, 'BOTTOM', 0, 3)			
			partytargets[i]:SetPoint("BOTTOM", parent, "TOP", 0, -3)
			partytargets[i]:SetFrameLevel(parent:GetFrameLevel()-1)
			pets[i]:SetFrameLevel(parent:GetFrameLevel()-1)
			end
		end
	end
end)	