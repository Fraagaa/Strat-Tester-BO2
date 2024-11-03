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
#include maps\mp\ombies\_zm_equipment;

main()
{
	replacefunc(maps\mp\zm_tomb_giant_robot::zombie_stomp_death, ::custom_zombie_stomp_death);
	replacefunc(maps\mp\zm_tomb_tank::flamethrower_damage_zombies, ::custom_flamethrower_damage_zombies);
	replacefunc(maps\mp\zombies\_zm_weap_one_inch_punch::knockdown_zombie_animate_state, ::custom_knockdown_zombie_animate_state);
	replacefunc(maps\mp\zm_tomb_tank::tank_drop_powerups, ::tank_drop_powerups);
	replacefunc(maps\mp\zombies\_zm_utility::get_player_weapon_limit, ::new_weapon_limit);
}

init()
{
	level thread enable_all_teleporters();
	level thread takeAllParts();
	level thread activateGenerators();
	level thread call_tank();
	level thread spawn_buildable_trigger((110, -3000, 60), "tomb_shield_zm", "^3Press &&1 for ^5Shield");
    thread wait_for_players();
    
	flag_wait("initial_blackscreen_passed");
    foreach(player in level.players)
        for(i = 0; i < 6; i++)
            player maps\mp\zombies\_zm_challenges::increment_stat( "zc_zone_captures" );
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

changecraftableoption( index )
{
	foreach (craftable in level.a_uts_craftables)
		if (craftable.equipname == "open_table")
			craftable thread setcraftableoption( index );
}

setcraftableoption( index )
{
	self endon("death");

	while (self.a_uts_open_craftables_available.size <= 0)
		wait 0.05;

	if (self.a_uts_open_craftables_available.size > 1)
	{
		self.n_open_craftable_choice = index;
		self.equipname = self.a_uts_open_craftables_available[self.n_open_craftable_choice].equipname;
		self.hint_string = self.a_uts_open_craftables_available[self.n_open_craftable_choice].hint_string;
		foreach (trig in self.playertrigger)
			trig sethintstring( self.hint_string );
	}
}


takecraftableparts( buildable )
{
	player = get_players()[ 0 ];
	foreach (stub in level.zombie_include_craftables)
    {
        foreach (piece in stub.a_piecestubs)
        {
            piecespawn = piece.piecespawn;
            if ( isDefined( piecespawn ) && buildable == "gramaphone" )
                player player_take_piece_gramophone( piecespawn );
            else
                player player_take_piece(piecespawn);
        }
    }
			return;
}

get_craftable_piece( str_craftable, str_piece )
{
	foreach (uts_craftable in level.a_uts_craftables)
		if ( uts_craftable.craftablestub.name == str_craftable )
			foreach (piecespawn in uts_craftable.craftablespawn.a_piecespawns)
				if ( piecespawn.piecename == str_piece )
					return piecespawn;
	return undefined;
}

player_take_piece_gramophone( piecespawn )
{
	piecestub = piecespawn.piecestub;
	damage = piecespawn.damage;

	if ( isDefined( piecestub.onpickup ) )
		piecespawn [[ piecestub.onpickup ]]( self );

	piecespawn piece_unspawn();
	piecespawn notify( "pickup" );

	if ( isDefined( piecestub.is_shared ) && piecestub.is_shared )
		piecespawn.in_shared_inventory = 1;

	self adddstat( "buildables", piecespawn.craftablename, "pieces_pickedup", 1 );
}

player_take_piece( piecespawn )
{
	piecestub = piecespawn.piecestub;
	damage = piecespawn.damage;

	if ( isDefined( piecestub.onpickup ) )
		piecespawn [[ piecestub.onpickup ]]( self );

	if ( isDefined( piecestub.is_shared ) && piecestub.is_shared  && isDefined( piecestub.client_field_id ))
        level setclientfield( piecestub.client_field_id, 1 );

	else if ( isDefined( piecestub.client_field_state ) )
		self setclientfieldtoplayer( "craftable", piecestub.client_field_state );

	piecespawn piece_unspawn();
	piecespawn notify( "pickup" );

	if ( isDefined( piecestub.is_shared ) && piecestub.is_shared )
		piecespawn.in_shared_inventory = 1;

	self adddstat( "buildables", piecespawn.craftablename, "pieces_pickedup", 1 );
}

piece_unspawn()
{
	if ( isDefined( self.model ) )
		self.model delete();

	self.model = undefined;

	if ( isDefined( self.unitrigger ) )
		thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger( self.unitrigger );

	self.unitrigger = undefined;
}

remove_buildable_pieces( buildable_name )
{
	foreach (buildable in level.zombie_include_buildables)
	{
		if(IsDefined(buildable.name) && buildable.name == buildable_name)
		{
			pieces = buildable.buildablepieces;
			for(i = 0; i < pieces.size; i++)
				pieces[i] maps\mp\zombies\_zm_buildables::piece_unspawn();
			return;
		}
	}
}

enemies_ignore_equipments()
{
	equipment = getFirstArrayKey(level.zombie_include_equipment);
	while (isDefined(equipment))
	{
		maps\mp\zombies\_zm_equipment::enemies_ignore_equipment(equipment);
		equipment = getNextArrayKey(level.zombie_include_equipment, equipment);
	}
}

new_weapon_limit()
{
	return 3;
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

		wait 0.1;
	}
}

