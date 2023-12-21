--[[

排行榜系统 by Mojito
http://uiwow.cc:88/

]]--
print(">>Script: M_list_new loading...OK")

local baoshi = 6948      --排行宝石
local updatetime = 24    --排行榜更新时间（小时）
    
function updatelist()                                   --每24小时更新一次排行榜
    SaveAllPlayers()                               --保存数据
	CharDBQuery("TRUNCATE TABLE list_honor;");     --删除荣誉排名
	CharDBQuery("TRUNCATE TABLE list_money;");     --删除金钱排名
	CharDBQuery("TRUNCATE TABLE list_kill;");      --删除击杀排名
	CharDBQuery("TRUNCATE TABLE list_online;");    --删除在线排名
	CharDBQuery("replace into list_honor(name, totalHonor) select name, totalHonorPoints from characters order by totalHonorPoints desc limit 10;");  --从characters抓取荣誉排名
	CharDBQuery("replace into list_money(name, money) select name, money from characters order by money desc limit 10;");  --从characters抓取金钱排名
	CharDBQuery("replace into list_kill(name, totalKills) select name, totalKills from characters order by totalKills desc limit 10;");  --从characters抓取击杀排名
	CharDBQuery("replace into list_online(name, totalTime) select name, totalTime from characters order by totalTime desc limit 10;"); --从characters抓取在线排名
end
CreateLuaEvent(updatelist, updatetime*60*60*1000, 0)       --每24小时更新一次排行榜

--[[给荣誉榜名次赋名字和数值]]--
    H1 = CharDBQuery("SELECT name, totalHonor FROM list_honor where Nox = 1 ;");        
    HN1, Ho1 = H1:GetString(0), H1:GetUInt32(1)
    H2 = CharDBQuery("SELECT name, totalHonor FROM list_honor where Nox = 2 ;");
    HN2, Ho2 = H2:GetString(0), H2:GetUInt32(1)
    H3 = CharDBQuery("SELECT name, totalHonor FROM list_honor where Nox = 3 ;");
    HN3, Ho3 = H3:GetString(0), H3:GetUInt32(1)
    H4 = CharDBQuery("SELECT name, totalHonor FROM list_honor where Nox = 4 ;");
	HN4, Ho4 = H4:GetString(0), H4:GetUInt32(1)			
	H5 = CharDBQuery("SELECT name, totalHonor FROM list_honor where Nox = 5 ;");
	HN5, Ho5 = H5:GetString(0), H5:GetUInt32(1)			
	H6 = CharDBQuery("SELECT name, totalHonor FROM list_honor where Nox = 6 ;");
	HN6, Ho6 = H6:GetString(0), H6:GetUInt32(1)			
	H7 = CharDBQuery("SELECT name, totalHonor FROM list_honor where Nox = 7 ;");
	HN7, Ho7 = H7:GetString(0), H7:GetUInt32(1)			
	H8 = CharDBQuery("SELECT name, totalHonor FROM list_honor where Nox = 8 ;");
	HN8, Ho8 = H8:GetString(0), H8:GetUInt32(1)			
	H9 = CharDBQuery("SELECT name, totalHonor FROM list_honor where Nox = 9 ;");
	HN9, Ho9 = H9:GetString(0), H9:GetUInt32(1)			
	H10 = CharDBQuery("SELECT name, totalHonor FROM list_honor where Nox = 10 ;");
	HN10, Ho10 = H10:GetString(0), H10:GetUInt32(1)		
