#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_utility; 
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zm_transit_bus;

#include scripts\zm\st;

main()
{
	replacefunc(maps\mp\zm_transit_bus::busschedule, ::print_busschedule);
	replaceFunc(maps\mp\zombies\_zm_ai_screecher::screecher_spawning_logic, ::screecher_spawning_logic);
}

init()
{
    level thread readChat();

    if(!istranzit())
        level thread raygun_counter();

    if(istranzit())
    while(true)
    {
        level waittill("connecting", player);
        if(!isdefined(player.bustimer))
            player thread busloc();
    }
}


busloc()
{
	level.busloc.hidewheninmenu = true;
    level.busloc = createserverfontstring( "objective", 1.3 );
    level.busloc.y = 20;
    level.busloc.x = 0;
    level.busloc.fontscale = 1;
    level.busloc.alignx = "center";
    level.busloc.horzalign = "user_center";
    level.busloc.vertalign = "user_top";
    level.busloc.aligny = "top";
    level.busloc.alpha = 1;
    level.busloc.label = " ";
    
	self.bustimer = newclienthudelem(self);
	self.bustimer.alpha = 1;
	self.bustimer.color = (0.505, 0.478, 0.721);
	self.bustimer.hidewheninmenu = 1;
	self.bustimer.fontscale = 1.7;
	self.bustimer settimerup(0);
    self.bustimer.alignx = "right";
    self.bustimer.aligny = "top";
    self.bustimer.horzalign = "user_right";
    self.bustimer.vertalign = "user_top";
    self.bustimer.x = -1;
    self.bustimer.y = 43;
	
    while(true)
    {
        wait 0.1;
        self.bustimer.alpha = getDvarInt("bustimer");
        level.busloc.alpha = getDvarInt("busloc");
        zone = level.the_bus get_current_zone();
        if(!isdefined(zone))
            continue;
        switch (zone)
        {
            case "zone_pri": name = "Bus Depot"; break;
            case "zone_pri2": name = "Bus Depot Hallway"; break;
            case "zone_station_ext": name = "Outside Bus Depot"; self.bustimer settimerup(0); break;
            case "zone_trans_2b": name = "Fog After Bus Depot"; break;
            case "zone_trans_2": name = "Tunnel Entrance"; break;
            case "zone_amb_tunnel": name = "Tunnel"; break;
            case "zone_trans_3": name = "Tunnel Exit"; break;
            case "zone_roadside_west": name = "Outside Diner"; break;
            case "zone_gas": name = "Gas Station"; break;
            case "zone_roadside_east": name = "Outside Garage"; break;
            case "zone_trans_diner": name = "Fog Outside Diner"; break;
            case "zone_trans_diner2": name = "Fog Outside Garage"; break;
            case "zone_gar": name = "Garage"; break;
            case "zone_din": name = "Diner"; break;
            case "zone_diner_roof": name = "Diner Roof"; break;
            case "zone_trans_4": name = "Fog After Diner"; break;
            case "zone_amb_forest": name = "Forest"; break;
            case "zone_trans_10": name = "Outside Church"; break;
            case "zone_town_church": name = "Church"; break;
            case "zone_trans_5": name = "Fog Before Farm"; break;
            case "zone_far": name = "Outside Farm"; break;
            case "zone_far_ext": name = "Farm"; break;
            case "zone_brn": name = "Barn"; break;
            case "zone_farm_house": name = "Farmhouse"; break;
            case "zone_trans_6": name = "Fog After Farm"; break;
            case "zone_amb_cornfield": name = "Cornfield"; break;
            case "zone_cornfield_prototype": name = "Nacht"; break;
            case "zone_trans_7": name = "Upper Fog Before Power"; break;
            case "zone_trans_pow_ext1": name = "Fog Before Power"; break;
            case "zone_pow": name = "Outside Power Station"; break;
            case "zone_prr": name = "Power Station"; break;
            case "zone_pcr": name = "Power Control Room"; break;
            case "zone_pow_warehouse": name = "Warehouse"; break;
            case "zone_trans_8": name = "Fog After Power"; break;
            case "zone_amb_power2town": name = "Cabin"; break;
            case "zone_trans_9": name = "Fog Before Town"; break;
            case "zone_town_north": name = "North Town"; break;
            case "zone_tow": name = "Center Town"; break;
            case "zone_town_east": name = "East Town"; break;
            case "zone_town_west": name = "West Town"; break;
            case "zone_town_south": name = "South Town"; break;
            case "zone_bar": name = "Bar"; break;
            case "zone_town_barber": name = "Bookstore"; break;
            case "zone_ban": name = "Bank"; break;
            case "zone_ban_vault": name = "Bank Vault"; break;
            case "zone_tbu": name = "Below Bank"; break;
            case "zone_trans_11": name = "Fog After Town"; break;
            case "zone_amb_bridge": name = "Bridge"; break;
            default: break;
        }
        if(isdefined(name))
        level.busloc settext(name);
    }
}

