-- 玩家上线欢迎系统

print(">>Script: Player Greeting")

local TEAM_ALLIANCE=0
local TEAM_HORDE=1
--CLASS职业
local CLASS_WARRIOR      = 1--战士
local CLASS_PALADIN      = 2--圣骑士
local CLASS_HUNTER       = 3--猎人
local CLASS_ROGUE        = 4--盗贼
local CLASS_PRIEST       = 5--牧师
local CLASS_DEATH_KNIGHT = 6--死亡骑士
local CLASS_SHAMAN       = 7--萨满
local CLASS_MAGE         = 8--法师
local CLASS_WARLOCK      = 9--术士
local CLASS_DRUID        = 11--德鲁伊

--职业表
local ClassName = {
	[CLASS_WARRIOR]      = "战士",
	[CLASS_PALADIN]      = "圣骑士",
	[CLASS_HUNTER]       = "猎人",
	[CLASS_ROGUE]        = "盗贼",
	[CLASS_PRIEST]       = "牧师",
	[CLASS_DEATH_KNIGHT] = "死亡骑士",
	[CLASS_SHAMAN]       = "萨满",
	[CLASS_MAGE]         = "法师",
	[CLASS_WARLOCK]      = "术士",
	[CLASS_DRUID]        = "德鲁伊",
}

local function GetPlayerInfo(player)--得到玩家信息
	local class = ClassName[player:GetClass()] or "? ? ?" --得到职业
	local name = player:GetName()
	local team = ""
	local teamType = player:GetTeam()
	if teamType == TEAM_ALLIANCE then
		team = "|cFF0070d0联盟|r"
	elseif teamType == TEAM_HORDE then
		team = "|cFFF000A0部落|r"
	end
	return string.format("%s%s玩家[|cFF00FF00|Hplayer:%s|h%s|h|r]",team,class,name,name)
end

local function OnPlayerFirstLogin(event, player)--玩家首次登录
	SendWorldMessage("|cFFFF0000[系统]|r欢迎"..GetPlayerInfo(player).." 首次进入|cFFFF0000全栈魔兽。|r")
	print("Player is Created. GUID:"..player:GetGUIDLow())
end

local function OnPlayerLogin(event, player)--玩家登录
	SendWorldMessage("|cFFFF0000[系统]|r欢迎"..GetPlayerInfo(player).." 上线。")
	print("Player is Login. GUID:"..player:GetGUIDLow())
end

local function OnPlayerLogout(event, player)--玩家登出
	SendWorldMessage("|cFFFF0000[系统]|r"..GetPlayerInfo(player).." 下线。")
	print("Player is Logout. GUID:"..player:GetGUIDLow())
end

RegisterPlayerEvent(30, OnPlayerFirstLogin)--首次登录
RegisterPlayerEvent(3, OnPlayerLogin)--登录
RegisterPlayerEvent(4, OnPlayerLogout)--登出
