print(">>Script: InstanceAura loading...OK")

local aura = {
--联盟光环 5%,10%,15%,20%,25%,30%
73762,
73824,
73825,
73826,
73827,
73828,
--部落光环 5%,10%,15%,20%,25%,30%
73816,
73818,
73819,
73820,
73821,
73822
}

local function CheckAura(Instance,Player)
		if Player:IsAlliance() then
			if Instance > 0 then
				if Instance == 1 then
					Player:AddAura( 73826, Player )--5人普通本
				elseif Instance == 2 then
					Player:AddAura( 73827, Player )--5人英雄本
				elseif Instance == 3 then
					Player:AddAura( 73828, Player )--团本
				end
			else
				for k,v in pairs (aura) do
					if Player:HasAura(v) then
						Player:RemoveAura(v)			
						break
					end
				end
			end
		else
			if Instance > 0 then
				if Instance == 1 then
					Player:AddAura( 73820, Player )
				elseif Instance == 2 then
					Player:AddAura( 73821, Player )
				elseif Instance == 3 then
					Player:AddAura( 73822, Player )
				end
			else
				for k,v in pairs (aura) do
					if Player:HasAura(v) then
						Player:RemoveAura(v)			
						break
					end
				end
			end		
		end
		
end

local function PlayerChangeMap(event,Player)
			if Player:GetMap():IsDungeon() then
				CheckAura(1,Player)
				Player:SendAreaTriggerMessage("您已获得地下城强化光环")
			elseif Player:GetMap():IsHeroic() then
				CheckAura(2,Player)
				Player:SendAreaTriggerMessage("您已获得英雄地下城强化光环")
			elseif Player:GetMap():IsRaid() then
				CheckAura(3,Player)
				Player:SendAreaTriggerMessage("您已获得团队地下城强化光环")
			else
				CheckAura(0,Player)
				--Player:SendAreaTriggerMessage("您离开地下城失去了强化光环")
			end
end

RegisterPlayerEvent(27,PlayerChangeMap)
