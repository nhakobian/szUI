oUF:Factory(function(self)
	oUF:SetActiveStyle("szGroup")

	local raid = CreateFrame("FRAME", "oUF_szRaid40", UIParent)
	
	local visibility = "custom [@raid26,exists] show; hide;"
	local initialw = 60
	local initialh = 35
	local padding = 0
	
	local raid = self:SpawnHeader("oUF_szGroup40", nil, visibility,
		'oUF-initialConfigFunction', [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute('initial-width'))
			self:SetHeight(header:GetAttribute('initial-height'))
		]],
		'initial-width', initialw,
		'initial-height', initialh,	
		"showPlayer", true, 
		"showRaid", true, 
		"groupFilter", "1,2,3,4,5,6,7,8", 
		"groupingOrder", "1,2,3,4,5,6,7,8",
		"sortMethod", "INDEX",
		"groupBy", "GROUP",
		"point", "TOP",
		"maxColumns", 8,
		"unitsPerColumn", 5,
		"columnAnchorPoint", "LEFT"
	)

	raid:SetParent(oUF_szRaid)

	raid:SetPoint("LEFT", oUF_szRaid40)
	
	local xpos, ypos = oUF_paradoxPlayer:GetCenter()
	local _, cypos = UIParent:GetCenter()
	oUF_szRaid40:SetPoint('CENTER', UIParent, "CENTER", 0, -(cypos-ypos))
	oUF_szRaid40:SetSize(initialw*8 + padding*7, initialh*5 + padding*4)

end)
