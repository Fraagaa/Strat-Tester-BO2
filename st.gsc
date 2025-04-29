#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zm_transit_bus;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_audio_announcer;
#include maps\mp\zombies\_zm_blockers;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm_weapons;

main()
{
	replaceFunc(maps\mp\animscripts\zm_utility::wait_network_frame, ::base_game_network_frame);
	replaceFunc(maps\mp\zombies\_zm_utility::wait_network_frame, ::base_game_network_frame);
	replaceFunc(maps\mp\zombies\_zm_spawner::zombie_can_drop_powerups, ::zombie_can_drop_powerups);
	replaceFunc(maps\mp\zombies\_zm_ai_basic::find_flesh, ::find_flesh);
}

init()
{
    if(!isDefined(level.total_chest_accessed))
        level.total_chest_accessed = 0;
	level thread setdvars();
	level thread fix_highround();
    level thread turn_on_power();
    level thread set_starting_round();
    level thread remove_boards_from_windows();
	thread enable_cheats();
	level thread readChat();
    thread wait_for_players();
    
	flag_wait("initial_blackscreen_passed");
	level thread openAllDoors();
    level thread round_pause();
	setdvar("cg_ufo_scaler", 6);
}

wait_for_players()
{
    while(true)
    {
        level waittill("connected" , player);
        player thread connected_st();
        player thread fraga_connected();
    }
}

fraga_connected()
{
	self endon("disconnect");
	self waittill("spawned_player");

	self thread timer();
	self thread timerlocation();
	self thread trap_timer();
}


connected_st()
{
    self endon( "disconnect" );
	self waittill("spawned_player");
	stversion = 1.6;

    while(true)
    {
		if(!isdefined(self.zone_hud))
		{
			self iprintln("^6Strat Tester " + stversion);
			self iprintln("^5Made by BoneCrusher");
			self thread scanweapons();
			self thread health_bar_hud();
			self thread zone_hud();
			self thread zombie_remaining_hud();
			self thread st_sph();
			if(!isdefined(self.zone_hud))
				self.zone_hud = true;
		}
		self.score = 1000000;
		self thread give_weapons_on_spawn();
		self thread give_perks_on_spawn();
		self thread give_perks_on_revive();
        wait 0.05;
		self waittill("spawned_player");
    }
}

enable_cheats()
{
    setDvar( "sv_cheats", 1 );
	setDvar( "cg_ufo_scaler", 0.7 );

    if( level.player_out_of_playable_area_monitor && IsDefined( level.player_out_of_playable_area_monitor ) )
		self notify( "stop_player_out_of_playable_area_monitor" );

	level.player_out_of_playable_area_monitor = 0;
}

set_starting_round()
{
	level.round_number = getDvarInt( "round" );
	level.zombie_vars[ "zombie_spawn_delay" ] = 2;
	timer = level.zombie_vars["zombie_spawn_delay"];

	for ( i = 1; i <= level.round_number; i++ )
        {
            timer = level.zombie_vars["zombie_spawn_delay"];

            if ( timer > 0.08 )
            {
                level.zombie_vars["zombie_spawn_delay"] = timer * 0.95;
                continue;
            }

            if ( timer < 0.08 )
			{
                level.zombie_vars["zombie_spawn_delay"] = 0.08;
				break;
			}
        }

	level.zombie_move_speed = level.round_number * level.zombie_vars["zombie_move_speed_multiplier"];
}

zombie_spawn_wait()
{
	level endon("end_game");
	level endon( "reround" );

	setDvar("ai_disableSpawn", 1);

	wait getDvarInt("delay");

	setDvar("ai_disableSpawn", 0);
}

round_pause()
{   
	if(ismob())
	flag_wait( "afterlife_start_over" );


	level.countdown_hud = create_simple_hud();
	level.countdown_hud.alignx = "center";
	level.countdown_hud.aligny = "center";
	level.countdown_hud.horzalign = "user_center";
	level.countdown_hud.vertalign = "user_center";
	level.countdown_hud.fontscale = 24;
	level.countdown_hud setshader( "hud_chalk_1", 64, 64 );
	level.countdown_hud FadeOverTime( 2.0 );
	level.countdown_hud.color = ( 0.21, 0, 0 );
	level.countdown_hud.alpha = 1;
	wait 2;
	level thread zombie_spawn_wait();

	for(delay = getDvarInt("delay"); delay > 0; delay--)
	{
		wait 1;
		level.countdown_hud SetValue(delay);
	}

	level.countdown_hud FadeOverTime( 1.0 );
	level.countdown_hud.color = (1,1,1);
	level.countdown_hud.alpha = 0;
	wait( 1.0 );
	
	foreach(player in level.players)
		player.round_timer settimerup(0);
	level.countdown_hud destroy_hud();
}

remove_boards_from_windows()
{
	if(!getDvarInt("boards"))
		return;

	flag_wait( "initial_blackscreen_passed" );

	maps\mp\zombies\_zm_blockers::open_all_zbarriers();
}

turn_on_power()
{
	if(!getDvarInt("power"))
		return;

	flag_wait( "initial_blackscreen_passed" );
	wait 5;
	trig = getEnt( "use_elec_switch", "targetname" );
	powerSwitch = getEnt( "elec_switch", "targetname" );
	powerSwitch notSolid();
	trig setHintString( &"ZOMBIE_ELECTRIC_SWITCH" );
	trig setVisibleToAll();
	trig notify( "trigger", self );
	trig setInvisibleToAll();
	powerSwitch rotateRoll( -90, 0, 3 );
	level thread maps\mp\zombies\_zm_perks::perk_unpause_all_perks();
	powerSwitch waittill( "rotatedone" );
	flag_set( "power_on" );
	level setClientField( "zombie_power_on", 1 ); 
}

give_perks_on_revive()
{
    if(!getDvarInt("perks"))
        return;

	level endon("end_game");
	self endon( "disconnect" );

	while(true)
	{
		self waittill( "player_revived", reviver );
        self give_perks_by_map();
		wait 2;
		self thread giveplayerdata();
	}
}

give_perks_on_spawn()
{
	if(!getDvarInt("perks"))
		return;

    level waittill("initial_blackscreen_passed");
    wait 0.5;
    self give_perks_by_map();
}

give_perks_by_map()
{
    if (isfarm())
        perks = array( "specialty_armorvest", "specialty_fastreload", "specialty_rof", "specialty_quickrevive" );
    if(istown() && !getDvarInt("jug"))
	{
        perks = array( "specialty_fastreload", "specialty_longersprint", "specialty_rof", "specialty_quickrevive" );
	}
	if(istown() && getDvarInt("jug"))
	{
        perks = array( "specialty_armorvest", "specialty_longersprint", "specialty_rof", "specialty_quickrevive" );
	}
    if (istranzit())
        perks = array( "specialty_armorvest", "specialty_longersprint", "specialty_fastreload", "specialty_quickrevive" );
    if(isnuketown())
        perks = array( "specialty_armorvest", "specialty_fastreload", "specialty_rof", "specialty_quickrevive" );
    if(isdierise())
        perks = array( "specialty_armorvest", "specialty_fastreload", "specialty_rof", "specialty_quickrevive" );
    if(ismob())
	{
        flag_wait( "afterlife_start_over" );
        perks = array( "specialty_armorvest", "specialty_fastreload", "specialty_rof", "specialty_grenadepulldeath" );
	}
    if(isburied())
        perks = array( "specialty_armorvest", "specialty_fastreload", "specialty_additionalprimaryweapon", "specialty_rof", "specialty_longersprint", "specialty_quickrevive" );
    if(isorigins())
		if(getDvarInt("cherry"))
        	perks = array( "specialty_armorvest", "specialty_fastreload", "specialty_additionalprimaryweapon", "specialty_flakjacket", "specialty_rof", "specialty_longersprint", "specialty_quickrevive", "specialty_grenadepulldeath" );
        else
        	perks = array( "specialty_armorvest", "specialty_fastreload", "specialty_additionalprimaryweapon", "specialty_flakjacket", "specialty_rof", "specialty_longersprint", "specialty_quickrevive" );

	self give_perks( perks );
}

give_perks( perk_array )
{
	foreach( perk in perk_array )
	{
		self give_perk( perk, 0 );
		wait 0.15;
	}
}

