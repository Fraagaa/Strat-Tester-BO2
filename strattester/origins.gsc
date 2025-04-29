#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zm_tomb_main_quest;
#include maps\mp\zm_tomb_utility;
#include maps\mp\zm_tomb_challenges;
#include maps\mp\zm_tomb_capture_zones;

pack_a_punch_think()
{
	pack_a_punch_enable();
}

watch_staff_usage()
{
    self notify( "watch_staff_usage" );
    self endon( "watch_staff_usage" );
    self endon( "disconnect" );
    self setclientfieldtoplayer( "player_staff_charge", 0 );

    while ( true )
    {
        self waittill( "weapon_change", weapon );
        has_upgraded_staff = 0;
        has_revive_staff = 0;
        weapon_is_upgraded_staff = is_weapon_upgraded_staff( weapon );
        str_upgraded_staff_weapon = undefined;
        a_str_weapons = self getweaponslist();

        foreach ( str_weapon in a_str_weapons )
        {
            if ( is_weapon_upgraded_staff( str_weapon ) )
            {
                has_upgraded_staff = 1;
                str_upgraded_staff_weapon = str_weapon;
            }

            if ( str_weapon == "staff_revive_zm" )
                has_revive_staff = 1;
        }

        if ( !has_revive_staff || !weapon_is_upgraded_staff && "none" != weapon && "none" != weaponaltweaponname( weapon ) )
            self setactionslot( 3, "altmode" );
        else
            self setactionslot( 3, "weapon", "staff_revive_zm" );

        if ( weapon_is_upgraded_staff )
            self thread staff_charge_watch_wrapper( weapon );
    }
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
	level.stomp_hud = newclienthudelem(self);
	level.stomp_hud.alignx = "left";
	level.stomp_hud.aligny = "bottom";
	level.stomp_hud.horzalign = "user_left";
	level.stomp_hud.vertalign = "user_bottom";
	level.stomp_hud.x = 0;
	level.stomp_hud.y = -220;
	level.stomp_hud.fontscale = 1.6;
	level.stomp_hud.alpha = 0;
	level.stomp_hud.hidewheninmenu = 0;
	level.stomp_hud.hidden = 0;
	level.stomp_hud.label = &"^3Stomp: ^5";
	flag_wait("initial_blackscreen_passed");
	while(1)
	{
		level.stomp_hud setvalue(level.stompkills);
		wait(0.05);
	}
}

tanktracker()
{
	self endon("disconnect");
	level.tankkills = 0;
	level.tank_hud = newclienthudelem(self);
	level.tank_hud.alignx = "left";
	level.tank_hud.aligny = "bottom";
	level.tank_hud.horzalign = "user_left";
	level.tank_hud.vertalign = "user_bottom";
	level.tank_hud.x = level.tank_hud.x - 0;
	level.tank_hud.y = level.tank_hud.y - 180;
	level.tank_hud.fontscale = 1.6;
	level.tank_hud.alpha = 0;
	level.tank_hud.hidewheninmenu = 0;
	level.tank_hud.hidden = 0;
	level.tank_hud.label = &"^3Tank: ^5";
	flag_wait("initial_blackscreen_passed");
	while(1)
	{
		level.tank_hud setvalue(level.tankkills);
		wait(0.05);
	}
}

tumbletracker()
{
	self endon("disconnect");
	level.tumbles = 0;
	level.tumble_hud = newclienthudelem(self);
	level.tumble_hud.alignx = "left";
	level.tumble_hud.aligny = "bottom";
	level.tumble_hud.horzalign = "user_left";
	level.tumble_hud.vertalign = "user_bottom";
	level.tumble_hud.x = 0;
	level.tumble_hud.y = -200;
	level.tumble_hud.fontscale = 1.6;
	level.tumble_hud.alpha = 0;
	level.tumble_hud.hidewheninmenu = 0;
	level.tumble_hud.hidden = 0;
	level.tumble_hud.label = &"^3Tumble: ^5";
	flag_wait("initial_blackscreen_passed");
	while(1)
	{
		level.tumble_hud setvalue(level.tumbles);
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

custom_knockdown_zombie_animate_state()
{
	level.tumbles++;
	self endon("death");
	self.is_knocked_down = 1;
	self waittill_any("damage", "back_up");
	self.is_knocked_down = 0;
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