-- On character load, correct their subfaction via SQL
hook.Add("PlayerCharacterLoaded", "", function(player)
    local subfactionName = player:GetSubfaction()
    local playerName = player:GetName();
    local character = player:GetCharacter();

    local characterTable = config.Get("mysql_characters_table"):Get()
    local queryObj = Clockwork.database:Select(characterTable)
    queryObj:Where("_Name", playerName)
    queryObj:Callback(function(result)
        if result and #result > 0 then
            local characterTable = result[1]
            local playerSubFac = characterTable._Subfaction

            if playerSubFac ~= "N/A" then
                player:SetSharedVar("subfaction", playerSubFac);
                player:SetCharacterData("ClanInvitation", "");
                character.subfaction = playerSubFac;
            else
                player:SetSharedVar("subfaction", "N/A");
                player:SetCharacterData("ClanInvitation", "N/A");
                character.subfaction = "N/A";
            end
        end
    end)
    queryObj:Execute()
end, HOOK_LOW)


-- On character load, correct their subfaction via SQL, added for debugging. REMOVE LATER
hook.Add("PlayerCharacterCreated", "", function(player, character)
    player:SetCharacterData("Subfaction", "N/A", true);
    player:SetSharedVar("subfaction", "N/A");
end, HOOK_LOW)


-- Hook DatabaseConnected to append a clan table to the database
hook.Add("DatabaseConnected", "", function()
    local databaseMod = Clockwork.database.Module
    if (databaseMod == "sqlite") then -- Create clans table
        local clansQueryObj = Clockwork.database:Create("clans")
        clansQueryObj:Create("_ID", "INTEGER AUTOINCREMENT")
        clansQueryObj:Create("_Name", "TEXT")
        clansQueryObj:Create("_Characters", "TEXT")
        clansQueryObj:PrimaryKey("_ID")
        clansQueryObj:Execute()

    else -- Create clans table
        local clansQueryObj = Clockwork.database:Create("clans")
        clansQueryObj:Create("_ID", "int(11) NOT NULL AUTO_INCREMENT")
        clansQueryObj:Create("_Name", "varchar(150) NOT NULL")
        clansQueryObj:Create("_Characters", "text NOT NULL")
        clansQueryObj:PrimaryKey("_ID")
        clansQueryObj:Execute()

    end
end)


-- Remove deleted characters from clan and drop the clan if no members are left
hook.Add("PlayerDeleteCharacter", "", function(player, character)
    local charName = character.name
    local clanName = character.subfaction

    if clanName == "N/A" then
        return
    end

    local clansTable = config.Get("mysql_clans_table"):Get()
    local charactersTable = config.Get("mysql_characters_table"):Get()

    local queryObj = Clockwork.database:Select(clansTable)
    queryObj:Where("_Name", clanName)
    queryObj:Callback(function(result)
        if result and #result > 0 then
            local clanData = result[1]
            local characters = util.JSONToTable(clanData._Characters) or {}

            -- Remove the character's name from the clan's character list.
            for i, name in ipairs(characters) do
                if name == charName then 
                    table.remove(characters, i)
                    break
                end
            end

            local updateQuery = Clockwork.database:Update(clansTable)
            updateQuery:Update("_Characters", util.TableToJSON(characters))
            updateQuery:Where("_Name", clanName)
            updateQuery:Execute()

            -- Check if the clan has no more members, and if so, delete it.
            if #characters == 0 then
                local deleteQuery = Clockwork.database:Delete(clansTable)
                deleteQuery:Where("_Name", clanName)
                deleteQuery:Callback(function()
                    print("The clan '" .. clanName .. "' has been deleted because the last member was removed.")
                end)
                deleteQuery:Execute()
            end
        end
    end)
    queryObj:Execute()
end, HOOK_LOW)