give_weapons_on_spawn()
{
	wait 2; // get mulekick
	if(!getDvarInt("weapons"))
		return;
	
    level waittill("initial_blackscreen_passed");

    if(isburied())
	{
		wait 1;
		self takeweapon("m1911_zm");
		wait 1;
		self giveweapon_nzv( "raygun_mark2_upgraded_zm" );
		self giveweapon_nzv( "m1911_upgraded_zm" );
		self giveweapon_nzv( "cymbal_monkey_zm" );
		self giveweapon_nzv( "claymore_zm" );
		self giveweapon_nzv( "tazer_knuckles_zm" );
		if(self == level.players[0])
		{
			self giveweapon_nzv( "slowgun_upgraded_zm" );
			self switchToWeapon( "slowgun_upgraded_zm" );
		}
	}
	if(isdierise())
	{
		self takeweapon("m1911_zm");
		if(self == level.players[0])
			self giveweapon_nzv( "slipgun_zm" );
		else
			self giveweapon_nzv( "m1911_upgraded_zm" );
		self giveweapon_nzv( "an94_upgraded_zm+mms" );
		self giveweapon_nzv( "cymbal_monkey_zm" );
		self giveweapon_nzv( "sticky_grenade_zm" );
		self giveweapon_nzv( "tazer_knuckles_zm" );
		self weapon_give( "claymore_zm", undefined, undefined, 0 );
		self giveweapon_nzv( "equip_springpad_zm" );
		self switchToWeapon( "slipgun_zm" );
	}
	if(isnuketown())
	{
		self takeweapon("m1911_zm");
		if(self == level.players[0])
			self giveweapon_nzv( "raygun_mark2_upgraded_zm" );
		else
			self giveweapon_nzv( "ray_gun_zm" );
		self giveweapon_nzv( "m1911_upgraded_zm" );
		self giveweapon_nzv( "cymbal_monkey_zm" );
	}
	if(ismob())
	{
		flag_wait( "afterlife_start_over" );
		self takeweapon("m1911_zm");
		if(self == level.players[0])
		{
			self giveweapon_nzv( "blundersplat_upgraded_zm" );
			self giveweapon_nzv( "raygun_mark2_upgraded_zm" );
		}
		else if(self == level.players[1])
		{
			self giveweapon_nzv( "blundersplat_upgraded_zm" );
			self giveweapon_nzv( "m1911_upgraded_zm" );
		}
		else if(self == level.players[2])
		{
			self giveweapon_nzv( "m1911_upgraded_zm" );
			self giveweapon_nzv( "uzi_zm" );
		}
		else if(self == level.players[3])
		{
			self giveweapon_nzv( "m1911_upgraded_zm" );
			self giveweapon_nzv( "uzi_zm" );
		}
		if(getDvarInt("shield"))
			self giveweapon_nzv( "alcatraz_shield_zm" );
		self giveweapon_nzv( "claymore_zm" );
		self giveweapon_nzv( "upgraded_tomahawk_zm" );
		self setclientfieldtoplayer( "upgraded_tomahawk_in_use", 1 );
	}
	if(isorigins())
	{
		self takeweapon("c96_zm");
		wait 1;
		self giveweapon_nzv( "sticky_grenade_zm" );
		self giveweapon_nzv( "cymbal_monkey_zm" );
		if(getDvarInt("shield"))
			self giveweapon_nzv( "tomb_shield_zm" );
		if(level.players.size == 1)
		{
			if(getDvarInt("wm"))
				self giveweapon( "m32_upgraded_zm" );
			else
				self giveweapon( "mp40_upgraded_zm" );
			self giveweapon( "raygun_mark2_upgraded_zm" );
			self equipment_take( "claymore_zm" );
			self weapon_give( "claymore_zm", undefined, undefined, 0 );
			self switchToWeapon( "mp40_upgraded_zm" );

			self setactionslot( 3, "weapon", "staff_revive_zm" );
			self giveweapon( "staff_revive_zm" );
			self givemaxammo( "staff_revive_zm" );
			if(getDvarInt("staff"))
			{
				self weapon_give( "staff_water_upgraded_zm", undefined, undefined, 0 );
				self switchToWeapon( "staff_water_upgraded_zm" );
			}
			else
			{
				if(cointoss())
				{
					self weapon_give( "staff_air_upgraded_zm", undefined, undefined, 0 );
					self switchToWeapon( "staff_air_upgraded_zm" );
				}
				else
				{
					self weapon_give( "staff_water_upgraded_zm", undefined, undefined, 0 );
					self switchToWeapon( "staff_water_upgraded_zm" );
				}
			}
		}
		else
		{
			if(self != level.players[0])
			self giveweapon( "mp40_upgraded_zm" );

			if(self == level.players[0])
			{	
				if(getDvarInt("wm"))
					self giveweapon( "m32_upgraded_zm" );
				else
					self giveweapon( "mp40_upgraded_zm" );

				self giveweapon( "raygun_mark2_upgraded_zm" );
			}
			else 
				self giveweapon( "c96_upgraded_zm" );

			self equipment_take( "claymore_zm" );
			self weapon_give( "claymore_zm", undefined, undefined, 0 );

			self setactionslot( 3, "weapon", "staff_revive_zm" );
			self giveweapon( "staff_revive_zm" );
			self givemaxammo( "staff_revive_zm" );
			level.players[0] weapon_give( "staff_air_upgraded_zm", undefined, undefined, 0 );
			level.players[1] weapon_give( "staff_water_upgraded_zm", undefined, undefined, 0 );
			level.players[2] weapon_give( "staff_fire_upgraded_zm", undefined, undefined, 0 );
			level.players[3] weapon_give( "staff_lightning_upgraded_zm", undefined, undefined, 0 );
			level.players[0] switchToWeapon( "staff_air_upgraded_zm" );
			level.players[1] switchToWeapon( "staff_water_upgraded_zm" );
			level.players[2] switchToWeapon( "staff_fire_upgraded_zm" );
			level.players[3] switchToWeapon( "staff_lightning_upgraded_zm" );
		}
	}
	if(istranzit())
	{
		self takeweapon("m1911_zm");
		self equipment_take( "claymore_zm" );
		self weapon_give( "claymore_zm", undefined, undefined, 0 );
		self giveweapon_nzv( "m16_gl_upgraded_zm" );
		self giveweapon_nzv( "m1911_upgraded_zm" );
		if(self == level.players[0])
			self giveweapon_nzv( "jetgun_zm" );
		self giveweapon_nzv( "emp_grenade_zm" );
		self giveweapon_nzv( "tazer_knuckles_zm" );
		if(self != level.players[0])
			giveweapon_nzv( "m1911_upgraded_zm" );
		
	}
	if(istown())
	{
		self takeweapon("m1911_zm");
		self giveweapon_nzv( "sticky_grenade_zm" );
		self giveweapon_nzv( "cymbal_monkey_zm" );
		self giveweapon_nzv( "tazer_knuckles_zm" );
		if(self == level.players[0])
			self giveweapon_nzv( "raygun_mark2_upgraded_zm" );
		else
			self giveweapon_nzv( "ray_gun_upgraded_zm" );
		self giveweapon_nzv( "m1911_upgraded_zm" );
	}
	if(isfarm() || isdepot())
	{
		self takeweapon("m1911_zm");
		self giveweapon_nzv( "cymbal_monkey_zm" );
		if(isfarm())
			self giveweapon_nzv( "tazer_knuckles_zm" );
		if(self == level.players[0])
			self giveweapon_nzv( "raygun_mark2_zm" );
		else
			self giveweapon_nzv( "ray_gun_zm" );
		self giveweapon_nzv( "qcw05_zm" );
	}
}

giveweapon_nzv( weapon )
{
	if( issubstr( weapon, "tomahawk_zm" ) && level.script == "zm_prison" )
	{
		self play_sound_on_ent( "purchase" );
		self notify( "tomahawk_picked_up" );
		level notify( "bouncing_tomahawk_zm_aquired" );
		self notify( "player_obtained_tomahawk" );
		if( weapon == "bouncing_tomahawk_zm" )
		{
			self.tomahawk_upgrade_kills = 0;
			self.killed_with_only_tomahawk = 1;
			self.killed_something_thq = 0;
		}
		else
		{
			self.tomahawk_upgrade_kills = 99;
			self.killed_with_only_tomahawk = 1;
			self.killed_something_thq = 1;
			self notify( "tomahawk_upgraded_swap" );
		}
		old_tactical = self get_player_tactical_grenade();
		if( old_tactical != "none" && IsDefined( old_tactical ) )
		{
			self takeweapon( old_tactical );
		}
		self set_player_tactical_grenade( weapon );
		self.current_tomahawk_weapon = weapon;
		gun = self getcurrentweapon();
		self disable_player_move_states( 1 );
		self giveweapon( "zombie_tomahawk_flourish" );
		self switchtoweapon( "zombie_tomahawk_flourish" );
		self waittill_any( "player_downed", "weapon_change_complete" );
		self switchtoweapon( gun );
		self enable_player_move_states();
		self takeweapon( "zombie_tomahawk_flourish" );
		self giveweapon( weapon );
		self givemaxammo( weapon );
		if( !(is_equipment( gun )) && !(is_placeable_mine( gun )) )
		{
			self switchtoweapon( gun );
			self waittill( "weapon_change_complete" );
		}
		else
		{
			primaryweapons = self getweaponslistprimaries();
			if( primaryweapons.size > 0 && IsDefined( primaryweapons ) )
			{
				self switchtoweapon( primaryweapons[ 0] );
				self waittill( "weapon_change_complete" );
			}
		}
		self play_weapon_vo( weapon );
	}
	else
	{
		if( issubstr( weapon, "staff_" ) && isorigins() )
		{
			if( issubstr( weapon, "_upgraded_zm" ) )
			{
				if( !(self hasweapon( "staff_revive_zm" )) )
				{
					self setactionslot( 3, "weapon", "staff_revive_zm" );
					self giveweapon( "staff_revive_zm" );
				}
				self givemaxammo( "staff_revive_zm" );
			}
			else
			{
				if( self hasweapon( "staff_revive_zm" ) )
				{
					self takeweapon( "staff_revive_zm" );
					self setactionslot( 3, "altmode" );
				}
			}
			self weapon_give( weapon, undefined, undefined, 0 );
		}
		else
		{
			if( self is_melee_weapon( weapon ) )
			{
				if( weapon == "bowie_knife_zm" || weapon == "tazer_knuckles_zm" )
				{
					// self give_melee_weapon_by_name( weapon );
					self give_melee_weapon_instant( weapon );
				}
				else
				{
					self play_sound_on_ent( "purchase" );
					gun = self getcurrentweapon();
					gun = self change_melee_weapon( weapon, gun );
					self giveweapon( weapon );
					if( !(is_equipment( gun )) && !(is_placeable_mine( gun )) )
					{
						self switchtoweapon( gun );
						self waittill( "weapon_change_complete" );
					}
					else
					{
						primaryweapons = self getweaponslistprimaries();
						if( primaryweapons.size > 0 && IsDefined( primaryweapons ) )
						{
							self switchtoweapon( primaryweapons[ 0] );
							self waittill( "weapon_change_complete" );
						}
					}
					self play_weapon_vo( weapon );
				}
			}
			else
			{
				if( self is_equipment( weapon ) )
				{
					self play_sound_on_ent( "purchase" );
					if( level.destructible_equipment.size > 0 && IsDefined( level.destructible_equipment ) )
					{
						i = 0;
						while( i < level.destructible_equipment.size )
						{
							equip = level.destructible_equipment[ i];
							if( equip.name == weapon && IsDefined( equip.name ) && equip.owner == self && IsDefined( equip.owner ) )
							{
								equip item_damage( 9999 );
								break;
							}
							else
							{
								if( equip.name == weapon && IsDefined( equip.name ) && weapon == "jetgun_zm" )
								{
									equip item_damage( 9999 );
									break;
								}
								else
								{
									i++;
								}
							}
							i++;
						}
					}
					self equipment_take( weapon );
					self equipment_buy( weapon );
					self play_weapon_vo( weapon );
				}
				else
				{
					if( self is_weapon_upgraded( weapon ) )
					{
						self weapon_give( weapon, 1, undefined, 0 );
					}
					else
					{
						self weapon_give( weapon, undefined, undefined, 0 );
					}
				}
			}
		}
	}
}

