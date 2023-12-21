--[[
Rock, Paper, Scissor Game
Original script made by Billtheslug.
Updated and converted to eluna by ToxicDev.
Version 1.1
modified by slp13at420 into gambling game.
]]--
local GOSSIP_EVENT_ON_HELLO                           = 1
local GOSSIP_EVENT_ON_SELECT                          = 2
print("Loading the Rock_Paper_Scissor")

local NPC_ID = 500001
local price = 100 -- in gold. min 1 gold.

function On_Gossip(event, plr, unit)
	if(plr:GetCoinage()>=(price*10000))then
		plr:GossipMenuAddItem(0, "|cffcc0000费用"..price.."金币|r", 0, 0, 0)
		plr:GossipMenuAddItem(0, "|cff0000ff我出石头|r", 0, 1, 0)
		plr:GossipMenuAddItem(0, "|cffcc0033我出布|r", 0, 2, 0)
		plr:GossipMenuAddItem(0, "|cff009900我出剪刀|r", 0, 3, 0)
		plr:GossipMenuAddItem(0, "|cffff0000没钱就快给我滚蛋!|r", 0, 4,0)
		plr:GossipSendMenu(1, unit)
	else
	    plr:SendBroadcastMessage("需要 "..price.." |cffffcc00金币|r")
	end
end

function On_Select(event, plr, unit, arg2, intid)
	if(intid == 0)then
		On_Gossip(event, plr, unit)
		return
		
	elseif(intid == 4)then
		plr:GossipComplete()
		return
		
	else
		plr:ModifyMoney(-(price*10000))
		plr:SendBroadcastMessage("|cffff00ff支付"..price.."|r")

		if (intid == 1) then
			local m = math.random(1, 3)
			if (m == 1) then
				plr:SendBroadcastMessage("|cffffcc00居然是平手这不科学啊！|r")
				plr:GossipComplete()
			end
			if (m == 2) then
				plr:SendBroadcastMessage("|cffffcc00哈哈！这次不能得意了吧！钱拿来！|r")
				plr:GossipComplete()
			end
			if (m == 3) then
				plr:SendBroadcastMessage("|cffffcc00失误！你赢了！不要得意有本事继续|r.")
				plr:SendBroadcastMessage("|cffff00ff获得了"..(price*2).."|r")
				plr:ModifyMoney((price*10000)*2)
				plr:GossipComplete()
			end
		end
	
		if (intid == 2) then
			local m = math.random(1, 3)
			if (m == 1) then
				plr:SendBroadcastMessage("|cffffcc00失误！你赢了！我让你的|r.")
				plr:SendBroadcastMessage("|cffff00ff获得了"..(price*2).."|r")
				plr:ModifyMoney((price*10000)*2)
				plr:GossipComplete()
			end
			if (m == 2) then
				plr:SendBroadcastMessage("|cffffcc00哎！早知道我出剪刀|r")
				plr:GossipComplete()
			end
			if (m == 3) then
				plr:SendBroadcastMessage("|cffffcc00我赢了！如果没钱你可以脱衣服！|r")
				plr:GossipComplete()
			end
		end
	
		if (intid == 3) then
			local m = math.random(1, 3)
			if (m == 1) then
				plr:SendBroadcastMessage("|cffffcc00我赢了！如果没钱你可以脱衣服！|r")
				plr:GossipComplete()
			end
			if (m == 2) then
				plr:SendBroadcastMessage("|cffffcc00失误！你赢了！|r")
				plr:SendBroadcastMessage("|cffff00ff获得了"..(price*2).."|r")
				plr:ModifyMoney((price*10000)*2)
				plr:GossipComplete()
			end
			if (m == 3) then
				plr:SendBroadcastMessage("|cffffcc00平手！你居然也出剪刀！|r")
				plr:GossipComplete()
			end
		end
	end
end

RegisterCreatureGossipEvent(NPC_ID, GOSSIP_EVENT_ON_HELLO, On_Gossip)
RegisterCreatureGossipEvent(NPC_ID, GOSSIP_EVENT_ON_SELECT, On_Select)