#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_utility;

#include scripts\zm\strattester\fixes;
#include scripts\zm\strattester\commands;
#include scripts\zm\strattester\start;
#include scripts\zm\strattester\zone;
#include scripts\zm\strattester\timers;
#include scripts\zm\strattester\ismap;
#include scripts\zm\strattester\sph;

main()
{
	replaceFunc(maps\mp\animscripts\zm_utility::wait_network_frame, ::base_game_network_frame);
	replaceFunc(maps\mp\zombies\_zm_utility::wait_network_frame, ::base_game_network_frame);
	replaceFunc(maps\mp\zombies\_zm_spawner::zombie_can_drop_powerups, ::zombie_can_drop_powerups);
	replaceFunc(maps\mp\zombies\_zm_ai_basic::find_flesh, ::find_flesh);
}

init()
{
	level.strat_tester = true;
    if(!isDefined(level.total_chest_accessed))
        level.total_chest_accessed = 0;
	level thread setdvars();
	level thread fix_highround();
    level thread turn_on_power();
    level thread set_starting_round();
    level thread remove_boards_from_windows();
	thread enable_cheats();
	level thread readChat();
	level thread readconsole();
	level thread checkConsole();
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
	stversion = 1.7;

    while(true)
    {
		if(!isdefined(self.has_hud))
		{
			self iprintln("^6Strat Tester " + stversion);
			self iprintln("^5Made by BoneCrusher");
			self thread scanweapons();
			self thread health_bar_hud();
			self thread zone_hud();
			self thread zombie_remaining_hud();
			self thread st_sph();
			if(!isdefined(self.has_hud))
				self.has_hud = true;
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
		if(!in_array(msg[0], level.StratTesterCommands) && (!in_array(msg[0], level.FragaCommands)))
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

checkConsole()
{
	createDvar("chat", "xxxxxxxxxxxx");
	while(true)
	{
		if(getDvar("chat") != "xxxxxxxxxxxx")
		{
			level notify("sayConsole", getDvar("chat"));
			setDvar("chat", "xxxxxxxxxxxx");
		}
		wait 0.1;
	}
}

readconsole()
{
    self endon("end_game");
    while (true) 
    {
        level waittill("sayConsole", message);
		level.players[0] iprintln(message);
		level.players[0] iprintln("a");
        msg = strtok(tolower(message), " ");
		if(!in_array(msg[0], level.StratTesterCommands) && (!in_array(msg[0], level.FragaCommands)))
		{
			strattesterprint("Unknown command ^1" + message);
			continue;
		}
		if(!isdefined(player))
			player = level.players[0];
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

createDvar(dvar, set)
{
	if(getDvar(dvar) == "")
		setDvar(dvar, set);
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

strattesterprint(message)
{
	foreach(player in level.players)
		player iprintln("^5[^6Strat Tester^5]^7 " + message);
}