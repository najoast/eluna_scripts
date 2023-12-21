--[[杀有经验的怪会得到15点荣誉值和竞技场点数
]]--
print(">>Script: AddRongYu.")
local itemID=600000
local itemcount=1

local function AddRongYu(event, killer, killed)
	local honornum = killer:GetHonorPoints()
	local arenanum = killer:GetArenaPoints()
	
	if(killer:IsHonorOrXPTarget(killed)) then
		killer:AddItem(itemID, itemcount)
		killer:SetHonorPoints(honornum + 2)
		killer:SetArenaPoints(arenanum + 1)
		killer:SendBroadcastMessage("获得1点荣誉值。")
	end
end

RegisterPlayerEvent(7,AddRongYu)