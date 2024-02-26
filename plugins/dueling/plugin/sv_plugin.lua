--[[
	Begotten III: Jesus Wept
--]]

local FFAtimerStarted = false
local ffaQueueTime = 30;
local ffaMinPlayers = 3;
local ffaMaxPlayers = 12;

local ThralltimerStarted = false
local thrallQueueTime = 30;
local thrallMinPlayers = 1;
local thrallMaxPlayers = 4;
local thrallEndWave = 13;
local thrallHealWaveDiv = 3

local CTFPlayersMax = 12;
local CTFPlayersMin = 4;
local CTFtimerStarted = false
local CTFQueueTime = 30;

cwDueling.firearmsAllowed = true;
cwDueling.thrallmodeEnabled = true;
cwDueling.CTFmodeEnabled = true;
cwDueling.FFAmodeEnabled = true;
cwDueling.gamemodes = {"1v1", "2v2", "3v3", "4v4", "5v5", "FFA", "Thralls", "CTF"};
local map = game.GetMap();

if map == "rp_begotten3" then
	if !cwDueling.THRALL_ARENAS then
		cwDueling.THRALL_ARENAS = {};
	end

	if !DUELING_ARENAS then
		DUELING_ARENAS = {
			["bridge"] = {
				types = {"TDM"},
				duelType,
				duelingTeam1 = {},
				duelingTeam2 = {},
				spawnPositions1 = {
					Vector(11851.328125, -11511.490234, -6132.968750),
					Vector(11886.997070, -11614.291016, -6080.367676),
					Vector(11881.155273, -11675.319336, -6080.827637),
					Vector(11822.998047, -11676.235352, -6080.731445)
				},				
				spawnAngles1 = Angle(0, -90, 0),
				spawnPositions2 = {
					Vector(11851.328125, -13267.906250, -6132.968750),
					Vector(11878.942383, -13137.342773, -6080.037109),
					Vector(11879.121094, -13083.681641, -6080.294434),
					Vector(11821.314453, -13083.488281, -6080.267090)
				},
				spawnAngles2 = Angle(0, 90, 0),
				timeLimit = 300,
				maxDuel = 4;
			},
			["hell"] = {
				types = {"TDM"},
				duelType,
				duelingTeam1 = {},
				duelingTeam2 = {},
				spawnPositions1 = {
					Vector(-11738.578125, -8073.676270, -12460.499023),
					Vector(-11810.575195, -8148.369629, -12458.788086),
					Vector(-11710.289062, -8191.522461, -12453.290039),
					Vector(-11589.990234, -8134.578613, -12465.045898),
					Vector(-11525.401367, -8219.200195, -12482.260742)
				},
				spawnAngles1 = Angle(0, -95, 0),
				spawnPositions2 = {
					Vector(-11932.957031, -9189.885742, -12463.690430),
					Vector(-11823.729492, -9201.526367, -12450.960938),
					Vector(-11734.523438, -9184.345703, -12452.982422),
					Vector(-11731.259766, -9112.806641, -12449.107422),
					Vector(-11812.610352, -9040.128906, -12453.374023)
				},
				spawnAngles2 = Angle(0, 83, 0),
				timeLimit = 300,
				maxDuel = 5;
			},
			["gore"] = {
				types = {"TDM"},
				duelType,
				duelingTeam1 = {},
				duelingTeam2 = {},
				spawnPositions1 = {
					Vector(-11502.302734, -11726.091797, 12126.031250),
					Vector(-11582.802734, -11631.621094, 12126.031250),
					Vector(-11669.138672, -11530.300781, 12126.031250),
					Vector(-11748.768555, -11598.156250, 12126.031250),
					Vector(-11674.611328, -11771.519531, 12126.031250)
				},
				spawnAngles1 = Angle(0, -135, 0),
				spawnPositions2 = {
					Vector(-12704.388672, -12753.103516, 12126.031250),
					Vector(-12628.571289, -12829.490234, 12126.031250),
					Vector(-12546.414062, -12912.263672, 12126.031250),
					Vector(-12468.939453, -12831.175781, 12126.031250),
					Vector(-12535.369141, -12711.557617, 12126.031250)
				},
				spawnAngles2 = Angle(0, 45, 0),
				timeLimit = 300,
				maxDuel = 5;
			},
			["silenthill"] = {
				types = {"TDM"},
				duelType,
				duelingTeam1 = {},
				duelingTeam2 = {},
				spawnPositions1 = {
					Vector(9018.288086, -13261.214844, -6184.968750),
					Vector(8933.267578, -13252.127930, -6184.968750),
					Vector(8865.659180, -13247.530273, -6184.968750),
					Vector(8956.103516, -13204.226562, -6184.723145)
				},
				spawnAngles1 = Angle(0, 90, 0),
				spawnPositions2 = {
					Vector(8864.781250, -12334.254883, -6184.968750),
					Vector(8955.876953, -12337.998047, -6184.968750),
					Vector(9032.824219, -12341.161133, -6184.968750),
					Vector(8944.809570, -12396.385742, -6184.723145)
				},
				spawnAngles2 = Angle(0, -90, 0),
				timeLimit = 300,
				maxDuel = 4;
			},
			["wasteland"] = {
				types = {"TDM", "FFA"},
				duelingFFAPlayers = {},
				duelType,
				duelingTeam1 = {},
				duelingTeam2 = {},
				spawnPositionsFFA = {
					Vector(13293, -6068, -2305),
					Vector(13792, -5914, -2301),
					Vector(14271, -6047, -2262),
					Vector(14736, -6083, -2199),
					Vector(14686, -5642, -2305),
					Vector(14991, -5329, -2271),
					Vector(15000, -4946, -2296),
					Vector(14984, -4405, -2305),
					Vector(14421, -4783, -2327),
					Vector(13775, -4418, -2223),
					Vector(13256, -4350, -2169),
					Vector(13397, -5408, -2305)
				},
				spawnAnglesFFA = {
					Angle(3, 65, 0),
					Angle(3, 11, 0),
					Angle(7, 68, 0),
					Angle(13, 119, 0),
					Angle(-9, -2, 0),
					Angle(2, 178, 0),
					Angle(0, -107, 0),
					Angle(0, -129, 0),
					Angle(2, 118, 0),
					Angle(14, -60, 0),
					Angle(12, -39, 0),
					Angle(4, 8, 0)
				},
				spawnPositions1 = {
					Vector(14875.026367, -4893.539551, -2277.919189),
					Vector(14780.530273, -4912.801758, -2279.594238),
					Vector(14668.728516, -4813.296387, -2281.565430),
					Vector(14693.205078, -4736.902832, -2279.968750),
					Vector(14822.407227, -4819.905762, -2279.968750)
				},
				spawnAngles1 = Angle(0, -135, 0),
				spawnPositions2 = {
					Vector(13596.124023, -5915.917969, -2279.968750),
					Vector(13503.266602, -5798.983398, -2279.968750),
					Vector(13427.566406, -5864.585449, -2279.968750),
					Vector(13481.307617, -5964.026855, -2279.968750),
					Vector(13580.916992, -6079.505859, -2279.968750)
				},
				spawnAngles2 = Angle(0, 45, 0),
				timeLimit = 300,
				maxDuel = 5;
			},
		};
	end

	if !DUELING_STATUES then
		DUELING_STATUES = {
			["forge1"] = {
				["spawnPosition"] = Vector(-83, 13556, -1081),
				["spawnAngles"] = Angle(0, 0, 0),
			},
			["forge2"] = {
				["spawnPosition"] = Vector(183, 13556, -1081),
				["spawnAngles"] = Angle(0, 0, 0),
			},
		};
	end

	if !DUELING_LEADERBOARDS then
		DUELING_LEADERBOARDS = {
			--[[[1] = {
				["spawnPosition"] = Vector( -469, 13642, -944),
				["spawnAngles"] = Angle(0, 0, 0),
				["leaderboardType"] = "12v"
			}]]--
	end

end

if !cwDueling.DUELING_PARTIES then
	cwDueling.DUELING_PARTIES = {};
end
	
if !cwDueling.playersInMatchmaking then
    cwDueling.playersInMatchmaking = {
        [1] = { }, -- 1v1
        [2] = { }, -- 2v2
        [3] = { }, -- 3v3
        [4] = { }, -- 4v4
        [5] = { }, -- 5v5
		[6] = { }, -- FFA
		[7] = { }, -- Thralls
		[8] = { }  -- CTF
    }
end

local bMap = game.GetMap() == "rp_begotten3" or game.GetMap() == "rp_begotten_redux" or game.GetMap() == "rp_scraptown";

-- Called every tick
function cwDueling:Think()
	if (!bMap) then
		return;
	end;
	local curTime = CurTime()

	if (!self.MatchmakingCheckCooldown or self.MatchmakingCheckCooldown < curTime) then
		self.MatchmakingCheckCooldown = curTime + 3;
		
		-- Check if players exited the range of their original duel shrine
		for e = 1, 8 do															
			if next(cwDueling.playersInMatchmaking[e]) then
				for i = 1, #cwDueling.playersInMatchmaking[e] do 				
					for	j = 1, cwDueling.playersInMatchmaking[e][i].size do		
						local duelStatueFound = false;
						local player = cwDueling.playersInMatchmaking[e][i].players[j]
						if IsValid(player) and player:Alive() then

							if player:IsBot() then
								duelStatueFound = true;
							elseif IsValid(player.duelStatue) then
								if player:GetPos():DistToSqr(player.duelStatue:GetPos()) <= (256 * 256) then
									duelStatueFound = true;
									break;
								end
							end

							if !duelStatueFound then
								local duelParty = player:GetSharedVar("duelParty")
								if duelParty and cwDueling.DUELING_PARTIES[duelParty] ~= nil then
									cwDueling:PartyExitsMatchmaking(duelParty);
									Schema:EasyText(cwDueling.DUELING_PARTIES[duelParty].players, "icon16/shield_go.png", "orange", "Party Member Exited Duel Matchmaking By Leaving Shrine Area")
								else
									Schema:EasyText(player, "icon16/shield_go.png", "orange", "Exited Duel Matchmaking By Leaving Shrine Area")
									cwDueling:PlayerExitsMatchmaking(player);
								end
							end
						end
					end
				end
			end
		end
		self:MatchmakingCheck();
	end

	-- Check if any thrall lobbies need spawns/wave and other logic handled every tick.
	if (!self.ThrallLobbyCheckCooldown or self.ThrallLobbyCheckCooldown < curTime) then
		self.ThrallLobbyCheckCooldown = curTime + 1;
		self:ThrallCheck();
	end
end

--Update leaderboard stuff
if not cwDueling.LeaderboardTable then
	cwDueling.LeaderboardTable = {}
end

if not timer.Exists("LeaderboardUpdate") then	
	timer.Create("LeaderboardUpdate", 5, 0, function()
		UpdateLeaderboardTable();
	end)
end



function UpdateLeaderboardTable()
    local charactersTable = Clockwork.config:Get("mysql_characters_table"):Get()
    local query = Clockwork.database:Select(charactersTable);
    query:Select("_Data");
    query:Select("_Name");

    query:Callback(function(result)
        if result and #result > 0 then
            local leaderboard = {}
            local onlinePlayers = _player.GetAll()

            -- Iterate through all characters
            for _, characterData in pairs(result) do
                local name = characterData._Name
                local data = util.JSONToTable(characterData._Data)
                local duelWins = data.DuelWins;

                if type(duelWins) == "table" then
                    for _, onlinePlayer in pairs(_player.GetAll()) do
                        if onlinePlayer:GetName() == name then
                            -- If the player is online, get the data directly
                            duelWins = onlinePlayer:GetCharacterData("DuelWins") or {0, 0, 0, 0, 0, 0, 0, 0}
                            break
                        end
                    end

                    -- Iterate through duel types
                    for duelType, wins in pairs(duelWins) do
                        -- Insert the player and their wins for the specific duel type
                        table.insert(leaderboard, { player = name, duelType = duelType, wins = wins })
                    end
                end
            end

            -- Sort the leaderboard by wins in descending order for each duel type
			cwDueling.LeaderboardTable = {}
            for duelType = 1, 8 do
                local typeLeaderboard = {}
                for _, entry in pairs(leaderboard) do
                    if entry.duelType == duelType then
                        table.insert(typeLeaderboard, entry)
                    end
                end

                table.sort(typeLeaderboard, function(a, b)
                    return a.wins > b.wins
                end)

                -- Update the leaderboard data for the specific duel type
                local maxEntries = 8
                local limitedLeaderboard = {}
                for i = 1, math.min(#typeLeaderboard, maxEntries) do
                    table.insert(limitedLeaderboard, typeLeaderboard[i])
                end
                cwDueling.LeaderboardTable[duelType] = table.Copy(limitedLeaderboard)
            end

            -- Collect total wins from all players
            local totalLeaderboard = {}

            for q, e in ipairs(leaderboard) do
                if not totalLeaderboard[e.player] then
                    totalLeaderboard[e.player] = {wins = 0, player = e.player}
                end
				if q ~= 7 then
                	totalLeaderboard[e.player].wins = totalLeaderboard[e.player].wins + e.wins
				end
            end

            local sortedPlayers = {}
            for _, playerData in pairs(totalLeaderboard) do
                table.insert(sortedPlayers, playerData)
            end

            -- Sort the list based on wins in descending order
            table.sort(sortedPlayers, function(a, b)
                return a.wins > b.wins
            end)

            -- Get the top 5 players
            local top5Players = {}
            for i = 1, math.min(8, #sortedPlayers) do
                table.insert(top5Players, sortedPlayers[i])
            end

            cwDueling.LeaderboardTable[9] = top5Players -- in the future [6] will be ffa.. need more detailed way of storing this, documentation etc
			--PrintTable(cwDueling.LeaderboardTable)
        end
    end)

    query:Execute()
end

-- Check if a list of teamPlayers is valid/alive for a duel, else kick them out of matchmaking
function cwDueling:TeamReadyCheck(teamPlayers)
	local teamPlayersReady = true;
	for e = 1, #teamPlayers do
		for i = 1, #teamPlayers[e].players do
			local p1 = teamPlayers[e].players[i];
			if !(IsValid(p1) and p1:Alive()) then
				cwDueling:TeamExitsMatchmaking(teamPlayers);
				return false;
			end
		end
	end
	return true;
end

-- Return true if the players are valid & alive
function cwDueling:PlayersReadyCheck(players, partySized)
	if partySized then 
		for e = 1, #players do
			for q = 1, #players[e].players do
				local p1 = players[e].players[q];
				if !(IsValid(p1) and p1:Alive()) then
					local p1DuelParty = p1:GetSharedVar("duelParty");
					cwDueling:PartyExitsMatchmaking(p1DuelParty)
					return false;
				end
			end
		end
		return true;
	else
		for e = 1, #players do
			local p1 = players[e].players[1];
			if !(IsValid(p1) and p1:Alive()) then
				cwDueling:PlayerExitsMatchmaking(p1)
				return false;
			end
		end
		return true;
	end
end

-- Return the team of the player
function cwDueling:GetPlayerTeam(player)
	local duelArena = player:GetSharedVar("duelArena")
	local duelType = player:GetSharedVar("duelType")
	local pTID = player:GetSharedVar("teamID")
    if DUELING_ARENAS then
		if duelArena and DUELING_ARENAS[duelArena] then
			local arena = DUELING_ARENAS[duelArena]
			if (duelType ~= "FFA") then
				if next(arena.duelingTeam1) ~= nil then
					for _, teamPlayer in ipairs(arena.duelingTeam1.players) do
						if IsValid(teamPlayer) and teamPlayer == player then
							return arena.duelingTeam1
						end
					end
				end
				if next(arena.duelingTeam2) ~= nil then
					for _, teamPlayer in ipairs(arena.duelingTeam2.players) do
						if IsValid(teamPlayer) and teamPlayer == player then
							return arena.duelingTeam2
						end
					end
				end
			else
				if next(arena.duelingFFAPlayers) ~= nil then
					for _,v in arena.duelingFFAPlayers do
						if v.players[1] == player then
							return v;
						end
					end
				end
			end
		end
    end
	
    return nil
end

-- Remove ragdolls from an arena, iterate through team1, team2, FFA players, and thrall players
function cwDueling:RagdollRemove(duelArenaRem)
    if duelArenaRem then
        -- Remove ragdolls from team1
		if duelArenaRem.duelingTeam1 then
			for _, player in ipairs(duelArenaRem.duelingTeam1) do
				if IsValid(player) then
					local ragdoll = player:GetRagdollEntity()

					if (ragdoll) then		
						timer.Simple(5, function()
							if IsValid(ragdoll) then
								ragdoll:Remove();
							end
						end);
					end
				end
			end
		end

        -- Remove ragdolls from team2
		if duelArenaRem.duelingTeam2 then
			for _, player in ipairs(duelArenaRem.duelingTeam2) do
				if IsValid(player) then
					local ragdoll = player:GetRagdollEntity()

					if (ragdoll) then		
						timer.Simple(5, function()
							if IsValid(ragdoll) then
								ragdoll:Remove();
							end
						end);
					end
				end
			end
		end

        -- Check if duelingFFAPlayers exists before removing ragdolls
        if duelArenaRem.duelingFFAPlayers then
            for _, player in ipairs(duelArenaRem.duelingFFAPlayers) do
				if IsValid(player) then
					local ragdoll = player:GetRagdollEntity()
	
					if (ragdoll) then		
						timer.Simple(5, function()
							if IsValid(ragdoll) then
								ragdoll:Remove();
							end
						end);
					end
				end
            end
        end

		if duelArenaRem.players then
            for _, player in ipairs(duelArenaRem.players) do
				if IsValid(player) then
					local ragdoll = player:GetRagdollEntity()
	
					if (ragdoll) then		
						timer.Simple(5, function()
							if IsValid(ragdoll) then
								ragdoll:Remove();
							end
						end);
					end
				end
            end
        end
    end
end

-- Check if all team players are dead, if so return true, else false
function cwDueling:AreTeamPlayersAllDead(teamPlayers)
    for _, player in ipairs(teamPlayers) do
        if IsValid(player) and player:Alive() and player:IsConnected() then -- if the player is offline, then it should still pass this loop
            return false
        end
    end
    return true 
end

-- Copy players from team structure to another team stucture players member
function copyPlayers(dest, source)
    for _, player in ipairs(source.players) do
        table.insert(dest.players, player)
    end
end

-- Build TDM teams matching a size given a table of availableParties
function cwDueling:BuildTeams(size, MMQueue)
    local team1 = { size = 0, partyIDs = {}, players = {}, id = ""}
    local team2 = { size = 0, partyIDs = {}, players = {}, id = ""}
	local availableParties = {};
	for e, v in ipairs(MMQueue) do
		table.insert(availableParties, v);
	end

    -- Randomly shuffle availableParties
    for i = #availableParties, 2, -1 do
        local j = math.random(i)
        availableParties[i], availableParties[j] = availableParties[j], availableParties[i]
    end

    -- Build Team1
    for _, party in ipairs(availableParties) do
        if team1.partyIDs[party.ID] == nil then
            if team1.size + party.size <= size then
                team1.size = team1.size + party.size
                team1.partyIDs[party.ID] = party.ID
                copyPlayers(team1, party)
            end
        end
        if team1.size == size then
            break
        end
    end 
	
    -- Build Team2
    for _, party in ipairs(availableParties) do
        if team2.partyIDs[party.ID] == nil and team1.partyIDs[party.ID] == nil then
            if team2.size + party.size <= size then
                team2.size = team2.size + party.size
                team2.partyIDs[party.ID] = party.ID
                copyPlayers(team2, party)
            end
        end
        if team2.size == size then
            break
        end
    end

    if team1.size == size and team2.size == size then
		team1.ID = os.time() .. "_" .. math.random(1000, 9999)
		team2.ID = os.time() .. "_" .. math.random(1000, 9999)
        return team1, team2
    else
        return nil, nil
    end
end

-- Return a table how many players are in queue of all the MM types. [1] = 1v1, [2] = 2v2... etc [6] FFA
function cwDueling:GetPlayersInQueue()
	local matchmakingStatus = {}

    for i = 1, 8 do
        local currentPlayers = 0
		local duelType = cwDueling.playersInMatchmaking[i]
		for _, team in pairs(duelType) do
			currentPlayers = currentPlayers + team.size
		end

        table.insert(matchmakingStatus, currentPlayers)
	end
	return matchmakingStatus
end

-- Colect players the FFA MM queue and return them as players
function cwDueling:BuildFFALobby()
    local ffaPlayers = {}
    local matchmakingTable = cwDueling.playersInMatchmaking[6]

    if matchmakingTable and #matchmakingTable >= 1 then
        for i = 1, math.min(#matchmakingTable, ffaMaxPlayers) do 
            table.insert(ffaPlayers, matchmakingTable[i])
        end

        for _, player in ipairs(ffaPlayers) do
            for j, originalPlayer in ipairs(matchmakingTable) do
                if player == originalPlayer then
                    table.remove(matchmakingTable, j)
                    break
                end
            end
        end
		return ffaPlayers;

    else
        print("Error: Unable to build FFA lobby. Insufficient players in matchmakingTable.")
		return nill;
    end
end

-- Try to setup a FFA Lobby given theres players and arenas ready
function cwDueling:SetupFFALobby()
	local players = cwDueling:BuildFFALobby();
	if cwDueling:PlayersReadyCheck(players, false) then
		local availableArenas = cwDueling:FindArenaMaps("FFA")
		for _,v in pairs(players) do
			cwDueling:PlayerExitsMatchmaking(v.players[1])
		end
		self:SetupFFA(players, availableArenas);
	end
end

-- Debug function for printing the MM queue to console
function cwDueling:PrintMMQueue(index, max)
	-- return;
	local playersInMM = 0;
	for k,v in pairs(cwDueling.playersInMatchmaking[index]) do
		playersInMM = playersInMM + v.size
	end
	print(playersInMM .. " / " .. max)
end

-- Check if theres enough players in queue for a specific type
function cwDueling:EnoughPlayers(index, target)
	local playersInMM = 0;
	for k,v in pairs(cwDueling.playersInMatchmaking[index]) do
		playersInMM = playersInMM + v.size
	end

	if playersInMM >= target then
		return true
	end
	return false
end

-- Return any valid/open arena maps for a specific type
function cwDueling:FindArenaMaps(duelType, tdmType)
	local availableArenas = {};
	for k, v in pairs(DUELING_ARENAS) do
		if v.types and table.HasValue(v.types, duelType) then
			if (not v.duelingTeam1 or next(v.duelingTeam1) == nil) and
				(not v.duelingTeam2 or next(v.duelingTeam2) == nil) and
				(not v.duelingFFAPlayers or next(v.duelingFFAPlayers) == nil) and
				(v.state == nil or (v.state and v.state == 0)) and 
				(tdmType == nil or (tdmType <= v.maxDuel)) then
					table.insert(availableArenas, k)
			end
		end
	end
	return availableArenas
end

-- Contact players in matchmaking for a specific index
function cwDueling:ContactMMPlayers(index, color, message)
	local playersToContact = {}
	for k,v in pairs(cwDueling.playersInMatchmaking[index]) do
		table.insert(playersToContact, v.players[1])
	end
	Schema:EasyText(playersToContact, "icon16/door_in.png", color, message)
end

-- Called in Think(), matches players into TDM, FFA, and Thrall arenas.
function cwDueling:MatchmakingCheck()
	for i = 1, 5 do -- TDM 1v1 to 5v5
		if next(cwDueling.playersInMatchmaking[i]) then
			cwDueling:PrintMMQueue(i, i*2)
			if cwDueling:EnoughPlayers(i, i*2) then
				local playersTeamOne, playersTeamTwo = cwDueling:BuildTeams(i, cwDueling.playersInMatchmaking[i])		
				if (playersTeamOne ~= nil and playersTeamTwo ~= nil) then						
					if (cwDueling:TeamReadyCheck(playersTeamOne) and cwDueling:TeamReadyCheck(playersTeamTwo)) then 
						local availableArenas = cwDueling:FindArenaMaps("TDM", i)
						if #availableArenas > 0 then
							cwDueling:TeamExitsMatchmaking(playersTeamOne)
							cwDueling:TeamExitsMatchmaking(playersTeamTwo)
							self:SetupDuel(playersTeamOne, playersTeamTwo, availableArenas, i);
						end
					end
				end
			end
		end
	end
	
	if next(cwDueling.playersInMatchmaking[6]) then -- FFA MM Check
		cwDueling:PrintMMQueue(6, ffaMaxPlayers)
		if ((next(cwDueling.playersInMatchmaking[6]) ~= nil )) and cwDueling:EnoughPlayers(6, ffaMinPlayers) then
			if not FFAtimerStarted then
				FFAtimerStarted = true
				local availableArenas = cwDueling:FindArenaMaps("FFA")
				if #availableArenas > 0 then
					cwDueling:ContactMMPlayers(6, "orange", "Atleast three players have been found, match will begin in " .. ffaQueueTime .. " seconds.")
					FFAtimerStarted = true

					timer.Create("FFACountDownFull", ffaQueueTime, 1, function()
						if cwDueling:EnoughPlayers(6, 2) then
							cwDueling:SetupFFALobby()
						else
							print("Not enough players in ffa MM to start.")
						end	
						FFAtimerStarted = false
					end)
					timer.Create("FFACountdownPartial", ffaQueueTime/3, 2, function()
						cwDueling:ContactMMPlayers(7, "orange", "Match will begin in " .. math.floor(timer.TimeLeft("FFACountdownFull")) .. " seconds.")
					end)
				end
			end
		end
	end

	if next(cwDueling.playersInMatchmaking[7]) then -- Thrall MM Check
		cwDueling:PrintMMQueue(7, thrallMaxPlayers)
		if ((next(cwDueling.playersInMatchmaking[7]) ~= nil )) and cwDueling:EnoughPlayers(7, thrallMinPlayers) then
			if not ThralltimerStarted then
				local availableArenas = cwDueling:FindArenaMaps("Thralls")
				if #availableArenas > 0 then
					cwDueling:ContactMMPlayers(7, "orange", "Atleast one player and an arena has been found, match will begin in " .. thrallQueueTime .. " seconds.")
					ThralltimerStarted = true

					timer.Create("ThrallCountdownFull", thrallQueueTime, 1, function()
						if cwDueling:EnoughPlayers(7, 1) then
							cwDueling:SetupThrallLobby()
						end			
						ThralltimerStarted = false
					end)
					timer.Create("ThrallCountdownPartial", thrallQueueTime/3, 2, function()
						cwDueling:ContactMMPlayers(7, "orange", "Match will begin in " .. math.floor(timer.TimeLeft("ThrallCountdownFull")) .. " seconds.")
					end)
				end
			end
		end
	end

	if next(cwDueling.playersInMatchmaking[8]) then -- CTF MM Check
		cwDueling:PrintMMQueue(8, 4)
		if (cwDueling:EnoughPlayers(8, CTFPlayersMin)) then 
			if not CTFtimerStarted then		
				local playersTeamOne, playersTeamTwo = cwDueling:BuildTeams((math.floor(#cwDueling.playersInMatchmaking[8] / 2)), cwDueling.playersInMatchmaking[8])	
				if (playersTeamOne ~= nil and playersTeamTwo ~= nil) then					
					if (cwDueling:TeamReadyCheck(playersTeamOne) and cwDueling:TeamReadyCheck(playersTeamTwo)) then 
						
						local availableArenas = cwDueling:FindArenaMaps("CTF")
						if #availableArenas > 0 then
							CTFtimerStarted = true;
							cwDueling:ContactMMPlayers(8, "orange", "Atleast four players and an arena has been found, match will begin in " .. CTFQueueTime .. " seconds.")
							
							timer.Create("CTFCountdownFull", CTFQueueTime, 1, function()
								if cwDueling:EnoughPlayers(8, CTFPlayersMin) then
									cwDueling:TeamExitsMatchmaking(playersTeamOne)
									cwDueling:TeamExitsMatchmaking(playersTeamTwo)
									self:SetupCTF(playersTeamOne, playersTeamTwo, availableArenas);
								end			
								CTFtimerStarted = false
							end)
							timer.Create("CTFCountdownPartial", CTFQueueTime/3, 2, function()
								cwDueling:ContactMMPlayers(8, "orange", "Match will begin in " .. math.floor(timer.TimeLeft("CTFCountdownFull")) .. " seconds.")
							end)
						end
					end
				end
			end
		end
	end
end

-- Check if a player is in matchmaking
function cwDueling:PlayerIsInMatchmaking(player)
	for key, value in pairs(cwDueling.playersInMatchmaking) do
		for _, team in ipairs(value) do
			for _, p in ipairs(team.players) do
				if p == player then
					return true
				end
			end
		end
	end
	return false;
end

-- Add a party to MM given t, the type of the duel. 1: 1v1, 6: FFA, 7: Thrall
function cwDueling:PartyEntersMatchmaking(party, t)
	for k,player in pairs(party.players) do
		if (IsValid(player.cwHoldingEnt)) then
			cwPickupObjects:ForceDropEntity(player);
		end;
		
		if cwDueling:PlayerIsInMatchmaking(player) then -- atleast one playeer is fucked, need to revert all changes done so far
			return
		end

		if (Clockwork.player:GetAction(player) == "pickupragdoll") then
			if (IsValid(player.PickingUpRagdoll)) then
				player.PickingUpRagdoll:SetNetVar("IsDragged", false);
				player.PickingUpRagdoll:SetNetVar("IsBeingPickedUp", false);
				player.PickingUpRagdoll.BeingPickedUp = nil;
				player.PickingUpRagdoll.PickedUpBy = nil;
			end;
			
			Clockwork.chatBox:AddInTargetRadius(player, "me", "releases their grip on the body before them.", player:GetPos(), config.Get("talk_radius"):Get() * 2);
			
			player.NextPickup = CurTime() + 1;
			player.PickingUpRagdoll = nil;
			player:SetNWBool("PickingUpRagdoll", false);
			Clockwork.player:SetAction(player, nil);
		end
	end
	--end [1] - [5], TDM. [6] FFA, [7] Thrall, [8] CTF Gamemode
	if player.opponent == nil then -- If both players spam really hard they can have multiple duels trigger at once.
		if (t and not cwDueling.playersInMatchmaking[t]) then
			cwDueling.playersInMatchmaking[t] = {}
		end
		table.insert(cwDueling.playersInMatchmaking[t], party);
		Schema:EasyText(party.players, "icon16/door_in.png", "orange", "Entered Duel Matchmaking")
		if t == 6 and FFAtimerStarted then
			timeLeft = math.floor(timer.TimeLeft("FFACountdownFull"))
			Schema:EasyText(party.players, "icon16/door_in.png", "orange", "There is " .. timeLeft .. " seconds left in the queue for FFA.")
		elseif t == 7 and ThralltimerStarted then -- 
			timeLeft = math.floor(timer.TimeLeft("ThrallCountdownFull"))
			Schema:EasyText(party.players, "icon16/door_in.png", "orange", "There is " ..  timeLeft .. " seconds left in the queue for thralls.")
		elseif t == 8 and CTFtimerStarted then -- 
			timeLeft = math.floor(timer.TimeLeft("CTFCountdownFull"))
			Schema:EasyText(party.players, "icon16/door_in.png", "orange", "There is " ..  timeLeft .. " seconds left in the queue for CTF.")
		end
		self:MatchmakingCheck();
	end
end

-- Add a player to MM given t, the type of the duel. 1: 1v1, 6: FFA, 7: Thrall
function cwDueling:PlayerEntersMatchmaking(player, t)
	if (IsValid(player.cwHoldingEnt)) then
		cwPickupObjects:ForceDropEntity(player);
	end;
	
	if (Clockwork.player:GetAction(player) == "pickupragdoll") then
		if (IsValid(player.PickingUpRagdoll)) then
			player.PickingUpRagdoll:SetNetVar("IsDragged", false);
			player.PickingUpRagdoll:SetNetVar("IsBeingPickedUp", false);
			player.PickingUpRagdoll.BeingPickedUp = nil;
			player.PickingUpRagdoll.PickedUpBy = nil;
		end;
		
		Clockwork.chatBox:AddInTargetRadius(player, "me", "releases their grip on the body before them.", player:GetPos(), config.Get("talk_radius"):Get() * 2);
		
		player.NextPickup = CurTime() + 1;
		player.PickingUpRagdoll = nil;
		player:SetNWBool("PickingUpRagdoll", false);
		Clockwork.player:SetAction(player, nil);
	end

	if cwDueling:PlayerIsInMatchmaking(player) then
		return;
	end

	if player.opponent == nil then -- If both players spam really hard they can have multiple duels trigger at once.
		local soloParty = {players = {}, size = 1, ID = os.time() .. "_" .. math.random(1000, 9999)} -- lazy fix, using a party struct for 1 player
		soloParty.players = soloParty.players or {}
		player:SetSharedVar("duelParty", soloParty.ID)
		table.insert(soloParty.players, player)
		table.insert(cwDueling.playersInMatchmaking[t], soloParty);

		Schema:EasyText(player, "icon16/door_in.png", "orange", "Entered Duel Matchmaking")
		if t == 6 and FFAtimerStarted then
			timeLeft = math.floor(timer.TimeLeft("FFACountdownFull"))
			Schema:EasyText(player, "icon16/door_in.png", "orange", "There is " ..  timeLeft .. " seconds left in the queue for FFA.")
		elseif t == 7 and ThralltimerStarted then
			timeLeft = math.floor(timer.TimeLeft("ThrallCountdownFull"))
			Schema:EasyText(player, "icon16/door_in.png", "orange", "There is " .. timeLeft .. " seconds left in the queue for thralls.")
		elseif t == 8 and CTFtimerStarted then -- 
			timeLeft = math.floor(timer.TimeLeft("CTFCountdownFull"))
			Schema:EasyText(player, "icon16/door_in.png", "orange", "There is " ..  timeLeft .. " seconds left in the queue for CTF.")
		end
		self:MatchmakingCheck();
	end
end

-- Remove a player from MM and disable timers if none left in queue.
function cwDueling:PlayerExitsMatchmaking(player)
    local partyID = player:GetSharedVar("duelParty")
    if not cwDueling.DUELING_PARTIES[partyID] or cwDueling.DUELING_PARTIES[partyID] == nil then
        player:SetSharedVar("duelParty", nil)
        for duelTypeKey, duelType in pairs(cwDueling.playersInMatchmaking) do
            for x, t in ipairs(duelType) do
                if t.ID == partyID then
                    table.remove(duelType, x)
					if duelTypeKey == 6 then
						if next(cwDueling.playersInMatchmaking[6]) == nil then
							if timer.Exists("FFACountdownPartial") then
								timer.Remove("FFACountdownPartial")
							end

							if timer.Exists("FFACountdownFull") then
								timer.Remove("FFACountdownFull")
							end
							FFAtimerStarted = false
						end
					elseif duelTypeKey == 7 then
						if next(cwDueling.playersInMatchmaking[7]) == nil then
							if timer.Exists("ThrallCountdownPartial") then
								timer.Remove("ThrallCountdownPartial")
							end
					
							if timer.Exists("ThrallCountdownFull") then
								timer.Remove("ThrallCountdownFull")
							end
							ThralltimerStarted = false
						end
					elseif duelTypeKey == 8 then
						if next(cwDueling.playersInMatchmaking[8]) == nil then
							if timer.Exists("CTFCountdownPartial") then
								timer.Remove("CTFCountdownPartial")
							end
					
							if timer.Exists("CTFCountdownFull") then
								timer.Remove("CTFCountdownFull")
							end
							CTFtimerStarted = false
						end
					end
					return;
                end
            end
        end
    else
        cwDueling:PartyExitsMatchmaking(partyID)
    end
end

-- Check if a party is in matchmaking
function cwDueling:IsPartyInMatchmaking(duelPartyID)
	for _, duelType in pairs(cwDueling.playersInMatchmaking) do
		for _, party in pairs(duelType) do
			if party.ID == duelPartyID then
				return true
			end
		end
	end
    return false
end

-- Remove a party from MM and disable timers if none left in queue.
function cwDueling:PartyExitsMatchmaking(partyID)
	if cwDueling.DUELING_PARTIES[partyID] then
		local party = cwDueling.DUELING_PARTIES[partyID]
		if party then
			for duelTypeKey, duelType in pairs(cwDueling.playersInMatchmaking) do
				for x, t in ipairs(duelType) do
					if t.ID == party.ID then
						table.remove(duelType, x)
						if duelTypeKey == 6 then
							if next(cwDueling.playersInMatchmaking[6]) == nil then
								if timer.Exists("FFACountdownPartial") then
									timer.Remove("FFACountdownPartial")
								end
						
								if timer.Exists("FFACountdownFull") then
									timer.Remove("FFACountdownFull")
								end
								FFAtimerStarted = false
							end
						elseif duelTypeKey == 7 then
							if next(cwDueling.playersInMatchmaking[7]) == nil then -- take off timers if no players left
								if timer.Exists("ThrallCountdownPartial") then
									timer.Remove("ThrallCountdownPartial")
								end
						
								if timer.Exists("ThrallCountdownFull") then
									timer.Remove("ThrallCountdownFull")
								end
								ThralltimerStarted = false
							end
						elseif duelTypeKey == 8 then
							if next(cwDueling.playersInMatchmaking[8]) == nil then
								if timer.Exists("CTFCountdownPartial") then
									timer.Remove("CTFCountdownPartial")
								end
						
								if timer.Exists("CTFCountdownFull") then
									timer.Remove("CTFCountdownFull")
								end
								CTFtimerStarted = false
							end
						end
						return;
					end
				end
			end
		end
	else
		for duelTypeKey, duelType in pairs(cwDueling.playersInMatchmaking) do
			
			for k,party in ipairs(duelType) do
				if party.ID == partyID then
					table.remove(duelType, k)
					return;
				end
			end
		end
	end
end

-- Remove a team from MM and disable timers if none left in queue.
function cwDueling:TeamExitsMatchmaking(team)
    if team and team.partyIDs then
        for duelTypeKey, duelType in pairs(cwDueling.playersInMatchmaking) do
            local teamsToRemove = {}
            for teamKey, p in ipairs(duelType) do
                for k,id in pairs(team.partyIDs) do
                    if id == p.ID then
                        table.insert(teamsToRemove, teamKey)
                    end
                end
            end

            -- Remove the identified teams in reverse order
            for i = #teamsToRemove, 1, -1 do
                local removeKey = teamsToRemove[i]
                table.remove(duelType, removeKey)
            end
        end
    end

	if duelTypeKey == 7 then
		if next(cwDueling.playersInMatchmaking[7]) == nil then -- take off timers if no players left
			if timer.Exists("ThrallCountdownPartial") then
				timer.Remove("ThrallCountdownPartial")
			end
	
			if timer.Exists("ThrallCountdownFull") then
				timer.Remove("ThrallCountdownFull")
			end

			ThralltimerStarted = false
		end
	elseif duelTypeKey == 6 then
		if next(cwDueling.playersInMatchmaking[6]) == nil then -- take off timers if no players left
			if timer.Exists("FFACountdownPartial") then
				timer.Remove("FFACountdownPartial")
			end
	
			if timer.Exists("FFACountdownFull") then
				timer.Remove("FFACountdownFull")
			end

			FFAtimerStarted = false
		end
	elseif duelTypeKey == 8 then
		if next(cwDueling.playersInMatchmaking[8]) == nil then
			if timer.Exists("CTFCountdownPartial") then
				timer.Remove("CTFCountdownPartial")
			end

			if timer.Exists("CTFCountdownFull") then
				timer.Remove("CTFCountdownFull")
			end
			CTFtimerStarted = false
		end
	end
end

-- Setup a duel
function cwDueling:SetupDuel(team1, team2, availableArenas, duelType)
    if not map or #availableArenas == 0 then
        return
    end

    local random_arena = availableArenas[math.random(1, #availableArenas)]
    local availablePos1 = {}
    local availablePos2 = {}
	DUELING_ARENAS[random_arena].duelingTeam1 = team1
    DUELING_ARENAS[random_arena].duelingTeam2 = team2
	DUELING_ARENAS[random_arena].duelType = "TDM";

    for _, v in ipairs(DUELING_ARENAS[random_arena].spawnPositions1) do
        table.insert(availablePos1, Vector(v.x, v.y, v.z))
    end
    for _, v in ipairs(DUELING_ARENAS[random_arena].spawnPositions2) do
        table.insert(availablePos2, Vector(v.x, v.y, v.z))
    end
	
	for i=1, #team1.players do
		cwDueling:InitPlayer(team1.players[i], team2, team1.ID, random_arena, duelType)
	end

	for i=1, #team2.players do
		cwDueling:InitPlayer(team2.players[i], team1, team2.ID, random_arena, duelType)
	end

	-- after 5 seconds goes by, check if all p=layers are alive/valid, if so, put them into MM.. if not duel abort, later we can re-add them to mm
	timer.Simple(5, function()
		local allValid = true;
		for _,v in pairs(team1.players) do
			if not IsValid(v) or not v:Alive() then
				allValid = false;
			end
		end
		for _,v in pairs(team2.players) do
			if not IsValid(v) or not v:Alive() then
				allValid = false;
			end
		end

		if allValid then
			for i=1, #team1.players do
				local pos = table.remove(availablePos1, math.random(1, #availablePos1))
				cwDueling:SetupPlayer(team1.players[i], pos, DUELING_ARENAS[random_arena].spawnAngles1)
			end
		
			for i=1, #team2.players do
				local pos = table.remove(availablePos2, math.random(1, #availablePos2))
				cwDueling:SetupPlayer(team2.players[i], pos, DUELING_ARENAS[random_arena].spawnAngles2)
			end

			timer.Create("DuelTimer_" .. random_arena, DUELING_ARENAS[random_arena].timeLimit, 1, function()
				if IsValid(team) then
					self:DuelAborted(team, team2, random_arena) -- this might introduce a bug
				end
			end)	
		else
			DUELING_ARENAS[random_arena].duelType = nil;
			for i=1, #team1.players do
				if IsValid(team1.players[i]) then
					cwDueling:PlayerResetAbort(team1)
				end
			end
			for i=1, #team2.players do
				if IsValid(team2.players[i]) then
					cwDueling:PlayerResetAbort(team2)
				end
			end
		end
	end)
end

-- Award a ctf point to a team in an arena, if points > 2 after then the CTF is completed
function cwDueling:AwardPointCTF(winnerTID, plyDuelArena)
	local winner, loser;

	if winnerTID == DUELING_ARENAS[plyDuelArena].duelingTeam1.ID then
		DUELING_ARENAS[plyDuelArena].CTFPoints[1] = DUELING_ARENAS[plyDuelArena].CTFPoints[1] + 1;
		winner = DUELING_ARENAS[plyDuelArena].duelingTeam1
		loser = DUELING_ARENAS[plyDuelArena].duelingTeam2
		Schema:EasyText(winner.players, "Your team scored! " .. DUELING_ARENAS[plyDuelArena].CTFPoints[1] .. "/2");
		Schema:EasyText(loser.players, "Enemy team scored! " .. DUELING_ARENAS[plyDuelArena].CTFPoints[1] .. "/2");
	elseif winnerTID == DUELING_ARENAS[plyDuelArena].duelingTeam2.ID then
		DUELING_ARENAS[plyDuelArena].CTFPoints[2] = DUELING_ARENAS[plyDuelArena].CTFPoints[2] + 1;
		winner = DUELING_ARENAS[plyDuelArena].duelingTeam2
		loser = DUELING_ARENAS[plyDuelArena].duelingTeam1
		Schema:EasyText(winner.players, "Your team scored! " .. DUELING_ARENAS[plyDuelArena].CTFPoints[2] .. "/2");
		Schema:EasyText(loser.players, "Enemy team scored! " .. DUELING_ARENAS[plyDuelArena].CTFPoints[2] .. "/2");
	end

	if DUELING_ARENAS[plyDuelArena].CTFPoints[1] >= 2 or DUELING_ARENAS[plyDuelArena].CTFPoints[2] >= 2 then
		cwDueling:CTFCompleted(winner, loser, plyDuelArena);
	end
end

-- Respawn a dead team
function cwDueling:CTFRespawnDeadTeam(teamID, arenaID)
	local team;
	if arenaID and DUELING_ARENAS[arenaID] then
		local availablePos = {};
		local angle;

		if DUELING_ARENAS[arenaID].duelingTeam1.ID == teamID then
			team = DUELING_ARENAS[arenaID].duelingTeam1;
			for _, v in ipairs(DUELING_ARENAS[arenaID].spawnPositions1) do
				table.insert(availablePos, Vector(v.x, v.y, v.z))
			end
			angle = DUELING_ARENAS[arenaID].spawnAngles1;

		elseif DUELING_ARENAS[arenaID].duelingTeam2.ID == teamID then
			team = DUELING_ARENAS[arenaID].duelingTeam2;
			for _, v in ipairs(DUELING_ARENAS[arenaID].spawnPositions2) do
				table.insert(availablePos, Vector(v.x, v.y, v.z))
			end
			angle = DUELING_ARENAS[arenaID].spawnAngles2;
		end
		for _,v in pairs(team.players) do
			if IsValid(v) and not v:Alive() then
				local pos = table.remove(availablePos, math.random(1, #availablePos))
				cwDueling:CTFRespawnPlayer(v, pos, angle, arenaID)
			end
		end
	end
end

-- Respawn a dead player
function cwDueling:CTFRespawnPlayer(player, pos, angle, arenaID)
	if IsValid(player) then
		player:Freeze(false);
		player:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255 ), 1, 0);

		if player:GetMoveType(player) == MOVETYPE_NOCLIP then -- prob not needed for ctf cuz no spectate?
			cwObserverMode:MakePlayerExitObserverMode(player);
		end	
		local max_stamina = player:GetMaxStamina();
		local max_stability = player:GetMaxStability();

		
		timer.Simple(0.1, function()
			if IsValid(player) then
				Schema:EasyText(player, "Respawning.");
				player:Spawn();
				player:SetPos(pos);
				player:SetEyeAngles(angle);

				player:SetCharacterData("Stamina", max_stamina);
				player:SetNWInt("Stamina", max_stamina);
				player:SetCharacterData("stability", max_stability);
				player:SetNWInt("stability", max_stability);
				Clockwork.limb:RestoreLimbsFromCache(player);
				Clockwork.limb:HealBody(player, 100);
				player:ResetInjuries();
			end
		end);
			
		if player.distortedRingFired then
			player.distortedRingFired = nil;
		end
		
		if player:GetCharacterData("Hatred") then -- reset hate to 0
			player:SetLocalVar("Hatred", 0);
		end
	end
end

-- Add a flag to a duelArena's .flags variable
function cwDueling:CTFAddFlag(duelArena, flag)
	if duelArena and DUELING_ARENAS[duelArena] and DUELING_ARENAS[duelArena].flags ~= nil then
		DUELING_ARENAS[duelArena].flags[flag] = flag;
	end
end

-- Remove a flag from duelArena's .flags variable
function cwDueling:CTFRemoveFlag(duelArena, flag)
	if DUELING_ARENAS[duelArena].flags ~= nil and DUELING_ARENAS[duelArena].flags[flag] ~= nil then
		DUELING_ARENAS[duelArena].flags[flag] = nil;
	end
	flag:Remove();
end

-- Remove all flags from duelArena's .flags variable
function cwDueling:CTFRemoveFlags(duelArena)
	for k,v in pairs(DUELING_ARENAS[duelArena].flags) do 
		v:Remove();
		DUELING_ARENAS[duelArena].flags[k] = nil;
	end

	for _,team in ipairs({DUELING_ARENAS[duelArena].duelingTeam1, DUELING_ARENAS[duelArena].duelingTeam2}) do
		for k,v in pairs(team.players) do
			local carryingFlag = v:GetSharedVar("DuelCarryingFlag")
			if carryingFlag then
				hook.Remove("PlayerSwitchWeapon", "DropFlagOnSwitch" .. v:GetName())
				v:StripWeapon("begotten_polearm_glazicbanner")
				v:SetSharedVar("DuelCarryingFlag", false);
				v:SetSharedVar("DuelFlagOrigin", nil)
			end
		end
	end
end

function cwDueling:CTFCompleted(winner, loser, duelArena)
	if timer.Exists("DuelCTFRespawn" .. winner.ID) then
		timer.Remove("DuelCTFRespawn" .. winner.ID)
	end
	if timer.Exists("DuelCTFRespawn" .. loser.ID) then
		timer.Remove("DuelCTFRespawn" .. loser.ID)
	end
	cwDueling:RagdollRemove(DUELING_ARENAS[duelArena])
	DUELING_ARENAS[duelArena].duelType = nil;
		
	if winner ~= nil and loser ~= nil then
		local duelType = winner.players[1]:GetSharedVar("duelType")
		for k, v in pairs(DUELING_ARENAS) do
			if (v.duelingTeam1 == winner or v.duelingTeam2 == winner) and (v.duelingTeam1 == loser or v.duelingTeam2 == loser) then
				-- Set winner/loser sql data
				for i = 1, #winner.players do
					cwDueling:UpdateCharWins(winner.players[i], 8)
				end
				
				for i = 1, #loser.players do
					cwDueling:UpdateCharLosses(loser.players[i], 8)
				end

				-- Delete any leftover flags
				cwDueling:CTFRemoveFlags(k)
				DUELING_ARENAS[k].duelingTeam1 = {};
				DUELING_ARENAS[k].duelingTeam2 = {};
				DUELING_ARENAS[k].CTFPoints = {0,0};
				

				-- Delete the two flagzones
				for _,v in pairs(DUELING_ARENAS[k].flagZones) do
					v:Remove();
				end
				DUELING_ARENAS[k].flagZones = {};

					
				if timer.Exists("DuelTimer_"..k) then
					timer.Remove("DuelTimer_"..k)
				end

				for _, team in ipairs({winner.players, loser.players}) do
					for i = 1, #team do
						cwDueling:restoreAbortedCharacter(team[i])
					end
				end	
				cwDueling:SendScoreboard(winner, loser, duelType)
				break;
			end
			
		end
	end
end

-- instead of canceling between 2 players, cancel 2 teams
function cwDueling:CTFAborted(team1, team2, duelArena)
	local v = DUELING_ARENAS[duelArena];
	cwDueling:RagdollRemove(DUELING_ARENAS[duelArena])
	-- remove respawn timers
	if timer.Exists("DuelCTFRespawn" .. team1.ID) then
		timer.Remove("DuelCTFRespawn" .. team1.ID)
	end
	if timer.Exists("DuelCTFRespawn" .. team2.ID) then
		timer.Remove("DuelCTFRespawn" .. team2.ID)
	end
	
	if #team1.players > 0 and #team2.players > 0 then
		if (v.duelingTeam1 == team1 or v.duelingTeam2 == team1) and (v.duelingTeam1 == team2 or v.duelingTeam2 == team2) then
			-- There was probably a tie or something.
			DUELING_ARENAS[duelArena].duelingTeam1 = {};
			DUELING_ARENAS[duelArena].duelingTeam2 = {};
			
			if timer.Exists("DuelTimer_"..duelArena) then
				timer.Remove("DuelTimer_"..duelArena)
			end
		
			
			for _, team in ipairs({team1, team2}) do
				for i = 1, #team do
					cwDueling:restoreAbortedCharacter(team[i])
					Schema:EasyText({team[i]}, "icon16/shield.png", "orange", "Draw!");
				end
			end			
		end
	elseif #team1.players > 0 then
		if v.duelingTeam1 == team1 or v.duelingTeam2 == team1 then
			-- team2 dropped
			for k, v in pairs (_player.GetAll()) do
				if v:IsAdmin() then
					Schema:EasyText(v, "orangered","[DUELLING] Team: "..team.." dropped from an in progress duel.");
				end;
			end;
			DUELING_ARENAS[duelArena].duelingTeam1 = {};
			DUELING_ARENAS[duelArena].duelingTeam2 = {};
			
			if timer.Exists("DuelTimer_"..duelArena) then
				timer.Remove("DuelTimer_"..duelArena)
			end

			for i = 1, #team1 do
				cwDueling:restoreAbortedCharacter(team1[i])
				Schema:EasyText({team1[i]}, "icon16/shield.png", "orange", "You win (JK) !");
			end
			
		end
	elseif #team2.players > 0 then 
		if v.duelingTeam1 == team2 or v.duelingTeam2 == team2 then
			-- team1 dropped
			for k, v in pairs (_player.GetAll()) do
				if v:IsAdmin() then
					Schema:EasyText(v, "orangered","[DUELLING] Team: "..team.." dropped from an in progress duel.");
				end;
			end;
			DUELING_ARENAS[duelArena].duelingTeam1 = {};
			DUELING_ARENAS[duelArena].duelingTeam2 = {};
			
			if timer.Exists("DuelTimer_"..duelArena) then
				timer.Remove("DuelTimer_"..duelArena)
			end

			for i = 1, #team2 do
				cwDueling:restoreAbortedCharacter(team2[i])
				Schema:EasyText({team2[i]}, "icon16/shield.png", "orange", "You win (JK) !");
			end
		end
	end
end

-- Setup a CTF
function cwDueling:SetupCTF(team1, team2, availableArenas)
    if not map or #availableArenas == 0 then
        return
    end

    local random_arena = availableArenas[math.random(1, #availableArenas)]
    local availablePos1 = {}
    local availablePos2 = {}
	DUELING_ARENAS[random_arena].duelingTeam1 = team1
    DUELING_ARENAS[random_arena].duelingTeam2 = team2
	DUELING_ARENAS[random_arena].duelType = "CTF";

    for _, v in ipairs(DUELING_ARENAS[random_arena].spawnPositions1) do
        table.insert(availablePos1, Vector(v.x, v.y, v.z))
    end

    for _, v in ipairs(DUELING_ARENAS[random_arena].spawnPositions2) do
        table.insert(availablePos2, Vector(v.x, v.y, v.z))
    end

	for i=1, #team2.players do
		cwDueling:InitPlayer(team1.players[i], team2, team1.ID, random_arena, "CTF")
	end

	for i=1, #team2.players do
		cwDueling:InitPlayer(team2.players[i], team1, team2.ID, random_arena, "CTF")
	end

	-- after 5 seconds goes by, check if all p=layers are alive/valid, if so, put them into MM.. if not duel abort, later we can re-add them to mm
	timer.Simple(5, function()
		local allValid = true;
		for _,v in pairs(team1.players) do
			if not IsValid(v) or not v:Alive() then
				allValid = false;
			end
		end
		for _,v in pairs(team2.players) do
			if not IsValid(v) or not v:Alive() then
				allValid = false;
			end
		end

		if allValid then

			for i=1, #team1.players do
				local pos = table.remove(availablePos1, math.random(1, #availablePos1))
				cwDueling:SetupPlayer(team1.players[i], pos, DUELING_ARENAS[random_arena].spawnAngles1)
			end
		
			for i=1, #team2.players do
				local pos = table.remove(availablePos2, math.random(1, #availablePos2))
				cwDueling:SetupPlayer(team2.players[i], pos, DUELING_ARENAS[random_arena].spawnAngles2)
			end

			timer.Create("DuelTimer_" .. random_arena, DUELING_ARENAS[random_arena].timeLimit, 1, function()
				if IsValid(team) then
					self:CTFAborted(team, team2)
				end
			end)

			-- put down flagzones, init team1 to contain no flag
			-- init team2 to contain a flag
			local team1FlagZone = ents.Create("cw_flagzone");
			team1FlagZone:SetPos(DUELING_ARENAS[random_arena].CTFFlagPositions[1]);
			team1FlagZone:SetAngles(DUELING_ARENAS[random_arena].CTFFlagAngles[1]);
			team1FlagZone.type = 1;
			team1FlagZone.duelArena = random_arena;
			team1FlagZone.teamID = team1.ID;
			team1FlagZone:Spawn();

			local team2FlagZone = ents.Create("cw_flagzone");
			team2FlagZone:SetPos(DUELING_ARENAS[random_arena].CTFFlagPositions[2]);
			team2FlagZone:SetAngles(DUELING_ARENAS[random_arena].CTFFlagAngles[2]);
			team2FlagZone.type = 1;
			team2FlagZone.duelArena = random_arena;
			team2FlagZone.teamID = team2.ID;
			team2FlagZone:Spawn();
			
			DUELING_ARENAS[random_arena].CTFPoints = {0,0};
			DUELING_ARENAS[random_arena].flagZones = {team1FlagZone, team2FlagZone};
		else
			DUELING_ARENAS[random_arena].duelType = nil;
			for i=1, #team1.players do
				if IsValid(team1.players[i]) then
					cwDueling:PlayerResetAbort(team1)
				end
			end
			for i=1, #team2.players do
				if IsValid(team2.players[i]) then
					cwDueling:PlayerResetAbort(team2)
				end
			end
		end
	end)
end

-- Setup a FFA
function cwDueling:SetupFFA(players, availableArenas)
    if not map or #availableArenas == 0 then
        return
    end

    local random_arena = availableArenas[math.random(1, #availableArenas)]
    local availablePos = {}
	DUELING_ARENAS[random_arena].duelingFFAPlayers = players
	DUELING_ARENAS[random_arena].duelType = "FFA";

    for _, v in ipairs(DUELING_ARENAS[random_arena].spawnPositionsFFA) do
        table.insert(availablePos, Vector(v.x, v.y, v.z))
    end
	
	for i=1, #players do
		cwDueling:InitPlayer(players[i].players[1], {"temp"}, players[i].ID, random_arena, "FFA")
	end

	local spawnPosA = table.Copy(DUELING_ARENAS[random_arena].spawnPositionsFFA)
	local spawnAnglesA = table.Copy(DUELING_ARENAS[random_arena].spawnAnglesFFA)

	-- Check if all players are not dead & not busy, if so put them into the duel. TODO: Add other players back to MM
	timer.Simple(5, function()
		local allValid = true;
		for _,v in pairs(players) do
			if not IsValid(v.players[1]) or not v.players[1]:Alive() then
				allValid = false;
			end
		end

		if allValid then
			for i=1, #players do
				local pos = table.remove(spawnPosA, math.random(1, #spawnPosA))
				local ang = table.remove(spawnAnglesA, math.random(1, #spawnAnglesA))
				cwDueling:SetupPlayer(players[i].players[1], pos, ang)
			end

			timer.Create("DuelTimer_" .. random_arena, DUELING_ARENAS[random_arena].timeLimit, 1, function()
				if IsValid(team) then
					self:FFAAborted(playerList, random_arena) -- this might introduce a bug
				end
			end)
		else
			DUELING_ARENAS[random_arena].duelingFFAPlayers = {}
			DUELING_ARENAS[random_arena].duelType = nil;
			for i=1, #players do
				if IsValid(players[i].players[1]) then
					cwDueling:PlayerResetAbort(players[i])
				end
			end
		end
	end)
end

-- Reset variables belonging to a player when a duel is aborted
function cwDueling:PlayerResetAbort(team)
	Schema:EasyText(team.players[i], "icon16/shield_go.png", "orangered", "Duel Aborted!")
	team.players[i]:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 5, 0)
	team.players[i].opponent = nil
	team.players[i]:SetSharedVar("teamID", nil)
	team.players[i]:SetSharedVar("duelType", nil)
	Clockwork.datastream:Start(team.players[i], "SetPlayerDueling", false)
end

-- Init vars for a player getting ready to enter a duel
function cwDueling:InitPlayer(player, opponent, tid, arenaID, duelType)
	Schema:EasyText(player, "icon16/shield_go.png", "forestgreen", "Duel Found!")
	player:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255), 4, 1.2)
	Clockwork.datastream:Start(player, "FadeAmbientMusic")
	player.opponent = opponent
	player:SetSharedVar("teamID", tid)
	player:SetSharedVar("duelArena", arenaID)
	player:SetSharedVar("duelType", duelType)
	player:SetSharedVar("duelKills", 0)
	player:SetSharedVar("duelDamageDone", 0)
	
	player:SetSharedVar("dueling", true)
	
	if duelType == "TDM" then
		player:SetSharedVar("duelFriendlyFires", 0)
	elseif duelType == "CTF" then
		player:SetSharedVar("duelCarryingFlag", 0)
		player:SetSharedVar("DuelCarryingFlag", false);
		player:SetSharedVar("DuelFlagOrigin", nil)
		player:SetSharedVar("duelFlagCaps", 0)
		player:SetSharedVar("duelFlagDefs", 0)
	end

	if cwSpawnSaver then
		cwSpawnSaver:PrePlayerCharacterUnloaded(player)
	end
end

-- local pos = table.remove(spawnPos, math.random(1, #spawnPos))
-- Setup a player for a duel
function cwDueling:SetupPlayer(player, spawnPos, spawnAngles)
	Clockwork.datastream:Start(player, "SetPlayerDueling", true)
	Clockwork.limb:CacheLimbs(player, true)
	player:Spawn()
	player:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 5, 0)
	player:SetPos(spawnPos)
	player:SetEyeAngles(spawnAngles)
	player:SetHealth(player:GetMaxHealth())

	if player:GetLocalVar("Hatred") then
		player:SetLocalVar("Hatred", 0)
	end

	player.duelStatue = nil

	timer.Simple(5, function()
		Clockwork.datastream:Start(player, "StartBattleMusicNoLimit")
	end)
	
	hook.Run("PlayerEnteredDuel", player)
end


-- Waves where an additional spawner is added, depending on the index (Amount of players)
local ThrallWaveSpawners = {3,5,6,7};

-- Difficulty of thralls to spawn from [1] - Easy to [5] - IMPOSSIBLE
local THRALL_DIFFLEVELS = { 
	{"npc_bgt_another", "npc_bgt_shambler", "npc_bgt_brute"},
	{"npc_bgt_grunt", "npc_bgt_chaser", "npc_bgt_pursuer"},
	{"npc_bgt_eddie", "npc_bgt_coinsucker", "npc_bgt_guardian"},
	{"npc_bgt_suitor", "npc_bgt_ironclad", "npc_bgt_otis"},
	{"npc_bgt_giant"}
}

-- Thrall difficulty wave info
local THRALL_WAVEINFO = { 
	{{{diff = 1, kill = 3}, {diff = 2, kill = 0}, {diff = 3, kill = 0}, {diff = 4, kill = 0}, {diff = 5, kill = 0}}, speed = 12},	-- 1
	{{{diff = 1, kill = 4}, {diff = 2, kill = 1}, {diff = 3, kill = 0}, {diff = 4, kill = 0}, {diff = 5, kill = 0}}, speed = 10},	-- 2
	{{{diff = 1, kill = 5}, {diff = 2, kill = 2}, {diff = 3, kill = 0}, {diff = 4, kill = 0}, {diff = 5, kill = 0}}, speed = 9},	-- 3
	{{{diff = 1, kill = 3}, {diff = 2, kill = 3}, {diff = 3, kill = 0}, {diff = 4, kill = 0}, {diff = 5, kill = 0}}, speed = 12},	-- 4
	{{{diff = 1, kill = 4}, {diff = 2, kill = 2}, {diff = 3, kill = 1}, {diff = 4, kill = 0}, {diff = 5, kill = 0}}, speed = 7},	-- 5
	{{{diff = 1, kill = 4}, {diff = 2, kill = 2}, {diff = 3, kill = 2}, {diff = 4, kill = 1}, {diff = 5, kill = 0}}, speed = 10},	-- 6
	{{{diff = 1, kill = 5}, {diff = 2, kill = 3}, {diff = 3, kill = 4}, {diff = 4, kill = 2}, {diff = 5, kill = 0}}, speed = 9},	-- 7
	{{{diff = 1, kill = 3}, {diff = 2, kill = 3}, {diff = 3, kill = 6}, {diff = 4, kill = 3}, {diff = 5, kill = 0}}, speed = 8},	-- 8
	{{{diff = 1, kill = 2}, {diff = 2, kill = 2}, {diff = 3, kill = 5}, {diff = 4, kill = 4}, {diff = 5, kill = 0}}, speed = 9},	-- 9
	{{{diff = 1, kill = 2}, {diff = 2, kill = 3}, {diff = 3, kill = 5}, {diff = 4, kill = 3}, {diff = 5, kill = 0}}, speed = 8},	-- 10
	{{{diff = 1, kill = 1}, {diff = 2, kill = 5}, {diff = 3, kill = 6}, {diff = 4, kill = 5}, {diff = 5, kill = 0}}, speed = 7},	-- 11
	{{{diff = 1, kill = 2}, {diff = 2, kill = 0}, {diff = 3, kill = 0}, {diff = 4, kill = 0}, {diff = 5, kill = 1}}, speed = 7},	-- 12
	{{{diff = 1, kill = 1}, {diff = 2, kill = 0}, {diff = 3, kill = 0}, {diff = 4, kill = 0}, {diff = 5, kill = 0}}, speed = 7}		-- 13
}

-- Gather players into a team and return it
function cwDueling:BuildThrallLobby()
	local availableParties = {};
	local size = thrallMaxPlayers;
	local team1 = { size = 0, partyIDs = {}, players = {}, id = ""}
	for e, v in ipairs(cwDueling.playersInMatchmaking[7]) do
		table.insert(availableParties, v);
	end

	for _, party in ipairs(availableParties) do
		if team1.partyIDs[party.ID] == nil then
			if team1.size + party.size <= size then
				team1.size = team1.size + party.size
				team1.partyIDs[party.ID] = party.ID
				copyPlayers(team1, party)
			end
		end
		if team1.size == size then
			break
		end
	end 

	team1.ID = os.time() .. "_" .. math.random(1000, 9999)
	return team1
end

-- Gather available arenas + teams, and SetupThrall match if matches are found
function cwDueling:SetupThrallLobby()
	local teams = cwDueling:BuildThrallLobby();

	if teams ~= nil then
		if cwDueling:TeamReadyCheck(teams) then
			local availableArenas = cwDueling:FindArenaMaps("Thralls")
			if (#availableArenas ~= 0) then 
				cwDueling:TeamExitsMatchmaking(teams)
				self:SetupThrall(teams, availableArenas);
			end
		end
	end
end

-- Set up a thrall arena
function cwDueling:SetupThrall(team, availableArenas)
	if not map or #availableArenas == 0 then
		return
	end

	local random_arena = availableArenas[math.random(1, #availableArenas)]
	local spawnPosA = table.Copy(DUELING_ARENAS[random_arena].spawnPositionsThPlayers)
	local spawnAnglesA = table.Copy(DUELING_ARENAS[random_arena].spawnAnglesThPlayers)
	DUELING_ARENAS[random_arena].thrallParties = team
	DUELING_ARENAS[random_arena].state = 1;
	DUELING_ARENAS[random_arena].duelType = "Thralls";

	for i=1, #team.players do
		cwDueling:InitPlayer(team.players[i], {"temp"}, team.ID, random_arena, "Thralls")
	end

	-- After 5 seconds, if all players are alive/connected then start a thrall arena
	timer.Simple(5, function()
		local allValid = true;
		for _,v in pairs(team.players) do
			if not IsValid(v) or not v:Alive() then
				allValid = false;
			end
		end
		if allValid then
			
			for i=1, #team.players do
				local pos = table.remove(spawnPosA, math.random(1, #spawnPosA))
				local ang = table.remove(spawnAnglesA, math.random(1, #spawnAnglesA))
				cwDueling:SetupPlayer(team.players[i], pos, ang)
			end
			cwDueling:ThrallMatchStart(random_arena)
		else
			DUELING_ARENAS[random_arena].state = 0;
			DUELING_ARENAS[random_arena].thrallParties = {}
			DUELING_ARENAS[random_arena].duelType = nil;
			for _,v in pairs(team.players) do
				if IsValid(v) then
					cwDueling:PlayerResetAbort(team)
				end
			end
		end
	end)
end

-- Create/init a new thrall arena and begin the match
function cwDueling:ThrallMatchStart(arenaID)
	hook.Add("OnNPCKilled", "ThrallKilled_" .. arenaID, function(victim, inflictor, attacker)
		-- table.insert(cwDueling.THRALL_ARENAS[arenaID].thralls, npc)
		for _,npc in pairs(cwDueling.THRALL_ARENAS[arenaID].thralls) do 
			if IsValid(victim) and victim == npc then
				cwDueling:OnThrallKilled(arenaID, npc, inflictor)
				break;
			end
		end
	end)

	DUELING_ARENAS[arenaID].state = 1;
	local colPlayers = {}
	local thrallsLeft = 0;
	for _,play in pairs(DUELING_ARENAS[arenaID].thrallParties.players) do
		table.insert(colPlayers, play)
	end

	cwDueling.THRALL_ARENAS[arenaID] = {arenaID = arenaID, players = colPlayers, thralls = {}, wave = 0, thrallsToSummon = {}, thrallsLeft = {}, intermission = false, spawners = #colPlayers;};
	cwDueling.THRALL_ARENAS[arenaID].thrallsToSummon = table.Copy(THRALL_WAVEINFO[1][1]);
	cwDueling.THRALL_ARENAS[arenaID].thrallsLeft = table.Copy(THRALL_WAVEINFO[1][1]);

	for _,v in pairs(cwDueling.THRALL_ARENAS[arenaID].thrallsToSummon) do
		v.kill = v.kill * #colPlayers
	end
	for _,v in pairs(cwDueling.THRALL_ARENAS[arenaID].thrallsLeft) do
		v.kill = v.kill * #colPlayers
	end
	for _,v in pairs(cwDueling.THRALL_ARENAS[arenaID].thrallsLeft) do
		thrallsLeft = thrallsLeft + v.kill;
	end
	Schema:EasyText(colPlayers, "orange", "Wave 1 begins in 5 seconds! You have to kill " .. thrallsLeft ..  " thralls!");

	timer.Simple(5, function()
		if cwDueling.THRALL_ARENAS[arenaID] ~= nil then
			cwDueling.THRALL_ARENAS[arenaID].wave = 1;
		end
	end)
end

-- Check if a list of entities contains any filtered ent types {players, NPCs, non-observers}
function CheckValidLocation(ents)
	for _, entity in pairs(ents) do
		if entity:IsPlayer() or (entity:IsNPC() and not entity:IsFlagSet(FL_NOTARGET)) then
			return false;
		end
	end
	return true;
end

-- Spawn a thrall at diff level in arenaID
function cwDueling:SpawnThrall(arenaID, diff)
	local thrallsLeft = false;

	if cwDueling.THRALL_ARENAS[arenaID] ~= nil then
		for _,v in pairs(cwDueling.THRALL_ARENAS[arenaID].thrallsToSummon) do
			if v.kill > 0 then 
				thrallsLeft = true
			end
		end
		if thrallsLeft then
			local npcType = THRALL_DIFFLEVELS[diff][math.random(1, #THRALL_DIFFLEVELS[diff])]
			local npc =  ents.Create(npcType)

			if IsValid(npc) then
				-- check if the spawn point I'm spawning in is clear of other entities like another npc/player so I don't get stuck in them when I spawn the npc
				local destination = nil;
				local foundOne = false;
				local maxTries = 10;
				local tries = 0;

				repeat
					tries = tries + 1;
					destination = DUELING_ARENAS[arenaID].thrallSpawnPoints[math.random(1, #DUELING_ARENAS[arenaID].thrallSpawnPoints)]
					local entities = ents.FindInSphere(destination[1], 50)

					if CheckValidLocation(entities) then
						if destination[2] == false then
							destination[2] = true;
							foundOne = true;
							timer.Simple(3, function()
								destination[2] = false; 
							end)
							break;
						end
					end

					if tries > maxTries then
						break
					end
				until false;

				if not foundOne then
					destination = DUELING_ARENAS[arenaID].thrallSpawnPoints[math.random(1,10)]
				end
				local spawnDelay = math.Rand(1, 2);
				sound.Play("begotten/npc/tele2_fadeout2.ogg", destination[1], 80, math.random(95, 105));
				timer.Simple(spawnDelay, function()
					ParticleEffect("teleport_fx", destination[1], Angle(0,0,0));
					sound.Play("misc/summon.wav", destination[1], 100, 100);
					
					timer.Simple(0.2, function()
						local flash = ents.Create("light_dynamic")
						flash:SetKeyValue("brightness", "2")
						flash:SetKeyValue("distance", "256")
						flash:SetPos(destination[1] + Vector(0, 0, 8));
						flash:Fire("Color", "255 100 0")
						flash:Spawn()
						flash:Activate()
						flash:Fire("TurnOn", "", 0)
						timer.Simple(0.5, function() if IsValid(flash) then flash:Remove() end end)
						
						util.ScreenShake(destination[1], 10, 100, 0.4, 1000, true);
					end);
			
					timer.Simple(0.75, function()
						if IsValid(npc) and cwDueling.THRALL_ARENAS[arenaID] ~= nil then
							if npc.CustomInitialize then
								npc:CustomInitialize();
							end
							
							npc:SetPos(destination[1] + Vector(0, 0, 16));
							npc:Spawn();
							npc:Activate();
							table.insert(cwDueling.THRALL_ARENAS[arenaID].thralls, npc)
						end
					end);
				end);
			end
		end
	end
end

-- Called when a thrall is killed in an arena, subtracts from kill count
function cwDueling:OnThrallKilled(arenaID, thrall, killer)
	local killerName = killer:GetName();

	if cwDueling.THRALL_ARENAS[arenaID] ~= nil then
		for j = #cwDueling.THRALL_ARENAS[arenaID].thralls, 1, -1 do
			local storedThrall = cwDueling.THRALL_ARENAS[arenaID].thralls[j]
			if storedThrall == thrall then
				-- Get the difficulty index of the killed thrall
				local difficultyIndex = 1  
				for diffIndex, diffLevel in ipairs(THRALL_DIFFLEVELS) do
					if table.HasValue(diffLevel, thrall:GetClass()) then
						difficultyIndex = diffIndex
						break
					end
				end

				-- Subtract a kill from thrallsLeft for the corresponding difficulty level
				local killsLeftForDifficulty = cwDueling.THRALL_ARENAS[arenaID].thrallsLeft[difficultyIndex].kill
				if killsLeftForDifficulty and killsLeftForDifficulty > 0 then
					cwDueling.THRALL_ARENAS[arenaID].thrallsLeft[difficultyIndex].kill = killsLeftForDifficulty - 1
				end
				local thrallsLeft = 0;
				for _,v in pairs(cwDueling.THRALL_ARENAS[arenaID].thrallsLeft) do
					thrallsLeft = thrallsLeft + v.kill;
				end
				
				Schema:EasyText(cwDueling.THRALL_ARENAS[arenaID].players, "orange", killerName .. " killed a thrall! There are " .. thrallsLeft .. " left!!");
				table.remove(cwDueling.THRALL_ARENAS[arenaID].thralls, j)
				break
			end
		end
	end
end

-- Called when a thrall arena with arenaID is completed, dead bool for victory/lost
function cwDueling:ThrallCompleted(arenaID, dead)
	cwDueling:RagdollRemove(cwDueling.THRALL_ARENAS[arenaID])
	DUELING_ARENAS[arenaID].duelType = nil;
	hook.Remove("OnNPCKilled", "ThrallKilled_" .. arenaID);

	if arenaID ~= nil and cwDueling.THRALL_ARENAS[arenaID] ~= nil then
		local players = cwDueling.THRALL_ARENAS[arenaID].players

		for _, p in ipairs(players) do
			cwDueling:restoreAbortedCharacter(p)
		end

		if not dead then
			result = "win";
			col = "forestgreen";
		else
			result = "lose";
			col = "orange"
		end
		Schema:EasyText(players, "icon16/shield_add.png", col, "Game over you " .. result .. "! You made it to wave " .. cwDueling.THRALL_ARENAS[arenaID].wave .. ".");

		for i = 1, #players do
			cwDueling:UpdateCharThrallProg(players[i], arenaID)
		end
		
		local thralls = cwDueling.THRALL_ARENAS[arenaID].thralls
		for i = #thralls, 1, -1 do
			local npc = thralls[i]
			if IsValid(npc) then
				
				timer.Simple(1, function()
					local damageInfo = DamageInfo()
					damageInfo:SetDamage(9999)  -- Adjust the damage value as needed
					damageInfo:SetAttacker(game.GetWorld())
					if IsValid(npc) then
						npc:TakeDamageInfo(damageInfo)
					end
					table.remove(thralls, i);
				end);
				
			else
				table.remove(thralls, i) 
			end
		end

		DUELING_ARENAS[arenaID].state = 0;
		cwDueling.THRALL_ARENAS[arenaID] = nil
	end
end

-- Called in think(), check for wave victory condition, wave healing, thrall spawning, and wave progression.
function cwDueling:ThrallCheck()
	for arenaID, arena in pairs(cwDueling.THRALL_ARENAS) do
		if arena.wave > 0 and arena.wave ~= thrallEndWave then
			local delay = THRALL_WAVEINFO[arena.wave].speed
			local thrallsLeft = 0
			for _, v in pairs(arena.thrallsLeft) do
				thrallsLeft = thrallsLeft + v.kill
			end

			if thrallsLeft <= 0 then
				arena.wave = arena.wave + 1
				if arena.wave % thrallHealWaveDiv == 0 then -- heal every 4 waves
					for _,v in pairs(arena.players) do
						if IsValid(v) and v:Alive() then
							Schema:EasyText(v, "green", "Your health has been restored.")
							v:SetHealth(v:GetMaxHealth() or 100);
						end
					end
				end

				if arena.wave == ThrallWaveSpawners[#arena.players] then
					arena.spawners = arena.spawners + 1;
				end

				cwDueling.THRALL_ARENAS[arenaID].thrallsToSummon = table.Copy(THRALL_WAVEINFO[cwDueling.THRALL_ARENAS[arenaID].wave][1])
				cwDueling.THRALL_ARENAS[arenaID].thrallsLeft = table.Copy(THRALL_WAVEINFO[cwDueling.THRALL_ARENAS[arenaID].wave][1])

				for _, v in pairs(cwDueling.THRALL_ARENAS[arenaID].thrallsToSummon) do
					v.kill = v.kill * #arena.players
				end

				for _, v in pairs(cwDueling.THRALL_ARENAS[arenaID].thrallsLeft) do
					v.kill = v.kill * #arena.players
				end

				for _, v in pairs(arena.thrallsLeft) do
					thrallsLeft = thrallsLeft + v.kill
				end

				Schema:EasyText(cwDueling.THRALL_ARENAS[arenaID].players, "orange", "Wave " .. arena.wave .. " begins in 5 seconds! You have to kill " .. thrallsLeft .. " thralls!")

				cwDueling.THRALL_ARENAS[arenaID].intermission = true

				timer.Create("ThrallWaveWait" .. arenaID, 5, 1, function()
					if cwDueling.THRALL_ARENAS[arenaID] ~= nil then
						cwDueling.THRALL_ARENAS[arenaID].intermission = false
					end
				end)
			elseif not arena.intermission then
				local thrallsLeftSum = 0

				for _, v in pairs(arena.thrallsToSummon) do
					thrallsLeftSum = thrallsLeftSum + v.kill
				end

				if thrallsLeftSum > 0 then
					for i = 1, arena.spawners do 
						if not timer.Exists("ThrallSpawn_" .. arenaID .. "_" .. i) then 
							local availableThralls = {}

							for _, v in pairs(arena.thrallsToSummon) do
								if v.kill > 0 then
									table.insert(availableThralls, v)
								end
							end

							if next(availableThralls) then
								local randomThrallType = math.random(1, #availableThralls)
								cwDueling:SpawnThrall(arenaID, availableThralls[randomThrallType].diff)
								arena.thrallsToSummon[availableThralls[randomThrallType].diff].kill = arena.thrallsToSummon[availableThralls[randomThrallType].diff].kill - 1
								thrallsLeftSum = thrallsLeftSum - 1

								if thrallsLeftSum > 0 then
									timer.Create("ThrallSpawn_" .. arenaID .. "_" .. i, delay, 1, function()
									end)
								end
							end
						end
					end
				end
			end
		elseif arena.wave == thrallEndWave then
			cwDueling:ThrallCompleted(arenaID, false)
		end
	end
end

-- Check if a player is dueling
function cwDueling:PlayerIsDueling(player) -- cont, this isnt working well cuz arena.duelingTeam1 isnt set
    if DUELING_ARENAS then
        for _, arena in pairs(DUELING_ARENAS) do
			local ffaArenaPlayerDueling = false;
			if arena.duelingFFAPlayers and next(arena.duelingFFAPlayers) ~= nil then -- i should reall be using an arena id lol
				for _,v in pairs(arena.duelingFFAPlayers) do
					if v.players[1] == player then
						ffaArenaPlayerDueling = true
					end
				end
			end
			
			if ((arena.duelingTeam1 and arena.duelingTeam1.players and table.HasValue(arena.duelingTeam1.players, player)) or 
				(arena.duelingTeam2 and arena.duelingTeam2.players and table.HasValue(arena.duelingTeam2.players, player))) or 
				ffaArenaPlayerDueling then
				return true
			end
        end
    end

	if cwDueling.THRALL_ARENAS then
		for _, arena in pairs(cwDueling.THRALL_ARENAS) do
			for _, pv in pairs(arena.players) do
				if pv == player then
					return true
				end
			end
		end
	end
	
    return false
end

-- Check if a duel party with a specific ID is dueling
function cwDueling:IsPartyDueling(duelPartyID)
    if DUELING_ARENAS then
        for _, arena in pairs(DUELING_ARENAS) do
            if arena.duelingTeam1 and table.HasValue(arena.duelingTeam1.partyIDs, duelPartyID) or
               arena.duelingTeam2 and table.HasValue(arena.duelingTeam2.partyIDs, duelPartyID) then
                return true
            end
        end
    end
    
    return false
end

-- Junk func, remove probably: Check if two players are doing,
function cwDueling:PlayersAreDueling(player1, player2)
    if DUELING_ARENAS then
        for _, arena in pairs(DUELING_ARENAS) do
            if arena.duelingTeam1 and table.HasValue(arena.duelingTeam1, player1) and table.HasValue(arena.duelingTeam2, player2) or
               arena.duelingTeam2 and table.HasValue(arena.duelingTeam2, player1) and table.HasValue(arena.duelingTeam1, player2) then
                return true
            end
        end
    end

    return false
end

-- Junk func, remove probably.
function cwDueling:GetPlayerDuelOpponent(player)
	if IsValid(player.opponent) then
		return player.opponent;
	end
	return;
end

-- Restore a characters netvars/sharedvars to pre-duel states
function cwDueling:restoreAbortedCharacter(player)
	player:Freeze(true);
	player:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255 ), 4, 1.1);
	Clockwork.datastream:Start(player, "FadeBattleMusic");

	local te = player:GetSharedVar("duelParty")
	if not cwDueling.DUELING_PARTIES[te] then
		player:SetSharedVar("duelParty", nil)
	end

	timer.Simple(5, function()
		if IsValid(player) then
			player.opponent = nil;
			player:Freeze(false);
			player:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255 ), 5, 0);
			player:SetSharedVar("duelType", nil)
			player:SetSharedVar("duelDamageDone", 0)

			if player:GetMoveType(player) == MOVETYPE_NOCLIP then
				cwObserverMode:MakePlayerExitObserverMode(player);
			end
			
			if player.cachedPos and player.cachedAngles then
				player:Spawn();
				player:SetPos(player.cachedPos + Vector(0, 0, 8));
				player:SetEyeAngles(player.cachedAngles);
				
				Clockwork.limb:RestoreLimbsFromCache(player);
				
				timer.Simple(0.1, function()
					if IsValid(player) then
						player:SetPos(player.cachedPos + Vector(0, 0, 8));
						player:SetEyeAngles(player.cachedAngles);
					end
				end);
			end
			
			if player.cachedHP then
				player:SetHealth(player.cachedHP);
				player:SetNWInt("freeze", 0);
			end
			
			if player.distortedRingFired then
				player.distortedRingFired = nil;
			end
			
			if player:GetCharacterData("Hatred") then
				player:SetLocalVar("Hatred", player:GetCharacterData("Hatred"));
			end
			
			player.opponent = nil;
			player:SetSharedVar("teamID", nil)
			
			Clockwork.datastream:Start(player, "SetPlayerDueling", false);
			
			hook.Run("PlayerExitedDuel", player);
		end
	end)
end

-- instead of canceling between 2 players, cancel 2 teams
function cwDueling:DuelAborted(team1, team2, duelArena)
	cwDueling:RagdollRemove(DUELING_ARENAS[duelArena])
	
	if IsValid(team1) and IsValid(team2) then
		for k, v in pairs(DUELING_ARENAS) do
			if (v.duelingTeam1 == team1 or v.duelingTeam2 == team1) and (v.duelingTeam1 == team2 or v.duelingTeam2 == team2) then
				-- There was probably a tie or something.
				DUELING_ARENAS[k].duelingTeam1 = {};
				DUELING_ARENAS[k].duelingTeam2 = {};
				
				if timer.Exists("DuelTimer_"..k) then
					timer.Remove("DuelTimer_"..k)
				end
			
				
				for _, team in ipairs({team1, team2}) do
					for i = 1, #team do
						cwDueling:restoreAbortedCharacter(team[i])
						Schema:EasyText({team[i]}, "icon16/shield.png", "orange", "Draw!");
					end
				end			
			end
		end
	elseif IsValid(team1) then
		for k, v in pairs(DUELING_ARENAS) do
			if v.duelingTeam1 == team1 or v.duelingTeam2 == team1 then
				-- team2 dropped
				for k, v in pairs (_player.GetAll()) do
					if v:IsAdmin() then
						Schema:EasyText(v, "orangered","[DUELLING] Team: "..team.." dropped from an in progress duel.");
					end;
				end;
				DUELING_ARENAS[k].duelingTeam1 = {};
				DUELING_ARENAS[k].duelingTeam2 = {};
				
				if timer.Exists("DuelTimer_"..k) then
					timer.Remove("DuelTimer_"..k)
				end

				for i = 1, #team1 do
					cwDueling:restoreAbortedCharacter(team1[i])
					Schema:EasyText({team[i]}, "icon16/shield.png", "orange", "Draw!");
				end
				
			end
		end
	elseif IsValid(team2) then 
		for k, v in pairs(DUELING_ARENAS) do
			if v.duelingTeam1 == team2 or v.duelingTeam2 == team2 then
				-- team1 dropped
				for k, v in pairs (_player.GetAll()) do
					if v:IsAdmin() then
						Schema:EasyText(v, "orangered","[DUELLING] Team: "..team.." dropped from an in progress duel.");
					end;
				end;
				DUELING_ARENAS[k].duelingTeam1 = {};
				DUELING_ARENAS[k].duelingTeam2 = {};
				
				if timer.Exists("DuelTimer_"..k) then
					timer.Remove("DuelTimer_"..k)
				end

				for i = 1, #team2 do
					cwDueling:restoreAbortedCharacter(team2[i])
					Schema:EasyText({team[i]}, "icon16/shield.png", "orange", "Draw!");
				end
			end
		end
	end
end

-- Get the player's arena, and then checks if there is only 1 person alive, if so return the winner or nil
function cwDueling:FFAEndCheck()
    local winners = {}
    local losers = {}

    for _, arena in pairs(DUELING_ARENAS) do
        if arena.duelingFFAPlayers then
            if next(arena.duelingFFAPlayers) ~= nil then
                for _, playparty in pairs(arena.duelingFFAPlayers) do
                    if playparty.players[1]:Alive() then
                        table.insert(winners, playparty)
                    else
                        table.insert(losers, playparty)
                    end
                end
            end
        end
    end

    if #winners == 1 then
        return winners[1], losers
    else
        return nil
    end
end

-- Cancel a FFA match given a player list
function cwDueling:FFAAborted(players, k)
	cwDueling:RagdollRemove(DUELING_ARENAS[k])
	if IsValid(players) then
		local v = DUELING_ARENAS[k];
		DUELING_ARENAS[k].duelingFFAPlayers = {};

		if timer.Exists("DuelTimer_"..k) then
			timer.Remove("DuelTimer_"..k)
		end
	
		for i = 1, #players do
			cwDueling:restoreAbortedCharacter(players[i].players[1])
			Schema:EasyText(players[i].players[1], "icon16/shield.png", "orange", "Draw!");
		end	
	end
end

-- Return a table of arena details for TDM, FFA, Thrall arenas
function cwDueling:GetArenaDetails()
	local areanStrings = {}
	for k, arena in pairs(DUELING_ARENAS) do
		if arena.duelType then
			arenaString = k .. " (" .. arena.duelType .. "): "
			if arena.duelingTeam1 ~= nil and next(arena.duelingTeam1) ~= nil and next(arena.duelingTeam2) ~= nil then
				arenaString = arenaString .. "Team1 - "
				local numPlayers = #arena.duelingTeam1.players
				for j, playerData in ipairs(arena.duelingTeam1.players) do
					arenaString = arenaString .. playerData:GetName()
		
					if j < numPlayers then
						arenaString = arenaString .. ", "
					end
				end
		
				arenaString = arenaString .. " & Team2 - "
				local numPlayers = #arena.duelingTeam2.players
				for j, playerData in ipairs(arena.duelingTeam2.players) do
					arenaString = arenaString .. playerData:GetName()
		
					if j < numPlayers then
						arenaString = arenaString .. ", "
					end
				end
				table.insert(areanStrings, arenaString)
			elseif arena.duelingFFAPlayers and next(arena.duelingFFAPlayers) ~= nil then
				arenaString = arenaString .. "FFA Players: "
				local numPlayers = #cwDueling.DUELING_ARENAS[k].duelingFFAPlayers
				for j, pd in pairs(cwDueling.THRALL_ARENAS[k].duelingFFAPlayers) do
					local playerData = pd;
					arenaString = arenaString .. playerData:GetName()
		
					if j < numPlayers then
						arenaString = arenaString .. ", "
					end
				end
				table.insert(areanStrings, arenaString)
			elseif cwDueling.THRALL_ARENAS[k] ~= nil and next(cwDueling.THRALL_ARENAS[k]) ~= nil then
				arenaString = arenaString .. "Thrall Players: "
				local numPlayers = #cwDueling.THRALL_ARENAS[k].players
				for j, pd in pairs(cwDueling.THRALL_ARENAS[k].players) do
					local playerData = pd;
					arenaString = arenaString .. playerData:GetName()
		
					if j < numPlayers then
						arenaString = arenaString .. ", "
					end
				end
				table.insert(areanStrings, arenaString)
			end
		end
	end
	return areanStrings;
end

function cwDueling:UpdateCharThrallProg(char, arenaID)
	local wins = char:GetCharacterData("DuelWins") or {0, 0, 0, 0, 0, 0, 0, 0};
	if type(wins) ~= "table" then
		wins = {0, 0, 0, 0, 0, 0, 0, 0};
	end

	for i = 1, 8 - #wins do
		table.insert(wins, 0);
	end

	if duelType then
		if wins[7] < cwDueling.THRALL_ARENAS[arenaID].wave then
			wins[7] = cwDueling.THRALL_ARENAS[arenaID].wave
			print("YO")
			char:SetCharacterData("DuelWins", wins);
		end
	end
end

function cwDueling:UpdateCharWins(char, duelType)
	local wins = char:GetCharacterData("DuelWins") or {0, 0, 0, 0, 0, 0, 0, 0};
	if type(wins) ~= "table" then
		wins = {0, 0, 0, 0, 0, 0, 0, 0};
	end

	if #wins < 8 then
		for i = 1, 8 - #wins do
			table.insert(wins, 0);
		end
	end

	if duelType then
		wins[duelType] = wins[duelType] + 1
		char:SetCharacterData("DuelWins", wins);
	end
end


function cwDueling:UpdateCharLosses(char, duelType)
	local losses = char:GetCharacterData("DuelLosses") or {0, 0, 0, 0, 0, 0, 0, 0};
	if type(losses) ~= "table" then
		losses = {0, 0, 0, 0, 0, 0, 0, 0};
	end

	if #losses < 8 then
		for i = 1, 8 - #losses do
			table.insert(losses, 0);
		end
	end

	if duelType then
		losses[duelType] = losses[duelType] + 1
		char:SetCharacterData("DuelLosses", losses);
	end
end

-- Handles a completed Duel arena given an array of winner/losers.
function cwDueling:DuelCompleted(winner, loser, duelArena)
	local v = DUELING_ARENAS[duelArena];
	cwDueling:RagdollRemove(v)

	if winner ~= nil and loser ~= nil then
		local duelType = winner.players[1]:GetSharedVar("duelType")
		
		if (v.duelingTeam1 == winner or v.duelingTeam2 == winner) and (v.duelingTeam1 == loser or v.duelingTeam2 == loser) then
			-- Set winner/loser sql data
			for i = 1, #winner.players do
				cwDueling:UpdateCharWins(winner.players[i], duelType)
			end
			
			for i = 1, #loser.players do
				cwDueling:UpdateCharLosses(loser.players[i], duelType)
			end

			v.duelingTeam1 = {};
			v.duelingTeam2 = {};
			v.duelType = nil;
				
			if timer.Exists("DuelTimer_"..k) then
				timer.Remove("DuelTimer_"..k)
			end

			for _, team in ipairs({winner.players, loser.players}) do
				for i = 1, #team do
					cwDueling:restoreAbortedCharacter(team[i])
				end
			end	

			cwDueling:SendScoreboard(winner, loser, duelType)
		end
	end
end

function cwDueling:BuildScoreboardStruct(players, duelType)
	local structStorage = {}

	for _,ply in pairs(players) do
		local level = ply:GetCharacterData("level", 1)
		local health = ply:Health()
		local kills = ply:GetSharedVar("duelKills") or 0
		local teamkills = ply:GetSharedVar("duelFriendlyFires") or 0;
		local kinisgerOverride = ply:GetSharedVar("kinisgerOverride")
		local damageDone = ply:GetSharedVar("duelDamageDone") or 0
		local waveReached = ply:GetSharedVar("duelWaveReached") or 0;
		local flagCap = ply:GetSharedVar("duelFlagCaps") or 0;
		local flagDef = ply:GetSharedVar("duelFlagDefs") or 0;

		if cwBeliefs then
			if ply:GetSubfaction() == "Kinisger" and kinisgerOverride then
				if kinisgerOverride ~= "Children of Satan" and ply:GetSharedVar("kinisgerOverrideSubfaction") ~= "Clan Reaver" then
					if level > cwBeliefs.sacramentLevelCap and ply:HasBelief("sorcerer") then
						if ply:HasBelief("loremaster") then
							if level > (cwBeliefs.sacramentLevelCap + 10) then
								level = 50;
							end
						else
							level = 40;
						end
					end
				end
			end
		end	-- [1]-[3] Universal, [4] TDM, [5]-[6] Universal, [7] Thralls, [8]-[9] CTF
		table.insert(structStorage, {ply:GetName(), level, health, kills, teamkills, damageDone, duelType, waveReached, flagCap, flagDef})
		end
	return structStorage
end

-- Build up leaderboard data & send it to people (scoreboard)
function cwDueling:SendScoreboard(winner, loser, duelType)
	local winnerInfo, winTeamData, loseTeamData = {}, {}, {}
	local losers, winners = {}, {};
	if duelType == "FFA" then
		for _,vt in pairs(loser) do
			table.insert(losers, vt.players[1])
		end
		for _,vt in pairs(winner) do
			table.insert(winners, vt.players[1])
		end
	else
		winners = winner.players
		losers = loser.players
	end

	winTeamData = cwDueling:BuildScoreboardStruct(winners, duelType)
	if losers then
		loseTeamData = cwDueling:BuildScoreboardStruct(losers, duelType)
	end

	local combinedTable = {}
	table.Add(combinedTable, winners)
	table.Add(combinedTable, losers)
	netstream.Start(combinedTable, "DuelLeaderboard", {winTeamData, loseTeamData})

	local winnerInfo = "";
	for _,v in pairs(winTeamData) do
		winnerInfo = winnerInfo .. v[1] .. " (" .. v[2] .. ")" -- bug here, fix htis
	end

	if #winnerInfo > 0 then
		Schema:EasyText(combinedTable, "icon16/shield_add.png", "forestgreen", #winnerInfo == 1 and winnerInfo .. " was the winner!" or winnerInfo .. " were the winners!");
	else
		Schema:EasyText(combinedTable, "icon16/shield_add.png", "forestgreen", "No eligible winners found.");
	end
end

-- Handles a completed FFA arena given an array of winner/losers.
function cwDueling:FFACompleted(winner, losers)
	
	if winner ~= nil and losers ~= nil then
		local duelType = winner.players[1]:GetSharedVar("duelType") -- if server crashes, its cuz  this. i should move this into botrh inner loops
		local duelArena = winner.players[1]:GetSharedVar("duelArena")

		cwDueling:RagdollRemove(cwDueling.THRALL_ARENAS[duelArena])
		DUELING_ARENAS[duelArena].duelType = nil;

		for i = 1, #winner do
			cwDueling:UpdateCharWins(winner.players[1], 6)
		end

		for i = 1, #losers do
			cwDueling:UpdateCharLosses(losers[i].players[1], 6)
		end

		DUELING_ARENAS[duelArena].duelingFFAPlayers = {};
		if timer.Exists("DuelTimer_"..duelArena) then
			timer.Remove("DuelTimer_"..duelArena)
		end

		for _, team in ipairs(losers) do
			cwDueling:restoreAbortedCharacter(team.players[1])
		end	
		cwDueling:restoreAbortedCharacter(winner.players[1])
		cwDueling:SendScoreboard({winner}, losers, duelType)
	end
end

-- Derma helper functions
function cwDueling:CreateParty(player)
	local duelParty = player:GetSharedVar("duelParty")
	if not duelParty then
		local newParty = {size = 1, players = {player}, ID = os.time() .. "_" .. math.random(1000, 9999)}
		player:SetSharedVar("duelParty", newParty.ID)
		cwDueling.DUELING_PARTIES[newParty.ID] = newParty
		Clockwork.player:Notify(player, "You have created a new duel party.")
	else
		Clockwork.player:Notify(player, "You are already in a duel party!")
	end
end

function cwDueling:InviteToParty(player)
	local duelParty = player:GetSharedVar("duelParty")
	if cwDueling.DUELING_PARTIES[duelParty].players[1] ~= player  then
		Clockwork.player:Notify(player, "You aren't the leader of your party!")
		return false
	end
	Clockwork.dermaRequest:RequestString(player, "Invite To Party", "Type the name of a character to invite.", nil, function(result)
		local target = Clockwork.player:FindByID(result)
		if IsValid(target) then
			if target:Alive() then
				if IsValid(target) and target:Alive() then
					local entName = target:GetName()
					local entPid = target:GetSharedVar("duelParty")

					if (not entPid) then

						if not target.duelPartyInvites then
							target.duelPartyInvites = {}
						end
			
						for _, invite in ipairs(target.duelPartyInvites) do
							if invite.ID == duelParty then
								Clockwork.player:Notify(player, "You have already invited " .. entName)
								return
							end
						end

						if #target.duelPartyInvites >= 5 then
							table.remove(target.duelPartyInvites, 1)
						end

						Clockwork.player:Notify(player, "You invited " .. entName)
						Clockwork.player:Notify(target, "You have been invited by " .. player:GetName())
						local pInvite = {ID = duelParty, player = player}
						table.insert(target.duelPartyInvites, pInvite)
					else
						Clockwork.player:Notify(player, "They're already in a party!")
					end

					return true;
				end
			else
				Schema:EasyText(player, "darkgrey", "The target character is already dead!");
			end
		else
			Schema:EasyText(player, "grey", tostring(result).." is not a valid character!");
		end
	end)	
end

function cwDueling:DisbandParty(player)
	local duelParty = player:GetSharedVar("duelParty")

	-- check if a party is in matchmaking
	if not cwDueling:IsPartyInMatchmaking(duelParty) or not cwDueling:IsPartyDueling(duelParty) then
		if duelParty and cwDueling.DUELING_PARTIES[duelParty] then
			if player:GetName() == cwDueling.DUELING_PARTIES[duelParty].players[1]:GetName() then
				for _, partyPlayer in ipairs(cwDueling.DUELING_PARTIES[duelParty].players) do
					partyPlayer:SetSharedVar("duelParty", nil)
				end

				cwDueling.DUELING_PARTIES[duelParty] = nil
				Clockwork.player:Notify(player, "Party disbanded.")
			else
				Clockwork.player:Notify(player, "You aren't the leader!")
			end
		else
			Clockwork.player:Notify(player, "You are not in a party.")
		end
	else
		Clockwork.player:Notify(player, "You are in matchmaking or dueling, you cant disband your party!")
	end
end

function cwDueling:KickPartyMember(player, targetName)
	local target
	if targetName then
		target = Clockwork.player:FindByID(targetName)
	else
		Clockwork.player:Notify(player, "Not a valid target!")
		return
	end
	local duelParty = player:GetSharedVar("duelParty")
	playerFound = false
	
	if duelParty and cwDueling.DUELING_PARTIES[duelParty] then
		if not cwDueling:IsPartyInMatchmaking(duelParty) or not cwDueling:IsPartyDueling(duelParty) then
			if player ~= target then
				if cwDueling.DUELING_PARTIES[duelParty].players[1] == player then
					for i,p in ipairs(cwDueling.DUELING_PARTIES[duelParty].players) do
						if p:GetName() == target:GetName() then
							Clockwork.player:Notify(player, "Removed " .. p:GetName() .. " from your party!")
							p:SetSharedVar("duelParty", nil) 
							table.remove(cwDueling.DUELING_PARTIES[duelParty].players, i)
							cwDueling.DUELING_PARTIES[duelParty].size = cwDueling.DUELING_PARTIES[duelParty].size - 1
							playerFound = true
							break
						end
					end
					if not playerFound then
						Clockwork.player:Notify(player, "Player not found.")
					end
				else
					Clockwork.player:Notify(player, "You must be the leader of the party to kick players.")
				end
			else
				Clockwork.player:Notify(player, "You can't kick yourself!")
			end
		else
			Clockwork.player:Notify(player, "You are in matchmaking, you cant remove players!")
		end
	else
		Clockwork.player:Notify(player, "You're not in a party!")
	end
end

function cwDueling:LeaveParty(player)
	local duelParty = player:GetSharedVar("duelParty")

    -- check if a party is in matchmaking
	if duelParty and cwDueling.DUELING_PARTIES[duelParty] then
   	 	if not cwDueling:IsPartyInMatchmaking(duelParty) or not cwDueling:IsPartyDueling(duelParty) then
        
            if cwDueling.DUELING_PARTIES[duelParty].players[1] ~= player then
                local playerIndex = table.KeyFromValue(cwDueling.DUELING_PARTIES[duelParty].players, player)

                if playerIndex then
                    table.remove(cwDueling.DUELING_PARTIES[duelParty].players, playerIndex)
                    cwDueling.DUELING_PARTIES[duelParty].size = cwDueling.DUELING_PARTIES[duelParty].size - 1
                    player:SetSharedVar("duelParty", nil)

                    Clockwork.player:Notify(player, "You have left your party.")
                else
                    Clockwork.player:Notify(player, "You are not in a party.")
                end
            else
                Clockwork.player:Notify(player, "You are the leader, you can't leave! Try disbanding instead.")
            end
        else
            Clockwork.player:Notify(player, "You are in matchmaking or dueling, you can't disband your party!")
        end
    else
        Clockwork.player:Notify(player, "You are not in a party.")
    end
end


function cwDueling:AcceptPartyInvite(player, pid)
	local pDuelParty = player:GetSharedVar("duelParty")
	local f = false;
	for _,v in pairs(player.duelPartyInvites) do
		if v.ID == pid then
			f = true
			break;
		end
	end

	if pDuelParty ~= nil then
		Clockwork.player:Notify(player, "You're already in a party.")
	elseif not player.duelPartyInvites or not pid or not f then
		Clockwork.player:Notify(player, "You don't have an invite from that person.")
	elseif cwDueling.DUELING_PARTIES[pid].size == 5  then
		Clockwork.player:Notify(player, "The party you are trying to join is full!")
	else
		Clockwork.player:Notify(player, "You accepted the duel invite from " .. cwDueling.DUELING_PARTIES[pid].players[1]:GetName()) -- replace w struct later
		for i = 1, #player.duelPartyInvites do
			local v = player.duelPartyInvites[i]
			if v.ID == pid then
				table.remove(player.duelPartyInvites, i)
				break
			end
		end
		player:SetSharedVar("duelParty", pid) 
		
		table.insert(cwDueling.DUELING_PARTIES[pid].players, player)
		cwDueling.DUELING_PARTIES[pid].size = cwDueling.DUELING_PARTIES[pid].size + 1
	end
end

-- Derma hooks
netstream.Hook("DermaPartyCreate", function(player, data)
	cwDueling:CreateParty(player)
	cwDueling:UpdatePartyPanel(player)
end)

netstream.Hook("DermaPartyInvite", function(player, data)
	cwDueling:InviteToParty(player)
	--cwDueling:UpdatePartyPanel(player) TODO when a player accepts & derma is open, update party panel
end)

netstream.Hook("DermaPartyAccept", function(player, data)
	local pid = data;
	cwDueling:AcceptPartyInvite(player, pid)
	cwDueling:UpdatePartyPanel(player)
end)

netstream.Hook("DermaPartyDisband", function(player, data)
	cwDueling:DisbandParty(player)
	cwDueling:UpdatePartyPanel(player)
end)

netstream.Hook("DermaPartyKick", function(player, data)
	local kickPlayer; 
	if data[1] then
		kickPlayer = data[1]
	else
		kickPlayer = nil;
	end
	cwDueling:KickPartyMember(player, kickPlayer)
	cwDueling:UpdatePartyPanel(player)
end)

netstream.Hook("DermaPartyLeave", function(player, data)
	cwDueling:LeaveParty(player)
	cwDueling:UpdatePartyPanel(player)
end)

function cwDueling:UpdatePartyPanel(player)
	local duelParty = player:GetSharedVar("duelParty")
	if duelParty then
		netstream.Start(player, "UpdatePartyDerma", {cwDueling.DUELING_PARTIES[duelParty].players, player.duelPartyInvites});
	else
		netstream.Start(player, "UpdatePartyDerma", {nil, player.duelPartyInvites});
	end
end