print_busschedule()
{
    depot = randomintrange( 40, 180 );
    dinner = randomintrange( 40, 180 );
    farm = randomintrange( 40, 180 );
    power = randomintrange( 40, 180 );
    town = randomintrange( 40, 180 );
	if(getDvarInt("depart") >= 40 && getDvarInt("depart") <= 180)
    farm = getDvarInt("depart");

    level.busschedule = busschedulecreate();
    level.busschedule busscheduleadd( "depot", 0, depot, 19, 15 );
    level.busschedule busscheduleadd( "tunnel", 1, 10, 27, 5 );
    level.busschedule busscheduleadd( "diner", 0, dinner, 18, 20 );
    level.busschedule busscheduleadd( "forest", 1, 10, 18, 5 );
    level.busschedule busscheduleadd( "farm", 0, farm, 26, 25 );
    level.busschedule busscheduleadd( "cornfields", 1, 10, 23, 10 );
    level.busschedule busscheduleadd( "power", 0, power, 19, 15 );
    level.busschedule busscheduleadd( "power2town", 1, 10, 26, 5 );
    level.busschedule busscheduleadd( "town", 0, town, 18, 20 );
    level.busschedule busscheduleadd( "bridge", 1, 10, 23, 10 );

    println("Depot: " + depot);
    println("Dinner: " + dinner);
    println("Farm: " + farm);
    println("Power: " + power);
    println("Town: " + town);
}

busschedulecreate()
{
    schedule = spawnstruct();
    schedule.destinations = [];
    return schedule;
}

busscheduleadd( stopname, isambush, maxwaittimebeforeleaving, busspeedleaving, gasusage )
{
    assert( isdefined( stopname ) );
    assert( isdefined( isambush ) );
    assert( isdefined( maxwaittimebeforeleaving ) );
    assert( isdefined( busspeedleaving ) );
    destinationindex = self.destinations.size;
    self.destinations[destinationindex] = spawnstruct();
    self.destinations[destinationindex].name = stopname;
    self.destinations[destinationindex].isambush = isambush;
    self.destinations[destinationindex].maxwaittimebeforeleaving = maxwaittimebeforeleaving;
    self.destinations[destinationindex].busspeedleaving = busspeedleaving;
    self.destinations[destinationindex].gasusage = gasusage;
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
            case "!denizen": denizencase(); break;
			case "!busoff": case "!buson": busoffcase(); break;
            case "!depart": departcase(msg[1]); break;
            case "!busloc": setDvar("busloc", !getDvarInt("busloc")); break;
            case "!bustimer": setDvar("bustimer", !getDvarInt("bustimer")); break;
            case "!perma": permacase(player); break;
            case "!jug": jugcase(); break;
            case "!endround": case "!killhorde": case "!notarget": case "!tpc": case "!tp": case "!sph":case "!power": case "!boards": case "!doors": case "!round": case "!delay": case "!zone": case "!remaining": case "!weapons": case "!perks": case "!healthbar": case "!timer": case "!perkrng": case "!nuke":case "!max": case "!boxmove": case "!fog": break;
            default: strattesterprint("Unknown command ^1" + message); break;
        }
    }
}

departcase(time)
{
    setDvar("depart", time);
    if(time >= 40 && time <= 180)
        strattesterprint("Next game, bus will stop for " + time + " seconds on farm.");
    else
        strattesterprint("Bad input, try a number between 40 and 180");
}

jugcase()
{
    setDvar("jug", !getDvarInt("jug"));
    if(getDvarInt("jug"))
        strattesterprint("You will spawn with jug instead of speed cola");
    else
        strattesterprint("You will spawn with speed cola instead of speed jug");
}

istranzit()
{
	return (level.script == "zm_transit" && level.scr_zm_map_start_location == "transit" && level.scr_zm_ui_gametype_group == "zclassic");
}


