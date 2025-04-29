#include maps\mp\_utility;

#include scripts\zm\strattester\nuketown;
#include scripts\zm\strattester\box;

init()
{
    level.total_chest_accessed = 0;
    level thread checkpaplocation();
    level thread boxhits();
	level thread raygun_counter();
    thread bring_perks();
}