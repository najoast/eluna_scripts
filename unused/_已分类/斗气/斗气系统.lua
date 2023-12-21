--[[
历练系统LUA---击杀指定怪物获得历练值，分配给角色属性
]]--

function showInfo(event, player) 
	player:SendBroadcastMessage( "|cFFFF0000[功能提示]|r历练系统：完成任务和成就会获得历练值,然后去吃苹果" )
end

RegisterPlayerEvent( 3, showInfo)

print(">>Script: douqixitong.lua Loading...OK")

local itemEntry=4536 -- 打开历练界面的物品
local countScaleQ = 0.3 -- 一个任务几点历练值
local countScaleA = 3 -- 一个成就几点历练值
local czitem=43629 -- 重置历练点需要消耗的物品ID
local czitemcount=1 -- 重置历练点消耗物品数量
local xiaofeicount=1 -- 每次加点消耗多少经验
local jiadianshangxian=200 -- 每个属性最高分配多少次


-- local spell_liliang=8118
-- local spell_minjie=8115
-- local spell_naili=8099
-- local spell_zhili=8096
-- local spell_jingshen=8112
local spells = {
	[1]=16609,
	[2]=22888,
	[3]=12178,
	[4]=12176,
	[5]=12177,
}

local douqizhi=nil
local shuxingcount=1
local dqz={}
local aura={}


-- local function guaiwuDQ(event, killer, killed)
-- 	local killedu=killed:ToUnit()
--     local douqizhi=CharDBQuery("SELECT * FROM characters_douqi WHERE guid="..killer:GetGUIDLow()..";")	
-- 	    if (douqizhi==nil) then
-- 		    CharDBExecute("INSERT INTO characters_douqi VALUES ("..killer:GetGUIDLow()..", 0, 0, 0, 0, 0, 0, 0);")
-- 			killer:SaveToDB()
-- 			killer:SendBroadcastMessage("|CFFFF0080【历练系统】|r 初次击杀初始化存档")
-- 		else
-- 			CharDBExecute("UPDATE characters_douqi SET douqizhi=douqizhi+"..(killedu:GetLevel()).." WHERE guid="..killer:GetGUIDLow()..";")
-- 			killer:SaveToDB()
-- 			killer:SendBroadcastMessage("|CFFFF0080【历练系统】|r 获得"..(killedu:GetLevel()).."点历练值.")
-- 		end			   
-- end

local function Douqi_AddGoss(event, player, item, target,intid)
	quest=CharDBQuery("SELECT count(*) FROM character_queststatus_rewarded WHERE guid="..player:GetGUIDLow()..";")
	achievement=CharDBQuery("SELECT count(*) FROM character_achievement WHERE guid="..player:GetGUIDLow()..";")
	douqizhi=CharDBQuery("SELECT * FROM characters_douqi WHERE guid="..player:GetGUIDLow()..";")
	if (douqizhi==nil) then
		CharDBExecute("INSERT INTO characters_douqi VALUES ("..player:GetGUIDLow()..", 0, 0, 0, 0, 0, 0, 0);")
		douqizhi=CharDBQuery("SELECT * FROM characters_douqi WHERE guid="..player:GetGUIDLow()..";")
	end

	dqz[0]=quest:GetUInt32(0)*countScaleQ + achievement:GetUInt32(0)*countScaleA - douqizhi:GetUInt32(7)
	dqz[1]=douqizhi:GetUInt32(2)
	dqz[2]=douqizhi:GetUInt32(3)
	dqz[3]=douqizhi:GetUInt32(4)
	dqz[4]=douqizhi:GetUInt32(5)
	dqz[5]=douqizhi:GetUInt32(6)
	dqz[6]=douqizhi:GetUInt32(7)

	UpdateAura(player:ToUnit())
	ShwoMenu(player,item)
end

function UpdateAura(player)
	
	aura[1]=GetAuraCount(player,spells[1])
	aura[2]=GetAuraCount(player,spells[2])
	aura[3]=GetAuraCount(player,spells[3])
	aura[4]=GetAuraCount(player,spells[4])
	aura[5]=GetAuraCount(player,spells[5])
end
function GetAuraCount(player,id)
	if player:HasAura(id) then 
		return player:GetAura(id):GetStackAmount() 
	else 
		return 0 
	end
end
function Up(player,item,price,intid)
	player:AddAura(spells[intid], player)
	dqz[intid]=dqz[intid]+1
	dqz[0]=dqz[0]-price
	dqz[6]=dqz[6]+price
	UpdateAura(player)
	ShwoMenu(player,item)
