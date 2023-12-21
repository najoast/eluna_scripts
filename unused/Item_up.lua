--[[
简介: ELUNA 物品升级
原作者：5L
修改：烟雨江南
致谢：ayase，愈
]]--
print(">>Script: Item_up loading...OK")
math.randomseed(tonumber(tostring(os.time()):reverse():sub(1,6)))
local ITEMID   = 60007 --合成宝珠
UP ={};

function Item_Up(event, player, item, target)
	player:MoveTo(0,player:GetX()+0.01,player:GetY(),player:GetZ())
	U = target:GetEntry();
	--------------------------0----1------2-------3-------4--------5-----6------7---------8---
	Q = WorldDBQuery("SELECT id1, id2, amount, amount1, amount2, upid, chance, crazing, baoshi FROM item_up WHERE `id` = '"..U.."';");
	if (Q == nil) then
		player:SendBroadcastMessage("装备无法升级。")
		player:SendAreaTriggerMessage("装备无法升级。")	
		return;
	end
	UP[U] = {
		upid    = Q:GetString(5),  --升级后的ID
		amount  = Q:GetString(2),  --原始装备的数量
		chance  = Q:GetString(6),  --成功几率
		crazing = Q:GetString(7),  --失败是否碎裂：0不碎，1碎
		id1     = Q:GetString(0),  --需要的物品1的ID
		amount1 = Q:GetString(3),  --需要的物品1的数量
		id2     = Q:GetString(1),  --需要的物品2的ID
		amount2 = Q:GetString(4),  --需要的物品2的数量
		baoshi  = Q:GetString(8)   --幸运宝珠ID
					};
		player:GossipClearMenu();
		player:GossipMenuAddItem(1,"|TInterface\\ICONS\\Tradeskill_Inscription_JadeSerpent.blp:30|t 需要材料:"..GetItemLink(U).."×"..UP[U].amount.."件",0,99);
		if (tonumber(UP[U].id1) > 0 and tonumber(UP[U].amount1) > 0) then
		player:GossipMenuAddItem(1,"|TInterface\\ICONS\\Tradeskill_Inscription_RedCrane.blp:30|t 需要材料:"..GetItemLink(UP[U].id1).."×"..UP[U].amount1.."件",0,99);
		end
		if (tonumber(UP[U].id2) > 0 and tonumber(UP[U].amount2) > 0) then
		player:GossipMenuAddItem(1,"|TInterface\\ICONS\\Tradeskill_Inscription_BlackOx.blp:30|t 需要材料:"..GetItemLink(UP[U].id2).."×"..UP[U].amount2.."件",0,99);
		end
		player:GossipMenuAddItem(1,"|TInterface\\ICONS\\Spell_Priest_Chakra.blp:30|t 升级后装备:"..GetItemLink(UP[U].upid),0,99);
		player:GossipMenuAddItem(1,"|TInterface\\ICONS\\Spell_Priest_VowofUnity.blp:30|t 成功几率:"..UP[U].chance.."%",0,99);
		if (tonumber(UP[U].crazing) == 0) then
			player:GossipMenuAddItem(1,"|TInterface\\ICONS\\INV_Ingot_Trillium.blp:30|t 失败后不会碎裂",0,99);
		end
		if (tonumber(UP[U].crazing) == 1) then
			player:GossipMenuAddItem(1,"|TInterface\\ICONS\\INV_Ingot_Titansteel_red.blp:30|t 失败后道具消失",0,99);
		end
		player:GossipMenuAddItem(1,"|TInterface\\ICONS\\Spell_Holy_HopeAndGrace.blp:40|t |CFFFF1100确认合成|R",1,1);
		player:GossipSendMenu(1,item);
	
end
function Item_Select(event, player, object, sender, intid, code, menu_id)
	if (intid == 1) then
		local ChanceUp = math.random(0,100)
		if player:HasItem(U, tonumber(UP[U].amount)) and (tonumber(UP[U].id1) == 0 or tonumber(UP[U].amount1) == 0 or player:HasItem(tonumber(UP[U].id1), tonumber(UP[U].amount1))) and (tonumber(UP[U].id2) == 0 or tonumber(UP[U].amount2) == 0 or player:HasItem(tonumber(UP[U].id2), tonumber(UP[U].amount2))) then
			if tonumber(UP[U].id1) > 0 and tonumber(UP[U].amount1) > 0 then
				player:RemoveItem(UP[U].id1, UP[U].amount1);
			end
			if tonumber(UP[U].id2) > 0 and tonumber(UP[U].amount2) > 0 then
				player:RemoveItem(UP[U].id2, UP[U].amount2);
			end
			if tonumber(UP[U].chance) >= ChanceUp then
				if player:HasItem(tonumber(UP[U].baoshi), 1) then
					player:RemoveItem(tonumber(UP[U].baoshi), 1);
				end
				player:RemoveItem(U,UP[U].amount);
				player:AddItem(UP[U].upid, 1);
				player:SendBroadcastMessage("|CFFFF0000合成成功!!|R");
				player:SendAreaTriggerMessage("|CFFFF0000合成成功!!|R");
			else
				if (tonumber(UP[U].crazing) == 0) then
					player:SendBroadcastMessage("|CFFFF0000合成失败！！|R");
					player:SendAreaTriggerMessage("|CFFFF0000合成失败！！|R");
				elseif player:HasItem(tonumber(UP[U].baoshi), 1) then
					player:RemoveItem(tonumber(UP[U].baoshi), 1);
					player:SendBroadcastMessage("|CFFFF0000合成失败！破碎的幸运宝珠抵消了灾厄的降临！！|R");
					player:SendAreaTriggerMessage("|CFFFF0000合成失败！破碎的幸运宝珠抵消了灾厄的降临！！|R");
				else
					player:RemoveItem(U, UP[U].amount);
					player:SendBroadcastMessage("|CFFFF0000合成失败！物品破碎！|R");
					player:SendAreaTriggerMessage("|CFFFF0000合成失败！物品破碎！|R");
				end
			end
		else
			player:SendBroadcastMessage("|CFFFF0000装备或材料数量不足|R");
			player:SendAreaTriggerMessage("|CFFFF0000装备或材料数量不足|R");	
		end
		player:GossipComplete();
	end
	if(intid == 99) then
		player:SendBroadcastMessage("|CFFFF0000请点击确定合成按钮！！！|R");
		player:SendAreaTriggerMessage("|CFFFF0000请点击确定合成按钮！！！R");
		player:GossipComplete();
	end
end
RegisterItemEvent(ITEMID, 2, Item_Up);
RegisterItemGossipEvent(ITEMID, 2, Item_Select);