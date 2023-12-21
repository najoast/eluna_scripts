   
    local itemid =6948
	local ItemEntry =60000
	
	local ST={
	TIME=90,
	NPCID1=60003,
	NPCID2=152,
--{guid,npc,time},
}


    function Tele_Book(event, player, item)
		player:MoveTo(0,player:GetX()+0.01,player:GetY(),player:GetZ())
            if (player:IsInCombat() == true) then
                    player:SendAreaTriggerMessage("你不能在战斗中使用!")
            else
                    Tele_Menu(item, player)
            end
    end
     
    function Tele_Menu(item, player) -- Home Page
    --player:GossipMenuAddItem(5, "|cffff6060传送石|r", 0,  998)
    player:GossipMenuAddItem(6, "|TInterface\\ICONS\\achievement_zone_zuldrak_05.blp:30|t |cff0000ff各大主城传送", 0,  1)
    player:GossipMenuAddItem(2, "|cFFFF0000|TInterface\\ICONS\\Achievement_BG_winWSG.blp:30|t 超级副本", 0,  801)
	player:GossipMenuAddItem(9, "|TInterface\\ICONS\\Achievement_BG_winWSG.blp:30|t 古拉巴什竞技场", 0,  13)
	player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Zone_EasternKingdoms_01.blp:30|t 东部王国地区", 0,  27)
    player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Zone_Kalimdor_01.blp:30|t 卡利姆多地区", 0,  28)
    player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Boss_PrinceKeleseth.blp:30|t 艾泽拉斯副本", 0,  3)
    player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Zone_Blackrock_01.blp:30|t 艾泽拉斯团队副本", 0,  4)
    player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Zone_Outland_01.blp:30|t 外域地区", 0,  5)
    player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_boss_murmur.blp:30|t 外域副本", 0,  6)
    player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Zone_IsleOfQuelDanas.blp:30|t 外域团队副本", 0,  7)
    player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Zone_Northrend_01.blp:30|t 诺森德地区", 0,  8)
    player:GossipMenuAddItem(2, "|TInterface\\LFGFrame\\LFGIcon-TheForgeofSouls.blp:30|t 诺森德副本", 0,  9)
    player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Zone_IceCrown_01.blp:30|t 诺森德团队副本", 0,  10)
    player:GossipSendMenu(1, item)
    end
	
	function Tele_Select(event, player, item, sender, intid, code)
    local plyr = player:GetRace()
    local x, y, z, o = player:GetX(), player:GetY(), player:GetZ(), player:GetO()
     
    --Go Home 
 
    if (intid == 1) then -- Alliance Cities
            if (plyr == 1) or (plyr == 3) or (plyr == 4) or (plyr == 7) or (plyr == 11) then
                    player:GossipMenuAddItem(2, "|cFF990066|TInterface\\ICONS\\Achievement_Zone_GrizzlyHills_01.blp:30|t [主城]达拉然", 0,  203)
					player:GossipMenuAddItem(2, "|cFF0000CC|TInterface\\ICONS\\Achievement_Leader_King_Magni_Bronzebeard.blp:30|t [联盟]铁炉堡", 0,  20)
                    player:GossipMenuAddItem(2, "|cFF0000CC|TInterface\\ICONS\\Achievement_Leader_King_Varian_Wrynn.blp:30|t [联盟]暴风城", 0,  19)
                    player:GossipMenuAddItem(2, "|cFF0000CC|TInterface\\ICONS\\Achievement_Leader_Tyrande_Whisperwind.blp:30|t [联盟]达拉苏斯", 0,  21)
                    player:GossipMenuAddItem(2, "|cFF0000CC|TInterface\\ICONS\\Achievement_Leader_Prophet_Velen.blp:30|t [联盟]埃索达", 0,  22)
		            player:GossipMenuAddItem(2, "|cFFFF0000|TInterface\\ICONS\\Achievement_Leader_ Thrall.blp:30|t [攻打]奥格瑞玛", 0,  23)
					player:GossipMenuAddItem(2, "|cFF990066|TInterface\\ICONS\\Achievement_Zone_Tanaris_01.blp:30|t [中立]加基森", 0,  200)
		            player:GossipMenuAddItem(2, "|cFF990066|TInterface\\ICONS\\Achievement_Zone_ElwynnForest.blp:30|t [中立]藏宝海湾", 0,  201)
					player:GossipMenuAddItem(2, "|cFF990066|TInterface\\ICONS\\Achievement_Zone_EversongWoods.blp:30|t [中立]沙塔斯", 0,  202)
					player:GossipMenuAddItem(0, "|TInterface\\ICONS\\achievement_bg_masterofallbgs.blp:30|t 返回首页", 0,  999)
                    player:GossipSendMenu(1, item)
            end
                                    -- Horde Cities
            if (plyr == 2) or (plyr == 5) or (plyr == 6) or (plyr == 8) or (plyr == 10) then
					player:GossipMenuAddItem(2, "|cFF990066|TInterface\\ICONS\\Achievement_Zone_GrizzlyHills_01.blp:30|t [主城]达拉然", 0,  203)	
				    player:GossipMenuAddItem(2, "|cFF000000|TInterface\\ICONS\\Achievement_Leader_ Thrall.blp:30|t [部落]奥格瑞玛", 0,  23)
                    player:GossipMenuAddItem(2, "|cff000000|TInterface\\ICONS\\Achievement_Leader_Cairne Bloodhoof.blp:30|t [部落]雷霆崖", 0,  24)
                    player:GossipMenuAddItem(2, "|cff000000|TInterface\\ICONS\\Achievement_Leader_Sylvanas.blp:30|t [部落]幽暗城", 0,  25)
                    player:GossipMenuAddItem(2, "|cff000000|TInterface\\ICONS\\Achievement_Leader_Lorthemar_Theron .blp:30|t [部落]银月城", 0,  26)
					player:GossipMenuAddItem(2, "|cFFFF0000|TInterface\\ICONS\\Achievement_Leader_King_Varian_Wrynn.blp:30|t [攻打]暴风城", 0,  19)
					player:GossipMenuAddItem(2, "|cFF990066|TInterface\\ICONS\\Achievement_Zone_Tanaris_01.blp:30|t [中立]加基森", 0,  200)
					player:GossipMenuAddItem(2, "|cFF990066|TInterface\\ICONS\\Achievement_Zone_ElwynnForest.blp:30|t [中立]藏宝海湾", 0,  201)
					player:GossipMenuAddItem(2, "|cFF990066|TInterface\\ICONS\\Achievement_Zone_EversongWoods.blp:30|t [中立]沙塔斯", 0,  202)
		            player:GossipMenuAddItem(0, "|TInterface\\ICONS\\achievement_bg_masterofallbgs.blp:30|t 返回首页", 0,  999)
                    player:GossipSendMenu(1, item)
            end
    end
     
    if (intid == 2) then -- Azeroth Continets

            player:GossipMenuAddItem(2, "东部王国", 0,  27)
            player:GossipMenuAddItem(2, "卡利姆多", 0,  28)
            player:GossipMenuAddItem(0, "返回首页", 0,  999)
            player:GossipSendMenu(1, item)
    end
    
	if (intid == 801) then
			player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Zone_ElwynnForest.blp:30|t GM岛【宝石BOSS】", 0,  804)
	        player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Boss_Archimonde .blp:30|t 【危险】凄凉山战场", 0,  803)
			player:GossipMenuAddItem(2, "|TInterface\\ICONS\\achievement_dungeon_gundrak_normal.blp:30|t【危险】熔火之心|cff000000[扣100积分]", 0,  48)
			player:GossipMenuAddItem(0, "返回首页", 0,  999)
			player:GossipSendMenu(1, item)
	end
	
    if (intid == 3) then -- Azeroth Instances
            player:GossipMenuAddItem(2, "黑暗深渊", 0,  29)
           -- player:GossipMenuAddItem(2, "黑石深渊", 0,  30)
            player:GossipMenuAddItem(2, "厄运之槌", 0,  31)
            player:GossipMenuAddItem(2, "诺莫瑞根", 0,  32)
            player:GossipMenuAddItem(2, "玛拉顿", 0,  33)
            if (plyr == 2) or (plyr == 5) or (plyr == 6) or (plyr == 8) or (plyr == 10) then
                    player:GossipMenuAddItem(2, "怒焰裂谷", 0,  34)
            end
            player:GossipMenuAddItem(2, "剃刀高地", 0,  35)
            player:GossipMenuAddItem(2, "剃刀沼泽", 0,  36)
            player:GossipMenuAddItem(2, "血色修道院", 0,  37)
            player:GossipMenuAddItem(2, "通灵学院", 0,  38)
            player:GossipMenuAddItem(2, "影牙城堡", 0,  39)
            player:GossipMenuAddItem(2, "斯坦索姆", 0,  40)
            player:GossipMenuAddItem(2, "沉没的神庙", 0,  41)
            player:GossipMenuAddItem(2, "死亡矿井", 0,  42)
            if (plyr == 1) or (plyr == 3) or (plyr == 4) or (plyr == 7) or (plyr == 11) then
                    player:GossipMenuAddItem(2, "暴风城监狱", 0,  43)
            end
            player:GossipMenuAddItem(0, "下一页", 0,  994)
            player:GossipMenuAddItem(0, "返回首页", 0,  999)
            player:GossipSendMenu(1, item)
    end
     
    if (intid == 994) then -- Azeroth Instances Cont.
            player:GossipMenuAddItem(2, "奥达曼", 0,  44)
            player:GossipMenuAddItem(2, "哀嚎洞穴", 0,  45)
            player:GossipMenuAddItem(2, "祖尔法拉克", 0,  46)
            player:GossipMenuAddItem(0, "上一页", 0,  3)
            player:GossipMenuAddItem(0, "返回首页", 0,  999)
            player:GossipSendMenu(1, item)
    end
     
    if (intid == 4) then -- Azeroth Raids
         --   player:GossipMenuAddItem(2, "黑翼之巢", 0,  47)
            player:GossipMenuAddItem(2, "熔火之心", 0,  48)
            player:GossipMenuAddItem(2, "奥妮克希亚的巢穴", 0,  49)
            player:GossipMenuAddItem(2, "安其拉废墟", 0,  50)
            player:GossipMenuAddItem(2, "安其拉神殿", 0,  51)
            player:GossipMenuAddItem(2, "祖尔格拉布", 0, 52)
            player:GossipMenuAddItem(0, "返回首页", 0,  999)
            player:GossipSendMenu(1, item)
    end
     
    if (intid == 5) then -- Outland Locations
            player:GossipMenuAddItem(2, "沙塔斯城", 0,  11)
            player:GossipMenuAddItem(2, "刀锋山脉", 0,  53)
            player:GossipMenuAddItem(2, "地狱火半岛", 0,  54)
            player:GossipMenuAddItem(2, "纳格兰", 0,  55)
            player:GossipMenuAddItem(2, "虚空风暴", 0,  56)
            player:GossipMenuAddItem(2, "影月谷", 0,  57)
            player:GossipMenuAddItem(2, "泰罗卡森林", 0,  58)
            player:GossipMenuAddItem(2, "赞加沼泽", 0,  59)
            player:GossipMenuAddItem(0, "返回首页", 0,  999)
            player:GossipSendMenu(1, item)
    end
     
    if (intid == 6) then -- Outland Instances
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_boss_murmur.blp:30|t 奥金顿", 0,  60)
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Zone_Tanaris_01.blp:30|t 时光之穴", 0,  61)
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Boss_LadyVashj.blp:30|t 盘牙水库", 0,  62)
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Boss_KargathBladefist_01.blp:30|t 地狱火堡垒", 0,  63)
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Boss_PrinceKeleseth.blp:30|t 魔导师平台", 0,  64)
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Leader_ Thrall.blp:30|t 旧希尔斯布莱德丘陵", 0,  65)
            player:GossipMenuAddItem(0, "|TInterface\\ICONS\\achievement_bg_masterofallbgs.blp:30|t 返回首页", 0,  999)
            player:GossipSendMenu(1, item)
    end
     
    if (intid == 7) then -- Outland Raids
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\achievement_boss_illidan.blp:30|t 黑暗神殿", 0,  66)
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Boss_Archimonde .blp:30|t 海加尔山", 0,  67)
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\achievement_boss_ladyvashj.blp:30|t 毒蛇神殿", 0,  68)
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\achievement_boss_gruulthedragonkiller.blp:30|t 格鲁尔巢穴", 0,  69)
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\achievement_boss_magtheridon.blp:30|t 玛瑟里顿巢穴", 0,  70)
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\achievement_boss_princemalchezaar_02.blp:30|t 卡拉赞", 0, 71)
         --   player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Boss_Kiljaedan.blp:30|t 太阳井高地", 0,  72)
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\achievement_character_bloodelf_male.blp:30|t 风暴要塞", 0,  73)
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\achievement_boss_zuljin.blp:30|t 祖阿曼", 0,  74)
            player:GossipMenuAddItem(0, "|TInterface\\ICONS\\achievement_bg_masterofallbgs.blp:30|t 返回首页", 0,  999)
            player:GossipSendMenu(1, item)
    end
     
    if (intid == 8) then -- Northrend Locations
            player:GossipMenuAddItem(2, "北风苔原", 0, 75)
            player:GossipMenuAddItem(2, "晶歌森林", 0, 76)
            player:GossipMenuAddItem(2, "龙骨荒野", 0, 77)
            player:GossipMenuAddItem(2, "灰熊丘陵", 0, 78)
            player:GossipMenuAddItem(2, "凛风峡湾", 0, 79)
            player:GossipMenuAddItem(2, "寒冰皇冠", 0, 80)
            player:GossipMenuAddItem(2, "索拉查盆地", 0, 81)
            player:GossipMenuAddItem(2, "风暴之巅", 0, 82)
            player:GossipMenuAddItem(2, "冬拥湖", 0, 83)
            player:GossipMenuAddItem(2, "祖达克", 0, 84)
            player:GossipMenuAddItem(0, "返回首页", 0, 999)
            player:GossipSendMenu(1, item)
    end
     
    if (intid == 9) then -- Northrend Instances
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\achievement_dungeon_azjoluppercity_normal.blp:30|t 艾卓-尼鲁布", 0, 85)
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\achievement_dungeon_drak'tharon_normal.blp:30|t 德拉克萨隆要塞", 0, 86)
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\achievement_dungeon_gundrak_normal.blp:30|t 古达克", 0, 87)
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\achievement_dungeon_cotstratholme_normal.blp:30|t 净化斯坦索姆", 0, 88)
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\achievement_dungeon_ulduar80_normal.blp:30|t 闪电大厅", 0, 89)
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\achievement_dungeon_ulduar77_normal.blp:30|t 岩石大厅", 0, 90)
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\achievement_dungeon_nexus70_normal.blp:30|t 魔枢", 0, 91)
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\achievement_dungeon_theviolethold_normal.blp:30|t 紫罗兰监狱", 0, 92)
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\achievement_dungeon_utgardekeep_normal.blp:30|t 乌特加德城堡", 0, 93)
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\achievement_dungeon_utgardepinnacle_normal.blp:30|t 乌特加德之巅", 0, 94)
            player:GossipMenuAddItem(0, "|TInterface\\ICONS\\achievement_bg_masterofallbgs.blp:30|t 返回首页", 0, 999)
            player:GossipSendMenu(1, item)
    end
      	
    if (intid == 10) then -- Northrend Raids
						player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Zone_IceCrown_01.blp:30|t 新三本", 0, 206)
			player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Zone_IceCrown_01.blp:30|t 冰冠堡垒", 0, 204)
			player:GossipMenuAddItem(2, "|TInterface\\LFGFrame\\LFGIcon-ArgentRaid.blp:30|t 十字军的试炼", 0, 205)
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Boss_KelThuzad_01.blp:30|t 纳克萨玛斯", 0, 95)
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Boss_Malygos_01.blp:30|t 永恒之眼", 0, 96)
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Reputation_WyrmrestTemple.blp:30|t 黑曜石圣殿", 0, 97)
--player:GossipMenuAddItem(2, "|TInterface\\ICONS\\achievement_dungeon_ulduarraid_archway_01.blp:30|t 奥杜尔", 0, 98)
            player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Dungeon_UlduarRaid_IceGiant_01.blp:30|t 阿尔卡冯的宝库", 0, 99)
			player:GossipMenuAddItem(0, "|TInterface\\ICONS\\achievement_bg_masterofallbgs.blp:30|t 返回首页", 0, 999)
            player:GossipSendMenu(1, item)
    end
   
    -- Shattrath
     
    if (intid == 11) then
            player:Teleport(530, -1817.82, 5453.04, -12.42, 0)
            player:GossipComplete()
    end
     
     
    -- Gurubashi Arena
     
    if (intid == 13) then
            player:Teleport(0, -13261.30, 164.45, 35.78, 0)
            player:GossipComplete()
    end
     
    -- Alliance Cities
     
    if (intid == 19) then -- Stormwind
            player:Teleport(0, -8913.23, 554.63, 93.79, 0)
            player:GossipComplete()
    end
     
    if (intid == 20) then -- Ironforge
            player:Teleport(0, -4937.70, -935.43, 503.14, 0)
            player:GossipComplete()
    end
     
    if (intid == 21) then -- Darnassus
            player:Teleport(1, 9945.49, 2609.89, 1316.26, 0)
            player:GossipComplete()
    end
     
    if (intid == 22) then -- Exodar
            player:Teleport(530, -4002.67, -11875.54, -0.71, 0)
            player:GossipComplete()
    end
     
     
    -- Horde Cities
     
    if (intid == 23) then -- Orgimmar
            player:Teleport(1, 1502.71, -4415.41, 21.77, 0)
            player:GossipComplete()
    end
     
    if (intid == 24) then -- Thunderbluff
            player:Teleport(1, -1280, 125, 131, 0)
            player:GossipComplete()
    end
     
    if (intid == 25) then -- Undercity
            player:Teleport(0, 1831.26, 238.52, 60.52, 0)
            player:GossipComplete()
    end
     
    if (intid == 26) then -- Silvermoon
            player:Teleport(530, 9398.75, -7277.41, 14.21, 0)
            player:GossipComplete()
    end
     
     
    -- Azeroth Locations
     
    if (intid == 27) then -- Eastern Kingdoms
            player:GossipMenuAddItem(2, "奥特兰克山脉", 0, 112)
            player:GossipMenuAddItem(2, "阿拉希高地", 0, 113)
            player:GossipMenuAddItem(2, "荒芜之地", 0, 114)
            player:GossipMenuAddItem(2, "诅咒之地", 0, 115)
            --player:GossipMenuAddItem(2, "燃烧平原", 0, 116)
            player:GossipMenuAddItem(2, "逆风小径", 0, 117)
            player:GossipMenuAddItem(2, "丹莫罗", 0, 118)
            player:GossipMenuAddItem(2, "暮色森林", 0, 119)
            player:GossipMenuAddItem(2, "东瘟疫之地", 0, 120)
            player:GossipMenuAddItem(2, "艾尔文森林", 0, 121)
            player:GossipMenuAddItem(2, "永歌森林", 0, 122)
            player:GossipMenuAddItem(2, "幽魂之地", 0, 123)
            player:GossipMenuAddItem(2, "希尔斯布莱德丘陵", 0, 124)
            player:GossipMenuAddItem(2, "奎尔达纳斯之岛", 0, 125)
            player:GossipMenuAddItem(0, "下一页", 0, 996)
            player:GossipMenuAddItem(0, "返回首页", 0, 999)
            player:GossipSendMenu(1, item)
    end
     
    if (intid == 996) then -- Eastern Kingdoms Cont.
            player:GossipMenuAddItem(2, "洛克莫丹", 0, 126)
            player:GossipMenuAddItem(2, "赤脊山脉", 0, 127)
            player:GossipMenuAddItem(2, "灼热峡谷", 0, 128)
            player:GossipMenuAddItem(2, "银松森林", 0, 129)
            player:GossipMenuAddItem(2, "荆棘谷", 0, 130)
            player:GossipMenuAddItem(2, "悲伤沼泽", 0, 131)
            player:GossipMenuAddItem(2, "辛特兰", 0, 132)
            player:GossipMenuAddItem(2, "提瑞斯法林地", 0, 133)
            player:GossipMenuAddItem(2, "西瘟疫之地", 0, 134)
            player:GossipMenuAddItem(2, "西部荒野", 0, 135)
            player:GossipMenuAddItem(2, "湿地", 0, 136)
            player:GossipMenuAddItem(0, "上一页", 0, 27)
            player:GossipMenuAddItem(0, "返回首页", 0, 999)
            player:GossipSendMenu(1, item)
    end
     
    if (intid == 28) then -- Kalimdor
            player:GossipMenuAddItem(2, "灰谷", 0, 137)
            player:GossipMenuAddItem(2, "艾萨拉", 0, 138)
            player:GossipMenuAddItem(2, "秘蓝岛", 0, 139)
            player:GossipMenuAddItem(2, "秘血岛", 0, 140)
            player:GossipMenuAddItem(2, "黑海岸", 0, 141)
            player:GossipMenuAddItem(2, "凄凉之地", 0, 142)
            player:GossipMenuAddItem(2, "杜洛塔", 0, 143)
            player:GossipMenuAddItem(2, "尘泥沼泽", 0, 144)
            player:GossipMenuAddItem(2, "费伍德森林", 0, 145)
            player:GossipMenuAddItem(2, "菲拉斯", 0, 146)
            player:GossipMenuAddItem(2, "月光林地", 0, 147)
            player:GossipMenuAddItem(2, "莫高雷", 0, 148)
            player:GossipMenuAddItem(2, "希利苏斯", 0, 149)
            player:GossipMenuAddItem(0, "下一页", 0, 995)
            player:GossipMenuAddItem(0, "返回首页", 0, 999)
            player:GossipSendMenu(1, item)
    end
     
    if (intid == 995) then -- Kalimdor Cont.
            player:GossipMenuAddItem(2, "石爪山脉", 0, 150)
            player:GossipMenuAddItem(2, "塔纳利斯", 0, 151)
            player:GossipMenuAddItem(2, "泰达希尔", 0, 152)
            player:GossipMenuAddItem(2, "贫瘠之地", 0, 153)
            player:GossipMenuAddItem(2, "千针石林", 0, 154)
            player:GossipMenuAddItem(2, "安戈洛环形山", 0, 155)
            player:GossipMenuAddItem(2, "冬泉谷", 0, 156)
            player:GossipMenuAddItem(0, "上一页", 0, 28)
            player:GossipMenuAddItem(0, "返回首页", 0, 999)
            player:GossipSendMenu(1, item)
    end
     
    if (intid == 29) then -- Blackfathom Deeps
            player:Teleport(1, 4247.34, 744.05, -24.71, 0)
            player:RemoveItem(ItemEntry, 100);           
		    player:GossipComplete()
    end
     
    if (intid == 30) then -- Blackrock Depths
            player:Teleport(0, -7576.74, -1126.68, 262.26, 0)
            player:GossipComplete()
    end
     
    if (intid == 31) then -- Dire Maul
            player:Teleport(1, -3879.52, 1095.26, 154.78, 0)
            player:GossipComplete()
    end
     
    if (intid == 32) then -- Gnomeregan
            player:Teleport(0, -5162.63, 923.21, 257.17, 0)
            player:GossipComplete()
    end
     
    if (intid == 33) then -- Maraudon
            player:Teleport(1, -1412.73, 2816.92, 112.64, 0)
            player:GossipComplete()
    end
     
    if (intid == 34) then -- Ragefire Chasm
            player:Teleport(1, 1814.17, -4401.13, -17.67, 0)
            player:GossipComplete()
    end
     
    if (intid == 35) then -- Razorfen Downs
            player:Teleport(1, -4378.32, -1949.14, 88.57, 0)
            player:GossipComplete()
    end
     
    if (intid == 36) then -- Razorfen Kraul
            player:Teleport(1, -4473.31, -1810.05, 86.11, 0)
            player:GossipComplete()
    end
     
    if (intid == 37) then -- Scarlet Monastery
            player:Teleport(0, 2881.84, -816.23, 160.33, 0)
            player:GossipComplete()
    end
     
    if (intid == 38) then -- Scholomance
            player:Teleport(0, 1229.45, -2576.66, 90.43, 0)
            player:GossipComplete()
    end
     
    if (intid == 39) then -- Shadowfang Keep
            player:Teleport(0, -243.85, 1517.21, 76.23, 0)
            player:GossipComplete()
    end
     
    if (intid == 40) then -- Stratholme
            player:Teleport(0, 3362.14, -3380.05, 144.78, 0)
            player:GossipComplete()
    end
     
    if (intid == 41) then -- Sunken Temple
            player:Teleport(0, -10177.9, -3994.9, -111.239, 6.01885)
            player:GossipComplete()
    end
     
    if (intid == 42) then -- The Deadmines
            player:Teleport(0, -11209.6, 1666.54, 24.6974, 1.42053)
            player:GossipComplete()
    end
     
    if (intid == 43) then -- The Stockade
            player:Teleport(0, -8797.29, 826.67, 97.63, 0)
            player:GossipComplete()
    end
     
    if (intid == 44) then -- Uldaman
            player:Teleport(0, -6072.23, -2955.94, 209.61, 0)
            player:GossipComplete()
    end
     
    if (intid == 45) then -- Wailing Caverns
            player:Teleport(1, -735.11, -2214.21, 16.83, 0)
            player:GossipComplete()
    end
     
    if (intid == 46) then -- Zul'Farrak
            player:Teleport(1, -6825.69, -2882.77, 8.91, 0)
            player:GossipComplete()
    end
     
     
    -- Azeroth Raids
     
    if (intid == 47) then -- Blackwing Lair
            player:Teleport(469, -7666.11, -1101.53, 399.67, 0)
            player:GossipComplete()
    end
     
    if (intid == 48) then -- Molten Core
            player:Teleport(230, 1117.61, -457.36, -102.49, 0)
            player:RemoveItem(ItemEntry, 100);
			player:GossipComplete()
    end
     
    if (intid == 49) then -- Onyxia's Lair
            player:Teleport(1, -4697.81, -3720.44, 50.35, 0)
            player:GossipComplete()
    end
     
    if (intid == 50) then -- Ruins of Ahn'Qiraj
            player:Teleport(1, -8380.47, 1480.84, 14.35, 0)
            player:GossipComplete()
    end
     
    if (intid == 51) then -- Temple of Ahn'Qiraj
            player:Teleport(1, -8258.27, 1962.73, 129.89, 0)
            player:GossipComplete()
    end
     
    if (intid == 52) then -- Zul'Gurub
            player:Teleport(0, -11916.74, -1203.32, 92.28, 0)
            player:GossipComplete()
    end
     
     
    -- Outland Locations
     
    if (intid == 53) then -- Blade's Edge Mountains
            player:Teleport(530, 2039.24, 6409.27, 134.30, 0)
            player:GossipComplete()
    end
     
    if (intid == 54) then -- Hellfire Peninsula
            player:Teleport(530, -247.37, 964.77, 84.33, 0)
            player:GossipComplete()
    end
     
    if (intid == 55) then -- Nagrand
            player:Teleport(530, -605.84, 8442.39, 60.76, 0)
            player:GossipComplete()
    end
     
    if (intid == 56) then -- Netherstorm
            player:Teleport(530, 3055.70, 3671.63, 142.44, 0)
            player:GossipComplete()
    end
     
    if (intid == 57) then -- Shadowmoon Valley
            player:Teleport(530, -2859.75, 3184.24, 9.76, 0)
            player:GossipComplete()
    end
     
    if (intid == 58) then -- Terokkar Forest
            player:Teleport(530, -1917.17, 4879.45, 2.10, 0)
            player:GossipComplete()
    end
     
    if (intid == 59) then -- Zangarmarsh
            player:Teleport(530, -206.61, 5512.90, 21.58, 0)
            player:GossipComplete()
    end
     
     
    -- Outland Instances
     
    if (intid == 60) then -- Auchindoun
            player:Teleport(530, -3323.76, 4934.31, -100.21, 0)
            player:GossipComplete()
    end
     
    if (intid == 61) then -- Caverns of Time
            player:Teleport(1, -8187.16, -4704.91, 19.33, 0)
            player:GossipComplete()
    end
     
    if (intid == 62) then -- Coilfang Reservoir
            player:Teleport(530, 731.04, 6849.35, -66.62, 0)
            player:GossipComplete()
    end
     
    if (intid == 63) then -- Hellfire Citadel
            player:Teleport(530, -331.87, 3039.30, -16.66, 0)
            player:GossipComplete()
    end
     
    if (intid == 64) then -- Magisters' Terrace
            player:Teleport(530, 12884.92, -7333.78, 65.48, 0)
            player:GossipComplete()
    end
     
    if (intid == 65) then -- Tempest Keep
            player:Teleport(1, -8345.88, -4060.33, -208, 0)
            player:GossipComplete()
    end
     
     
    -- Outland Raids
     
    if (intid == 66) then -- Black Temple
            player:Teleport(530, -3638.16, 316.09, 35.40, 0)
            player:GossipComplete()
    end
     
    if (intid == 67) then -- Hyjal Summit
            player:Teleport(1, -8175.94, -4178.52, -166.74, 0)
            player:GossipComplete()
    end
     
    if (intid == 68) then -- Serpentshrine Cavern
            player:Teleport(530, 731.04, 6849.35, -66.62, 0)
            player:GossipComplete()
    end
     
    if (intid == 69) then -- Gruul's Lair
            player:Teleport(530, 3528.99, 5133.50, 1.31, 0)
            player:GossipComplete()
    end
     
    if (intid == 70) then -- Magtheridon's Lair
            player:Teleport(530, -337.50, 3131.88, -102.92, 0)
            player:GossipComplete()
    end
     
    if (intid == 71) then -- Karazhan
            player:Teleport(0, -11119.22, -2010.73, 47.09, 0)
            player:GossipComplete()
    end
     
    if (intid == 72) then -- Sunwell Plateau
            player:Teleport(530, 12560.79, -6774.58, 15.08, 0)
            player:GossipComplete()
    end
     
    if (intid == 73) then -- The Eye
            player:Teleport(530, 3088.25, 1388.17, 185.09, 0)
            player:GossipComplete()
    end
     
    if (intid == 74) then -- Zul'Aman
            player:Teleport(530, 6850, -7950, 170, 0)
            player:GossipComplete()
    end
     
     
    -- Northrend Locations
     
    if (intid == 75) then -- Borean Tundra
            player:Teleport(571, 2920.15, 4043.40, 1.82, 0)
            player:GossipComplete()
    end
     
    if (intid == 76) then -- Crystalsong Forest
            player:Teleport(571, 5371.18, 109.11, 157.65, 0)
            player:GossipComplete()
    end
     
    if (intid == 77) then -- Dragonblight
            player:Teleport(571, 2729.59, 430.70, 66.98, 0)
            player:GossipComplete()
    end
     
    if (intid == 78) then -- Grizzly Hills
            player:Teleport(571, 3587.20, -4545.12, 198.75, 0)
            player:GossipComplete()
    end
     
    if (intid == 79) then -- Howling Fjord
            player:Teleport(571, 154.39, -4896.33, 296.14, 0)
            player:GossipComplete()
    end
     
    if (intid == 80) then -- Icecrown
            player:Teleport(571, 8406.89, 2703.79, 665.17, 0)
            player:GossipComplete()
    end
     
    if (intid == 81) then -- Sholazar Basin
            player:Teleport(571, 5569.49, 5762.99, -75.22, 0)
            player:GossipComplete()
    end
     
    if (intid == 82) then -- The Storm Peaks
            player:Teleport(571, 6180.66, -1085.65, 415.54, 0)
            player:GossipComplete()
    end
     
    if (intid == 83) then -- Wintergrasp
            player:Teleport(571, 5044.03, 2847.23, 392.64, 0)
            player:GossipComplete()
    end
     
    if (intid == 84) then -- Zul'Drak
            player:Teleport(571, 4700.09, -3306.54, 292.41, 0)
            player:GossipComplete()
    end
     
     
    -- Northrend Instances
     
    if (intid == 85) then -- Azjol-Nerub
            player:Teleport(571, 3738.93, 2164.14, 37.29, 0)
            player:GossipComplete()
    end
     
    if (intid == 86) then -- Drak'Tharon
            player:Teleport(571, 4772.13, -2035.85, 229.38, 0)
            player:GossipComplete()
    end
     
    if (intid == 87) then -- Gundrak
            player:Teleport(571, 6937.12, -4450.80, 450.90, 0)
            player:GossipComplete()
    end
     
    if (intid == 88) then -- The Culling of Stratholme
            player:Teleport(1, -8746.94, -4437.69, -199.98, 0)
            player:GossipComplete()
    end
     
    if (intid == 89) then -- The Halls of Lightning
            player:Teleport(571, 9171.01, -1375.94, 1099.55, 0)
            player:GossipComplete()
    end
     
    if (intid == 90) then -- The Halls of Stone
            player:Teleport(571, 8921.35, -988.56, 1039.37, 0)
            player:GossipComplete()
    end
     
    if (intid == 91) then -- The Nexus
            player:Teleport(571, 3897.42, 6985.33, 69.49, 0)
            player:GossipComplete()
    end
     
    if (intid == 92) then -- The Violet Hold
            player:Teleport(571, 5695.19, 505.38, 652.68, 0)
            player:GossipComplete()
    end
     
    if (intid == 93) then -- Utgarde Keep
            player:Teleport(571, 1222.44, -4862.61, 41.24, 0)
            player:GossipComplete()
    end
     
    if (intid == 94) then -- Utgarde Pinnacle
            player:Teleport(571, 1251.10, -4856.31, 215.86, 0)
            player:GossipComplete()
    end
     
     
    -- Northrend Raids
     
    if (intid == 95) then -- Naxxramas
            player:Teleport(571, 3669.77, -1275.48, 243.51, 0)
            player:GossipComplete()
    end
     
    if (intid == 96) then -- The Eye of Eternity
            player:Teleport(571, 3873.50, 6974.83, 152.04, 0)
            player:GossipComplete()
    end
     
    if (intid == 97) then -- The Obsidian Sanctum
            player:Teleport(571, 3547.39, 267.95, -115.96, 0)
            player:GossipComplete()
    end
     
    if (intid == 98) then -- Ulduar
            player:Teleport(571, 9330.53, -1115.40, 1245.14, 0)
            player:GossipComplete()
    end
     
    if (intid == 99) then -- Vault of Archavon
            player:Teleport(571, 5410.21, 2842.37, 418.67, 0)
            player:GossipComplete()
    end
     
    -- Eastern Kingdoms
     
    if (intid == 112) then -- Alterac Mountains
            player:Teleport(0, 353.79, -607.08, 150.76, 0)
            player:GossipComplete()
    end
     
    if (intid == 113) then -- Arathi Highlands
            player:Teleport(0, -2269.78, -2501.06, 79.04, 0)
            player:GossipComplete()
    end
     
    if (intid == 114) then -- Badlands
            player:Teleport(0, -6026.58, -3318.27, 260.64, 0)
            player:GossipComplete()
    end
     
    if (intid == 115) then -- Blasted Lands
            player:Teleport(0, -10797.67, -2994.29, 44.42, 0)
            player:GossipComplete()
    end
     
    if (intid == 116) then -- Burning Steppes
            player:Teleport(0, -8357.72, -2537.49, 135.01, 0)
            player:GossipComplete()
    end
     
    if (intid == 117) then -- Deadwind Pass
            player:Teleport(0, -10460.22, -1699.33, 81.85, 0)
            player:GossipComplete()
    end
     
    if (intid == 118) then -- Dun Morogh
            player:Teleport(0, -6234.99, 341.24, 383.22, 0)
            player:GossipComplete()
    end
     
    if (intid == 119) then -- Duskwood
            player:Teleport(0, -10068.30, -1501.07, 28.41, 0)
            player:GossipComplete()
    end
     
    if (intid == 120) then -- Eastern Plaguelands
            player:Teleport(0, 1924.70, -2653.54, 59.70, 0)
            player:GossipComplete()
    end
     
    if (intid == 121) then -- Elwynn Forest
            player:Teleport(0, -8939.71, -131.22, 83.62, 0)
            player:GossipComplete()
    end
     
    if (intid == 122) then -- Eversong Woods
            player:Teleport(530, 10341.73, -6366.29, 34.31, 0)
            player:GossipComplete()
    end
     
    if (intid == 123) then -- Ghostlands
            player:Teleport(530, 7969.87, -6872.63, 58.66, 0)
            player:GossipComplete()
    end
     
    if (intid == 124) then -- Hillsbrad Foothills
            player:Teleport(0, -585.70, 612.18, 83.80, 0)
            player:GossipComplete()
    end
     
    if (intid == 125) then -- Isle of Quel'Danas
            player:Teleport(530, 12916.81, -6867.82, 7.69, 0)
            player:GossipComplete()
    end
     
    if (intid == 126) then -- Loch Modan
            player:Teleport(0, -4702.59, -2698.61, 318.75, 0)
            player:GossipComplete()
    end
     
    if (intid == 127) then -- Redridge Mountains
            player:Teleport(0, -9600.62, -2123.21, 66.23, 0)
            player:GossipComplete()
    end
     
    if (intid == 128) then -- Searing Gorge
            player:Teleport(0, -6897.73, -1821.58, 241.16, 0)
            player:GossipComplete()
    end
     
    if (intid == 129) then -- Silverpine Forest
            player:Teleport(0, 1499.57, 623.98, 47.01, 0)
            player:GossipComplete()
    end
     
    if (intid == 130) then -- Stranglethorn Vale
            player:Teleport(0, -11355.90, -383.40, 65.14, 0)
            player:GossipComplete()
    end
     
    if (intid == 131) then -- Swamp of Sorrows
            player:Teleport(0, -10552.60, -2355.25, 85.95, 0)
            player:GossipComplete()
    end
     
    if (intid == 132) then -- The Hinterlands
            player:Teleport(0, 92.63, -1942.31, 154.11, 0)
            player:GossipComplete()
    end
     
    if (intid == 133) then -- Tirisfal Glades
            player:Teleport(0, 1676.13, 1669.37, 137.02, 0)
            player:GossipComplete()
    end
     
    if (intid == 134) then -- Western Plaguelands
            player:Teleport(0, 1635.57, -1068.50, 66.57, 0)
            player:GossipComplete()
    end
     
    if (intid == 135) then -- Westfall
            player:Teleport(0, -9827.95, 865.80, 25.80, 0)
            player:GossipComplete()
    end
     
    if (intid == 136) then -- Wetlands
            player:Teleport(0, -4086.32, -2620.72, 43.55, 0)
            player:GossipComplete()
    end
     
     
    -- Kalimdor
     
    if (intid == 137) then -- Ashenvale
            player:Teleport(1, 3474.41, 853.47, 5.76, 0)
            player:GossipComplete()
    end
     
    if (intid == 138) then -- Azshara
            player:Teleport(1, 2763.93, -3881.34, 92.52, 0)
            player:GossipComplete()
    end
     
    if (intid == 139) then -- Azuremyst Isle
            player:Teleport(530, -3972.72, -13914.99, 98.88, 0)
            player:GossipComplete()
    end
     
    if (intid == 140) then -- Bloodmyst Isle
            player:Teleport(530, -2721.67, -12208.90, 9.08, 0)
            player:GossipComplete()
    end
     
    if (intid == 141) then -- Darkshore
            player:Teleport(1, 4336.61, 173.83, 46.84, 0)
            player:GossipComplete()
    end
     
    if (intid == 142) then -- Desolace
            player:Teleport(1, 47.28, 1684.64, 93.55, 0)
            player:GossipComplete()
    end
     
    if (intid == 143) then -- Durotar
            player:Teleport(1, -611.61, -4263.16, 38.95, 0)
            player:GossipComplete()
    end
     
    if (intid == 144) then -- Dustwallow Marsh
            player:Teleport(1, -3682.58, -2556.93, 58.43, 0)
            player:GossipComplete()
    end
     
    if (intid == 145) then -- Felwood
            player:Teleport(1, 3590.56, -1516.69, 169.98, 0)
            player:GossipComplete()
    end
     
    if (intid == 146) then -- Feralas
            player:Teleport(1, -4300.02, -631.56, -9.35, 0)
            player:GossipComplete()
    end
     
    if (intid == 147) then -- Moonglade
            player:Teleport(1, 7999.68, -2670.19, 512.09, 0)
            player:GossipComplete()
    end
     
    if (intid == 148) then -- Mulgore
            player:Teleport(1, -2931.49, -262.82, 53.25, 0)
            player:GossipComplete()
    end
     
    if (intid == 149) then -- Silithus
            player:Teleport(1, -6814.57, 833.77, 49.74, 0)
            player:GossipComplete()
    end
     
    if (intid == 150) then -- Stonetalon Mountains
            player:Teleport(1, -225.34, -765.16, 6.4, 0)
            player:GossipComplete()
    end
     
    if (intid == 151) then -- Tanaris
            player:Teleport(1, -6999.47, -3707.94, 26.44, 0)
            player:GossipComplete()
    end
     
    if (intid == 152) then -- Teldrassil
            player:Teleport(1, 8754.06, 949.62, 25.99, 0)
            player:GossipComplete()
    end
     
    if (intid == 153) then -- The Barrens
            player:Teleport(1, -948.46, -3738.60, 5.98, 0)
            player:GossipComplete()
    end
     
    if (intid == 154) then -- Thousand Needles
            player:Teleport(1, -4685.72, -1836.24, -44.04, 0)
            player:GossipComplete()
    end
     
    if (intid == 155) then -- Un'Goro Crater
            player:Teleport(1, -6162.47, -1098.74, -208.99, 0)
            player:GossipComplete()
    end
     
    if (intid == 156) then -- Winterspring
            player:Teleport(1, 6896.27, -2302.51, 586.69, 0)
            player:GossipComplete()
    end
     
     
    -- Profession Trainers
     
    if (intid == 157) then -- Alchemy
     
            player:GossipComplete()
    end
     
    if (intid == 158) then -- Unlearn ^^
            player:RemoveSpell(51303)
            player:RemoveSpell(51304)
            player:RemoveSpell(53042)
            player:GossipComplete()
    end
     
    if (intid == 159) then -- Blacksmithing
     
            player:GossipComplete()
    end
     
    if (intid == 160) then -- Unlearn ^^
            player:RemoveSpell(51298)
            player:RemoveSpell(51300)
            player:GossipComplete()
    end
     
    if (intid == 161) then -- Enchanting
           
            player:GossipComplete()
    end
     
    if (intid == 162) then -- Unlearn ^^
            player:RemoveSpell(51312)
            player:RemoveSpell(51313)
            player:GossipComplete()
    end
     
    if (intid == 163) then -- Engineering
     
            player:GossipComplete()
    end
     
    if (intid == 164) then -- Unlearn ^^
            player:RemoveSpell(51305)
            player:RemoveSpell(51306)
            player:GossipComplete()
    end
     
    if (intid == 165) then -- Herbalism
     
            player:GossipComplete()
    end
     
    if (intid == 166) then -- Unlearn Herbalism
            player:RemoveSpell(50300)
            player:RemoveSpell(50301)
            player:GossipComplete()
    end
     
    if (intid == 167) then -- Inscription
     
            player:GossipComplete()
    end
     
    if (intid == 168) then -- Unlearn ^^
            player:RemoveSpell(45363)
            player:RemoveSpell(45380)
            player:GossipComplete()
    end
     
    if (intid == 169) then -- Jewelcrafting
     
            player:GossipComplete()
    end
     
    if (intid == 170) then -- Unlearn ^^
            player:RemoveSpell(51310)
            player:RemoveSpell(51311)
            player:GossipComplete()
    end
     
    if (intid == 171) then -- Leatherworking
     
            player:GossipComplete()
    end
     
    if (intid == 172) then -- Unlearn ^^
            player:RemoveSpell(51301)
            player:RemoveSpell(51302)
            player:GossipComplete()
    end
     
    if (intid == 173) then -- Mining
     
            player:GossipComplete()
    end
     
    if (intid == 174) then -- Unlearn ^^
            player:RemoveSpell(50309)
            player:RemoveSpell(50310)
            player:GossipComplete()
    end
     
    if (intid == 175) then -- Skinning
     
            player:GossipComplete()
    end
     
    if (intid == 176) then -- Unlearn ^^
            player:RemoveSpell(50305)
            player:RemoveSpell(50306)
            player:GossipComplete()
    end
     
    if (intid == 177) then -- Tailoring
     
            player:GossipComplete()
    end
     
    if (intid == 178) then -- Unlearn ^^
            player:RemoveSpell(51308)
            player:RemoveSpell(51309)
            player:GossipComplete()
    end
     
     
     
    -- Secondary Professions
     
    if (intid == 179) then -- Cooking
     
                    player:GossipMenuAddItem(0, "我想忘却这个技能.", 0, 183)
                    player:GossipMenuAddItem(0, "返回首页", 0, 999)
                    player:GossipSendMenu(1, item)
                    ------------------------
                    player:LearnSpell(51295)
    end
     
    if (intid == 180) then -- First Aid
     
                    player:GossipMenuAddItem(0, "我想忘却这个技能.", 0, 185)
                    player:GossipMenuAddItem(0, "返回首页", 0, 999)
                    player:GossipSendMenu(1, item)
                    ------------------------
                    player:LearnSpell(50299)
    end
     
    if (intid == 181) then -- Fishing
     
                    player:GossipMenuAddItem(0, "我想忘却这个技能.", 0, 187)
                    player:GossipMenuAddItem(0, "返回首页", 0, 999)
                    player:GossipSendMenu(1, item)
                    ------------------------
                    player:LearnSpell(51293)
    end
     
     
    -- Secondary Profession Trainers
     
    if (intid == 182) then -- Cooking
     
            player:GossipComplete()
    end
     
    if (intid == 183) then -- Unlearn ^^
            player:RemoveSpell(51296)
            player:RemoveSpell(51295)
            player:GossipComplete()
    end
     
    if (intid == 184) then -- First Aid
     
            player:GossipComplete()
    end
     
    if (intid == 185) then -- Unlearn ^^
            player:RemoveSpell(50299)
            player:RemoveSpell(45442)
            player:GossipComplete()
    end
     
    if (intid == 186) then -- Fishing
     
            player:GossipComplete()
    end
     
    if (intid == 187) then -- Unlearn ^^
            player:RemoveSpell(51294)
            player:RemoveSpell(51293)
            player:GossipComplete()
    end
     
     
    -- Foothills
     
    if(intid == 9997) then
            if (plyr == 1) or (plyr == 3) or (plyr == 4) or (plyr == 7) or (plyr == 11) then
                    player:GossipMenuAddItem(2, "Qurantis", 0, 1235)
                    player:GossipSendMenu(1, item)
            end
     
            if (plyr == 2) or (plyr == 5) or (plyr == 6) or (plyr == 8) or (plyr == 10) then
                    player:GossipMenuAddItem(2, "Mulderan", 0, 1236)
                    player:GossipSendMenu(1, item)
            end
    end
     
    if(intid == 1235) then -- Qurantis
            player:Teleport(560, 3611.490723, 2288.865967, 59.283901, 0)
    end
     
    if(intid == 1236) then -- Mulderan
            player:Teleport(560, 2539.483643, 2423.052734, 63.581509, 0)
    end
	
	if(intid == 200) then -- 加基森
            player:Teleport(1, -7174, -3778, 9, 0)
    end
	
	if(intid == 201) then -- 藏宝海湾
            player:Teleport(0, -14281.9, 552.564, 8.90422, 0.860144)
    end
	
	if(intid == 202) then -- 沙塔斯
            player:Teleport(530, -1887.62, 5359.09, -12.4279, 4.40435)
    end
	
	if(intid == 203) then -- 达拉然
            player:Teleport(571, 5809.78, 432.913, 658.772, 1.20920)
    end
    
	if(intid == 204) then -- 冰冠堡垒
            player:Teleport(571, 5855.22, 2102.03, 635.991, 3.57899)
    end
	if(intid == 205) then -- 十字军的试炼
            player:Teleport(571, 8515.61, 714.153, 558.248, 1.57753)
    end
    
	if(intid == 206) then -- 新三本
            player:Teleport(571, 5631.05, 2092.57, 798.14, 6.14356)
    end
	
	if(intid == 803) then -- 凄凉山战场
            player:Teleport(37, -50.0, -40.5, 271.6, 0.14356)
	end
	
	if(intid == 804) then -- GM岛
            player:Teleport(1, 16199.22, 16205.91, 0.14, 1.048492)
	end
	
    if (intid == 999) then -- Main page
    --player:GossipMenuAddItem(5, "|cffff6060传送石|r", 0, 998)
    player:GossipMenuAddItem(6, "|TInterface\\ICONS\\achievement_zone_zuldrak_05.blp:30|t |cff0000ff主城传送", 0,  1)
	player:GossipMenuAddItem(9, "|cFFFF0000|TInterface\\ICONS\\Achievement_BG_winWSG.blp:30|t 超级副本", 0,  801)
	player:GossipMenuAddItem(9, "|TInterface\\ICONS\\Achievement_BG_winWSG.blp:30|t 古拉巴什竞技场", 0,  13)
    player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Zone_EasternKingdoms_01.blp:30|t 东部王国", 0,  27)
    player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Zone_Kalimdor_01.blp:30|t 卡利姆多", 0,  28)
    player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Boss_PrinceKeleseth.blp:30|t 艾泽拉斯副本", 0,  3)
    player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Zone_Blackrock_01.blp:30|t 艾泽拉斯团队副本", 0,  4)
    player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Zone_Outland_01.blp:30|t 外域", 0,  5)
    player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_boss_murmur.blp:30|t 外域副本", 0,  6)
    player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Zone_IsleOfQuelDanas.blp:30|t 外域团队副本", 0,  7)
    player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Zone_Northrend_01.blp:30|t 诺森德", 0,  8)
    player:GossipMenuAddItem(2, "|TInterface\\LFGFrame\\LFGIcon-TheForgeofSouls.blp:30|t 诺森德副本", 0,  9)
    player:GossipMenuAddItem(2, "|TInterface\\ICONS\\Achievement_Zone_IceCrown_01.blp:30|t 诺森德团队副本", 0,  10)
    player:GossipMenuAddItem(9, "|TInterface\\ICONS\\INV_Misc_Rune_01:30|t 返回首页", 0,  999)
    player:GossipSendMenu(1, item)
    end
    end
     
    RegisterItemGossipEvent(6948, 1, Tele_Book)
    RegisterItemGossipEvent(6948, 2, Tele_Select)

