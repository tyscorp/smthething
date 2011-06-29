#pragma semicolon 1

#include <sourcemod>

#define PLUGIN_VERSION "0.0.1"

// ConVars
new Handle:sm_thing_enabled;
new Handle:sm_thing_weapon;
new Handle:sm_thing_speed;
new Handle:sm_thing_health;

// enable switch
new bool:g_Enabled = true;


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
	g_hEnabled = CreateConVar("sm_thing_enabled", "1", "Enables THE THING plugin.");
	g_hThingWeapon = CreateConVar("sm_thing_weapon", "m4a1", "The weapon for THE THING.");
	g_hThingSpeed = CreateConVar("sm_thing_speed", "2.0", "The speed for THE THING.");
	g_hThingHealth = CreateConVar("sm_thing_health", "200", "The health for THE THING.");
	
	if (g_Enabled)
	{
		// hook events
		HookEvent("player_spawn", Event_OnPlayerSpawn);
		HookEvent("player_death", Event_OnPlayerDeath);
		HookEvent("round_start", Event_OnRoundStart);
		HookEvent("round_end", Event_OnRoundEnd);
		HookEvent("player_team", Event_OnPlayerTeam);
		HookEvent("item_pickup", Event_OnItemPickup);
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


/*
 * Hooked Events
 */
public Action:OnSwitchThing(client, args)
{
	
}
