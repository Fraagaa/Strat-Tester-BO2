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

#include scripts\zm\strattester\box;
#include scripts\zm\strattester\bus;
#include scripts\zm\strattester\ismap;

main()
{
	replacefunc(maps\mp\zm_transit_bus::busschedule, ::print_busschedule);
	replaceFunc(maps\mp\zombies\_zm_ai_screecher::screecher_spawning_logic, ::screecher_spawning_logic);
}

init()
{
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

strattesterprint(message)
{
	foreach(player in level.players)
		player iprintln("^5[^6Strat Tester^5]^7 " + message);
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