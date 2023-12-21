--[[
--BOSS击杀公告lua
]]--

print("LUA>>Kill_Whole.lua Loaded")

--需要通报的BOSS集合
local boss = {14321,14322,14323,14324,14325,11501,14326};


local ZoneBattles = {
        ["location"] = {
                [1] = {372.501  ,322.953    ,2.85161    ,5.71649}; --厄运
                [2] = {399.778	,323.19	    ,2.85145    ,4.07108}; --厄运
                [3] = {307.455  ,270.263    ,2.85094	,5.28531}; --厄运
                [4] = {307.858	,241.042	,2.85171	,0.970322}; --厄运
                [5] = {270.004	,229.513	,3.86379    ,1.18316}; --厄运
                [6] = {367.22	,456.015	,-7.22137	,1.16746}; --厄运
                [7] = {433.946	,523.404	,-17.296	,0.0914619}; --厄运
                [8] = {543.448	,564.315	,-4.75475	,4.3923}; --厄运
                [9] = {560.658	,499.469	,29.4746	,3.01785}; --厄运
                [10] = {649.969	,519.458	,29.457	    ,1.21851}; --厄运
                [11] = {649.849	,441.629	,29.4636	,5.36148}; --厄运
                [12] = {783.455	,391.859	,40.3962	,3.48123}; --厄运
                [13] = {851.026	,385.789	,40.3963	,4.1928}; --厄运
                [14] = {905	    ,425.938	,40.3965	,4.80698}; --厄运
                [15] = {912.349	,524.978	,40.3954	,1.87588}; --厄运
                [16] = {820.324	,575.095	,40.3954	,4.7363}; --厄运	
                [17] = {763.67	,560.501	,40.3973	,1.25462}; --厄运
                [18] = {439.143	,-77.4434	,-28.4752	,2.67838}; --厄运
                [19] = {498.681	,104.38	    ,-2.58272	,0.583914}; --厄运
                [20] = {463.781 ,269.785	,2.85251	,3.92579}; --厄运
                [21] = {464.284	,241.716	,2.85294	,2.31572}; --厄运
                [22] = {429.554	,370.9	    ,3.86289	,1.91909}; --厄运				
        };

};


local T = {}



--厄运之锤
function KilledCreature(event, killer, killed)
    local pguid, cguid = killer:GetGUIDLow(), killed:GetGUIDLow()
    if (T[pguid] and T[pguid][cguid]) then
         T[pguid][cguid] = nil
    end



    for k,v in pairs (boss) do
        if (killed:GetEntry() == v) then
   local teamId = math.random(1, 100)
   if teamId > 22 then return end

   local x = ZoneBattles["location"][teamId][1]
   local y = ZoneBattles["location"][teamId][2]
   local z = ZoneBattles["location"][teamId][3]
   local o = ZoneBattles["location"][teamId][4]

   local NPC=killer:SpawnCreature(59900,x, y, z, o, 6,60*1000);
	    SendWorldMessage("|cFFFF0000[副本公告]|r"..killer:GetName().." |cFF6495ED的勇猛表现获得了女神的亲睐，触发了特殊BOSS|cFFB23AEE瓦里安的投影|r降临！|r")
        end
    end
end 


RegisterPlayerEvent(7, KilledCreature)