--[[给金钱榜名次赋名字和数值]]--	
    M1 = CharDBQuery("SELECT name, money FROM list_money where Nox = 1 ;");
	Ma1, Mo1 = M1:GetString(0), M1:GetUInt32(1)
	M2 = CharDBQuery("SELECT name, money FROM list_money where Nox = 2 ;");
	Ma2, Mo2 = M2:GetString(0), M2:GetUInt32(1)
   	M3 = CharDBQuery("SELECT name, money FROM list_money where Nox = 3 ;");
	Ma3, Mo3 = M3:GetString(0), M3:GetUInt32(1)
	M4 = CharDBQuery("SELECT name, money FROM list_money where Nox = 4 ;");
	Ma4, Mo4 = M4:GetString(0), M4:GetUInt32(1)
    M5 = CharDBQuery("SELECT name, money FROM list_money where Nox = 5 ;");
	Ma5, Mo5 = M5:GetString(0), M5:GetUInt32(1)
    M6 = CharDBQuery("SELECT name, money FROM list_money where Nox = 6 ;");
	Ma6, Mo6 = M6:GetString(0), M6:GetUInt32(1)
    M7 = CharDBQuery("SELECT name, money FROM list_money where Nox = 7 ;");
	Ma7, Mo7 = M7:GetString(0), M7:GetUInt32(1)
    M8 = CharDBQuery("SELECT name, money FROM list_money where Nox = 8 ;");
	Ma8, Mo8 = M8:GetString(0), M8:GetUInt32(1)
   	M9 = CharDBQuery("SELECT name, money FROM list_money where Nox = 9 ;");
	Ma9, Mo9 = M9:GetString(0), M9:GetUInt32(1)
   	M10 = CharDBQuery("SELECT name, money FROM list_money where Nox = 10 ;");
	Ma10, Mo10 = M10:GetString(0), M10:GetUInt32(1)
--[[给击杀榜名次赋名字和数值]]--	
	K1 = CharDBQuery("SELECT name, totalKills  FROM list_kill where Nox = 1 ;");
	Ka1, Ko1 = K1:GetString(0), K1:GetUInt32(1)
	K2 = CharDBQuery("SELECT name, totalKills  FROM list_kill where Nox = 2 ;");
	Ka2, Ko2 = K2:GetString(0), K2:GetUInt32(1)
    K3 = CharDBQuery("SELECT name, totalKills  FROM list_kill where Nox = 3 ;");
	Ka3, Ko3 = K3:GetString(0), K3:GetUInt32(1)
   	K4 = CharDBQuery("SELECT name, totalKills  FROM list_kill where Nox = 4 ;");
	Ka4, Ko4 = K4:GetString(0), K4:GetUInt32(1)
   	K5 = CharDBQuery("SELECT name, totalKills  FROM list_kill where Nox = 5 ;");
	Ka5, Ko5 = K5:GetString(0), K5:GetUInt32(1)
   	K6 = CharDBQuery("SELECT name, totalKills  FROM list_kill where Nox = 6 ;");
	Ka6, Ko6 = K6:GetString(0), K6:GetUInt32(1)
   	K7 = CharDBQuery("SELECT name, totalKills  FROM list_kill where Nox = 7 ;");
	Ka7, Ko7 = K7:GetString(0), K7:GetUInt32(1)
   	K8 = CharDBQuery("SELECT name, totalKills  FROM list_kill where Nox = 8 ;");
	Ka8, Ko8 = K8:GetString(0), K8:GetUInt32(1)
   	K9 = CharDBQuery("SELECT name, totalKills  FROM list_kill where Nox = 9 ;");
	Ka9, Ko9 = K9:GetString(0), K9:GetUInt32(1)
   	K10 = CharDBQuery("SELECT name, totalKills  FROM list_kill where Nox = 10 ;");
	Ka10, Ko10 = K10:GetString(0), K10:GetUInt32(1)
--[[给在线榜名次赋名字和数值]]--
	L1 = CharDBQuery("SELECT name, totalKills  FROM list_kill where Nox = 1 ;");
	La1, Lo1 = L1:GetString(0), L1:GetUInt32(1)
	L2 = CharDBQuery("SELECT name, totalKills  FROM list_kill where Nox = 2 ;");
	La2, Lo2 = L2:GetString(0), L2:GetUInt32(1)
    L3 = CharDBQuery("SELECT name, totalKills  FROM list_kill where Nox = 3 ;");
	La3, Lo3 = L3:GetString(0), L3:GetUInt32(1)
   	L4 = CharDBQuery("SELECT name, totalKills  FROM list_kill where Nox = 4 ;");
	La4, Lo4 = L4:GetString(0), L4:GetUInt32(1)
   	L5 = CharDBQuery("SELECT name, totalKills  FROM list_kill where Nox = 5 ;");
	La5, Lo5 = L5:GetString(0), L5:GetUInt32(1)
   	L6 = CharDBQuery("SELECT name, totalKills  FROM list_kill where Nox = 6 ;");
	La6, Lo6 = L6:GetString(0), L6:GetUInt32(1)
   	L7 = CharDBQuery("SELECT name, totalKills  FROM list_kill where Nox = 7 ;");
	La7, Lo7 = L7:GetString(0), L7:GetUInt32(1)
   	L8 = CharDBQuery("SELECT name, totalKills  FROM list_kill where Nox = 8 ;");
	La8, Lo8 = L8:GetString(0), L8:GetUInt32(1)
   	L9 = CharDBQuery("SELECT name, totalKills  FROM list_kill where Nox = 9 ;");
	La9, Lo9 = L9:GetString(0), L9:GetUInt32(1)
   	L10 = CharDBQuery("SELECT name, totalKills  FROM list_kill where Nox = 10 ;");
	La10, Lo10 = L10:GetString(0), L10:GetUInt32(1)
	
	
    function List_PD(event, player, item)
		player:MoveTo(0,player:GetX()+0.01,player:GetY(),player:GetZ())
            if (player:IsInCombat() == true) then
                    player:SendAreaTriggerMessage("无法在战斗中查看排行榜!")
            else
                    List_Menu(item, player)
            end
    end
		
