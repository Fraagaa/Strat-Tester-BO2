#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm;

#include scripts\zm\strattester\origins;
#include scripts\zm\strattester\buildables;

main()
{
	replacefunc(maps\mp\zm_tomb_giant_robot::zombie_stomp_death, ::custom_zombie_stomp_death);
	replacefunc(maps\mp\zm_tomb_tank::flamethrower_damage_zombies, ::custom_flamethrower_damage_zombies);
	replacefunc(maps\mp\zombies\_zm_weap_one_inch_punch::knockdown_zombie_animate_state, ::custom_knockdown_zombie_animate_state);
	replacefunc(maps\mp\zm_tomb_tank::tank_drop_powerups, ::tank_drop_powerups);
	replacefunc(maps\mp\zm_tomb_capture_zones::pack_a_punch_think, ::pack_a_punch_think);
	replacefunc(maps\mp\zm_tomb_utility::watch_staff_usage, ::watch_staff_usage);
    replaceFunc(maps\mp\zm_tomb_tank::tank_push_player_off_edge, ::tank_push_player_off_edge);
}

init()
{
	level thread enable_all_teleporters();
	level thread takeAllParts();
	level thread call_tank();
    thread wait_for_players();
    
	flag_wait("initial_blackscreen_passed");
	if(getDvarInt("shield"))
	{
		level thread spawn_buildable_trigger_shield((110, -3000, 60), "tomb_shield_zm", "^3Press &&1 for ^5Shield");
		level thread spawn_buildable_trigger_shield((2308, 689, -23), "tomb_shield_zm", "^3Press &&1 for ^5Shield");
	}

	foreach(player in level.players)
			for(i = 0; i < 6; i++)
				player maps\mp\zombies\_zm_challenges::increment_stat( "zc_zone_captures" );
	
	foreach (gen in getstructarray( "s_generator", "targetname" ))
	{
		if(gen.script_noteworthy == "generator_nml_right")
			continue;
		gen.n_current_progress = 100;
		gen players_capture_zone();
		level setclientfield( gen.script_noteworthy, gen.n_current_progress / 100 );
    	level setclientfield( "state_" + gen.script_noteworthy, 2 );
	}

	pack_a_punch_enable();

	takecraftableparts( "" );
    thread placeStaffsInChargers();
}

wait_for_players()
{
    while(true)
    {
        level waittill( "connected" , player);
        player thread connected_st();
    }
}

connected_st()
{
    self endon( "disconnect" );

    while(true)
    {
        self waittill( "spawned_player" );

		self thread stomptracker();
		self thread tanktracker();
		self thread tumbletracker();

		if(self == level.players[0])
			self tomb_give_equipment();
        
        wait 0.05;
    }
}


custom_flamethrower_damage_zombies(n_flamethrower_id, str_tag)
{
	self endon("flamethrower_stop_" + n_flamethrower_id);
	while(1)
	{
		a_targets = tank_flamethrower_get_targets(str_tag, n_flamethrower_id);
		foreach(ai_zombie in a_targets)
		{
			if(isalive(ai_zombie))
			{
				a_players = get_players_on_tank(1);
				if(a_players.size > 0)
				{
					level notify("vo_tank_flame_zombie");
				}
				if(str_tag == "tag_flash")
				{
					level.tankkills++;
					ai_zombie do_damage_network_safe(self, ai_zombie.health, "zm_tank_flamethrower", "MOD_BURNED");
					ai_zombie thread zombie_gib_guts();
				}
				else
				{
					ai_zombie thread maps\mp\zombies\_zm_weap_staff_fire::flame_damage_fx("zm_tank_flamethrower", self);
				}
				wait(0.05);
			}
		}
		wait_network_frame();
	}
}

tank_drop_powerups()
{
    flag_wait( "start_zombie_round_logic" );
    a_drop_nodes = [];

    for ( i = 0; i < 3; i++ )
    {
        drop_num = i + 1;
        a_drop_nodes[i] = getvehiclenode( "tank_powerup_drop_" + drop_num, "script_noteworthy" );
        a_drop_nodes[i].next_drop_round = 0;
        s_drop = getstruct( "tank_powerup_drop_" + drop_num, "targetname" );
        a_drop_nodes[i].drop_pos = s_drop.origin;
    }

    a_possible_powerups = array( "nuke", "full_ammo", "zombie_blood", "insta_kill", "fire_sale", "double_points" );

    while ( true )
    {
        self ent_flag_wait( "tank_moving" );

        foreach ( node in a_drop_nodes )
        {
            dist_sq = distance2dsquared( node.origin, self.origin );

            if ( dist_sq < 250000 )
            {
                a_players = get_players_on_tank( 1 );

                if ( a_players.size > 0 )
                {
                    if (level.round_number >= node.next_drop_round )
                    {
                        str_powerup = random( a_possible_powerups );
                        level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop( str_powerup, node.drop_pos );
                        node.next_drop_round = level.round_number + randomintrange( 8, 12 );
                        continue;
                    }

                    level notify( "sam_clue_tank", self );
                }
            }
        }

        wait 2.0;
    }
}

fixed_tank_push_player_off_edge()
{
    return;
}