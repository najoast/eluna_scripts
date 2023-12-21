 print (">> loading stat.lua")

local itemEntry=199020 --物品id,需要那些可以点击使用的物品，比如炉石之类的
local qtos=1   --每完成多少个任务获得一点分配点数
local cz_item=600000   --重置加点所需要的物品材料
local cz_item_count=5  --重置所需要材料数量

local tj=5529     --表明该所要统计的参数，下面列出参数，当然条件参数远不止这么点，不过我就随便列出两个算了，当然如果改动为杀敌的话，下面的部分说明文字请自行改正。
--[[
3631		---任务数量
5529		---杀敌数量
]]--


local spell_liliang=99901
local spell_liliangup=99902
local spell_minjie=99903
local spell_minjieup=99904
local spell_naili=99905
local spell_nailiup=99906
local spell_zhili=99907
local spell_zhiliup=99908
local spell_jingshen=99909
local spell_jingshenup=99910

local playergid=nil
local questcount=nil
--[[
local goss={----(icon,	text,	intid) 
				{0, 	"力量",	1	},
				{0, 	"敏捷",	2	},
				{0, 	"耐力",	3	},
				{0, 	"智力",	4	},
				{0, 	"精神",	5	},
}
]]--		


local function stat_AddGoss(event, player, item, target,intid)	
	player:GossipClearMenu()	
	playergid=item:GetOwnerGUID()
	player:SaveToDB()
	questcount=CharDBQuery("SELECT * FROM character_achievement_progress WHERE criteria="..tj.." and guid="..playergid..";")
	if questcount then 	
		points=CharDBQuery("SELECT * FROM character_quest_to_point WHERE guid="..playergid..";")	
		if points then
			player:GossipMenuAddItem(0,"当前共计杀死怪物|cFFA50000"..questcount:GetUInt32(2).."|r个。\n\n每杀死|cFFA50000"..qtos.."|r个怪物将获取一点潜力点数。\n\n当前总共获得|cFFA50000"..math.modf(questcount:GetUInt32(2)/qtos).."|r点，剩余|cFFA50000"..math.modf(questcount:GetUInt32(2)/qtos-points:GetUInt32(1)).."|r点。",1,0)
	--[[
	for k,v in pairs(goss) do 	
		local icon,text,intid = v[1],v[2],v[3]
		player:GossipMenuAddItem(icon,text,1,intid)			
	end		
	]]--
			player:GossipMenuAddItem(0,">>  力量 + |cFF006699"..points:GetUInt32(2).."|r",1,1)		
			player:GossipMenuAddItem(0,">>  敏捷 + |cFF006699"..points:GetUInt32(3).."|r",1,2)	
			player:GossipMenuAddItem(0,">>  耐力 + |cFF006699"..points:GetUInt32(4).."|r",1,3)	
			player:GossipMenuAddItem(0,">>  智力 + |cFF006699"..points:GetUInt32(5).."|r",1,4)	
			player:GossipMenuAddItem(0,">>  精神 + |cFF006699"..points:GetUInt32(6).."|r",1,5)	
			player:GossipMenuAddItem(0,">>\n>>  重置加点分配",1,6,false,"确定重置吗？\n\n需要消耗："..GetItemLink(cz_item).." x "..cz_item_count)
			player:GossipSendMenu(1, item)--(npc_text, unit[, menu_id]) 
		else	
			CharDBExecute("insert into character_quest_to_point (guid) VALUES ("..playergid..");")
			player:SendBroadcastMessage("初始化数据。。。")		
		end
	else
		questcount={0,0,0,0}
		player:SendBroadcastMessage("当前杀怪数量为0，请至少杀死一个怪物来开启功能。")			
	end			
end