equipment_buy( equipment )
{
    if ( isdefined( self.current_equipment ) && equipment != self.current_equipment )
        self equipment_drop( self.current_equipment );

    if ( ( equipment == "riotshield_zm" || equipment == "alcatraz_shield_zm" || equipment == "tomb_shield_zm" ) && isdefined( self.player_shield_reset_health ) )
        self [[ self.player_shield_reset_health ]]();
    else
        self player_set_equipment_damage( equipment, 0 );

    self equipment_give( equipment );
}


enable_all_teleporters()
{
	flag_wait( "initial_blackscreen_passed" );
	flag_set( "activate_zone_chamber" );
	while(1)
	{
		if ( level.zones[ "zone_nml_18" ].is_enabled && !isDefined(gramo))
		{
			a_door_main = getentarray( "chamber_entrance", "targetname" );
			array_thread( a_door_main, ::open_gramophone_door );
			gramo = 1;
		}
		if( level.zones[ "zone_air_stairs" ].is_enabled && !isDefined(air))
		{
			maps\mp\zm_tomb_teleporter::stargate_teleport_enable( 2 );
			air = 1;
		}
		if( level.zones[ "zone_fire_stairs" ].is_enabled && !isDefined(fire))
		{
			maps\mp\zm_tomb_teleporter::stargate_teleport_enable( 1 );
			fire = 1;
		}
		if( level.zones[ "zone_nml_farm" ].is_enabled && !isDefined(light))
		{
			maps\mp\zm_tomb_teleporter::stargate_teleport_enable( 3 );
			light = 1;
		}
		if( level.zones[ "zone_ice_stairs" ].is_enabled && !isDefined(ice))
		{
			maps\mp\zm_tomb_teleporter::stargate_teleport_enable( 4 );
			ice = 1;
		}
		if( isDefined(air) && isDefined(fire) && isDefined(light) && isDefined(ice) && isDefined(gramo) )
		{
			break;
		}
		wait 1;
	}
}

open_gramophone_door()
{
	flag_init( self.targetname + "_opened" );
	trig_position = getstruct( self.targetname + "_position", "targetname" );
	trig_position.has_vinyl = 0;
	trig_position.gramophone_model = undefined;
	t_door = tomb_spawn_trigger_radius( trig_position.origin, 60, 1 );
	t_door set_unitrigger_hint_string( &"ZOMBIE_BUILD_PIECE_MORE" );
	trig_position.gramophone_model = spawn( "script_model", trig_position.origin );
	trig_position.gramophone_model.angles = trig_position.angles;
	trig_position.gramophone_model setmodel( "p6_zm_tm_gramophone" );
	flag_set( "gramophone_placed" );
	//level setclientfield( "piece_record_zm_player", 0 );
	t_door trigger_off();
	str_song = trig_position get_gramophone_song();
	playsoundatposition( str_song, self.origin );
	self playsound( "zmb_crypt_stairs" );
	wait 6;
	chamber_blocker();
	flag_set( self.targetname + "_opened" );
	if ( isDefined( trig_position.script_flag ) )
	{
		flag_set( trig_position.script_flag );
	}
	level setclientfield( "crypt_open_exploder", 1 );
	self movez( -260, 10, 1, 1 );
	self waittill( "movedone" );
	self connectpaths();
	self delete();
	t_door tomb_unitrigger_delete();
	trig_position.trigger = undefined;
}


