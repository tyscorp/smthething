#pragma semicolon 1

#include <sourcemod>
#include <cstrike>
#include <sdktools>
#include <colors>

#define PLUGIN_VERSION "0.0.2"

// ConVars
new Handle:hsm_thing_enabled;
new Handle:hsm_thing_weapon;
new Handle:hsm_thing_speed;
new Handle:hsm_thing_health;

// enable switch
new bool:g_Enabled = true;

new int:g_Thing = 1;
new bool:g_IsSwitchedToThing = false;
new String:g_ThingModel[101];

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
	
	RegConsoleCmd("sm_thing", OnSwitchThing);
}

/*
 * Generic Events
 */
public OnMapStart()
{
	if(!g_Enabled)
		return Plugin_Handled;
	
	return Plugin_Handled;
}

public OnClientPostAdminCheck(client)
{
	if(!g_Enabled)
		return Plugin_Handled;
	
	CPrintToChat(client, "Welcome to {red}THE THING{default}!");
	return Plugin_Handled;
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
	GetClientModel(g_Thing, g_ThingModel, 101);
	g_IsSwitchedToThing = false;
	for (new client = 1; client <= clients; client++)
	{
		if (!IsClientConnected(client))
		{
			continue;
		}
		if (client == thingIndex)
		{
			CPrintToChat(client, "You {green}are {red}THE THING{default}!\nYour objective is to kill everyone else without being discovered.");
			PrintCenterText(client, "You are THE THING!");
			PrintHintText(client, "Kill everyone without being discovered.");
		}
		else
		{
			CPrintToChat(client, "You are {green}not {red}THE THING{default}!\nYour objective is to find and kill {red}THE THING{default}.");
			PrintCenterText(client, "You are not THE THING!");
			PrintHintText(client, "Find and kill THE THING.");
		}

		new iWeapon;
		for(new i = CS_SLOT_PRIMARY; i <= CS_SLOT_C4; i++)
		{
			while((iWeapon = GetPlayerWeaponSlot(client, i)) != -1)
			{
				RemovePlayerItem(client, iWeapon);
				RemoveEdict(iWeapon);
			}
		}
		GivePlayerItem(client, "weapon_knife");	
		GivePlayerItem(client, "weapon_usp");	
		SetEntProp(client, Prop_Send, "m_ArmorValue", 100, 1);
	}
	
	return Plugin_Handled;
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
	
	return Plugin_Handled;
}


public Action:OnPlayerTeam(Handle:event, const String:name[], bool:dontBroadcast)
{
	new int:team = GetEventInt(event, "team");
	
	if(team == FindTeamByName("T"))
	{
	//	CS_SwitchTeam(GetClientOfUserId(GetEventInt(event, "userid")), FindTeamByName("C"));
	}
	
	return Plugin_Handled;
}


public Action:OnSwitchThing(client, args)
{
	if(GetClientUserId(client) == g_Thing)
	{
		if(g_IsSwitchedToThing)
		{
			g_IsSwitchedToThing = false;
			CPrintToChat(client, "You are now normal again.");
			//SetEntProp(client, Prop_Data, "m_iMaxHealth", nHealth);
			new health = GetClientHealth(client) / 4;
			SetEntityHealth(client, health);
			SetEntityHealth(client, health);
			new iWeapon;
			for(new i = CS_SLOT_PRIMARY; i <= CS_SLOT_C4; i++)
			{
				while((iWeapon = GetPlayerWeaponSlot(client, i)) != -1)
				{
					RemovePlayerItem(client, iWeapon);
					RemoveEdict(iWeapon);
				}
			}
			GivePlayerItem(client, "weapon_knife");	
			GivePlayerItem(client, "weapon_usp");
			SetEntData(client, FindSendPropOffs("CCSPlayer", "m_flLaggedMovementValue"), 1.0);
			SetEntityModel(client, g_ThingModel);
		}
		else
		{
			g_IsSwitchedToThing = true;
			CPrintToChat(client, "You have taken the form of {red}THE THING{default}!!!");
			new health = GetClientHealth(client) * 4;
			SetEntityHealth(client, health);
			SetEntityHealth(client, health);
			new iWeapon;
			for(new i = CS_SLOT_PRIMARY; i <= CS_SLOT_C4; i++)
			{
				while((iWeapon = GetPlayerWeaponSlot(client, i)) != -1)
				{
					RemovePlayerItem(client, iWeapon);
					RemoveEdict(iWeapon);
				}
			}
			GivePlayerItem(client, "weapon_knife");	
			GivePlayerItem(client, "weapon_usp");
			GivePlayerItem(client, "weapon_ak47");
			SetEntData(client, FindSendPropOffs("CCSPlayer", "m_flLaggedMovementValue"), 1.4);
			
			SetEntityModel(client, "npc_zombie");
		}
	}
	else
	{
		CPrintToChat(client, "You are not {red}THE THING{default}!");
	}
	
	return Plugin_Handled;
}
