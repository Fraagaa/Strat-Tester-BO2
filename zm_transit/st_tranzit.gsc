#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_utility; 
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm;
#include maps\mp\zm_transit_bus;

main()
{
	replacefunc(maps\mp\zm_transit_bus::busschedule, ::print_busschedule);
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

	
	level.farm_time = create_simple_hud();
	level.farm_time.alignx = "left";
	level.farm_time.aligny = "top";
	level.farm_time.horzalign = "user_left";
	level.farm_time.vertalign = "user_top";
	level.farm_time.fontscale = 1.3;
	level.farm_time SetValue( farm );
	level.farm_time.alpha = 1;

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