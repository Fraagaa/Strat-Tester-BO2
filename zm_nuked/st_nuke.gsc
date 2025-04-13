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
#include maps\mp\zm_nuked_perks;

init()
{
    thread bring_perks();
    level thread checkpaplocation();
    level thread boxhits();
	level thread raygun_counter();
    level thread readchat();
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
            case "!endround": case "!killhorde": case "!notarget": case "!tpc": case "!tp": case "!sph":case "!power": case "!boards": case "!doors": case "!round": case "!delay": case "!zone": case "!remaining": case "!weapons": case "!perks": case "!healthbar": case "!timer": case "!perkrng": case "!nuke":case "!max": case "!boxmove": case "!fog": break;
            default: strattesterprint("Unknown command ^1" + message); break;
        }
    }
}

strattesterprint(message)
{
	foreach(player in level.players)
		player iprintln("^5[^6Strat Tester^5]^7 " + message);
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


boxhits()
{
    level thread displayBoxHits();
    while(true)
    {
        level waittill("connecting", player);
        player thread track_rays();
    }
}

track_rays()
{
    wait 2;
    while(true)
    {
        while(self.sessionstate != "playing")
            wait 0.1;
        if(self hasweapon("ray_gun_zm")) level.total_ray++;
        if(self hasweapon("raygun_mark2_zm")) level.total_mk2++;

        while(self has_weapon_or_upgrade("ray_gun_zm") || self has_weapon_or_upgrade("raygun_mark2_zm")) 
            wait 0.1;
        wait 0.1;
    }
}

displayBoxHits()
{
	level.boxhits.hidewheninmenu = true;
    level.boxhits = createserverfontstring( "objective", 1.3 );
    level.boxhits.y = 0;
    level.boxhits.x = 0;
    level.boxhits.fontscale = 1.4;
    level.boxhits.alignx = "center";
    level.boxhits.horzalign = "user_center";
    level.boxhits.vertalign = "user_top";
    level.boxhits.aligny = "top";
    level.boxhits.alpha = 0;
    level.boxhits.label = &"^3Box Hits: ^5";
    level.boxhits setvalue(0);
    level.total_chest_accessed_mk2 = 0;
    level.total_chest_accessed_ray = 0;
    level.boxhits.alignx = "left";
    level.boxhits.horzalign = "user_left";
    level.boxhits.x = 2;
    level.boxhits.alpha = 1;

    while(!isdefined(level.total_chest_accessed) || !isdefined(level.chest_accessed))
        wait 0.1;

    counter = 0;
    while(true)
    {
        if(counter != level.chest_accessed)
        {
            counter = level.chest_accessed;
            if(counter == 0) continue;

            level.total_chest_accessed++;

            if(count_for_raygun()) level.total_chest_accessed_ray++;
            if(count_for_mk2()) level.total_chest_accessed_mk2++;
            
            level.boxhits setvalue(level.total_chest_accessed);
        }
        wait 0.1;
    }
}

count_for_raygun()
{
    foreach(player in level.players)
        if (!player has_weapon_or_upgrade("ray_gun_zm"))
            return true;
    return false;
}
count_for_mk2()
{
    foreach(player in level.players)
        if(player has_weapon_or_upgrade("raygun_mark2_zm"))
            return false;
    return true;
}

raygun_counter()
{
    self endon("disconnect");

    if(!isDefined(level.total_mk2)) level.total_mk2 = 0;
    if(!isDefined(level.total_ray)) level.total_ray = 0;

	level.total_ray_display.hidewheninmenu = true;
    level.total_ray_display = createserverfontstring( "objective", 1.3 );
    level.total_ray_display.y = 26;
    level.total_ray_display.x = 2;
    level.total_ray_display.fontscale = 1.3;
    level.total_ray_display.alignx = "left";
    level.total_ray_display.horzalign = "user_left";
    level.total_ray_display.vertalign = "user_top";
    level.total_ray_display.aligny = "top";
    level.total_ray_display.alpha = 1;
	level.total_mk2_display.hidewheninmenu = true;
    level.total_mk2_display = createserverfontstring( "objective", 1.3 );
    level.total_mk2_display.y = 14;
    level.total_mk2_display.x = 2;
    level.total_mk2_display.fontscale = 1.3;
    level.total_mk2_display.alignx = "left";
    level.total_mk2_display.horzalign = "user_left";
    level.total_mk2_display.vertalign = "user_top";
    level.total_mk2_display.aligny = "top";
    level.total_mk2_display.alpha = 1;
    
    level.total_ray_display setvalue(0);
    level.total_mk2_display setvalue(0);

    while(true)
    {
        if(getDvarInt("avg"))
        {
            level.total_mk2_display.label = &"^3Raygun MK2 AVG: ^5";
            level.total_ray_display.label = &"^3Raygun AVG: ^5";
            if(isDefined(level.total_ray_display)) level.total_ray_display setvalue(level.total_chest_accessed_ray / level.total_ray);
            if(isDefined(level.total_mk2_display)) level.total_mk2_display setvalue(level.total_chest_accessed_mk2 / level.total_mk2);
        }
        else
        {
            level.total_mk2_display.label = &"^3Total Raygun MK2: ^5";
            level.total_ray_display.label = &"^3Total Raygun: ^5";
            if(isDefined(level.total_ray_display)) level.total_ray_display setvalue(level.total_ray);
            if(isDefined(level.total_mk2_display)) level.total_mk2_display setvalue(level.total_mk2);
        }
        wait 0.1;
    }
}