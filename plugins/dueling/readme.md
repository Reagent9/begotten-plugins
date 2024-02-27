This is an unoffical plugin for Begotten III expanding the duel system from 1v1s to 5v5 team battles, and free for all arenas. This plugin works out of the box but, configuration of important values and timers can be done in the header of sv_plugin.lua. CTF and Thrall gamemodes are disabled by default for now due to no default arenas setup and bugs.
A party system has been implemented and can be accessed with the /dp command, allowing you to create premade teams.

    -- Main Commands -- 
    DuelWins 
    Check your duel wins. 
    
    DuelLeaderboard 
    Check the top 5 duel wins for each category. 
    
    ViewMatchmakingStatus 
    View matchmaking status. 
    
    ViewArenas 
    View the current arenas in play. 
    
    ToggleDuelingHalo 
    Toggle friendly halos in duels. 
    
    DuelParty 
    Open up the duel party management menu 

    -- Text commands for editing parties -- 
    DuelPartyCreate 
    Create a new duel party. 
    
    DuelPartyInvite 
    Invite a player you're looking at to your party provided they are in range of the dueling shrine. 
    
    DuelPartyViewInvites 
    View pending duel invites. 
    
    DuelPartyAcceptInvite <InviterName> 
    Accept a duel party invite from a specific player. 
    
    DuelPartyInfo 
    View all players in your party and other info. 
    
    DuelPartyDisband 
    Disband your party. 
    
    DuelPartyLeave 
    Leave your party. 
    
    DuelPartyRemove 
    Remove a pest from your party 

    -- DEBUG Commands -- 
    DuelForceAcceptInvite <string TargetName> 
    Admin DEBUG: Force a player to accept your invite. 
    
    DuelAdminKickParty <string TargetName> 
    Admin DEBUG: Remove a player from their party. 
    
    ViewParties 
    View the current parties and their members. 
    
    DuelAdminRemoveParty <string TargetPartyID> 
    Admin DEBUG: Remove a party. 
    
    DuelForceEnterMatchmaking <string Name> <duelType> 
    Admin DEBUG: Force a character to enter duel matchmaking.
    
    DuelForceMakeParty <string TargetName> 
    Admin DEBUG: Force a player to make a duel party. 
    
    DuelForceInviteParty <string InviterName> <string InviteeName> 
    Admin DEBUG: Force a player to invite another player to their duel party 
    
    DuelForceAcceptParty <string InviterName> <string InviteeName> 
    Admin DEBUG: Force a player to accept a duel party invite.