function List_Menu(item, player) -- 排行榜菜单主页
    player:GossipMenuAddItem(10, "|TInterface\\ICONS\\INV_Misc_Ribbon_01.BLP:30|t |cff000099      荣誉榜", 0, 11);
	player:GossipMenuAddItem(10, "|TInterface\\ICONS\\INV_Misc_Ribbon_01.BLP:30|t |cff330099      富豪榜", 0, 12);
	player:GossipMenuAddItem(10, "|TInterface\\ICONS\\INV_Misc_Ribbon_01.BLP:30|t |cff660099      击杀榜", 0, 13);
	player:GossipMenuAddItem(10, "|TInterface\\ICONS\\INV_Misc_Ribbon_01.BLP:30|t |cff990099      在线榜", 0, 14);
    player:GossipSendMenu(3550, item)
    end
    
	
	function List_List(event, player, item, sender, intid, code)
	   
	    if (intid == 11) then -- 显示荣誉前十排名
   		player:GossipMenuAddItem(10, "  |cFFFF0000第一名        "..HN1.."    "..Ho1.."", 0, 1)	
   		player:GossipMenuAddItem(10, "  |cFFFF0033第二名        "..HN2.."    "..Ho2.."", 0, 1)
   		player:GossipMenuAddItem(10, "  |cFFFF0066第三名        "..HN3.."    "..Ho3.."", 0, 1)
   		player:GossipMenuAddItem(10, "  |cFFFF0099第四名        "..HN4.."    "..Ho4.."", 0, 1)
   		player:GossipMenuAddItem(10, "  |cFFFF00CC第五名        "..HN5.."    "..Ho5.."", 0, 1)
   		player:GossipMenuAddItem(10, "  |cFFFF00FF第六名        "..HN6.."    "..Ho6.."", 0, 1)
   		player:GossipMenuAddItem(10, "  |cFFFF33FF第七名        "..HN7.."    "..Ho7.."", 0, 1)
   		player:GossipMenuAddItem(10, "  |cFFFF33CC第八名        "..HN8.."    "..Ho8.."", 0, 1)	
   		player:GossipMenuAddItem(10, "  |cFFFF3399第九名        "..HN9.."    "..Ho9.."", 0, 1)	
		player:GossipMenuAddItem(10, "  |cFFFF3366第十名        "..HN10.."    "..Ho10.."", 0, 1)
		player:GossipMenuAddItem(10, "  \n|cFF0033FF    点击领取荣誉榜专属BUFF", 0, 999)
		player:GossipSendMenu(3550, item)
		end	

	    if (intid == 12) then -- 显示金钱前十排名
   		player:GossipMenuAddItem(10, "  |cFFFF0000第一名        "..Ma1.."    "..Mo1.."", 0, 1)	
   		player:GossipMenuAddItem(10, "  |cFFFF0033第二名        "..Ma2.."    "..Mo2.."", 0, 1)
   		player:GossipMenuAddItem(10, "  |cFFFF0066第三名        "..Ma3.."    "..Mo3.."", 0, 1)
   		player:GossipMenuAddItem(10, "  |cFFFF0099第四名        "..Ma4.."    "..Mo4.."", 0, 1)
   		player:GossipMenuAddItem(10, "  |cFFFF00CC第五名        "..Ma5.."    "..Mo5.."", 0, 1)
   		player:GossipMenuAddItem(10, "  |cFFFF00FF第六名        "..Ma6.."    "..Mo6.."", 0, 1)
   		player:GossipMenuAddItem(10, "  |cFFFF33FF第七名        "..Ma7.."    "..Mo7.."", 0, 1)
   		player:GossipMenuAddItem(10, "  |cFFFF33CC第八名        "..Ma8.."    "..Mo8.."", 0, 1)	
   		player:GossipMenuAddItem(10, "  |cFFFF3399第九名        "..Ma9.."    "..Mo9.."", 0, 1)	
		player:GossipMenuAddItem(10, "  |cFFFF3366第十名        "..Ma10.."    "..Mo10.."", 0, 1)
		player:GossipMenuAddItem(10, "  \n|cFF0033FF    点击领取金钱榜专属BUFF", 0, 999)
		player:GossipSendMenu(3550, item)
		end	
	
		if (intid == 13) then -- 显示击杀前十排名
   		player:GossipMenuAddItem(10, "  |cFFFF0000第一名        "..Ka1.."    "..Ko1.."", 0, 1)
   		player:GossipMenuAddItem(10, "  |cFFFF0033第二名        "..Ka2.."    "..Ko2.."", 0, 1)
   		player:GossipMenuAddItem(10, "  |cFFFF0066第三名        "..Ka3.."    "..Ko3.."", 0, 1)
   		player:GossipMenuAddItem(10, "  |cFFFF0099第四名        "..Ka4.."    "..Ko4.."", 0, 1)
   		player:GossipMenuAddItem(10, "  |cFFFF00CC第五名        "..Ka5.."    "..Ko5.."", 0, 1)
   		player:GossipMenuAddItem(10, "  |cFFFF00FF第六名        "..Ka6.."    "..Ko6.."", 0, 1)
   		player:GossipMenuAddItem(10, "  |cFFFF33FF第七名        "..Ka7.."    "..Ko7.."", 0, 1)
   		player:GossipMenuAddItem(10, "  |cFFFF33CC第八名        "..Ka8.."    "..Ko8.."", 0, 1)
   		player:GossipMenuAddItem(10, "  |cFFFF3399第九名        "..Ka9.."    "..Ko9.."", 0, 1)	
		player:GossipMenuAddItem(10, "  |cFFFF3366第十名        "..Ka10.."    "..Ko10.."", 0, 1)
		player:GossipMenuAddItem(10, "  \n|cFF0033FF    点击领取击杀榜专属BUFF", 0, 999)
		player:GossipSendMenu(3550, item)
		end	
	
	    if (intid == 14) then -- 显示在线前十排名
   		player:GossipMenuAddItem(10, "  |cFFFF0000第一名        "..La1.."    "..Lo1.."", 0, 1)	
   		player:GossipMenuAddItem(10, "  |cFFFF0033第二名        "..La2.."    "..Lo2.."", 0, 1)
   		player:GossipMenuAddItem(10, "  |cFFFF0066第三名        "..La3.."    "..Lo3.."", 0, 1)
   		player:GossipMenuAddItem(10, "  |cFFFF0099第四名        "..La4.."    "..Lo4.."", 0, 1)
   		player:GossipMenuAddItem(10, "  |cFFFF00CC第五名        "..La5.."    "..Lo5.."", 0, 1)
   		player:GossipMenuAddItem(10, "  |cFFFF00FF第六名        "..La6.."    "..Lo6.."", 0, 1)
   		player:GossipMenuAddItem(10, "  |cFFFF33FF第七名        "..La7.."    "..Lo7.."", 0, 1)
   		player:GossipMenuAddItem(10, "  |cFFFF33CC第八名        "..La8.."    "..Lo8.."", 0, 1)	
   		player:GossipMenuAddItem(10, "  |cFFFF3399第九名        "..La9.."    "..Lo9.."", 0, 1)
		player:GossipMenuAddItem(10, "  |cFFFF3366第十名        "..La10.."    "..Lo10.."", 0, 1)
		player:GossipMenuAddItem(10, "  \n|cFF0033FF    点击领取在线榜专属BUFF", 0, 999)
		player:GossipSendMenu(3550, item)
		end	
	end

    RegisterItemGossipEvent(6948, 1, List_PD)
    RegisterItemGossipEvent(6948, 2, List_List)