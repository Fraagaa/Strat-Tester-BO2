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

init()
{
	flag_wait("initial_blackscreen_passed");
	level thread spawn_buildable_trigger((3366, 9406, 1336), "alcatraz_shield_zm", "^3Press &&1 for ^5Shield"); // shield
	level.players[0] thread speeddoor();
	level.players[0] thread infinite_afterlifes();
	level thread readchat();
}

speeddoor()
{
	if(!getDvarInt("doors"))
		return;
	if(!getDvarInt("power"))
		return;
	flag_wait( "afterlife_start_over" );
	wait 1;
	self takeWeapon("raygun_mark2_upgraded_zm");
	self giveweapon("lightning_hands_zm");
	self switchToWeapon("lightning_hands_zm");
	self setOrigin((-536, 9513, 1336));
	self setPlayerAngles((0, 0, 0));
	wait 3;
	self setOrigin((3851, 9791, 1704));
	wait 0.5;
	self setOrigin((-1504, 5480, -71));
	self setPlayerAngles((0, -77, 0));
	wait 0.5;
	self setOrigin((-1064, 6263, 64));
	self setPlayerAngles((0, 10, 0));
	wait 0.5;
	self setOrigin((-316, 6886, 64));
	wait 0.5;
	self setOrigin((-530, 6545, 72));
	wait 0.5;
	self setOrigin((2127, 9552, 1450));
	wait 0.5;
	self setOrigin((-359, 9077, 1450));
	self setPlayerAngles((0, -170, 0));
	wait 0.5;
	self setOrigin((800, 8403, 1544));
	self setPlayerAngles((0, -90, 0));
	wait 0.5;
	self setOrigin((2050, 9566, 1336)); // cafe key
	wait 1;
	self setOrigin((-277, 9107, 1336));// office key
	wait 1;
	self setOrigin((1195, 10613, 1336));
	self TakeWeapon("lightning_hands_zm");
	self giveweapon("raygun_mark2_upgraded_zm");
}

spawn_buildable_trigger(origin, build, string)
{
	trigger = spawn("trigger_radius", origin, 40, 70, 140);
	trigger.targetname = "shield_trigger";
	trigger SetCursorHint("HINT_NOICON");
	trigger SetHintString(string);
	while(true)
	{
		trigger waittill( "trigger", player );
		if( player UseButtonPressed() )
			if( !player hasWeapon( build ) )
				player equipment_buy( build );

		if(!level.shield)
			trigger.origin = (0, -10000, 0);
		wait 0.1;
	}
}

equipment_buy( equipment )
{
    if ( isdefined( self.current_equipment ) && equipment != self.current_equipment )
        self equipment_drop( self.current_equipment );

    if ( ( equipment == "riotshield_zm" || equipment == "alcatraz_shield_zm" ) && isdefined( self.player_shield_reset_health ) )
        self [[ self.player_shield_reset_health ]]();
    else
        self player_set_equipment_damage( equipment, 0 );

    self equipment_give( equipment );
}



infinite_afterlifes()
{
	self endon( "disconnect" );
	while(true)
	{
		self waittill( "player_revived", reviver );
		wait 2;
		if(getDvarInt("lives"))
			self.lives++;
	}
}

readchat()
{
    self endon("end_game");
    while (true) 
    {
        level waittill("say", message, player);
        msg = strtok(tolower(message), " ");

        if(msg[0][0] != "!")
            continue;

        switch(msg[0])
        {
            case "!shield": shieldcase(); break;
            case "!lives": livescase(); break;
            case "!traptimer": setDvar("traptimer", !getDvarInt("traptimer")); break;
            case "!drops": case "!endround": case "!killhorde": case "!notarget": case "!tpc": case "!tp": case "!sph":case "!power": case "!boards": case "!doors": case "!round": case "!delay": case "!zone": case "!remaining": case "!weapons": case "!perks": case "!healthbar": case "!timer": case "!perkrng": case "!nuke":case "!max": case "!boxmove": case "!fog": break;
            default: strattesterprint("Unknown command ^1" + message); break;
        }
    }
}

shieldcase()
{
    setDvar("shield", !getDvarInt("shield"));
    if(getDvarInt("shield"))
        strattesterprint("restart the match to spawn with shield");
    else
        strattesterprint("restart the match to spawn without shield");
}

livescase()
{
    setDvar("lives", !getDvarInt("lives"));
    if(getDvarInt("lives"))
        strattesterprint("Infinite lives deactivated");
    else
        strattesterprint("Infinite lives activated");
}

strattesterprint(message)
{
	foreach(player in level.players)
		player iprintln("^5[^6Strat Tester^5]^7 " + message);
}