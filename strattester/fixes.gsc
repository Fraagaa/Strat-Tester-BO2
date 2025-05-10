#include common_scripts\utility;
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

// Remove other patches HUD (manually)

removeUselessHUD()
{
	flag_wait("initial_blackscreen_passed");
	might_have_b2op = false;
	wait 0.1;
	if(isdefined(level.timer_hud))
		might_have_b2op = true;
	level.timer_hud destroy();
	level.springpad_hud destroy();
	level.subwoofer_hud destroy();
	level.turbine_hud destroy();
	level.round_hud destroy();
	while(might_have_b2op)
	{
		setDvar("cg_drawChecksums", 0);
    	foreach(slot in level.set_of_slots)
			slot.alpha = 0;
		wait 0.1;
	}
}