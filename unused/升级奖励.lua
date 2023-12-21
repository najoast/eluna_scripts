print(">>Script: LevelUpAward loading...OK")


AWARD = {
--物品ID,等级,数量,备注（原版使用参数4的名称，修改后直接上物品链接，参数4只做备忘）
{70006,10,1,"金币"},
{70006,20,2,"金币"},
{70006,30,4,"金币"},
{70006,40,8,"金币"},
{70006,50,16,"金币"},
{70006,60,32,"金币"},
{70006,70,64,"金币"},
{70006,80,128,"金币"},

{70002,10,10,"积分"},
{70002,20,20,"积分"},
{70002,30,30,"积分"},
{70002,40,50,"积分"},
{70002,50,75,"积分"},
{70002,60,100,"积分"},
{70002,70,150,"积分"},
{70002,80,200,"积分"},

};

local function LevelUpAward (event, player, oldLevel)
	local nowLevel = player:GetLevel()--得到当前等级
	local item = ""
	for _,v in pairs (AWARD) do
		if (nowLevel == v[2]) then--由于modify money给金钱有问题，取消，使用代金币物品，出售给NPC换钱
			--if v[1] == 0 then --给金币
			--	player:RunCommand(".modify money "..v[3]*10000)
			--	local ItemName = v[4]
			--	item = item.."|cffff0000["..ItemName.."]|r"..v[3].."个"
				--player:SendBroadcastMessage("恭喜你提升到"..nowLevel.."级,获得系统奖励["..v[4].."]"..v[3].."个。")
				--SendWorldMessage("|cffff0000[系统公告]|r|cffcc00cc恭喜玩家|r|Hplayer:"..player:GetName().."|h|cff3333ff["..player:GetName().."]|h|r|cffcc00cc提升到"..nowLevel.."级,获得系统奖励["..v[4].."]"..v[3].."个。|r")
			--else
				player:AddItem(v[1], v[3])
				local ItemName = GetItemLink(v[1])
				item = item..ItemName..v[3].."个"
				--player:SendBroadcastMessage("恭喜你提升到"..nowLevel.."级,获得系统奖励["..ItemName.."]"..v[3].."个。")
				--SendWorldMessage("|cffff0000[系统公告]|r|cffcc00cc恭喜玩家|r|Hplayer:"..player:GetName().."|h|cff3333ff["..player:GetName().."]|h|r|cffcc00cc提升到"..nowLevel.."级,获得系统奖励["..ItemName.."]"..v[3].."个。|r")
			--end
		end
	end
	if item ~= "" and item ~= nil then
		player:SendBroadcastMessage("恭喜你提升到"..nowLevel.."级,获得系统奖励:"..item.."。")
		SendWorldMessage("|cffff0000[系统公告]|r|cffcc00cc恭喜玩家|r|Hplayer:"..player:GetName().."|h|cff3333ff["..player:GetName().."]|h|r|cffcc00cc提升到"..nowLevel.."级,获得系统奖励:"..item.."。|r")
	end
end

RegisterPlayerEvent(13, LevelUpAward)