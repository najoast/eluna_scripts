
--[[作者信息：
	Command Extra  （游戏命令扩展）
	作者QQ：247321453
	作者Email：247321453@qq.com
	修改日期：2014-3-12
	功能：添加额外的命令、GM命令
]]--
print(">>Script: Command Extra.")

--[[
.wmsg 内容		GM发送世界消息
.be    			查看机器人装备
.npcbot equips  查看机器人装备
.rh 			GM回复生命
.reset hp 		GM回复生命
.gh				传送回家
.go home		传送回家
.卡				传送回家
]]--
	
local function ShowBotEquip(player)--查看机器人装备
	local guid=player:GetGUIDLow()--得到玩家的guid
	local target=player:GetSelection()--得到玩家选中对象
	local text=""
	if(target)then
		if(target:GetTypeId()==3)then--目标是生物
			local Q = CharDBQuery("SELECT * FROM character_npcbot Where owner="..guid.." and entry="..target:GetEntry().." and active=1")
			--player:Say("me: "..guid.." target:"..target:GetEntry(),0)
			if(Q)then--查到相应的信息
				text=target:GetName().."的装备：\n"
				for i=5,22 do 
					local item=Q:GetUInt32(i)--读取内容
					if(item and item >0)then
						text=text..GetItemLink(item).." "
						target:SendUnitWhisper(GetItemLink(item),player)--向玩家悄悄话
					end
				end
				--target:SendUnitSay(text,0)
			else
				player:Say("没有找到机器人，或者没有选中机器人",0)
			end
		else
			player:Say("请选中一个机器人。",0)
		end
	else
		player:Say("请选中一个机器人。",0)
	end
	return text
end

local function ResetHP(player)
	if(player:GetGMRank()>=3)then--判断是不是GM
		player:SetHealth(player:GetMaxHealth())
		player:SendBroadcastMessage("已经回复生命。")
		return false
	else
		return true
	end
end

local function Start(player)
	player:CastSpell(player,8690,true)	
	player:ResetSpellCooldown(8690, true)
	player:SendBroadcastMessage("已经回到家")
end

local CMD={
	["go home"]=function(player)
		Start(player)
	end,
	["gh"]=function(player)
		Start(player)
	end,
	["卡"]=function(player)
		Start(player)
	end,
	["wmsg"]=function(player,msg)
		if(player)then
			if(player:GetGMRank()>=3)then
				SendWorldMessage(string.format("|cFFFF0000[系统]|r|cFFFFFF00%s|r",msg))
			end
		else
			SendWorldMessage(string.format("|cFFFF0000[系统]|r|cFFFFFF00%s|r",msg))
		end
	end,
	["be"]=function(player)--机器人装备
		ShowBotEquip(player)
		return false
	end,
	
	["npcbot equips"]=function(player)--机器人装备
		ShowBotEquip(player)
		return false
	end,
	
	["reset hp"]=function(player)--GM回复生命
		ResetHP(player)
	end,
	
	["rh"]=function(player)--GM回复生命
		ResetHP(player)
	end,
}

function CMD.Input(event, player, command)
	local cmd,space,excmd=command,command:find(" ") or 0,""
	if(space>1)then
		cmd=command:sub(1,space-1)--主命令
		excmd=command:sub(space+1)--额外命令参数
	end
	local func=CMD[cmd]--用输入的命令去查找函数
	if(func)then
		return func(player,excmd) or false
	end
end
--PLAYER_EVENT_ON_COMMAND =     42       -- (event, player, command) - Can return false
RegisterPlayerEvent(42,CMD.Input)