takeAllParts() 
{
    p = getPlayers()[0];
    foreach ( craftable in level.a_uts_craftables ) 
	{
        foreach ( piece in craftable.craftablespawn.a_piecespawns )
		{
            p player_take_piece(piece);
            wait 0.1;
        }
    }

    p player_drop_piece();

    level notify("allPartsTaken");
}

tomb_give_equipment()
{
	flag_wait( "start_zombie_round_logic" );
	self.dig_vars[ "has_shovel" ] = 1;
    self.dig_vars["has_upgraded_shovel"] = 1;
    self.dig_vars["has_helmet"] = 1;
	n_player = self getentitynumber() + 1;
	level setclientfield( "shovel_player" + n_player, 2 );
    level setclientfield( "helmet_player" + n_player, 1 );
}

activateGenerators() 
{
    a_s_generator = getstructarray("s_generator", "targetname");

    for (i = 0; i < a_s_generator.size; i++) 
	{
		if(a_s_generator[i].script_noteworthy == "generator_start_bunker")
			continue;
		if(a_s_generator[i].script_noteworthy == "generator_church")
			continue;
		if(a_s_generator[i].script_noteworthy == "generator_tank_trench")
			continue;
        a_s_generator[i].n_current_progress = 100;
        a_s_generator[i] handle_generator_capture();
    }
}

handle_generator_capture()
{
    level setclientfield( "zc_change_progress_bar_color", 0 );
    self show_zone_capture_objective( 0 );

    if ( self.n_current_progress == 100 )
    {
        self players_capture_zone();
        self kill_all_capture_zombies();
    }
    else if ( self.n_current_progress == 0 )
    {
        if ( self ent_flag( "player_controlled" ) )
        {
            self.sndent stoploopsound( 0.25 );
            self thread generator_deactivated_vo();
            self.is_playing_audio = 0;

            foreach ( player in get_players() )
            {
                player maps\mp\zombies\_zm_stats::increment_client_stat( "tomb_generator_lost", 0 );
                player maps\mp\zombies\_zm_stats::increment_player_stat( "tomb_generator_lost" );
            }
        }

        self set_zombie_controlled_area();

        if ( flag( "recapture_event_in_progress" ) && get_captured_zone_count() > 0 )
        {

        }
        else
            self kill_all_capture_zombies();
    }

    if ( get_contested_zone_count() == 0 )
        flag_clear( "zone_capture_in_progress" );
}

placeStaffsInChargers() 
{
    p = getPlayers()[0];
    for (i = 1; i <= 4; i++) {
        level notify("player_teleported", p, i);
        flag_set("charger_ready_" + i);
        wait 0.5;
    }
    foreach (staff in level.a_elemental_staffs) {        
        staff.charger.is_inserted = 1;
        maps\mp\zm_tomb_craftables::clear_player_staff( staff.weapname );
        staff.charge_trigger trigger_off();
        if ( isdefined( staff.charger.angles ) )
            staff.angles = staff.charger.angles;
        staff moveto( staff.charger.origin, 0.05 );
        staff waittill( "movedone" );
        staff setclientfield( "staff_charger", staff.enum );
        staff.charger.full = 0;
        staff show();
        staff playsound( "zmb_squest_charge_place_staff" );
        flag_set(staff.weapname + "_upgrade_unlocked");
        staff.charger.charges_received = 20;
    }
}


