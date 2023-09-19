<p align="center">
  <img src="https://i.imgur.com/4xssqVN.png" />
</p>


User Commands:

    /ClanCreate
        Description: Creates a clan.
        Usage: /ClanCreate <clan name>
        Example: /ClanCreate Clan

    /ClanInvite
        Description: Add a player you're looking at to your clan.
        Usage: /ClanInvite

    /ClanCheckInv
        Description: Check if you've been invited to a clan.
        Usage: /ClanCheckInv

    /ClanLeave
        Description: Leave your active clan. If you're the last person, it is disbanded.
        Usage: /ClanLeave

    /ClanDetails
        Description: Print all clan details.
        Usage: /ClanDetails

    /ClanKick
        Description: Kick a player from your clan.
        Usage: /ClanKick <player name>
        Example: /ClanKick Player

    /ClanPromote
        Description: Promote a user to a subleader.
        Usage: /ClanPromote <player name>
        Example: /ClanPromote Player

    /ClanDemote
        Description: Demote a player one rank lower than their current rank.
        Usage: /ClanDemote <player name>
        Example: /ClanDemote Player

    /ClanAcceptInvite
        Description: Accept a clan invitation.
        Usage: /ClanAcceptInvite

    /ClanHide
        Description: Toggle if your clan affiliation should be hidden to non-clan members.
        Usage: /ClanHide

Admin Commands:

    /ClansList
        Description: Lists all clans online on the server.
        Usage: /ClansList
        
    /ClanList
        Description: Lists all players in a specific clan.
        Usage: /ClanList <clan name>
        Example: /ClanList ExampleClan
        
    /ClanDevHide
        Description: Force a player to toggle their clan affiliation visibility.
        Usage: /ClanDevHide

    /ClanDevForceAccept
        Description: Force a player to accept their clan invitation.
        Usage: /ClanDevAccept
        Example: /ClanDevAccept

    /ClanDevRemove
        Description: Delete a clan given its name.
        Usage: /ClanDevRemove <clan name>
        Example: /ClanDevRemove ExampleClan

    /ClanDevClearInv
        Description: Clear a player's ClanInvitation.
        Usage: /ClanDevClearInv <player>
        Example: /ClanDevClearInv ExamplePlayer

    /ClanDevPromoteSelf
        Description: Promote yourself to a specified rank in a clan.
        Usage: /ClanDevPromoteSelf <rank>
        Example: /ClanDevPromoteSelf Officer

set groupType in sh_plugin.lua to whatever name of the group you wish to have for your server to modify commands. Ex: /ClanCreate -> /GangCreate
