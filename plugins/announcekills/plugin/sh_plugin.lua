PLUGIN:SetGlobalAlias("cwAnnounceKills")
if SERVER then
	util.AddNetworkString("AnnounceKilledPlayer")
end;

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");