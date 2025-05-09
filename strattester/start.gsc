#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_blockers;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;

#include scripts\zm\strattester\ismap;

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
		wait 1;
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


give_perks( perk_array )
{
	foreach( perk in perk_array )
	{
		self give_perk( perk, 0 );
		wait 0.15;
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

giveplayerdata()
{
	self maps\mp\zombies\_zm_weapons::weapondata_give( self.a_saved_primaries_weapons[2] );
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