local function stat_seleGoss(event,player,item,target,intid)
	if intid==0 then
		stat_AddGoss(event, player, item, target,intid)
	elseif 	intid==6 then
		if player:HasItem(cz_item,cz_item_count) then	
			CharDBExecute("DELETE FROM character_quest_to_point WHERE guid="..playergid..";")
			player:RemoveItem(cz_item,cz_item_count)
			player:RemoveAura(spell_liliang)
			player:RemoveAura(spell_liliangup)
			player:RemoveAura(spell_minjie)
			player:RemoveAura(spell_minjieup)
			player:RemoveAura(spell_naili)
			player:RemoveAura(spell_nailiup)
			player:RemoveAura(spell_zhili)
			player:RemoveAura(spell_zhiliup)
			player:RemoveAura(spell_jingshen)
			player:RemoveAura(spell_jingshenup)			
			player:SendBroadcastMessage("重置完毕~~~~")
			player:GossipComplete()	
		else 			
			player:SendBroadcastMessage("重置失败，缺少"..GetItemLink(cz_item).." x "..cz_item_count)
			player:GossipComplete()	
		end
	end		
		
	if (math.modf(questcount:GetUInt32(2)/qtos-points:GetUInt32(1))<=0) then
		player:SendBroadcastMessage("当前剩余潜力点数为0，请继续努力~")
		player:GossipComplete()
	else
		if intid==1 then
			CharDBExecute("update character_quest_to_point set zongshu=zongshu+1,liliang=liliang+1 where guid="..playergid..";")
			local spell_liliang_1=CharDBQuery("SELECT stackcount FROM character_aura WHERE spell="..spell_liliang.." and guid="..playergid..";")		
			if (spell_liliang_1==nil) then 			
				player:AddAura(spell_liliang, player)
				stat_AddGoss(event, player, item, target,intid)		
			else
				if (spell_liliang_1:GetUInt32(0)<250) then
					player:AddAura(spell_liliang, player)
					stat_AddGoss(event, player, item, target,intid)	
				else
					player:RemoveAura(spell_liliang)
					player:AddAura(spell_liliang, player)
					player:AddAura(spell_liliangup, player)
					stat_AddGoss(event, player, item, target,intid)	
				end
			end
		elseif intid==2 then
			CharDBExecute("update character_quest_to_point set zongshu=zongshu+1,minjie=minjie+1 where guid="..playergid..";")
			local spell_minjie_1=CharDBQuery("SELECT stackcount FROM character_aura WHERE spell="..spell_minjie.." and guid="..playergid..";")		
			if (spell_minjie_1==nil) then 			
				player:AddAura(spell_minjie, player)
				stat_AddGoss(event, player, item, target,intid)		
			else
				if (spell_minjie_1:GetUInt32(0)<250) then
					player:AddAura(spell_minjie, player)
					stat_AddGoss(event, player, item, target,intid)	
				else
					player:RemoveAura(spell_minjie)
					player:AddAura(spell_minjie, player)
					player:AddAura(spell_minjieup, player)
					stat_AddGoss(event, player, item, target,intid)	
				end
			end				
		elseif intid==3 then	
			CharDBExecute("update character_quest_to_point set zongshu=zongshu+1,naili=naili+1 where guid="..playergid..";")
			local spell_naili_1=CharDBQuery("SELECT stackcount FROM character_aura WHERE spell="..spell_naili.." and guid="..playergid..";")		
			if (spell_naili_1==nil) then 			
				player:AddAura(spell_naili, player)
				stat_AddGoss(event, player, item, target,intid)		
			else
				if (spell_naili_1:GetUInt32(0)<250) then
					player:AddAura(spell_naili, player)
					stat_AddGoss(event, player, item, target,intid)	
				else
					player:RemoveAura(spell_naili)
					player:AddAura(spell_naili, player)
					player:AddAura(spell_nailiup, player)
					stat_AddGoss(event, player, item, target,intid)	
				end
			end				
		elseif intid==4 then
			CharDBExecute("update character_quest_to_point set zongshu=zongshu+1,zhili=zhili+1 where guid="..playergid..";")
			local spell_zhili_1=CharDBQuery("SELECT stackcount FROM character_aura WHERE spell="..spell_zhili.." and guid="..playergid..";")		
			if (spell_zhili_1==nil) then 			
				player:AddAura(spell_zhili, player)
				stat_AddGoss(event, player, item, target,intid)		
			else
				if (spell_zhili_1:GetUInt32(0)<250) then
					player:AddAura(spell_zhili, player)
					stat_AddGoss(event, player, item, target,intid)	
				else
					player:RemoveAura(spell_zhili)
					player:AddAura(spell_zhili, player)
					player:AddAura(spell_zhiliup, player)
					stat_AddGoss(event, player, item, target,intid)	
				end
			end	
		elseif intid==5 then
			CharDBExecute("update character_quest_to_point set zongshu=zongshu+1,jingshen=jingshen+1 where guid="..playergid..";")
			local spell_jingshen_1=CharDBQuery("SELECT stackcount FROM character_aura WHERE spell="..spell_jingshen.." and guid="..playergid..";")		
			if (spell_jingshen_1==nil) then 			
				player:AddAura(spell_jingshen, player)
				stat_AddGoss(event, player, item, target,intid)		
			else
				if (spell_jingshen_1:GetUInt32(0)<250) then
					player:AddAura(spell_jingshen, player)
					stat_AddGoss(event, player, item, target,intid)	
				else
					player:RemoveAura(spell_jingshen)
					player:AddAura(spell_jingshen, player)
					player:AddAura(spell_jingshenup, player)
					stat_AddGoss(event, player, item, target,intid)	
				end
			end	
		end
	end		
end

	CharDBExecute([[	
CREATE TABLE IF NOT EXISTS `character_quest_to_point` (	
  `guid` int(11) NOT NULL,
  `zongshu` int(11) NOT NULL DEFAULT '0',
  `liliang` int(11) NOT NULL DEFAULT '0',
  `minjie` int(11) NOT NULL DEFAULT '0',
  `naili` int(11) NOT NULL DEFAULT '0',
  `zhili` int(11) NOT NULL DEFAULT '0',
  `jingshen` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	]])



RegisterItemGossipEvent(itemEntry, 1, stat_AddGoss)
RegisterItemGossipEvent(itemEntry, 2, stat_seleGoss)