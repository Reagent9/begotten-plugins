-- On character load, set ClanInvition to N/A
hook.Add("PlayerCharacterLoaded", "", function(player)
    player:SetCharacterData("ClanInvitation", "N/A");
end, HOOK_LOW)


-- On character load, correct their subfaction via SQL, added for debugging. REMOVE LATER
hook.Add("PlayerCharacterCreated", "", function(player, character)
    player:SetCharacterData("Subfaction", "N/A", true);
    player:SetSharedVar("subfaction", "N/A");
end, HOOK_LOW)
