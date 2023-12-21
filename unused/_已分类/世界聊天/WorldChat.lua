print(">>Script: Wolrd Chating.")

local info="|cFFFF0000[功能提示]|r世界聊天：@+消息内容"
local SAY="@"--普通聊天

local TEAM_ALLIANCE	= 0	--联盟阵营
local TEAM_HORDE	= 1	--部落阵营

local CLASS={--职业号
	WARRIOR 		= 1,		--战士
	PALADIN			= 2,	--圣骑士
	HUNTER			= 3,		--猎人
	ROGUE			= 4,		--盗贼
	PRIEST			= 5,		--牧师
	DEATH_KNIGHT	= 6,		--死亡骑士
	SHAMAN			= 7,		--萨满
	MAGE			= 8,		--法师
	WARLOCK			= 9,		--术士
	DRUID			= 11,	--德鲁伊
}	

local ClassName={--职业表
	[CLASS.WARRIOR]	="战士",
	[CLASS.PALADIN]	="圣骑士",
	[CLASS.HUNTER]	="猎人",
	[CLASS.ROGUE]	="盗贼",
	[CLASS.PRIEST]	="牧师",
	[CLASS.DEATH_KNIGHT]="死亡骑士",
	[CLASS.SHAMAN]	="萨满",
	[CLASS.MAGE]	="法师",
	[CLASS.WARLOCK]	="术士",
	[CLASS.DRUID]	="德鲁伊",
}
	
local function GetPlayerInfo(player)--得到玩家信息
	local Pclass	= ClassName[player:GetClass()] or "???" --得到职业
	local Pname		= player:GetName()
	local Pteam		= ""
	local team=player:GetTeam()
	if(team==TEAM_ALLIANCE)then
		Pteam="|cFF0070d0联盟|r"
	elseif(team==TEAM_HORDE)then 
		Pteam="|cFFF000A0部落|r"
	end
	return string.format("%s %s [|cFF00FF00|Hplayer %s|h%s|h|r]",Pteam,Pclass,Pname,Pname)
end


local function PlayerOnChat(event, player, msg, Type, lang)--世界聊天
	local head=string.format("[世界]|cFFF08000%s|r %s说： ","",GetPlayerInfo(player))
	if(string.find(msg,SAY)==1)then
		SendWorldMessage(string.format("%s|cFFFFFFFF%s|r",head,msg:sub(SAY:len()+1)))
		return false
	end
end
RegisterPlayerEvent(18, PlayerOnChat) --世界聊天

function showInfo(event, player) 
	player:SendBroadcastMessage( info )
end

RegisterPlayerEvent( 3, showInfo)