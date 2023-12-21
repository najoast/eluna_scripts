
--[[信息：
	召唤血色特殊BOSS  （Teleport stone）
	修改日期：2020-1-17
	功能：教堂随机召唤池中的BOSS
	作者：星大
]]--
print(">>Script: zhBOSS script loading...OK")

--菜单所有者 --失落的霜之哀伤
local gameobjectEntry	=300006
local U = 60004
local MMENU=1
local npcEntry={60001,60002,60003,60004,60005}
--GOSSIP_ICON 菜单图标
local GOSSIP_ICON_CHAT            = 0                    -- 对话
local GOSSIP_ICON_VENDOR          = 1                    -- 货物
local GOSSIP_ICON_TAXI            = 2                    -- 传送
local GOSSIP_ICON_TRAINER         = 3                    -- 训练（书）
local GOSSIP_ICON_INTERACT_1    	= 4                    -- 复活
local GOSSIP_ICON_INTERACT_2      = 5                    -- 设为我的家
local GOSSIP_ICON_MONEY_BAG   	= 6                    -- 钱袋
local GOSSIP_ICON_TALK            = 7                    -- 申请 说话+黑色点
local GOSSIP_ICON_TABARD          = 8                    -- 工会（战袍）
local GOSSIP_ICON_BATTLE          = 9                    -- 加入战场 双剑交叉
local GOSSIP_ICON_DOT             = 10                   -- 加入战场
local Stone={}

function Stone.ShowGossip(event, player, object)
	Stone.AddGossip(player, object, MMENU)
end
function Stone.SelectGossip(event, player,  object, sender, intid, code, menu_id)
	local M = math.random(1, 5)
	if player:HasItem(U, 1) then
	   player:RemoveItem(U, 1);
	local NPC=player:SpawnCreature(npcEntry[M],1067.967773,1398.907715,30.763605,3.145518, 6,60*1000);
		  player:GossipComplete();
	else
		player:SendBroadcastMessage("|CFFFF0000你没有BOSS召唤石，升级任意品质的血色套装，失败即可获得召唤石|R");
		player:SendAreaTriggerMessage("|CFFFF0000你没有BOSS召唤石，升级任意品质的血色套装，失败即可获得召唤石|R");
		player:GossipComplete();		
end
end

function Stone.AddGossip(player, object, MMENU)
	player:GossipMenuAddItem(GOSSIP_ICON_CHAT, "召唤血色特殊BOSS（出上古之神首饰套装）", 0, 0x100)
	player:GossipSendMenu(1, object)
end
RegisterGameObjectGossipEvent(gameobjectEntry, 1, Stone.ShowGossip)
RegisterGameObjectGossipEvent(gameobjectEntry, 2, Stone.SelectGossip)