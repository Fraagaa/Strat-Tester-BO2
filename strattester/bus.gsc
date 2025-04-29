#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm;
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