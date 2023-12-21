
print(">>Script:  特色模块.lua Loading...OK")

local itemEntry=159    ------赌博需要的物品ID（带使用性质的）

local function Douqi_AddGoss(event, player, item, target,intid)
	douqizhi=CharDBQuery("SELECT count(*) FROM character_queststatus_rewarded WHERE guid="..player:GetGUIDLow()..";")
	SendWorldMessage(douqizhi:GetUInt32(1))
end

-- 	CharDBExecute([[	
-- CREATE TABLE If Not Exists `characters_douqi_hx` (
--   `guid` int(10) NOT NULL,
--   `douqizhi` int(30) NOT NULL DEFAULT '0',
--   `liliang` int(30) NOT NULL,
--   `minjie` int(30) NOT NULL,
--   `naili` int(30) NOT NULL,
--   `zhili` int(30) NOT NULL,
--   `jingshen` int(30) NOT NULL,
--   `used` int(30) NOT NULL,
--   PRIMARY KEY (`guid`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- 	]])

local function guaiwuDQ(event, killer, killed)
	douqizhi=CharDBQuery("SELECT count(*) FROM character_queststatus_rewarded WHERE guid="..killer:GetGUIDLow()..";")
	SendWorldMessage(douqizhi:GetUInt32(0))  
end
RegisterPlayerEvent(7, guaiwuDQ)
RegisterItemGossipEvent(itemEntry, 1, Douqi_AddGoss)