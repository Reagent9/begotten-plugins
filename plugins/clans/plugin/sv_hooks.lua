-- On character load, correct their subfaction via SQL
hook.Add("PlayerCharacterLoaded", "", function(player)
    local subfactionName = player:GetSubfaction()
    local playerName = player:GetName();

    local characterTable = config.Get("mysql_characters_table"):Get()
    local queryObj = Clockwork.database:Select(characterTable)
    queryObj:Where("_Name", playerName)
    queryObj:Callback(function(result)
        if result and #result > 0 then
            local characterTable = result[1]
            local playerSubFac = characterTable._ClanName

            print(playerSubFac .. "\n");

            if playerSubFac ~= "" then
                player:SetSharedVar("subfaction", playerSubFac);
                player:SetCharacterData("ClanInvitation", "");
            else
                player:SetSharedVar("subfaction", "");
                player:SetCharacterData("ClanInvitation", "");
            end
        end
    end)
    queryObj:Execute()
end, HOOK_LOW)


-- On character load, correct their subfaction via SQL
hook.Add("PlayerCharacterCreated", "", function(player, character)
    MsgC(Color(0, 0, 255), "[Clockwork]", Color(192, 192, 192), " New char created! WOW!\n")
    player:SetCharacterData("Subfaction", "N/A", true);
    player:SetSharedVar("subfaction", "N/A");
end, HOOK_LOW)


