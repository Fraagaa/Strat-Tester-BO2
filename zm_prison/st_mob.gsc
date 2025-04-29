#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm;

#include scripts\zm\strattester\mob;
#include scripts\zm\strattester\buildables;

init()
{
	flag_wait("initial_blackscreen_passed");
	level thread spawn_buildable_trigger_shield((3366, 9406, 1336), "alcatraz_shield_zm", "^3Press &&1 for ^5Shield"); // shield
	level.players[0] thread speeddoor();
	level.players[0] thread infinite_afterlifes();
}