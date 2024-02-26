Clockwork.kernel:IncludePrefixed("shared.lua");
util.AddNetworkString("UpdateLeaderboard")


AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");


-- Retrieves player win/lose data and constructs leaderboard data to be broadcasted to all players
local function UpdateLeaderboard()
    local pl = { [1] = {}, [2] = {}, [3] = {}, [4] = {}, [5] = {}, }

    local charactersTable = Clockwork.config:Get("mysql_characters_table"):Get()

    local query = Clockwork.database:Select(charactersTable);
    query:Select("_Data");
    query:Select("_Name");

    query:Callback(function(result)
        if result and #result > 0 then
            local leaderboard = {}

            -- Iterate through all characters
            for _, characterData in pairs(result) do
                local name = characterData._Name
                local data = util.JSONToTable(characterData._Data)
                local duelWins = data.DuelWins;

                if type(duelWins) == "table" then
                    for _, onlinePlayer in pairs(_player.GetAll()) do
                        if onlinePlayer:GetName() == name then
                            -- If the player is online, get the data directly
                            duelWins = onlinePlayer:GetCharacterData("DuelWins") or {0, 0, 0, 0, 0}
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
            for duelType = 1, 6 do
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
                local maxEntries = 5
                local limitedLeaderboard = {}
                for i = 1, math.min(#typeLeaderboard, maxEntries) do
                    table.insert(limitedLeaderboard, typeLeaderboard[i])
                end
                --print("update new table")
                --PrintTable(limitedLeaderboard)
                pl[duelType] = limitedLeaderboard
            end

            -- Collect total wins from all players
            local totalLeaderboard = {}

            for _, e in pairs(leaderboard) do
                if not totalLeaderboard[e.player] then
                    totalLeaderboard[e.player] = {wins = 0, player = e.player}
                end
                totalLeaderboard[e.player].wins = totalLeaderboard[e.player].wins + e.wins
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
            for i = 1, math.min(5, #sortedPlayers) do
                table.insert(top5Players, sortedPlayers[i])
            end

            pl[7] = top5Players -- in the future [6] will be ffa.. need more detailed way of storing this, documentation etc
            net.Start("UpdateLeaderboard")
                net.WriteTable(pl)
            net.Broadcast()
        end
    end)
    query:Execute();
end

function ENT:Initialize()
    self:SetNWString("LeaderboardType", self.LeaderboardType)
    if SERVER then
        self:SetModel("models/props/cs_assault/billboard.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetCollisionGroup(COLLISION_GROUP_WORLD)

        local physicsObject = self:GetPhysicsObject()

        if IsValid(physicsObject) then
            physicsObject:Wake()
            physicsObject:EnableMotion(false)
        end

        UpdateLeaderboard()
    end

end


function ENT:SetDefaults(txt)
    txt = string.gsub(string.gsub(txt or "", "//", "\n"), "\\n", "\n")
    local split = string.Split(txt, "\n") or {}
    local hasTitle = #split > 1
    if not hasTitle then split = string.Split(txt, " ") end

    self:SetTopText(split[1] or "Placeholder")
    self:SetBottomText(table.concat(split, hasTitle and "\n" or " ", 2))

    self:SetBarColor(Vector(1, 0.5, 0))
end

local function canEditVariable(self, ent, ply, key, val, editor)
    if self ~= ent then return end
    return self:CPPICanPhysgun(ply)
end


timer.Create("LeaderboardUpdateTimer", 30, 0, function()
    UpdateLeaderboard()
end)

hook.Add("PlayerCharacterLoaded", "InitialLeaderboardUpdate", function(ply)
    UpdateLeaderboard() 
end)

hook.Add("OnReloaded", "RefreshLeaderboard", function(ply)
    timer.Simple(1, function()
        UpdateLeaderboard() 
    end)
end)
