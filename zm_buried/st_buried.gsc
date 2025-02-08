#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\gametypes_zm\_weapons;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_blockers;
#include maps\mp\zm_buried_gamemodes;
#include maps\mp\zombies\_zm_ai_sloth;

init()
{
	level thread spawn_buildable_trigger((-135, 946, 19), "equip_turbine_zm", "^3Press &&1 for ^5Turbine"); // church
	if(getDvarInt("SetupBuried"))
	{
		level thread spawn_buildable_trigger((-327, 751, 140), "equip_subwoofer_zm", "^3Press &&1 for ^5Subwoofer", 0); // jug
		level thread spawn_buildable_trigger((662, -1124, 47), "equip_springpad_zm", "^3Press &&1 for ^5Springpad", 1); // saloon
	}
	else
	{
		level thread spawn_buildable_trigger((-327, 751, 140), "equip_springpad_zm", "^3Press &&1 for ^5Springpad", 0); // jug
		level thread spawn_buildable_trigger((662, -1124, 47), "equip_subwoofer_zm", "^3Press &&1 for ^5Subwoofer", 1); // saloon
	}

    
	flag_wait("initial_blackscreen_passed");
	deleteSlothBarricade( "juggernaut_alley" );
}


spawn_buildable_trigger(origin, build, string, limit)
{
	trigger = spawn("trigger_radius", origin, 40, 70, 140);
	trigger.targetname = "shield_trigger";
	trigger SetCursorHint("HINT_NOICON");
	trigger SetHintString(string);
	while(true)
	{
		trigger waittill( "trigger", player);
		if( player UseButtonPressed() )
			if(!isdefined(limit))
			{
				if( !player hasWeapon( build ) )
					player equipment_buy( build );
			}
			else
				if(player.origin[limit] < origin[limit])
				{
					if( !player hasWeapon( build ) )
						player equipment_buy( build );
				}


		wait 0.1;
	}
}