call_tank()
{
    str_loc = level.vh_tank.str_location_current;
    a_trigs = getentarray( "trig_tank_station_call", "targetname" );
    moving = level.vh_tank ent_flag( "tank_moving" );
    cooling = level.vh_tank ent_flag( "tank_cooldown" );

	foreach ( trig in a_trigs )
	{
		if ( moving )
		{
			trig setvisibletoall();
			trig sethintstring( &"ZM_TOMB_TNKM" );
			continue;
		}
		if ( cooling )
		{
			trig setvisibletoall();
			trig sethintstring( &"ZM_TOMB_TNKC" );
			continue;
		}
		trig setvisibletoall();
		trig sethintstring( &"ZM_TOMB_X2CT", 500 );
	}
	wait 0.1;
}

stomptracker()
{
	self endon("disconnect");
	level.stompkills = 0;
	stomp_hud = newclienthudelem(self);
	stomp_hud.alignx = "left";
	stomp_hud.aligny = "bottom";
	stomp_hud.horzalign = "user_left";
	stomp_hud.vertalign = "user_bottom";
	stomp_hud.x = stomp_hud.x - 0;
	stomp_hud.y = stomp_hud.y - 220;
	stomp_hud.fontscale = 1.6;
	stomp_hud.alpha = 0;
	stomp_hud.hidewheninmenu = 0;
	stomp_hud.hidden = 0;
	stomp_hud.label = &"^3Stomp: ^5";
	flag_wait("initial_blackscreen_passed");
	stomp_hud.alpha = 1;
	while(1)
	{
		stomp_hud setvalue(level.stompkills);
		wait(0.05);
	}
}

tanktracker()
{
	self endon("disconnect");
	level.tankkills = 0;
	tank_hud = newclienthudelem(self);
	tank_hud.alignx = "left";
	tank_hud.aligny = "bottom";
	tank_hud.horzalign = "user_left";
	tank_hud.vertalign = "user_bottom";
	tank_hud.x = tank_hud.x - 0;
	tank_hud.y = tank_hud.y - 180;
	tank_hud.fontscale = 1.6;
	tank_hud.alpha = 0;
	tank_hud.hidewheninmenu = 0;
	tank_hud.hidden = 0;
	tank_hud.label = &"^3Tank: ^5";
	flag_wait("initial_blackscreen_passed");
	tank_hud.alpha = 1;
	while(1)
	{
		tank_hud setvalue(level.tankkills);
		wait(0.05);
		tank_hud.alpha = getDvarInt("tank");
	}
}

tumbletracker()
{
	self endon("disconnect");
	level.tumbles = 0;
	tumble_hud = newclienthudelem(self);
	tumble_hud.alignx = "left";
	tumble_hud.aligny = "bottom";
	tumble_hud.horzalign = "user_left";
	tumble_hud.vertalign = "user_bottom";
	tumble_hud.x = tumble_hud.x - 0;
	tumble_hud.y = tumble_hud.y - 200;
	tumble_hud.fontscale = 1.6;
	tumble_hud.alpha = 0;
	tumble_hud.hidewheninmenu = 0;
	tumble_hud.hidden = 0;
	tumble_hud.label = &"^3Tumble: ^5";
	flag_wait("initial_blackscreen_passed");
	tumble_hud.alpha = 1;
	while(1)
	{
		tumble_hud setvalue(level.tumbles);
		wait(0.05);
	}
}

custom_zombie_stomp_death(robot, a_zombies_to_kill)
{
	n_interval = 0;
	for(i = 0; i < a_zombies_to_kill.size; i++)
	{
		zombie = a_zombies_to_kill[i];
		if(isdefined(zombie) && isalive(zombie))
		{
			zombie dodamage(zombie.health, zombie.origin, robot);
			level.stompkills++;
			n_interval++;
			if(n_interval >= 4)
			{
				wait_network_frame();
				n_interval = 0;
			}
		}
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

custom_knockdown_zombie_animate_state()
{
	level.tumbles++;
	self endon("death");
	self.is_knocked_down = 1;
	self waittill_any("damage", "back_up");
	self.is_knocked_down = 0;
}