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
                if name == charName then  -- Change 'clanName' to 'charName' here
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
