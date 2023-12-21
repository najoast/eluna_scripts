--[[
PVP击杀和奖励公告lua
]]--
print(">>Script: PvPkill.lua loading...OK")

local itemID=4338----------------奖励和惩罚的物品ID..我这儿用的魔纹布...随意改.只限背包内的物品
local Count=1--------------------数量.背包内的物品数量为0时.则无奖励和惩罚.只会出现公告

local function PvPkill(event, killer, killed)
        SendWorldMessage("|cFFFF99CC[PVP提示]|r： |h|cFF00FA9A资深玩家|r|Hplayer:"..killer:GetName().."|h|cffff0000["..killer:GetName().."]|r|h 杀死了 |cFF00FA9A菜鸟玩家|r|Hplayer:"..killed:GetName().."|h|cffff0000["..killed:GetName().."]|r|h")
	if killed:GetItemCount(itemID) < 0 then
	    killed:GetItemCount(itemID)
	else
	end
	
	  if killed:GetItemCount(itemID) > 0 then
		  killer:SendBroadcastMessage("击杀玩家["..killed:GetName().."]获得奖励"..GetItemLink(itemID).."*"..Count.."")
		  killed:SendBroadcastMessage("你被["..killer:GetName().."]杀死了.惩罚扣除"..GetItemLink(itemID).."*"..Count.."")
		  killer:AddItem(itemID, Count)
		  killed:RemoveItem(itemID, Count)
	  end
end

RegisterPlayerEvent(6, PvPkill)
