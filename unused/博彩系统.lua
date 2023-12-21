--[[博彩系统 by ljq5555
]]--

print(">>Script: bocai.lua loading...OK")

local itemEntry=159    ------赌博需要的物品ID（带使用性质的）
--赌博1
local RWitem1=49426
local RWitemcount1=1    --------扣除的数量
local RWitemName1="寒冰纹章1个"
local RWitemS1={49426}      ---------奖励的物品ID,可以填入多个

--赌博2
local RWitem2=49426
local RWitemName2="寒冰纹章1个"
local RWitemS2={49426}       ---------奖励的物品ID
local RWitemcount2=1      --------扣除的数量
--赌博3
local RWitem3=49426
local RWitemName3="寒冰纹章1个"
local RWitemS3={49426}   ---------奖励的物品ID
local RWitemcount3=1      --------扣除的数量

local function dubo_AddGoss (event, player, item, target, intid)
     player:SendBroadcastMessage("★★★★★★★★★★|CFFFF0000欢迎使用超级时时彩系统|R★★★★★★★★★★")
	 player:SendBroadcastMessage("★★★★★★★★★★|cffff0000      祝您中大奖      |R★★★★★★★★★★")
	        player:GossipClearMenu()
	        player:GossipMenuAddItem(7,"超级时时彩系统,来看看你的运气值多少钱吧！",1,0)
	        player:GossipMenuAddItem(2,"赌|cff0990ff"..RWitemName1.."|r一次|cffff0000"..RWitemcount1.."|r个",1,1)		
	        player:GossipMenuAddItem(5,"赌|CFFFF0080大|r|cff0000ff大于50的数字|r",1,2)	
		     player:GossipMenuAddItem(5,"赌|CFFFF0080豹子|r|cff0000ff两位一样的数字|r",1,3)	
			    player:GossipMenuAddItem(5,"赌|CFFFF0080小|r|cff0000ff小于等于50的数字|r",1,4)	
					        player:GossipMenuAddItem(2,"赌|cff0330ff"..RWitemName2.."|r一次|cffff0000"..RWitemcount2.."|r个",1,5)		
	        player:GossipMenuAddItem(5,"赌|CFFFF0080大|r|cff0000ff大于50的数字|r",1,6)	
		     player:GossipMenuAddItem(5,"赌|CFFFF0080豹子|r|cff0000ff两位一样的数字|r",1,7)	
			    player:GossipMenuAddItem(5,"赌|CFFFF0080小|r|cff0000ff小于等于50的数字|r",1,8)	
								        player:GossipMenuAddItem(2,"赌|cff00cc00"..RWitemName3.."|r一次|cffff0000"..RWitemcount3.."|r个",1,9)		
	        player:GossipMenuAddItem(5,"赌|CFFFF0080大|r|cff0000ff大于50的数字|r",1,10)	
		     player:GossipMenuAddItem(5,"赌|CFFFF0080豹子|r|cff0000ff两位一样的数字|r",1,11)	
			    player:GossipMenuAddItem(5,"赌|CFFFF0080小|r|cff0000ff小于等于50的数字|r",1,12)	
	        player:GossipSendMenu(1, item)

	   
end

local function dubo_seleGoss (event,player,item,target,intid)
 	if(intid == 0 or intid ==1  or intid == 5  or intid == 9 ) then
	    player:GossipComplete()
	    return
	end
 local item=0
 local count=0
 local items={}
 	if (intid == 2 or intid == 3 or intid == 4) then
	     if player:HasItem(RWitem1,RWitemcount1) then
             item=RWitem1
			 count=RWitemcount1
			 items =RWitemS1
	     else
	     player:SendBroadcastMessage("需要"..GetItemLink(RWitem1).."X"..RWitemcount1..",您的物品不足...")
		     player:GossipComplete()
		    return
	     end
	 elseif (intid == 6 or intid == 7 or intid == 8) then
	 	 if player:HasItem(RWitem2,RWitemcount2) then
        item=RWitem2
			 count=RWitemcount2
			 items =RWitemS2
	     else
	       player:SendBroadcastMessage("需要"..GetItemLink(RWitem2).."X"..RWitemcount2..",您的物品不足...")
		       player:GossipComplete()
		      return
	     end
	elseif (intid == 10 or intid == 11 or intid == 12) then
	    if player:HasItem(RWitem3,RWitemcount3) then
		        item=RWitem3
			 count=RWitemcount3
			 items =RWitemS3
	      else
	       player:SendBroadcastMessage("需要"..GetItemLink(RWitem3).."X"..RWitemcount3..",您的物品不足...")
		       player:GossipComplete()
		   return
	     end
	end
	   local playidlist= math.random(1,100)--
	   local bocai=0
	   local bocai1=0
	   if (playidlist==11 or playidlist==22 or playidlist==33 or playidlist==44 or playidlist==55 or playidlist==66 or playidlist==77 or playidlist==88 or playidlist==99) then
	   bocai1=2
	   elseif (playidlist<50) then
	   bocai1=0
	   else
	   bocai1=1
	   end 
	      if (intid==2 or intid==6 or intid==10) then
		     player:SendBroadcastMessage("您选择了大,请等待开奖...")
			 bocai=1
		    elseif (intid==3 or intid==7 or intid==11 	) then
		     player:SendBroadcastMessage("您选择了豹子,请等待开奖...")
			  bocai=2
		    else  
		     player:SendBroadcastMessage("您选择了小,请等待开奖...")
			  bocai=0
		  end
   if (bocai1==bocai) then
        player:AddItem(item,count)
        player:SendBroadcastMessage("本次数字："..playidlist..",您猜中了,请查收您的奖励")
		 local jl=10
		if (bocai==2) then
		jl=30
		  player:AddItem(item,count)
		  player:AddItem(item,count)
		   player:SendBroadcastMessage("您选择的是豹子,多送2倍奖励,请查收!")	
  	 SendWorldMessage("|cffff0000[超级时时彩]|r：|cffFFFFFF恭喜玩家|cffff0000["..player:GetName().."]|r|cffFFFFFF博彩中奖.获得豹子奖励|r "..GetItemLink(item).."*"..count.."个*3倍")		   
		else
 	 SendWorldMessage("|cffff0000[超级时时彩]|r：|cffFFFFFF恭喜玩家|cffff0000["..player:GetName().."]|r|cffFFFFFF博彩中奖.获得奖励|r "..GetItemLink(item).."*"..count.."个")
   end
   else
   		 player:RemoveItem(item,count)
  		 player:SendBroadcastMessage("本次数字："..playidlist..",您未中奖,扣除您的赌注"..GetItemLink(item).."X"..count)
   end
    player:GossipComplete()
	 player:SendBroadcastMessage("★★★★★★★★★★|CFF00FFFF提醒:小赌怡情,大赌伤身|R★★★★★★★★★★")
	 player:SendBroadcastMessage("★★★★★★★★★★|CFF00FFFF     欢迎下次再用     |R★★★★★★★★★★")
end

--RegisterServerEvent(5, datiXT)
RegisterItemGossipEvent(itemEntry, 1, dubo_AddGoss)
RegisterItemGossipEvent(itemEntry, 2, dubo_seleGoss)

