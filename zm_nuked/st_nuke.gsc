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
#include maps\mp\zm_tomb_vo;
#include maps\mp\zm_tomb_main_quest;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zm_tomb_craftables;
#include maps\mp\zm_tomb_challenges;
#include maps\mp\zm_tomb_capture_zones;
#include maps\mp\zm_nuked_perks;


init()
{
    level thread checkpaplocation();
    thread bring_perks();
}

bring_perks()
{
    machines = [];
    machine_triggers = [];
    machines[0] = getent( "vending_revive", "targetname" );
    machine_triggers[0] = getent( "vending_revive", "target" );
    machines[1] = getent( "vending_doubletap", "targetname" );
    machine_triggers[1] = getent( "vending_doubletap", "target" );
    machines[2] = getent( "vending_sleight", "targetname" );
    machine_triggers[2] = getent( "vending_sleight", "target" );
    machines[3] = getent( "vending_jugg", "targetname" );
    machine_triggers[3] = getent( "vending_jugg", "target" );
    machine_triggers[4] = getent( "specialty_weapupgrade", "script_noteworthy" );
    machines[4] = getent( machine_triggers[4].target, "targetname" );

	for(i = 0; i < machines.size; i++)
		bring_perk(machines[i], machine_triggers[i]);
}


checkpaplocation()
{
	if(!getDvarInt("perkrng"))
	{
		wait 1;
		if(level.players.size > 1)
		wait 4;
		pap = getent( "specialty_weapupgrade", "script_noteworthy" );
		jug = getent( "vending_jugg", "targetname" );
		if(pap.origin[0] > -1700 || jug.origin[0] > -1700)
			level.players[0] notify ("menuresponse", "", "restart_level_zm");
	}
}