give_melee_weapon_instant( weapon_name )
{
	self giveweapon( weapon_name );
	gun = change_melee_weapon( weapon_name, "knife_zm" );
	if ( self hasweapon( "knife_zm" ) )
		self takeweapon( "knife_zm" );

    gun = self getcurrentweapon();
	if ( gun != "none" && !is_placeable_mine( gun ) && !is_equipment( gun ) )
		self switchtoweapon( gun );
}

zombie_remaining_hud()
{
	self endon( "disconnect" );
	level endon( "end_game" );

    self.zombie_counter_hud = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1.4 );
    self.zombie_counter_hud maps\mp\gametypes_zm\_hud_util::setPoint( "CENTER", "CENTER", "CENTER", 190 );
    self.zombie_counter_hud.alpha = 0;
    self.zombie_counter_hud.label = &"^3Zombies: ^5";
	self thread zombie_remaining_hud_watcher();

    while(true)
    {
        self.zombie_counter_hud setValue((maps\mp\zombies\_zm_utility::get_round_enemy_array().size + level.zombie_total));
        wait 0.05; 
    }
}

zombie_remaining_hud_watcher()
{	
	self endon("disconnect");
	level endon( "end_game" );

	while(true)
	{
		self.zombie_counter_hud.alpha = getDvarInt("remaining");
        wait 0.1;
	}
}

zone_hud()
{
	if(!getDvarInt("zone"))
		return;

	self endon("disconnect");

	x = 8;
	y = -130;
	if (isburied())
		y -= 25;
	if (isorigins())
		y -= 30;

	self.zone_hud = newClientHudElem(self);
	self.zone_hud.alignx = "left";
	self.zone_hud.aligny = "bottom";
	self.zone_hud.horzalign = "user_left";
	self.zone_hud.vertalign = "user_bottom";
	self.zone_hud.x = x;
	self.zone_hud.y = y;
	self.zone_hud.fontscale = 1.3;
	self.zone_hud.alpha = 0;
	self.zone_hud.color = ( 1, 1, 1 );
	self.zone_hud.hidewheninmenu = 1;

	flag_wait( "initial_blackscreen_passed" );

	self thread zone_hud_watcher(x, y);
}

zone_hud_watcher( x, y )
{	
	self endon("disconnect");
	level endon( "end_game" );

	prev_zone = "";
	while(true)
	{
		while( !getDvarInt("zone") )
			wait 0.1;

		self.zone_hud.alpha = 1;

		while( getDvarInt("zone") )
		{
			self.zone_hud.y = (y + (self.zone_hud_offset * !level.hud_health_bar ) );

			zone = self get_zone_name();
			if(prev_zone != zone)
			{
				prev_zone = zone;

				self.zone_hud fadeovertime(0.2);
				self.zone_hud.alpha = 0;
				wait 0.2;

				self.zone_hud settext(zone);

				self.zone_hud fadeovertime(0.2);
				self.zone_hud.alpha = 1;
				wait 0.15;
			}

			wait 0.05;
		}
		self.zone_hud.alpha = 0;
	}
}

