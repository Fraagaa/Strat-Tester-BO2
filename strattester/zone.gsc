#include common_scripts\utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\_utility;

#include scripts\zm\strattester\ismap;

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
