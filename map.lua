local function pdx_MouseWheel(self, arg1)
	print(arg1)
	local scale = WorldMapFrame:GetScale()
	if (arg1 == 1) then WorldMapFrame:SetScale(scale + 0.1) end
	if (arg1 == -1) then WorldMapFrame:SetScale(scale - 0.1) end
end

WorldMapFrame:SetScript("OnMouseWheel", pdx_MouseWheel)