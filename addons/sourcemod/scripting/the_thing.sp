#pragma semicolon 1

#include <sourcemod>
#include <cstrike>
#include <sdktools>

#define PLUGIN_VERSION "0.0.1"

// ConVars
new Handle:hsm_thing_enabled;
new Handle:hsm_thing_weapon;
new Handle:hsm_thing_speed;
new Handle:hsm_thing_health;

// enable switch
new bool:g_Enabled = true;

new int:g_Thing;

public Plugin:myinfo =
{
	name = "THE THING",
	author = "Tyson Cleary and Girmame Ayele",
	description = "Just who is THE THING???",
	version = PLUGIN_VERSION,
	url = "http://code.google.com/p/smthething/"
};

public OnPluginStart()
{
	// initialise ConVars
	hsm_thing_enabled = CreateConVar("sm_thing_enabled", "1", "Enables THE THING plugin.");
	hsm_thing_weapon = CreateConVar("sm_thing_weapon", "m4a1", "The weapon for THE THING.");
	hsm_thing_speed = CreateConVar("sm_thing_speed", "2.0", "The speed for THE THING.");
	hsm_thing_health = CreateConVar("sm_thing_health", "200", "The health for THE THING.");
	
	if (g_Enabled)
	{
		// hook events
		HookEvent("player_death", OnPlayerDeath);
		HookEvent("round_start", OnRoundStart);
		HookEvent("round_end", OnRoundEnd);
		HookEvent("player_team", OnPlayerTeam);
	}
	
	RegConsoleCmd("sm_thing", OnSwitchThing, "Switches between THE THING and your normal self.");
}

/*
 * Generic Events
 */
public OnMapStart()
{
	if(!g_Enabled)
		return;
	
	
}

public OnClientPostAdminCheck(client)
{
	if(!g_Enabled)
		return;
	
	PrintToChat(client, "Welcome to THE THING.");
}

/*
 * Hooked Events
 */
public Action:OnRoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	// select a player to be THE THING
	new int:clients = GetClientCount();
	new int:thingIndex = GetRandomInt(1, clients);
	g_Thing = GetClientUserId(thingIndex);
	
	for (new i = 1; i <= clients; i++)
	{
		if (!IsClientConnected(i))
		{
			continue;
		}
		if (i == thingIndex)
		{
			PrintToChat(i, "You are THE THING!\nYour objective is to kill everyone else without being discovered.");
			PrintCenterText(i, "You are THE THING!");
			PrintHintText(i, "Kill everyone without being discovered.");
		}
		else
		{
			PrintToChat(i, "You are not THE THING.\nYour objective is to find and kill THE THING.");
			PrintCenterText(i, "You are not THE THING!");
			PrintHintText(i, "Find and kill THE THING.");
		}
	}
}

public Action:OnRoundEnd(Handle:event, const String:name[], bool:dontBroadcast)
{
	// logic for determining winner
	// display who won, THE THING or everyone else.
}

public Action:OnPlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	// check whether player is THE THING or not
	new victimId = GetEventInt(event, "userid");
	if (victimId == g_Thing)
	{
		// end round somehow
	}
	else
	{
		// say to everyone else that player X was killed
	}
}


public Action:OnPlayerTeam(Handle:event, const String:name[], bool:dontBroadcast)
{
	new int:team = GetEventInt(event, "team");
	
	if(team == FindTeamByName("T"))
	{
		CS_SwitchTeam(GetEventInt(event, "userid"), FindTeamByName("C"));
	}
}


public Action:OnSwitchThing(client, args)
{
	if(client == g_Thing)
	{
		// switch shit here
	}
	else
	{
		PrintToChat(client, "You are not THE THING!");
	}
}
