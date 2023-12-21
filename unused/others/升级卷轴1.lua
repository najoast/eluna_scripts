--[==[
作者游戏研究QQ群：865506553
-- vmangos 可以使用
物品代码 80000
]==]
PrintInfo(">> 升级卷轴 加载开始")
local itemid=80000
local ITEM_EVENT_ON_USE= 2
local MAX_LEVEL=60
-- ITEM_EVENT_ON_USE                               = 2,    // (event, player, item, target) - 
local ITEM_SELECT=[[
select entry from item_template a where a.entry = 80000;
]]
local ITEM_INSERT=[[
INSERT INTO  `item_template` (`entry`, `patch`, `class`, `subclass`, `name`, `description`, `display_id`, `quality`, `flags`, `buy_count`, `buy_price`, `sell_price`, `inventory_type`, `allowable_class`, `allowable_race`, `item_level`, `required_level`, `required_skill`, `required_skill_rank`, `required_spell`, `required_honor_rank`, `required_city_rank`, `required_reputation_faction`, `required_reputation_rank`, `max_count`, `stackable`, `container_slots`, `stat_type1`, `stat_value1`, `stat_type2`, `stat_value2`, `stat_type3`, `stat_value3`, `stat_type4`, `stat_value4`, `stat_type5`, `stat_value5`, `stat_type6`, `stat_value6`, `stat_type7`, `stat_value7`, `stat_type8`, `stat_value8`, `stat_type9`, `stat_value9`, `stat_type10`, `stat_value10`, `delay`, `range_mod`, `ammo_type`, `dmg_min1`, `dmg_max1`, `dmg_type1`, `dmg_min2`, `dmg_max2`, `dmg_type2`, `dmg_min3`, `dmg_max3`, `dmg_type3`, `dmg_min4`, `dmg_max4`, `dmg_type4`, `dmg_min5`, `dmg_max5`, `dmg_type5`, `block`, `armor`, `holy_res`, `fire_res`, `nature_res`, `frost_res`, `shadow_res`, `arcane_res`, `spellid_1`, `spelltrigger_1`, `spellcharges_1`, `spellppmrate_1`, `spellcooldown_1`, `spellcategory_1`, `spellcategorycooldown_1`, `spellid_2`, `spelltrigger_2`, `spellcharges_2`, `spellppmrate_2`, `spellcooldown_2`, `spellcategory_2`, `spellcategorycooldown_2`, `spellid_3`, `spelltrigger_3`, `spellcharges_3`, `spellppmrate_3`, `spellcooldown_3`, `spellcategory_3`, `spellcategorycooldown_3`, `spellid_4`, `spelltrigger_4`, `spellcharges_4`, `spellppmrate_4`, `spellcooldown_4`, `spellcategory_4`, `spellcategorycooldown_4`, `spellid_5`, `spelltrigger_5`, `spellcharges_5`, `spellppmrate_5`, `spellcooldown_5`, `spellcategory_5`, `spellcategorycooldown_5`, `bonding`, `page_text`, `page_language`, `page_material`, `start_quest`, `lock_id`, `material`, `sheath`, `random_property`, `set_id`, `max_durability`, `area_bound`, `map_bound`, `duration`, `bag_family`, `disenchant_id`, `food_type`, `min_money_loot`, `max_money_loot`, `extra_flags`, `other_team_entry`) VALUES ('80000', '0', '0', '0', '升级卷轴', '每次使用升一级', '1301', '1', '0', '5', '25', '1', '0', '-1', '-1', '5', '1', '0', '0', '0', '0', '0', '0', '0', '0', '20', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '433', '0', '-1', '0', '0', '11', '1000', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '0', '1');
]]
--PrintInfo(">> " .. ITEM_SELECT)
local TEAM_ALLIANCE=0
local TEAM_HORDE=1
--CLASS					职业	
local CLASS_WARRIOR 		= 1		--战士
local CLASS_PALADIN			= 2		--圣骑士
local CLASS_HUNTER			= 3		--猎人
local CLASS_ROGUE			= 4		--盗贼
local CLASS_PRIEST			= 5		--牧师
local CLASS_DEATH_KNIGHT	= 6		--死亡骑士
local CLASS_SHAMAN			= 7		--萨满
local CLASS_MAGE			= 8		--法师
local CLASS_WARLOCK			= 9		--术士
local CLASS_DRUID			= 11	--德鲁伊

local ClassName={--职业表
	[CLASS_WARRIOR]	="战士",
	[CLASS_PALADIN]	="圣骑士",
	[CLASS_HUNTER]	="猎人",
	[CLASS_ROGUE]	="盗贼",
	[CLASS_PRIEST]	="牧师",
	[CLASS_DEATH_KNIGHT]="死亡骑士",
	[CLASS_SHAMAN]	="萨满",
	[CLASS_MAGE]	="法师",
	[CLASS_WARLOCK]	="术士",
	[CLASS_DRUID]	="德鲁伊",
}

local function GetPlayerInfo(player)--得到玩家信息
	local Pclass	= ClassName[player:GetClass()] or "? ? ?" --得到职业
	local Pname		= player:GetName()
	local Pteam		= ""
	local team=player:GetTeam()
	if(team==TEAM_ALLIANCE)then
		Pteam		="|cFF0070d0联盟|r"
	elseif(team==TEAM_HORDE)then 
		Pteam		="|cFFF000A0部落|r"
	end
	return string.format("%s%s玩家[|cFF00FF00|Hplayer:%s|h%s|h|r]",Pteam,Pclass,Pname,Pname)
end

local Q = WorldDBQuery(ITEM_SELECT)
if Q then
    repeat
        local entry  = Q:GetUInt32(0)
        PrintInfo(">> 升级卷轴 物品已存在")
    until not Q:NextRow()
else
	WorldDBExecute(ITEM_INSERT)
	PrintInfo(">> 升级卷轴 物品新增完成")
end

local function levelup (event, player, item, target)
	PrintInfo(">> 升级卷轴 “" .. player:GetName() .. "”使用一次,当前等级" .. player:GetLevel())
	--PrintInfo(">> 当前等级：" .. player:GetLevel())
	if(player:GetLevel()>=MAX_LEVEL) then
		player:SendBroadcastMessage(string.format("%s 你已经是最高等级 %d，使用无效", player:GetName(),MAX_LEVEL))
	else
		player:SetLevel(player:GetLevel()+1)
		SendWorldMessage("|cFFFF0000[系统公告]|r恭喜"..GetPlayerInfo(player).." 使用升级卷轴升到" .. player:GetLevel() .. "级！")
	end	
end 

RegisterItemEvent( itemid, ITEM_EVENT_ON_USE, levelup )
-- cancel = RegisterItemEvent( entry, event, function )
PrintInfo(">> 升级卷轴 加载完成")
