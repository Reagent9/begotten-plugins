-- hook the death of players, for the inflictor/attacker i tell them that they killed someone

function cwAnnounceKills:PlayerDeath(player, inflictor, attacker, damageInfo)
    local playerTID = player:GetSharedVar("teamID");

    if attacker and type(attacker.GetSharedVar) == "function" then
        local attackerTID = attacker:GetSharedVar("teamID");
        print(attackerTID)
        print(playerTID)
        if (attackerTID ~= nil or playerTID ~= nil) and attackerTID == playerTID then
           -- print("Friendly")
        else
            net.Start("AnnounceKilledPlayer")
                net.WriteBool(true)
            net.Send(attacker)
        end
	end
end