busoffcase()
{
	if(!istranzit())
		return;
	if(!isdefined(level.the_bus.off))
		level.the_bus.off = false;
	if(level.the_bus.targetspeed != 0)
	{
		strattesterprint("Stopping Bus");
		level.the_bus.targetspeed = 0;
	}
	else
	{
		strattesterprint("Starting Bus");
		level.the_bus.targetspeed = 10;
	}
}

permacase(player)
{
    strattesterprint("Awarding perman perks to " + player.name);
    player thread award_permaperks_safe();
}

denizencase()
{
    if(!istranzit())
        return;
    if(level.zombie_ai_limit_screecher == 2)
    {
        strattesterprint("Denizens wont spwan");
        level.zombie_ai_limit_screecher = 0;
    }
    else
    {
        strattesterprint("Denizens will spwan");
        level.zombie_ai_limit_screecher = 2;
    }
}

screecher_spawning_logic()
{
    level endon( "intermission" );

    if ( level.intermission )
        return;

    if ( level.screecher_spawners.size < 1 )
        return;

    while ( true )
    {
        while ( !isdefined( level.zombie_screecher_locations ) || level.zombie_screecher_locations.size <= 0 )
            wait 0.1;

        while ( level.zombie_screecher_count >= level.zombie_ai_limit_screecher )
            wait 0.1;

        while ( getdvarint( #"scr_screecher_ignore_player" ) )
            wait 0.1;

        if (!flag("spawn_zombies"))
            flag_wait( "spawn_zombies" );

        valid_players_in_screecher_zone = 0;
        valid_players = [];

        while ( valid_players_in_screecher_zone <= 0 )
        {
            players = getplayers();
            valid_players_in_screecher_zone = 0;

            foreach (player in level.players)
            {
                if ( is_player_valid( player ) && player_in_screecher_zone( player ) && !isdefined( player.screecher ) )
                {
                    valid_players_in_screecher_zone++;
                    valid_players[valid_players.size] = player;
                }
            }

            if ( players.size == 1 )
            {
                if ( is_player_valid( players[0] ) && !player_in_screecher_zone( players[0] ) )
                    level.spawn_delay = 1;
            }

            wait 0.1;
        }

        if ( !isdefined( level.zombie_screecher_locations ) || level.zombie_screecher_locations.size <= 0 )
            continue;

        valid_players = array_randomize( valid_players );
        player_left_zone = 0;

        if ( isdefined( level.spawn_delay ) && level.spawn_delay )
        {
            spawn_points = get_array_of_closest( valid_players[0].origin, level.zombie_screecher_locations );
            spawn_point = undefined;

            if ( spawn_points.size >= 3 )
                spawn_point = spawn_points[2];
            else if ( spawn_points.size >= 2 )
                spawn_point = spawn_points[1];
            else if ( spawn_points.size >= 1 )
                spawn_point = spawn_points[0];

            if ( isdefined( spawn_point ) )
                playsoundatposition("zmb_vocals_screecher_spawn", spawn_point.origin);

            delay_time = gettime() + 5000;
            now_zone = getent( "screecher_spawn_now", "targetname" );

            while ( gettime() < delay_time )
            {
                in_zone = 0;

                if (valid_players[0] istouching(now_zone))
                    break;

                if (!is_player_valid( valid_players[0]))
                    break;

                if (player_in_screecher_zone(valid_players[0]))
                    in_zone = 1;

                if (!in_zone)
                {
                    player_left_zone = 1;
                    level.spawn_delay = 1;
                    break;
                }
                wait 0.1;
            }
        }

        if ( isdefined( player_left_zone ) && player_left_zone )
            continue;

        level.spawn_delay = 0;
        spawn_points = get_array_of_closest( valid_players[0].origin, level.zombie_screecher_locations );
        spawn_point = undefined;

        if ( !isdefined( spawn_points ) || spawn_points.size == 0 )
        {
            wait 0.1;
            continue;
        }

        if ( !isdefined( level.last_spawn ) )
        {
            level.last_spawn_index = 0;
            level.last_spawn = [];
            level.last_spawn[level.last_spawn_index] = spawn_points[0];
            level.last_spawn_index = 1;
            spawn_point = spawn_points[0];
        }
        else
        {
            foreach ( point in spawn_points )
            {
                if ( point == level.last_spawn[0] )
                    continue;

                if ( isdefined( level.last_spawn[1] ) && point == level.last_spawn[1] )
                    continue;

                spawn_point = point;
                level.last_spawn[level.last_spawn_index] = spawn_point;
                level.last_spawn_index++;

                if ( level.last_spawn_index > 1 )
                    level.last_spawn_index = 0;

                break;
            }
        }

        if ( !isdefined( spawn_point ) )
            spawn_point = spawn_points[0];

        if ( isdefined( level.screecher_spawners ) )
        {
            spawner = random( level.screecher_spawners );
            ai = spawn_zombie( spawner, spawner.targetname, spawn_point );
        }

        if ( isdefined( ai ) )
        {
            ai.spawn_point = spawn_point;
			strattesterprint("^2Denizen Spawned!");
            level.zombie_screecher_count++;
        }

        wait( level.zombie_vars["zombie_spawn_delay"] );
        wait 0.1;
    }
}

strattesterprint(message)
{
	foreach(player in level.players)
		player iprintln("^5[^6Strat Tester^5]^7 " + message);
}


award_permaperks_safe()
{
	level endon("end_game");
	self endon("disconnect");

	while (!isalive(self))
		wait 0.05;

	wait 0.5;
    perks_to_process = [];
    
    perks_to_process[perks_to_process.size] = permaperk_array("revive");
    perks_to_process[perks_to_process.size] = permaperk_array("multikill_headshots");
    perks_to_process[perks_to_process.size] = permaperk_array("perk_lose");
    perks_to_process[perks_to_process.size] = permaperk_array("jugg", undefined, undefined, 15);
    perks_to_process[perks_to_process.size] = permaperk_array("flopper", array("zm_buried"));
    perks_to_process[perks_to_process.size] = permaperk_array("box_weapon", array("zm_highrise", "zm_buried"), array("zm_transit"));
    perks_to_process[perks_to_process.size] = permaperk_array("cash_back");
    perks_to_process[perks_to_process.size] = permaperk_array("sniper");
    perks_to_process[perks_to_process.size] = permaperk_array("insta_kill");
    perks_to_process[perks_to_process.size] = permaperk_array("pistol_points");
    perks_to_process[perks_to_process.size] = permaperk_array("double_points");

	foreach (perk in perks_to_process)
	{
		if( !(istranzit() && perk == permaperk_array("box_weapon", array("zm_highrise", "zm_buried"), array("zm_transit"))))
		self resolve_permaperk(perk);
		wait 0.05;
	}
	if(istranzit())
        level.pers_box_weapon_lose_round = 0;

	wait 0.5;
	self maps\mp\zombies\_zm_stats::uploadstatssoon();
}

permaperk_array(code, maps_award, maps_take, to_round)
{
	if (!isDefined(maps_award))
		maps_award = array("zm_transit", "zm_highrise", "zm_buried");
	if (!isDefined(maps_take))
		maps_take = [];
	if (!isDefined(to_round))
		to_round = 255;

	permaperk = [];
	permaperk["code"] = code;
	permaperk["maps_award"] = maps_award;
	permaperk["maps_take"] = maps_take;
	permaperk["to_round"] = to_round;

	return permaperk;
}

resolve_permaperk(perk)
{
	wait 0.05;

	perk_code = perk["code"];

	if (isinarray(perk["maps_award"], level.script) && !self.pers_upgrades_awarded[perk_code])
	{
		for (j = 0; j < level.pers_upgrades[perk_code].stat_names.size; j++)
		{
			stat_name = level.pers_upgrades[perk_code].stat_names[j];
			stat_value = level.pers_upgrades[perk_code].stat_desired_values[j];

			self award_permaperk(stat_name, perk_code, stat_value);
		}
	}

	if (isinarray(perk["maps_take"], level.script) && self.pers_upgrades_awarded[perk_code])
		self remove_permaperk(perk_code);
}


award_permaperk(stat_name, perk_code, stat_value)
{
	flag_set("permaperks_were_set");
	self.stats_this_frame[stat_name] = 1;
	self maps\mp\zombies\_zm_stats::set_global_stat(stat_name, stat_value);
	self playsoundtoplayer("evt_player_upgrade", self);
}

remove_permaperk(perk_code)
{
	self.pers_upgrades_awarded[perk_code] = 0;
	self playsoundtoplayer("evt_player_downgrade", self);
}