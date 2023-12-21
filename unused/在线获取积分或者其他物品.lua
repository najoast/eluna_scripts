 print (">> loading online_jf.lua")


local ItemEntry=21833 --用于使用后查看积分并兑换的物品entry。 ps 其实可以整合到什么超级炉石那里的，所选用的物品必须带技能的能使用的。
local jf_entry=299998 --代表积分的物品可以叫某某货币之类的,本来想直接加在数据库值然后读取的 不过兑换东西的时候太麻烦，所以还是做成了物品容易用于兑换。
local jf_mins=300 --设置每多少分钟得到1点积分。

local mins=nil
local jf=nil	
local jf_count=nil
local inGameTime=nil
local playergid=nil
local jf_DBtime=nil
local jf_ingametime=nil
	
local function online_jf(event, player, item, target)	
	player:MoveTo(0,player:GetX(),player:GetY(),player:GetZ()+0.01)
	--player:GossipComplete()
	player:GossipClearMenu()	
	playergid=item:GetOwnerGUID()	
	jf_DBtime=CharDBQuery("SELECT * FROM characters_jf WHERE guid="..playergid..";")
	if (jf_DBtime==nil) then	
		CharDBExecute("insert into characters_jf (guid,jf_time,jf) VALUES ("..playergid..",0,0);")		
		player:SendBroadcastMessage("首次领取，初始化数据，请再次点击使用。")		
	else
	inGameTime=player:GetTotalPlayedTime()
	jf_ingametime=math.modf(inGameTime-jf_DBtime:GetUInt32(1))
	jf=math.modf(jf_ingametime/60/jf_mins)
	mins=math.modf(jf_ingametime/60)	
	jf_count=player:GetItemCount(jf_entry)		
		if(jf_count==nil) then 
			jf_count=0 
		end				
	player:GossipComplete()										
	player:GossipMenuAddItem(0,"您当前拥有"..GetItemLink(jf_entry).." x "..jf_count.."。\n\n累计共领取"..GetItemLink(jf_entry).." x "..jf_DBtime:GetUInt32(2).."\n\n累计未兑换的在线时间: "..mins.."分钟\n\n每在线"..jf_mins.."分钟可以兑换"..GetItemLink(jf_entry).." x 1  \n\n你当前一共可以兑换"..GetItemLink(jf_entry).." x "..jf.." ",1,1)
	player:GossipMenuAddItem(1,"点击确定兑换",1,1)
	player:GossipSendMenu(1, item)	
	--player:GossipClearMenu()
	--player:GossipComplete()
	end		
end

local function timetojf(event, player, item, target)
	if (jf==0) then
		  player:SendBroadcastMessage("兑换失败，累计在线时间少于"..jf_mins.."分钟。")
	else
	 jf=math.modf(jf_ingametime/60/jf_mins)
	  player:AddItem(jf_entry, jf)		
	  playergid=item:GetOwnerGUID()		
	  CharDBExecute("update characters_jf set jf_time=jf_time+"..jf_ingametime..",jf=jf+"..jf.." where guid="..playergid..";")
	  player:SendBroadcastMessage("成功兑换"..GetItemLink(jf_entry).." x " ..jf)
	  player:GossipComplete()
	  player:GossipClearMenu()
	end
	 
end


	CharDBExecute([[	
CREATE TABLE IF NOT EXISTS `characters_jf` (
  `guid` int(10) NOT NULL,
  `jf_time` int(10) NOT NULL DEFAULT '0',
  `jf` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	]])


RegisterItemEvent(ItemEntry, 2, online_jf)
RegisterItemGossipEvent(ItemEntry, 2, timetojf)