end
function ShwoMenu(player,item)
	player:GossipClearMenu()
	player:GossipMenuAddItem(8,"|CFFFF0080【历练系统】|r 完成任务会增加历练值 \n 剩余历练值：|CFFFF0000"..dqz[0].."|r",1,0)
	player:GossipMenuAddItem(5,"|cff0000ff酋长的祝福|r     加点消耗历练：[|CFFFF0000"..(aura[1]+1)*xiaofeicount.."|r]",1,1)		
	player:GossipMenuAddItem(5,"|cff0000ff屠龙者咆哮|r     加点消耗历练：[|CFFFF0000"..(aura[2]+1)*xiaofeicount.."|r]",1,2)	
	-- player:GossipMenuAddItem(5,"|cff0000ff耐力|r     加点消耗历练：[|CFFFF0000"..(aura[3]+1)*xiaofeicount.."|r]",1,3)	
	-- player:GossipMenuAddItem(5,"|cff0000ff智力|r     加点消耗历练：[|CFFFF0000"..(aura[4]+1)*xiaofeicount.."|r]",1,4)	
	-- player:GossipMenuAddItem(5,"|cff0000ff精神|r     加点消耗历练：[|CFFFF0000"..(aura[5]+1)*xiaofeicount.."|r]",1,5)
	player:GossipMenuAddItem(0,"|cFFA50000重置历练值|r",1,9,false,"确定重置吗？",player:GetLevel()^3)
	player:GossipSendMenu(1, item)
end

local function Douqi_seleGoss(event,player,item,target,intid)
    -- local playeru=player:ToUnit()
    if intid==0 then
		player:GossipComplete()
	end
    if intid==8 then
		-- Douqi_AddGoss(event, player, item, target,intid)
    elseif 	intid==9 then
        -- if (player:HasItem(czitem,czitemcount)) then
			CharDBExecute("update characters_douqi set douqizhi=douqizhi+used,used=0,liliang=0,minjie=0,naili=0,zhili=0,jingshen=0 where guid="..player:GetGUIDLow()..";")
		    -- player:RemoveItem(czitem,czitemcount)
			player:ModifyMoney(-player:GetLevel()^3)
			player:RemoveAura(spells[1])
			player:RemoveAura(spells[2])
			-- player:RemoveAura(spells[3])
			-- player:RemoveAura(spells[4])
			-- player:RemoveAura(spells[5])
			player:SendBroadcastMessage("|CFFFF0080【历练系统】|r 重置成功！！请重新打开菜单分配点数.")
			player:GossipComplete()
		-- else
		--     player:SendBroadcastMessage("|CFFFF0080【历练系统】|r 重置失败.缺少"..GetItemLink(czitem).." x "..czitemcount.."")
		-- 	player:GossipComplete()
		-- end
    end

   	price=(aura[intid]+1)*xiaofeicount
	if (dqz[0] < price) then
	    player:SendBroadcastMessage("|CFFFF0080【历练系统】|r 可分配的历练值不足.")
		player:GossipComplete()
	else
	    if intid==1 then
				CharDBExecute("update characters_douqi set used=used+"..price..",douqizhi=douqizhi-"..price..",liliang=liliang+"..shuxingcount.." where guid="..player:GetGUIDLow()..";")
				Up(player,item,price,intid)
		elseif intid==2 then
				CharDBExecute("update characters_douqi set used=used+"..price..",douqizhi=douqizhi-"..price..",minjie=minjie+"..shuxingcount.." where guid="..player:GetGUIDLow()..";")
				Up(player,item,price,intid)
		elseif intid==3 then
				CharDBExecute("update characters_douqi set used=used+"..price..",douqizhi=douqizhi-"..price..",naili=naili+"..shuxingcount.." where guid="..player:GetGUIDLow()..";")
				Up(player,item,price,intid)
		elseif intid==4 then
				CharDBExecute("update characters_douqi set used=used+"..price..",douqizhi=douqizhi-"..price..",zhili=zhili+"..shuxingcount.." where guid="..player:GetGUIDLow()..";")
				Up(player,item,price,intid)
		elseif intid==5 then
				CharDBExecute("update characters_douqi set used=used+"..price..",douqizhi=douqizhi-"..price..",jingshen=jingshen+"..shuxingcount.." where guid="..player:GetGUIDLow()..";")
				Up(player,item,price,intid)
		end
	end		
end



	CharDBExecute([[	
CREATE TABLE If Not Exists `characters_douqi` (
  `guid` int(10) NOT NULL,
  `douqizhi` int(30) NOT NULL DEFAULT '0',
  `liliang` int(30) NOT NULL,
  `minjie` int(30) NOT NULL,
  `naili` int(30) NOT NULL,
  `zhili` int(30) NOT NULL,
  `jingshen` int(30) NOT NULL,
  `used` int(30) NOT NULL,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	]])

-- RegisterPlayerEvent(7, guaiwuDQ)
RegisterItemGossipEvent(itemEntry, 1, Douqi_AddGoss)
RegisterItemGossipEvent(itemEntry, 2, Douqi_seleGoss)