get_zone_name()
{
	zone = self get_current_zone();
	if (!isDefined(zone))
		return "";

	name = "";
	if(isorigins())
		switch (zone)
		{
			case "zone_start": name = "Lower Laboratory"; break;
			case "zone_start_a": name = "Upper Laboratory"; break;
			case "zone_start_b": name = "Generator 1"; break;
			case "zone_bunker_1a": name = "Generator 3 Bunker 1"; break;
			case "zone_fire_stairs": name = "Fire Tunnel"; break;
			case "zone_bunker_1": name = "Generator 3 Bunker 2"; break;
			case "zone_bunker_3a": name = "Generator 3"; break;
			case "zone_bunker_3b": name = "Generator 3 Bunker 3"; break;
			case "zone_bunker_2a": name = "Generator 2 Bunker 1"; break;
			case "zone_bunker_2": name = "Generator 2 Bunker 2"; break;
			case "zone_bunker_4a": name = "Generator 2"; break;
			case "zone_bunker_4b": name = "Generator 2 Bunker 3"; break;
			case "zone_bunker_4c": name = "Tank Station"; break;
			case "zone_bunker_4d": name = "Above Tank Station"; break;
			case "zone_bunker_tank_c": name = "Generator 2 Tank Route 1"; break;
			case "zone_bunker_tank_c1": name = "Generator 2 Tank Route 2"; break;
			case "zone_bunker_4e": name = "Generator 2 Tank Route 3"; break;
			case "zone_bunker_tank_d": name = "Generator 2 Tank Route 4"; break;
			case "zone_bunker_tank_d1": name = "Generator 2 Tank Route 5"; break;
			case "zone_bunker_4f": name = "zone_bunker_4f"; break;
			case "zone_bunker_5a": name = "Workshop Downstairs"; break;
			case "zone_bunker_5b": name = "Workshop Upstairs"; break;
			case "zone_nml_2a": name = "No Man's Land Walkway"; break;
			case "zone_nml_2": name = "No Man's Land Entrance"; break;
			case "zone_bunker_tank_e": name = "Generator 5 Tank Route 1"; break;
			case "zone_bunker_tank_e1": name = "Generator 5 Tank Route 2"; break;
			case "zone_bunker_tank_e2": name = "zone_bunker_tank_e2"; break;
			case "zone_bunker_tank_f": name = "Generator 5 Tank Route 3"; break;
			case "zone_nml_1": name = "Generator 5 Tank Route 4"; break;
			case "zone_nml_4": name = "Generator 5 Tank Route 5"; break;
			case "zone_nml_0": name = "Generator 5 Left Footstep"; break;
			case "zone_nml_5": name = "Generator 5 Right Footstep Walkway"; break;
			case "zone_nml_farm": name = "Generator 5"; break;
			case "zone_nml_celllar": name = "Generator 5 Cellar"; break;
			case "zone_bolt_stairs": name = "Lightning Tunnel"; break;
			case "zone_nml_3": name = "No Man's Land 1st Right Footstep"; break;
			case "zone_nml_2b": name = "No Man's Land Stairs"; break;
			case "zone_nml_6": name = "No Man's Land Left Footstep"; break;
			case "zone_nml_8": name = "No Man's Land 2nd Right Footstep"; break;
			case "zone_nml_10a": name = "Generator 4 Tank Route 1"; break;
			case "zone_nml_10": name = "Generator 4 Tank Route 2"; break;
			case "zone_nml_7": name = "Generator 4 Tank Route 3"; break;
			case "zone_bunker_tank_a": name = "Generator 4 Tank Route 4"; break;
			case "zone_bunker_tank_a1": name = "Generator 4 Tank Route 5"; break;
			case "zone_bunker_tank_a2": name = "zone_bunker_tank_a2"; break;
			case "zone_bunker_tank_b": name = "Generator 4 Tank Route 6"; break;
			case "zone_nml_9": name = "Generator 4 Left Footstep"; break;
			case "zone_air_stairs": name = "Wind Tunnel"; break;
			case "zone_nml_11": name = "Generator 4"; break;
			case "zone_nml_12": name = "Generator 4 Right Footstep"; break;
			case "zone_nml_16": name = "Excavation Site Front Path"; break;
			case "zone_nml_17": name = "Excavation Site Back Path"; break;
			case "zone_nml_18": name = "Excavation Site Level 3"; break;
			case "zone_nml_19": name = "Excavation Site Level 2"; break;
			case "ug_bottom_zone": name = "Excavation Site Level 1"; break;
			case "zone_nml_13": name = "Generator 5 To Generator 6 Path"; break;
			case "zone_nml_14": name = "Generator 4 To Generator 6 Path"; break;
			case "zone_nml_15": name = "Generator 6 Entrance"; break;
			case "zone_village_0": name = "Generator 6 Left Footstep"; break;
			case "zone_village_5": name = "Generator 6 Tank Route 1"; break;
			case "zone_village_5a": name = "Generator 6 Tank Route 2"; break;
			case "zone_village_5b": name = "Generator 6 Tank Route 3"; break;
			case "zone_village_1": name = "Generator 6 Tank Route 4"; break;
			case "zone_village_4b": name = "Generator 6 Tank Route 5"; break;
			case "zone_village_4a": name = "Generator 6 Tank Route 6"; break;
			case "zone_village_4": name = "Generator 6 Tank Route 7"; break;
			case "zone_village_2": name = "Church"; break;
			case "zone_village_3": name = "Generator 6 Right Footstep"; break;
			case "zone_village_3a": name = "Generator 6"; break;
			case "zone_ice_stairs": name = "Ice Tunnel"; break;
			case "zone_bunker_6": name = "Above Generator 3 Bunker"; break;
			case "zone_nml_20": name = "Above No Man's Land"; break;
			case "zone_village_6": name = "Behind Church"; break;
			case "zone_chamber_0": name = "The Crazy Place Lightning Chamber"; break;
			case "zone_chamber_1": name = "The Crazy Place Lightning & Ice"; break;
			case "zone_chamber_2": name = "The Crazy Place Ice Chamber"; break;
			case "zone_chamber_3": name = "The Crazy Place Fire & Lightning"; break;
			case "zone_chamber_4": name = "The Crazy Place Center"; break;
			case "zone_chamber_5": name = "The Crazy Place Ice & Wind"; break;
			case "zone_chamber_6": name = "The Crazy Place Fire Chamber"; break;
			case "zone_chamber_7": name = "The Crazy Place Wind & Fire"; break;
			case "zone_chamber_8": name = "The Crazy Place Wind Chamber"; break;
			case "zone_robot_head": name = "Robot's Head"; break;
		}
	if(name != "")
		return name;
	if(isburied())
		switch (zone)
		{
			case "zone_start": name = "Processing"; break;
			case "zone_start_lower": name = "Lower Processing"; break;
			case "zone_tunnels_center": name = "Center Tunnels"; break;
			case "zone_tunnels_north": name = "Courthouse Tunnels 2"; break;
			case "zone_tunnels_north2": name = "Courthouse Tunnels 1"; break;
			case "zone_tunnels_south": name = "Saloon Tunnels 3"; break;
			case "zone_tunnels_south2": name = "Saloon Tunnels 2"; break;
			case "zone_tunnels_south3": name = "Saloon Tunnels 1"; break;
			case "zone_street_lightwest": name = "Outside General Store & Bank"; break;
			case "zone_street_lightwest_alley": name = "Outside General Store & Bank Alley"; break;
			case "zone_morgue_upstairs": name = "Morgue"; break;
			case "zone_underground_jail": name = "Jail Downstairs"; break;
			case "zone_underground_jail2": name = "Jail Upstairs"; break;
			case "zone_general_store": name = "General Store"; break;
			case "zone_stables": name = "Stables"; break;
			case "zone_street_darkwest": name = "Outside Gunsmith"; break;
			case "zone_street_darkwest_nook": name = "Outside Gunsmith Nook"; break;
			case "zone_gun_store": name = "Gunsmith"; break;
			case "zone_bank": name = "Bank"; break;
			case "zone_tunnel_gun2stables": name = "Stables To Gunsmith Tunnel 2"; break;
			case "zone_tunnel_gun2stables2": name = "Stables To Gunsmith Tunnel"; break;
			case "zone_street_darkeast": name = "Outside Saloon & Toy Store"; break;
			case "zone_street_darkeast_nook": name = "Outside Saloon & Toy Store Nook"; break;
			case "zone_underground_bar": name = "Saloon"; break;
			case "zone_tunnel_gun2saloon": name = "Saloon To Gunsmith Tunnel"; break;
			case "zone_toy_store": name = "Toy Store Downstairs"; break;
			case "zone_toy_store_floor2": name = "Toy Store Upstairs"; break;
			case "zone_toy_store_tunnel": name = "Toy Store Tunnel"; break;
			case "zone_candy_store": name = "Candy Store Downstairs"; break;
			case "zone_candy_store_floor2": name = "Candy Store Upstairs"; break;
			case "zone_street_lighteast": name = "Outside Courthouse & Candy Store"; break;
			case "zone_underground_courthouse": name = "Courthouse Downstairs"; break;
			case "zone_underground_courthouse2": name = "Courthouse Upstairs"; break;
			case "zone_street_fountain": name = "Fountain"; break;
			case "zone_church_graveyard": name = "Graveyard"; break;
			case "zone_church_main": name = "Church Downstairs"; break;
			case "zone_church_upstairs": name = "Church Upstairs"; break;
			case "zone_mansion_lawn": name = "Mansion Lawn"; break;
			case "zone_mansion": name = "Mansion"; break;
			case "zone_mansion_backyard": name = "Mansion Backyard"; break;
			case "zone_maze": name = "Maze"; break;
			case "zone_maze_staircase": name = "Maze Staircase"; break;
		}
	if(name != "")
		return name;
	if(isdierise())
	switch (zone)
		{
			case "zone_green_start": name = "Green Highrise Level 3b"; break;
			case "zone_green_escape_pod": name = "Escape Pod"; break;
			case "zone_green_escape_pod_ground": name = "Escape Pod Shaft"; break;
			case "zone_green_level1": name = "Green Highrise Level 3a"; break;
			case "zone_green_level2a": name = "Green Highrise Level 2a"; break;
			case "zone_green_level2b": name = "Green Highrise Level 2b"; break;
			case "zone_green_level3a": name = "Green Highrise Restaurant"; break;
			case "zone_green_level3b": name = "Green Highrise Level 1a"; break;
			case "zone_green_level3c": name = "Green Highrise Level 1b"; break;
			case "zone_green_level3d": name = "Green Highrise Behind Restaurant"; break;
			case "zone_orange_level1": name = "Upper Orange Highrise Level 2"; break;
			case "zone_orange_level2": name = "Upper Orange Highrise Level 1"; break;
			case "zone_orange_elevator_shaft_top": name = "Elevator Shaft Level 3"; break;
			case "zone_orange_elevator_shaft_middle_1": name = "Elevator Shaft Level 2"; break;
			case "zone_orange_elevator_shaft_middle_2": name = "Elevator Shaft Level 1"; break;
			case "zone_orange_elevator_shaft_bottom": name = "Elevator Shaft Bottom"; break;
			case "zone_orange_level3a": name = "Lower Orange Highrise Level 1a"; break;
			case "zone_orange_level3b": name = "Lower Orange Highrise Level 1b"; break;
			case "zone_blue_level5": name = "Lower Blue Highrise Level 1"; break;
			case "zone_blue_level4a": name = "Lower Blue Highrise Level 2a"; break;
			case "zone_blue_level4b": name = "Lower Blue Highrise Level 2b"; break;
			case "zone_blue_level4c": name = "Lower Blue Highrise Level 2c"; break;
			case "zone_blue_level2a": name = "Upper Blue Highrise Level 1a"; break;
			case "zone_blue_level2b": name = "Upper Blue Highrise Level 1b"; break;
			case "zone_blue_level2c": name = "Upper Blue Highrise Level 1c"; break;
			case "zone_blue_level2d": name = "Upper Blue Highrise Level 1d"; break;
			case "zone_blue_level1a": name = "Upper Blue Highrise Level 2a"; break;
			case "zone_blue_level1b": name = "Upper Blue Highrise Level 2b"; break;
			case "zone_blue_level1c": name = "Upper Blue Highrise Level 2c"; break;
		}
	if(name != "")
		return name;
	if(isnuketown())
	{
		switch (zone)
		{
			case "culdesac_yellow_zone": name = "Yellow House Middle"; break;
			case "culdesac_green_zone": name = "Green House Middle"; break;
			case "truck_zone": name = "Truck"; break;
			case "openhouse1_f1_zone": name = "Green House Downstairs"; break;
			case "openhouse1_f2_zone": name = "Green House Upstairs"; break;
			case "openhouse1_backyard_zone": name = "Green House Backyard"; break;
			case "openhouse2_f1_zone": name = "Yellow House Downstairs"; break;
			case "openhouse2_f2_zone": name = "Yellow House Upstairs"; break;
			case "openhouse2_backyard_zone": name = "Yellow House Backyard"; break;
			case "ammo_door_zone": name = "Yellow House Backyard Door"; break;
		}
	}
	if(name != "")
		return name;
	if(ismob())
		switch (zone)
		{
			case "zone_start": name = "D-Block"; break;
			case "zone_library": name = "Library"; break;
			case "zone_cellblock_west": name = "Cellblock 2nd Floor"; break;
			case "zone_cellblock_west_gondola": name = "Cellblock 3rd Floor"; break;
			case "zone_cellblock_west_gondola_dock": name = "Cellblock Gondola"; break;
			case "zone_cellblock_west_barber": name = "Michigan Avenue"; break;
			case "zone_cellblock_east": name = "Times Square"; break;
			case "zone_cafeteria": name = "Cafeteria"; break;
			case "zone_cafeteria_end": name = "Cafeteria End"; break;
			case "zone_infirmary": name = "Infirmary 1"; break;
			case "zone_infirmary_roof": name = "Infirmary 2"; break;
			case "zone_roof_infirmary": name = "Roof 1"; break;
			case "zone_roof": name = "Roof 2"; break;
			case "zone_cellblock_west_warden": name = "Sally Port"; break;
			case "zone_warden_office": name = "Warden's Office"; break;
			case "cellblock_shower": name = "Showers"; break;
			case "zone_citadel_shower": name = "Citadel To Showers"; break;
			case "zone_citadel": name = "Citadel"; break;
			case "zone_citadel_warden": name = "Citadel To Warden's Office"; break;
			case "zone_citadel_stairs": name = "Citadel Tunnels"; break;
			case "zone_citadel_basement": name = "Citadel Basement"; break;
			case "zone_citadel_basement_building": name = "China Alley"; break;
			case "zone_studio": name = "Building 64"; break;
			case "zone_dock": name = "Docks"; break;
			case "zone_dock_puzzle": name = "Docks Gates"; break;
			case "zone_dock_gondola": name = "Upper Docks"; break;
			case "zone_golden_gate_bridge": name = "Golden Gate Bridge"; break;
			case "zone_gondola_ride": name = "Gondola"; break;
			default: name = "Unknown Zone"; break;
		}
	if(name != "")
		return name;
	if(isorigins())
		switch (zone)
		{
			case "zone_start": name = "Lower Laboratory"; break;
			case "zone_start_a": name = "Upper Laboratory"; break;
			case "zone_start_b": name = "Generator 1"; break;
			case "zone_bunker_1a": name = "Generator 3 Bunker 1"; break;
			case "zone_fire_stairs": name = "Fire Tunnel"; break;
			case "zone_bunker_1": name = "Generator 3 Bunker 2"; break;
			case "zone_bunker_3a": name = "Generator 3"; break;
			case "zone_bunker_3b": name = "Generator 3 Bunker 3"; break;
			case "zone_bunker_2a": name = "Generator 2 Bunker 1"; break;
			case "zone_bunker_2": name = "Generator 2 Bunker 2"; break;
			case "zone_bunker_4a": name = "Generator 2"; break;
			case "zone_bunker_4b": name = "Generator 2 Bunker 3"; break;
			case "zone_bunker_4c": name = "Tank Station"; break;
			case "zone_bunker_4d": name = "Above Tank Station"; break;
			case "zone_bunker_tank_c": name = "Generator 2 Tank Route 1"; break;
			case "zone_bunker_tank_c1": name = "Generator 2 Tank Route 2"; break;
			case "zone_bunker_4e": name = "Generator 2 Tank Route 3"; break;
			case "zone_bunker_tank_d": name = "Generator 2 Tank Route 4"; break;
			case "zone_bunker_tank_d1": name = "Generator 2 Tank Route 5"; break;
			case "zone_bunker_4f": name = "zone_bunker_4f"; break;
			case "zone_bunker_5a": name = "Workshop Downstairs"; break;
			case "zone_bunker_5b": name = "Workshop Upstairs"; break;
			case "zone_nml_2a": name = "No Man's Land Walkway"; break;
			case "zone_nml_2": name = "No Man's Land Entrance"; break;
			case "zone_bunker_tank_e": name = "Generator 5 Tank Route 1"; break;
			case "zone_bunker_tank_e1": name = "Generator 5 Tank Route 2"; break;
			case "zone_bunker_tank_e2": name = "zone_bunker_tank_e2"; break;
			case "zone_bunker_tank_f": name = "Generator 5 Tank Route 3"; break;
			case "zone_nml_1": name = "Generator 5 Tank Route 4"; break;
			case "zone_nml_4": name = "Generator 5 Tank Route 5"; break;
			case "zone_nml_0": name = "Generator 5 Left Footstep"; break;
			case "zone_nml_5": name = "Generator 5 Right Footstep Walkway"; break;
			case "zone_nml_farm": name = "Generator 5"; break;
			case "zone_nml_celllar": name = "Generator 5 Cellar"; break;
			case "zone_bolt_stairs": name = "Lightning Tunnel"; break;
			case "zone_nml_3": name = "No Man's Land 1st Right Footstep"; break;
			case "zone_nml_2b": name = "No Man's Land Stairs"; break;
			case "zone_nml_6": name = "No Man's Land Left Footstep"; break;
			case "zone_nml_8": name = "No Man's Land 2nd Right Footstep"; break;
			case "zone_nml_10a": name = "Generator 4 Tank Route 1"; break;
			case "zone_nml_10": name = "Generator 4 Tank Route 2"; break;
			case "zone_nml_7": name = "Generator 4 Tank Route 3"; break;
			case "zone_bunker_tank_a": name = "Generator 4 Tank Route 4"; break;
			case "zone_bunker_tank_a1": name = "Generator 4 Tank Route 5"; break;
			case "zone_bunker_tank_a2": name = "zone_bunker_tank_a2"; break;
			case "zone_bunker_tank_b": name = "Generator 4 Tank Route 6"; break;
			case "zone_nml_9": name = "Generator 4 Left Footstep"; break;
			case "zone_air_stairs": name = "Wind Tunnel"; break;
			case "zone_nml_11": name = "Generator 4"; break;
			case "zone_nml_12": name = "Generator 4 Right Footstep"; break;
			case "zone_nml_16": name = "Excavation Site Front Path"; break;
			case "zone_nml_17": name = "Excavation Site Back Path"; break;
			case "zone_nml_18": name = "Excavation Site Level 3"; break;
			case "zone_nml_19": name = "Excavation Site Level 2"; break;
			case "ug_bottom_zone": name = "Excavation Site Level 1"; break;
			case "zone_nml_13": name = "Generator 5 To Generator 6 Path"; break;
			case "zone_nml_14": name = "Generator 4 To Generator 6 Path"; break;
			case "zone_nml_15": name = "Generator 6 Entrance"; break;
			case "zone_village_0": name = "Generator 6 Left Footstep"; break;
			case "zone_village_5": name = "Generator 6 Tank Route 1"; break;
			case "zone_village_5a": name = "Generator 6 Tank Route 2"; break;
			case "zone_village_5b": name = "Generator 6 Tank Route 3"; break;
			case "zone_village_1": name = "Generator 6 Tank Route 4"; break;
			case "zone_village_4b": name = "Generator 6 Tank Route 5"; break;
			case "zone_village_4a": name = "Generator 6 Tank Route 6"; break;
			case "zone_village_4": name = "Generator 6 Tank Route 7"; break;
			case "zone_village_2": name = "Church"; break;
			case "zone_village_3": name = "Generator 6 Right Footstep"; break;
			case "zone_village_3a": name = "Generator 6"; break;
			case "zone_ice_stairs": name = "Ice Tunnel"; break;
			case "zone_bunker_6": name = "Above Generator 3 Bunker"; break;
			case "zone_nml_20": name = "Above No Man's Land"; break;
			case "zone_village_6": name = "Behind Church"; break;
			case "zone_chamber_0": name = "The Crazy Place Lightning Chamber"; break;
			case "zone_chamber_1": name = "The Crazy Place Lightning & Ice"; break;
			case "zone_chamber_2": name = "The Crazy Place Ice Chamber"; break;
			case "zone_chamber_3": name = "The Crazy Place Fire & Lightning"; break;
			case "zone_chamber_4": name = "The Crazy Place Center"; break;
			case "zone_chamber_5": name = "The Crazy Place Ice & Wind"; break;
			case "zone_chamber_6": name = "The Crazy Place Fire Chamber"; break;
			case "zone_chamber_7": name = "The Crazy Place Wind & Fire"; break;
			case "zone_chamber_8": name = "The Crazy Place Wind Chamber"; break;
			case "zone_robot_head": name = "Robot's Head"; break;
		}
	if(name != "")
		return name;
	if(istranzit() || isdepot() || istown() || isfarm())
		switch (zone)
		{
			case "zone_pri": name = "Bus Depot"; break;
			case "zone_pri2": name = "Bus Depot Hallway"; break;
			case "zone_station_ext": name = "Outside Bus Depot"; break;
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
			case "zone_pow_ext1": name = "zone_pow_ext1"; break;
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
			case "zone_town_west2": name = "West Town2"; break;
			case "zone_town_south": name = "South Town"; break;
			case "zone_bar": name = "Bar"; break;
			case "zone_town_barber": name = "Bookstore"; break;
			case "zone_ban": name = "Bank"; break;
			case "zone_ban_vault": name = "Bank Vault"; break;
			case "zone_tbu": name = "Below Bank"; break;
			case "zone_trans_11": name = "Fog After Town"; break;
			case "zone_amb_bridge": name = "Bridge"; break;
			case "zone_trans_1": name = "Fog Before Bus Depot"; break;
			case "zone_bunker_4c": name = "Tank Station"; break;
			case "zone_bunker_4d": name = "Above Tank Station"; break;
		}
    return name;
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

health_bar_hud()
{
	level endon("end_game");
	self endon("disconnect");
	flag_wait("initial_blackscreen_passed");

	health_bar = self createprimaryprogressbar();
	health_bar.hidewheninmenu = 1;
	health_bar.bar.hidewheninmenu = 1;
	health_bar.barframe.hidewheninmenu = 1;
	health_bar_text = self createprimaryprogressbartext();
	health_bar_text.hidewheninmenu = 1;
	
	health_bar setpoint(undefined, "BOTTOM", 0, 5);
	health_bar_text setpoint(undefined, "BOTTOM", 75, 5);

	while(true)
	{
		if(!getDvarInt("healthbar"))
		{
			health_bar.alpha = 0;
			health_bar.bar.alpha = 0;
			health_bar.barframe.alpha = 0;
			health_bar_text.alpha = 0;
			while(!getDvarInt("healthbar"))
				wait 0.1;
		}
		if (isDefined(self.e_afterlife_corpse))
		{
			if (health_bar.alpha != 0)
			{
				health_bar.alpha = 0;
				health_bar.bar.alpha = 0;
				health_bar.barframe.alpha = 0;
				health_bar_text.alpha = 0;
			}
			
			wait 0.05;
			continue;
		}

		if (health_bar.alpha != 1)
		{
			health_bar.alpha = 1;
			health_bar.bar.alpha = 1;
			health_bar.barframe.alpha = 1;
			health_bar_text.alpha = 1;
		}

		health_bar updatebar (self.health / self.maxhealth);
		health_bar_text setvalue(self.health);
		health_bar.bar.color = (1 - self.health / self.maxhealth, self.health / self.maxhealth, 0);
		wait 0.05;
	}
}


timer()
{
	self endon("disconnect");

	self thread round_timer();
	self.timer = newclienthudelem(self);
	self.timer.alpha = !getDvarInt("st") * 0;
	self.timer.color = (1, 1, 1);
	self.timer.hidewheninmenu = 1;
	self.timer.fontscale = 1.7;
	flag_wait("initial_blackscreen_passed");
	while(true)
	{
		self.timer settimer( int(gettime() / 1000) - level.start_time);
		wait 0.05;
	}
}

round_timer()
{
	self endon("disconnect");

	self.round_timer = newclienthudelem(self);
	self.round_timer.alpha = 0;
	self.round_timer.fontscale = 1.7;
	self.round_timer.color = (0.8, 0.8, 0.8);
	self.round_timer.hidewheninmenu = 1;
	self.round_timer.x = self.timer.x;
	self.round_timer.y = self.timer.y + 15;
	flag_wait("initial_blackscreen_passed");
	level.fade_time = 0.2;

	while(1)
	{
		zombies_this_round = level.zombie_total + get_round_enemy_array().size;
		hordes = zombies_this_round / 24;
		dog_round = flag("dog_round");
		leaper_round = flag("leaper_round");
		self.round_timer settimerup(0);
		start_time = int(GetTime() / 1000);
		level waittill("end_of_round");
		end_time = int(GetTime() / 1000);
		time = end_time - start_time;
		self display_round_time(time, hordes, dog_round, leaper_round);
		level waittill("start_of_round");
		self.round_timer.label = &"";
		self.round_timer fadeovertime(level.fade_time);
		self.round_timer.alpha = 1;
	}
}

display_round_time(time, hordes, dog_round, leaper_round)
{
	timer_for_hud = time - 0.1;
	sph_off = 1;

	if(level.round_number > GetDvarInt("sph") && !dog_round && !leaper_round)
		sph_off = 0;
	self.round_timer.alpha = 1;
	if(sph_off)
	{
		for(i = 0; i < 228; i++)
		{
			self.round_timer settimer(timer_for_hud);
			wait(0.05);
		}
	}
	else
	{
		for(i = 0; i < 100; i++)
		{
			self.round_timer settimer(timer_for_hud);
			wait(0.05);
		}
		self.round_timer fadeovertime(level.fade_time);
		self.round_timer.alpha = 0;
		wait(level.fade_time * 2);
		self display_sph(time, hordes);
	}
}

display_sph(time, hordes)
{
	sph = time / hordes;
	self.round_timer fadeovertime(level.fade_time);
	self.round_timer.alpha = 1;
	self.round_timer.label = &"SPH: ";
	self.round_timer setvalue(sph);

	for(i = 0; i < 5; i++)
	{
		wait(1);
	}

	self.round_timer fadeovertime(level.fade_time);
	self.round_timer.alpha = 0;
	wait(level.fade_time);
}

timerlocation()
{
	self endon("disconnect");

	while(true)
	{
		switch(getDvarInt("timer"))
		{
			case 0:
				self.timer.alpha = !getDvarInt("st") * 0;
				self.round_timer.alpha = 0;
				break;
			case 1:
				self.round_timer.alignx = "right";
				self.round_timer.aligny = "top";
				self.round_timer.horzalign = "user_right";
				self.round_timer.vertalign = "user_top";
				self.timer.alignx = "right";
				self.timer.aligny = "top";
				self.timer.horzalign = "user_right";
				self.timer.vertalign = "user_top";
				self.timer.x = -1;
				self.timer.y = 13;
				self.timer.alpha = !getDvarInt("st") * 1;
				self.round_timer.alpha = 1;
				if(getDvar("cg_drawFPS") != "Off")
					self.timer.y += 4;
				if(getDvar("cg_drawFPS") != "Off" && GetDvar("language") == "japanese")
					self.timer.y += 10;
				if(ismob())
				{
					self.timer.y = 40;
					self.trap_timer.y = 19;
				}
				if(isdierise())
					self.timer.y = 30;
				break;
			case 2:
				self.round_timer.alignx = "left";
				self.round_timer.aligny = "top";
				self.round_timer.horzalign = "user_left";
				self.round_timer.vertalign = "user_top";
				self.timer.alignx = "left";
				self.timer.aligny = "top";
				self.timer.horzalign = "user_left";
				self.timer.vertalign = "user_top";
				self.timer.x = 1;
				self.timer.y = 0;
				self.timer.alpha = !getDvarInt("st") * 1;
				self.round_timer.alpha = 1;
				if(isorigins())
					self.timer.y = 45;
				if(issurvivalmap())
					self.timer.y = 40;
				if(isdierise() && level.springpad_hud.alpha != 0)
					self.timer.y = 10;
				if(isburied() && level.springpad_hud.alpha != 0)
					self.timer.y = 35;
				if(istranzit() && getDvarInt("bus"))
					self.timer.y = 21;
				if(istranzit() && getDvarInt("bus") && GetDvar("language") == "japanese")
					self.timer.y = 25;
				break;
			case 3:
				self.timer.alignx = "left";
				self.timer.aligny = "top";
				self.timer.horzalign = "user_left";
				self.timer.vertalign = "user_top";
				self.round_timer.alignx = "left";
				self.round_timer.aligny = "top";
				self.round_timer.horzalign = "user_left";
				self.round_timer.vertalign = "user_top";
				self.timer.x = 1;
				self.timer.y = 250;
				self.timer.alpha = !getDvarInt("st") * 1;
				self.round_timer.alpha = 1;
				break;
			case 4:
				self.round_timer.alignx = "right";
				self.round_timer.aligny = "top";
				self.round_timer.horzalign = "user_right";
				self.round_timer.vertalign = "user_top";
				self.timer.alignx = "right";
				self.timer.aligny = "top";
				self.timer.horzalign = "user_right";
				self.timer.vertalign = "user_top";
				self.timer.x = -170;
				self.timer.y = 415;
				self.timer.alpha = !getDvarInt("st") * 1;
				self.round_timer.alpha = 1;
				break;

			default: break;
		}
		self.round_timer.x = self.timer.x;
		self.round_timer.y = self.timer.y + 15;
		
		wait 0.1;
		if(GetDvar("language") == "japanese")
		{
			self.timer.fontscale = 1.5;
			self.round_timer.fontscale = self.timer.fontscale;
		}
	}
}


fix_highround()
{
	if(level.script == "zm_tomb")
		return;
	while(level.round_number > 155)
	{
		zombies = getaiarray("axis");
		i = 0;
		while(i < zombies.size)
		{
			if(zombies[i].targetname != "zombie")
			{
				continue;
			}
			if(zombies[i].targetname == "zombie")
			{
				if(!isdefined(zombies[i].health_override))
				{
					zombies[i].health_override = 1;
					zombies[i].health = 1044606723;
				}
			}
			i++;
		}
		wait(0.1);
	}
}

base_game_network_frame()
{
    if (level.players.size == 1)
        wait 0.1;
    else if (numremoteclients())
    {
        snapshot_ids = getsnapshotindexarray();

        for (acked = undefined; !isdefined(acked); acked = snapshotacknowledged(snapshot_ids))
            level waittill("snapacknowledged");
    }
    else
        wait 0.1;
}

setDvars()
{
    setdvar("sv_cheats", 0 );
    setdvar("player_strafeSpeedScale", 1 );
    setdvar("player_backSpeedScale", 1 );
    setdvar("r_dof_enable", 0 );

	createDvar("healthbar", 0);
	createDvar("timer", 1);
	createDvar("zone", 1);
	createDvar("remaining", 1);
	createDvar("weapons", 1);
	createDvar("doors", 1);
	createDvar("perks", 1);
	createDvar("power", 1);
	createDvar("boards", 1);
	createDvar("delay", 60);
	createDvar("round", 100);
	createDvar("sph", 1);
	createDvar("remove_drops", 0); 

	if(isorigins() || ismob())
		createDvar("shield", 0); 
	if(isorigins())
	{
		createDvar("staff", 1); 
		createDvar("cherry", 0);
		createDvar("wm", 0);
	}
	if(istown())
		createDvar("jug", 0); 
	if(issurvivalmap())
		createDvar("avg", 1);
	if(isburied())
		createDvar("setupBuried", 1); 
	if(istranzit())
	{
		createDvar("busloc", 0);
		createDvar("bustimer", 0);
		createDvar("depart", 1);
	}
	if(ismob())
	{
		createDvar("traptimer", 1);
		createDvar("lives", 1);
	}
	flag_wait("initial_blackscreen_passed");
    level.start_time = int(gettime() / 1000);
}

istown()
{
	return (level.script == "zm_transit" && level.scr_zm_map_start_location == "town" && level.scr_zm_ui_gametype_group == "zsurvival");
}

isfarm()
{
	return (level.script == "zm_transit" && level.scr_zm_map_start_location == "farm" && level.scr_zm_ui_gametype_group == "zsurvival");
}

isdepot()
{
	return (level.script == "zm_transit" && level.scr_zm_map_start_location == "transit" && level.scr_zm_ui_gametype_group == "zsurvival");
}

istranzit()
{
	return (level.script == "zm_transit" && level.scr_zm_map_start_location == "transit" && level.scr_zm_ui_gametype_group == "zclassic");
}

isnuketown()
{
	return (level.script == "zm_nuked");
}

isdierise()
{
	return (level.script == "zm_highrise");
}

ismob()
{
	return (level.script == "zm_prison");
}

isburied()
{
	return (level.script == "zm_buried");
}

isorigins()
{
	return (level.script == "zm_tomb");
}

is_round(round)
{
	return round <= level.round_number;
}

issurvivalmap()
{
	return (isnuketown() || istown() || isfarm() || isdepot());
}

isvictismap()
{
	return (istranzit() || isburied() || isdierise());
}

scanweapons()
{
	while(true)
	{
		wait 5;
		while(true)
		{
			wait 0.1;
			if(isdefined(self.revivetrigger))
			{
				while(isdefined(self.revivetrigger))
					wait 0.1;
				break;
			}
			if(self.origin[2] < 0 && isdierise())	//die rise
			{
				while(self.origin[2] < 0)
					wait 0.1;
				break;
			}
			self.a_saved_primaries = self getweaponslistprimaries();
			self.a_saved_primaries_weapons = [];
			index = 0;

			foreach ( weapon in self.a_saved_primaries )
			{
				self.a_saved_primaries_weapons[index] = maps\mp\zombies\_zm_weapons::get_player_weapondata( self, weapon );
				index++;
			}
			wait 0.1;
		}
	}
}

giveplayerdata()
{
	self maps\mp\zombies\_zm_weapons::weapondata_give( self.a_saved_primaries_weapons[2] );
}

openAllDoors()
{
	if(!getDvarInt("doors"))
		return;
    setdvar( "zombie_unlock_all", 1 );
    players = get_players();
    zombie_doors = getentarray( "zombie_door", "targetname" );
    foreach(door in zombie_doors)
    {
		wait 0.1;
		if(istown() && !getDvarInt("jug") && door.origin == (625, -1222, 166))
			continue;
		if(istown() && getDvarInt("jug") && door.origin == (1045, -28, 28))
			continue;
		if(istown() && getDvarInt("jug") && door.origin == (1113, 469, 8))
			continue;
		if(istranzit() && door.origin[0] > 7000 && door.origin[0] < 8400)
			continue;
		if(ismob())
		{
			if(door.origin == (-149, 8679, 1166))
				continue;
			if(door.origin == (2281, 9484, 1564))
				continue;
			if(door.origin == (1601, 9223, 1482))
				continue;
			if(door.origin == (2138, 9210, 1375))
				continue;
		}
		if(isburied())
			if(door.origin == (453, -1188, 100) || door.origin == (-384, -628, 52))
				continue;

        if ( is_true( door.power_door_ignore_flag_wait ) )
            door notify( "power_on" );
			
        door notify( "trigger", players[0] );

        wait 0.05;
    }

    zombie_debris = getentarray( "zombie_debris", "targetname" );

    for ( i = 0; i < zombie_debris.size; i++ )
    {
		if(isburied())
			if(zombie_debris[i].origin == (-435, 498, 478))
				continue;
        zombie_debris[i] notify( "trigger", players[0] );
        wait 0.05;
    }

    level notify( "open_sesame" );
    wait 1;
    setdvar( "zombie_unlock_all", 0 );
}

st_sph()
{
	self.sph = newclienthudelem(self);
	self.sph.fontscale = 1.7;
	self.sph.color = (0.8, 0.8, 0.8);
	self.sph.hidewheninmenu = 1;
	self.sph.x = 2;
	self.sph.y = 75;
	self.sph.alpha = getDvarInt("sph");
	self.sph.label = &"^3SPH:^5 ";
	self.sph.alignx = "left";
	self.sph.aligny = "top";
	self.sph.horzalign = "user_left";
	self.sph.vertalign = "user_top";
	self.sph setvalue(0);

	level waittill("start_of_round");
	while(isdefined(level.countdown_hud))
		wait 0.1;
	self.sph.time_start = gettime() / 1000;
	self.sph.zombies_total_start = level.zombie_total + get_round_enemy_array().size;
	self.sph.kills = 0;
	foreach(player in level.players)
		player.last_kills_check = 0;
    self thread updateSPH();

	while (true) 
	{
		level waittill("start_of_round");
		self.sph.time_start = gettime() / 1000;
    	self.sph.zombies_total_start = level.zombie_total + get_round_enemy_array().size;
	}
}

updateSPH() {
    while (true) 
	{
        wait 0.1;
        time = gettime() / 1000;
        self.sph.time_elapsed = int(time - self.sph.time_start);
		self.sph.kills = self.sph.zombies_total_start - (maps\mp\zombies\_zm_utility::get_round_enemy_array().size + level.zombie_total);
        self.sph.hordas_fraction = self.sph.kills / 24.0;
        if (self.sph.hordas_fraction > 0)
            self.sph.sph_value = self.sph.time_elapsed / self.sph.hordas_fraction;
        else
            self.sph.sph_value = 0;
        self.sph setvalue(self.sph.sph_value);
		self.sph.alpha = getDvarInt("sph");
    }
}

addCommand(command)
{
	level.StratTesterCommands[level.StratTesterCommands.size] =  "!" + command;
}
readchat() 
{
    self endon("end_game");
	level.StratTesterCommands = [];
	level.StratTesterCommands[level.StratTesterCommands.size] = "!a";
	level.StratTesterCommands[level.StratTesterCommands.size] = "!endround";
	level.StratTesterCommands[level.StratTesterCommands.size] = "!killhorde";
	level.StratTesterCommands[level.StratTesterCommands.size] = "!tpc";
	level.StratTesterCommands[level.StratTesterCommands.size] = "!tp";
	level.StratTesterCommands[level.StratTesterCommands.size] = "!sph";
	level.StratTesterCommands[level.StratTesterCommands.size] = "!power";
	level.StratTesterCommands[level.StratTesterCommands.size] = "!boards";
	level.StratTesterCommands[level.StratTesterCommands.size] = "!doors";
	level.StratTesterCommands[level.StratTesterCommands.size] = "!round";
	level.StratTesterCommands[level.StratTesterCommands.size] = "!delay";
	level.StratTesterCommands[level.StratTesterCommands.size] = "!zone";
	level.StratTesterCommands[level.StratTesterCommands.size] = "!remaining";
	level.StratTesterCommands[level.StratTesterCommands.size] = "!weapons";
	level.StratTesterCommands[level.StratTesterCommands.size] = "!perks";
	level.StratTesterCommands[level.StratTesterCommands.size] = "!healthbar";
	level.StratTesterCommands[level.StratTesterCommands.size] = "!timer";
	level.StratTesterCommands[level.StratTesterCommands.size] = "!nuke";
	level.StratTesterCommands[level.StratTesterCommands.size] = "!max";
	level.StratTesterCommands[level.StratTesterCommands.size] = "!boxmove";
	level.StratTesterCommands[level.StratTesterCommands.size] = "!fog";
	level.StratTesterCommands[level.StratTesterCommands.size] = "!notarget";
    while (true) 
    {
        level waittill("say", message, player);
        msg = strtok(tolower(message), " ");
        if(msg[0][0] != "!")
            continue;
		if(!in_array(msg[0], level.StratTesterCommands))
		{
			strattesterprint("Unknown command ^1" + message);
			continue;
		}
        switch(msg[0])
        {
            case "!a": strattesterprint(player.origin + "    " + player.angles); break;
            case "!endround": endroundcase(); break;
            case "!killhorde": killhordecase(); break;
            case "!tpc": tpccase(player, msg[1], msg[3], msg[2]); break;
            case "!tp": tpcase(player, msg[1]); break;
            case "!sph": setDvar("sph", !getDvarInt("sph")); break;
            case "!power": powercase(); break;
            case "!boards": boardscase(); break;
            case "!doors": doorscase(); break;
            case "!round": setDvar("round", msg[1]); break;
            case "!delay": setDvar("delay", msg[1]); break;
            case "!zone": setDvar("zone", !getDvarInt("zone")); break;
            case "!remaining": setDvar("remaining", !getDvarInt("remaining")); break;
            case "!weapons": weaponscase(); break;
            case "!perks": perkscase(); break;
            case "!healthbar": setDvar("healthbar", !getDvarInt("healthbar")); break;
            case "!timer": setDvar("timer", msg[1]); break;
			case "!nuke": level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("nuke", player.origin + (0, 0, 40)); break;
			case "!max": level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop("full_ammo", player.origin + (0, 0, 40)); break;
			case "!boxmove": boxmove(msg[1]); break;
			case "!fog": fogcase(); break;
			case "!notarget": notargetcase(player); break;
        }
    }
}

boxmove(location)
{
	switch(location)
	{
		case "bunker": if(!isnuketown()) return; location = "start_chest1"; break;
		case "yellow": if(!isnuketown()) return; location = "start_chest2"; break;
		case "garden": if(!isnuketown()) return; location = "culdesac_chest"; break;
		case "green": if(!isnuketown()) return; location = "oh1_chest"; break;
		case "garage": if(!isnuketown()) return; location = "oh2_chest"; break;
		case "dt": if(!istranzit() && !istown() && !ismob()) return; if(istranzit() || istown()) location = "town_chest_2"; if(ismob()) location = "citadel_chest"; break;
		case "qr": if(!istranzit() && !istown()) return; location = "town_chest"; break;
		case "farm": if(!istranzit()) return; location = "farm_chest"; break;
		case "power": if(!istranzit()) return; location = "pow_chest"; break;
		case "diner": if(!istranzit()) return; location = "start_chest"; break;
		case "depot": if(!istranzit()) return; location = "depot_chest"; break;
		case "cafe": if(!ismob()) return; location = "cafe_chest"; break;
		case "roof": if(!ismob() && !isdierise()) return; if(!isdierise()) location = "roof_chest"; else location = "ob6_chest"; break;
		case "dock": if(!ismob()) return; location = "dock_chest"; break;
		case "office": if(!ismob()) return; location = "start_chest"; break;
		case "gen1": if(!isorigins()) return; location = "bunker_start_chest"; break;
		case "gen2": if(!isorigins()) return; location = "bunker_tank_chest"; break;
		case "gen3": if(!isorigins()) return; location = "bunker_cp_chest"; break;
		case "gen4": if(!isorigins()) return; location = "nml_open_chest"; break;
		case "gen5": if(!isorigins()) return; location = "nml_farm_chest"; break;
		case "gen6": if(!isorigins()) return; location = "village_church_chest"; break;
		case "m16": if(!isdierise()) return; location = "start_chest"; break;
		case "bar": if(!isdierise()) return; location = "gb1_chest"; break;
		default: break;
	}
    if(isDefined(level._zombiemode_custom_box_move_logic))
        kept_move_logic = level._zombiemode_custom_box_move_logic;

    level._zombiemode_custom_box_move_logic = ::force_next_location;

    foreach (chest in level.chests)
    {
        if (!chest.hidden && chest.script_noteworthy == location)
        {
            if (isDefined(kept_move_logic))
                level._zombiemode_custom_box_move_logic = kept_move_logic;
            return;
        }
        if (!chest.hidden)
        {
            level.chest_min_move_usage = 8;
            level.chest_name = location;

            flag_set("moving_chest_now");
            chest thread fast_chest_move();

            wait 0.05;
            level notify("weapon_fly_away_start");
            wait 0.05;
            level notify("weapon_fly_away_end");

            break;
        }
    }

    while (flag("moving_chest_now"))
        wait 0.05;

    if (isDefined(kept_move_logic))
        level._zombiemode_custom_box_move_logic = kept_move_logic;

    if (isDefined(level.chest_name) && isDefined(level.dig_magic_box_moved))
        level.dig_magic_box_moved = 0;

    level.chest_min_move_usage = 4;
}


force_next_location()
{
    for (i = 0; i < level.chests.size; i++)
        if (level.chests[i].script_noteworthy == level.chest_name)
            level.chest_index = i;
}

createDvar(dvar, set)
{
	if(getDvar(dvar) == "")
		setDvar(dvar, set);
}


trap_timer()
{
	self endon( "disconnect" );

	self.trap_timer = newclienthudelem( self );
	self.trap_timer.alignx = "right";
	self.trap_timer.aligny = "top";
	self.trap_timer.horzalign = "user_right";
	self.trap_timer.vertalign = "user_top";
	self.trap_timer.x = -2;
	self.trap_timer.y = 14;
	self.trap_timer.fontscale = 1.4;
	self.trap_timer.hidewheninmenu = 1;
	self.trap_timer.hidden = 0;
	self.trap_timer.label = &"";

	while(true)
	{
		if(getDvarInt("traptimer"))
		{
			level waittill( "trap_activated" );
			if( level.trap_activated )
			{
				wait 0.1;
				self.trap_timer.color = ( 0, 1, 0 );
				self.trap_timer.alpha = 1;
				self.trap_timer settimer( 25 );
				wait 25;
				self.trap_timer settimer( 25 );
				self.trap_timer.color = ( 1, 0, 0 );
				wait 25;
				self.trap_timer.alpha = 0;
			}
		}
		wait 0.1;
	}
}

endRound(round)
{
	if(round) level.zombie_total = 0;
	
	location = level.players[0].origin;
	player_team = level.players[0].team;
    zombies = getaiarray( level.zombie_team );
    zombies = arraysort( zombies, location );
    zombies_nuked = [];

    foreach(zombie in zombies)
    {
        if ( isdefined( zombie.ignore_nuke ) && zombie.ignore_nuke )
            continue;

        if ( isdefined( zombie.marked_for_death ) && zombie.marked_for_death )
            continue;

        if ( isdefined( zombie.nuke_damage_func ) )
        {
            zombie thread [[ zombie.nuke_damage_func ]]();
            continue;
        }

        if ( is_magic_bullet_shield_enabled( zombie ) )
            continue;

        zombie.marked_for_death = 1;
        zombie.nuked = 1;
        zombies_nuked[zombies_nuked.size] = zombie;
    }

    foreach (nuked_zombie in zombies_nuked)
    {
        if ( !isdefined( nuked_zombie ) )
            continue;

        if ( is_magic_bullet_shield_enabled( nuked_zombie ) )
            continue;

        nuked_zombie dodamage( nuked_zombie.health + 666, nuked_zombie.origin );
    }
}

fast_chest_move()
{
    if ( isdefined( self.zbarrier ) )
        self hide_chest( 1 );

    level.verify_chest = 0;

    if ( isdefined( level._zombiemode_custom_box_move_logic ) )
        [[ level._zombiemode_custom_box_move_logic ]]();
    else
        default_box_move_logic();

    if ( isdefined( level.chests[level.chest_index].box_hacks["summon_box"] ) )
        level.chests[level.chest_index] [[ level.chests[level.chest_index].box_hacks["summon_box"] ]]( 0 );

    playfx( level._effect["poltergeist"], level.chests[level.chest_index].zbarrier.origin );
    level.chests[level.chest_index] show_chest();
    flag_clear( "moving_chest_now" );
    self.zbarrier.chest_moving = 0;
}

zombie_can_drop_powerups(zombie)
{
    if ( is_tactical_grenade( zombie.damageweapon ) || !flag( "zombie_drop_powerups" ) )
        return false;

    if ( isdefined( zombie.no_powerups ) && zombie.no_powerups )
        return false;

    return !getDvarInt("remove_drops");
}

strattesterprint(message)
{
	foreach(player in level.players)
		player iprintln("^5[^6Strat Tester^5]^7 " + message);
}

endroundcase()
{
    endRound(true);
    strattesterprint("Ending current round");
}

killhordecase()
{
    endRound(false);
    strattesterprint("Killing current horde");
}

tpccase(player, x, z, y)
{
    x = string_to_float(x);
    y = string_to_float(y);
    z = string_to_float(z);
    strattesterprint("Teleporting " + player.name + " to " + x + " " + y + " " + z);
    player setOrigin((string_to_float(x), string_to_float(y), string_to_float(z)));
}

tpcase(player, location)
{
	if(istranzit())
		switch(location)
		{
			case "farm": pos = (6908, -5750, -62); ang = (0, 173, 0); break;
			case "town": pos = (1152, -717, -55); ang = (0, 45, 0); break;
			case "depot": pos = (-7384, 4693, -63); ang = (0, 18, 0); break;
			case "tunel": pos = (-11814, -1903, 228); ang = (0, -60, 0); break;
			case "diner": pos = (-5012, -6694, -60); ang = (0, -127, 0); break;
			case "nacht": pos = (13840, -261, -188); ang = (0, -108, 0); break;
			case "power": pos = (12195, 8266, -751); ang = (0, -90, 0); break;
			case "ak": pos = (11200, 7745, -564); ang = (0, -108, 0); break;
			case "ware": pos = (10600, 8272, -400); ang = (0, -108, 0); break;
			case "bus": pos = level.the_bus.origin; ang = level.the_bus.angles; break;
			default: return;
		}
	if(ismob())
		switch(location)
		{
			case "cafe": pos = (3309, 9329, 1336); ang = (0, 131, 0); break;
			case "cage": pos = (-1771, 5401, -71); ang = (0, 0, 0); break;
			case "fans": pos = (-1042, 9489, 1350); ang = (0, -43, 0); break;
			case "dt":   pos = (25, 8762, 1128); ang = (0, 0, 0); break;
			default: return;
		}
	if(isdierise())
		switch(location)
		{
			case "shaft": pos = (3805, 1920, 2197); ang = (0, -161, 0); break;
			case "tramp": pos = (2159, 1161, 3070); ang = (0, 135, 0); break;
			default: return;
		}
	if(isburied())
		switch(location)
		{
			case "saloon": pos = (553, -1214, 56); ang = (0, -50, 0); break;
			case "jug": pos = (-660, 1030, 8); ang = (0, -90, 0); break;
			case "tunel": pos = (-483, 293, 423); ang = (0, -40, 0); break;
			default: return;
		}
	if(isorigins())
		switch(location)
		{
			case "church": pos = (1878, -1358, 150); ang = (0, 140, 0); break;
			case "tcp": pos = (10335, -7902, -411); ang = (0, 140, 0); break;
			case "gen1": pos = (2340, 4978, -303); ang = (0, -132, 0); break;
			case "gen2": pos = (469, 4788, -285); ang = (0, -134, 0); break;
			case "gen3": pos = (740, 2123, -125); ang = (0, 135, 0); break;
			case "gen4": pos = (2337, -170, 140); ang = (0, 90, 0); break;
			case "gen5": pos = (-2830, -21, 238); ang = (0, 40, 0); break;
			case "gen6": pos = (732, -3923, 300); ang = (0, 50, 0); break;
			case "tank": pos = level.vh_tank.origin + (0, 0, 50); ang = level.vh_tank.angles; break;
			default: return;
		}

	strattesterprint("Teleporting " + player.name + " to " + location);
    player setOrigin(pos);
    player setPlayerAngles(ang);
}

powercase()
{
    setDvar("power", !getDvarInt("power"));
    if(getDvarInt("power"))
        strattesterprint("Power will be turned on at the start of the game");
    else
        strattesterprint("Power will not be turned on at the start of the game");
}

boardscase()
{
    setDvar("boards", !getDvarInt("boards"));
    if(getDvarInt("boards"))
        strattesterprint("Boards will be removed at the start of the game");
    else
        strattesterprint("Boards will not be removed at the start of the game");
}

doorscase()
{
    setDvar("doors", !getDvarInt("doors"));
    if(getDvarInt("doors"))
        strattesterprint("Doors will be opened at the start of the game");
    else
        strattesterprint("Doors will not be opened at the start of the game");
}

weaponscase()
{
    setDvar("weapons", !getDvarInt("weapons"));
    if(getDvarInt("weapons"))
        strattesterprint("You will spawn with weapons");
    else
        strattesterprint("You will not spawn with weapons");
}

perkscase()
{
    if(getDvarInt("perks"))
        strattesterprint("You will spawn with perks");
    else
        strattesterprint("You will spawn without perks");
    setDvar("perks", !getDvarInt("perks")); 
}

dropscase()
{
    setDvar("remove_drops", !getDvarInt("remove_drops"));
    if(getDvarInt("remove_drops"))
        strattesterprint("Drops will no longer spawn");
    else
        strattesterprint("Drops will spawn");
}

fogcase()
{
	setDvar("r_fog", !getDvarInt("r_fog"));
	if(!getDvarInt("r_fog"))
		strattesterprint("Removing fog");
	else
		strattesterprint("Adding fog");
}
notargetcase(player)
{
	if(!isdefined(player.innotarget))
		player.innotarget = true;
	else
		player.innotarget = !player.innotarget;
	if(player.innotarget)
		strattesterprint(player.name + " will be ignored by zombies");
	else
		strattesterprint(player.name + " can be targeted by zombies");
}

find_flesh()
{
    self endon( "death" );
    level endon( "intermission" );
    self endon( "stop_find_flesh" );

    if ( level.intermission )
        return;

    self.ai_state = "find_flesh";
    self.helitarget = 1;
    self.ignoreme = 0;
    self.nododgemove = 1;
    self.ignore_player = [];
    self maps\mp\zombies\_zm_spawner::zombie_history( "find flesh -> start" );
    self.goalradius = 32;

    if ( isdefined( self.custom_goalradius_override ) )
        self.goalradius = self.custom_goalradius_override;

    while ( true )
    {
		wait 0.1;
        zombie_poi = undefined;

        if ( isdefined( level.zombietheaterteleporterseeklogicfunc ) )
            self [[ level.zombietheaterteleporterseeklogicfunc ]]();

        if ( isdefined( level._poi_override ) )
            zombie_poi = self [[ level._poi_override ]]();

        if ( !isdefined( zombie_poi ) )
            zombie_poi = self get_zombie_point_of_interest( self.origin );

        players = get_players();
		foreach(player in players)
			if(isdefined(player.innotarget) && player.innotarget)
				arrayremovevalue(player, players);

        if ( !isdefined( self.ignore_player ) || players.size == 1 )
            self.ignore_player = [];
        else if ( !isdefined( level._should_skip_ignore_player_logic ) || ![[ level._should_skip_ignore_player_logic ]]() )
        {
            i = 0;

            while ( i < self.ignore_player.size )
            {
                if ( isdefined( self.ignore_player[i] ) && isdefined( self.ignore_player[i].ignore_counter ) && self.ignore_player[i].ignore_counter > 3 )
                {
                    self.ignore_player[i].ignore_counter = 0;
                    self.ignore_player = arrayremovevalue( self.ignore_player, self.ignore_player[i] );

                    if ( !isdefined( self.ignore_player ) )
                        self.ignore_player = [];

                    i = 0;
                    continue;
                }

                i++;
            }
        }

        player = get_closest_valid_player(self.origin, self.ignore_player);
		if(isdefined(player.innotarget) && player.innotarget)
			continue;

        if ( !isdefined( player ) && !isdefined( zombie_poi ) )
        {
            self maps\mp\zombies\_zm_spawner::zombie_history( "find flesh -> can't find player, continue" );

            if ( isdefined( self.ignore_player ) )
            {
                if ( isdefined( level._should_skip_ignore_player_logic ) && [[ level._should_skip_ignore_player_logic ]]() )
                {
                    wait 0.1;
                    continue;
                }

                self.ignore_player = [];
            }

            wait 0.1;
            continue;
        }

        if ( !isdefined( level.check_for_alternate_poi ) || ![[ level.check_for_alternate_poi ]]() )
        {
            self.enemyoverride = zombie_poi;
            self.favoriteenemy = player;
        }

        self thread zombie_pathing();

        if ( players.size > 1 )
        {
            for ( i = 0; i < self.ignore_player.size; i++ )
            {
                if ( isdefined( self.ignore_player[i] ) )
                {
                    if ( !isdefined( self.ignore_player[i].ignore_counter ) )
                    {
                        self.ignore_player[i].ignore_counter = 0;
                        continue;
                    }

                    self.ignore_player[i].ignore_counter = self.ignore_player[i].ignore_counter + 1;
                }
            }
        }

        self thread attractors_generated_listener();

        if ( isdefined( level._zombie_path_timer_override ) )
            self.zombie_path_timer = [[ level._zombie_path_timer_override ]]();
        else
            self.zombie_path_timer = gettime() + randomfloatrange( 1, 3 ) * 1000;

        while ( gettime() < self.zombie_path_timer )
            wait 0.1;

        self notify( "path_timer_done" );
        self maps\mp\zombies\_zm_spawner::zombie_history( "find flesh -> bottom of loop" );
        debug_print( "Zombie is re-acquiring enemy, ending breadcrumb search" );
        self notify( "zombie_acquire_enemy" );
    }
}

in_array(data, array)
{
	foreach(element in array)
		if(element == data)
			return true;
	return false;
}