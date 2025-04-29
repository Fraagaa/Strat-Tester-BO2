
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

    if(isgreenrun())
    {
        level.StratTesterCommands[level.StratTesterCommands.size] = "!denizen";
        level.StratTesterCommands[level.StratTesterCommands.size] = "!busoff";
        level.StratTesterCommands[level.StratTesterCommands.size] = "!depart";
        level.StratTesterCommands[level.StratTesterCommands.size] = "!busloc";
        level.StratTesterCommands[level.StratTesterCommands.size] = "!bustimer";
        level.StratTesterCommands[level.StratTesterCommands.size] = "!perma";
        level.StratTesterCommands[level.StratTesterCommands.size] = "!jug";
        level.StratTesterCommands[level.StratTesterCommands.size] = "!buson";
    }
    if(isorigins())
    {
        level.StratTesterCommands[level.StratTesterCommands.size] = "!templars";
        level.StratTesterCommands[level.StratTesterCommands.size] = "!stomp";
        level.StratTesterCommands[level.StratTesterCommands.size] = "!tumble";
        level.StratTesterCommands[level.StratTesterCommands.size] = "!tank";
        level.StratTesterCommands[level.StratTesterCommands.size] = "!cherry";
        level.StratTesterCommands[level.StratTesterCommands.size] = "!shield";
        level.StratTesterCommands[level.StratTesterCommands.size] = "!wm";
        level.StratTesterCommands[level.StratTesterCommands.size] = "!staff";
        level.StratTesterCommands[level.StratTesterCommands.size] = "!gen";
        level.StratTesterCommands[level.StratTesterCommands.size] = "!unlockgens";
    }
    if(ismob())
    {
        level.StratTesterCommands[level.StratTesterCommands.size] = "!shield";
        level.StratTesterCommands[level.StratTesterCommands.size] = "!lives";
        level.StratTesterCommands[level.StratTesterCommands.size] = "!traptimer";
    }
    if(isdierise()) level.StratTesterCommands[level.StratTesterCommands.size] = "!perma";
    if(isburied())
    {
        level.StratTesterCommands[level.StratTesterCommands.size] = "!buried";
        level.StratTesterCommands[level.StratTesterCommands.size] = "!perma";
    }
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
            // TRANZIT
            case "!denizen": denizencase(); break;
			case "!busoff": case "!buson": busoffcase(); break;
            case "!depart": departcase(msg[1]); break;
            case "!busloc": setDvar("busloc", !getDvarInt("busloc")); break;
            case "!bustimer": setDvar("bustimer", !getDvarInt("bustimer")); break;
            case "!perma": permacase(player); break;
            case "!jug": jugcase(); break;
            // ORIGINS
            case "!templars": level thread recapture_round_start(); break;
            case "!stomp": level.stomp_hud.alpha = !level.stomp_hud.alpha; break;
            case "!tumble": level.tumble_hud.alpha = !level.tumble_hud.alpha; break;
            case "!tank": level.tank_hud.alpha = !level.tank_hud.alpha; break;
            case "!cherry": cherrycase(); break;
            case "!shield": shieldcase(); break;
            case "!wm": wmcase(); break;
            case "!staff": staffcase(); break;
			case "!gen": changeGenStatus(msg[1]); break;
			case "!unlockgens": unlockgenscase(); break;
            // MOB
            case "!shield": shieldcase(); break;
            case "!lives": livescase(); break;
            case "!traptimer": setDvar("traptimer", !getDvarInt("traptimer")); break;
            // BURIED
            case "!buried": buriedcase(); break;
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

addCommand(command)
{
	level.StratTesterCommands[level.StratTesterCommands.size] =  "!" + command;
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


shieldcase()
{
    setDvar("shield", !getDvarInt("shield"));
    if(getDvarInt("shield"))
        strattesterprint("restart the match to spawn with shield");
    else
        strattesterprint("restart the match to spawn without shield");
}

cherrycase()
{
    setDvar("cherry", !getDvarInt("cherry"));
    if(getDvarInt("cherry"))
        strattesterprint("You will spawn with electric cherry");
    else
        strattesterprint("You will not spawn with electric cherry");
}

wmcase()
{
    setDvar("wm", !getDvarInt("wm"));
    if(getDvarInt("wm"))
        strattesterprint("You will spawn with war machine");
    else
        strattesterprint("You will not spawn with war machine");
}

staffcase()
{
	setDvar("staff", !getDvarInt("staff"));
	if(getDvarInt("staff"))
		strattesterprint("You will spawn with the ice staff");
	else
		strattesterprint("You can spawn with the ice staff or the wind staff");
}

changeGenStatus(generator)
{
	generator = string_to_float(generator);
	switch(generator)
	{
		case 1: name = "generator_start_bunker"; break;
		case 2: name = "generator_tank_trench"; break;
		case 3: name = "generator_mid_trench"; break;
		case 4: name = "generator_nml_right"; break;
		case 5: name = "generator_nml_left"; break;
		case 6: name = "generator_church"; break;
	}
	foreach (gen in getstructarray( "s_generator", "targetname" ))
	{
		if(gen.script_noteworthy == name)
		{
			if(gen.n_current_progress == 100)
			{
				gen.n_current_progress = 0;
				gen set_zombie_controlled_area();
				level setclientfield( gen.script_noteworthy, gen.n_current_progress / 100 );
				level setclientfield( "state_" + gen.script_noteworthy, 0 );
			}
			else
			{
				gen.n_current_progress = 100;
				gen players_capture_zone();
				level setclientfield( gen.script_noteworthy, gen.n_current_progress / 100 );
				level setclientfield( "state_" + gen.script_noteworthy, 2 );
			}
		}
	}
}

unlockgenscase()
{
	foreach (gen in getstructarray( "s_generator", "targetname" ))
		gen thread init_capture_zone();
	strattesterprint("All generators have been unlocked");
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

buriedcase()
{
	setDvar("setupBuried", !getDvarInt("setupBuried"));
	if(getDvarInt("setupBuried"))
		strattesterprint("Subwofer will be built at jug");
	else
		strattesterprint("Subwofer will be built at saloon");
}