#include maps\mp\zm_nuked_perks;

bring_perks()
{
    machines = [];
    machine_triggers = [];
    machines[0] = getent( "vending_revive", "targetname" );
    machine_triggers[0] = getent( "vending_revive", "target" );
    machines[1] = getent( "vending_doubletap", "targetname" );
    machine_triggers[1] = getent( "vending_doubletap", "target" );
    machines[2] = getent( "vending_sleight", "targetname" );
    machine_triggers[2] = getent( "vending_sleight", "target" );
    machines[3] = getent( "vending_jugg", "targetname" );
    machine_triggers[3] = getent( "vending_jugg", "target" );
    machine_triggers[4] = getent( "specialty_weapupgrade", "script_noteworthy" );
    machines[4] = getent( machine_triggers[4].target, "targetname" );

	for(i = 0; i < machines.size; i++)
		bring_perk(machines[i], machine_triggers[i]);
}

checkpaplocation()
{
	if(!getDvarInt("perkrng"))
	{
		wait 1;
		if(level.players.size > 1)
		wait 4;
		pap = getent( "specialty_weapupgrade", "script_noteworthy" );
		jug = getent( "vending_jugg", "targetname" );
		if(pap.origin[0] > -1700 || jug.origin[0] > -1700)
			level.players[0] notify ("menuresponse", "", "restart_level_zm");
	}
}
