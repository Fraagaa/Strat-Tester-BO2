#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm;

speeddoor()
{
	if(!getDvarInt("doors"))
		return;
	if(!getDvarInt("power"))
		return;
	flag_wait( "afterlife_start_over" );
	wait 1;
	self takeWeapon("raygun_mark2_upgraded_zm");
	self giveweapon("lightning_hands_zm");
	self switchToWeapon("lightning_hands_zm");
	self setOrigin((-536, 9513, 1336));
	self setPlayerAngles((0, 0, 0));
	wait 3;
	self setOrigin((3851, 9791, 1704));
	wait 0.5;
	self setOrigin((-1504, 5480, -71));
	self setPlayerAngles((0, -77, 0));
	wait 0.5;
	self setOrigin((-1064, 6263, 64));
	self setPlayerAngles((0, 10, 0));
	wait 0.5;
	self setOrigin((-316, 6886, 64));
	wait 0.5;
	self setOrigin((-530, 6545, 72));
	wait 0.5;
	self setOrigin((2127, 9552, 1450));
	wait 0.5;
	self setOrigin((-359, 9077, 1450));
	self setPlayerAngles((0, -170, 0));
	wait 0.5;
	self setOrigin((800, 8403, 1544));
	self setPlayerAngles((0, -90, 0));
	wait 0.5;
	self setOrigin((2050, 9566, 1336)); // cafe key
	wait 1.5;
	self setOrigin((-277, 9107, 1336));// office key
	wait 1.5;
	self setOrigin((1195, 10613, 1336));
	self TakeWeapon("lightning_hands_zm");
	self giveweapon("raygun_mark2_upgraded_zm");
}

infinite_afterlifes()
{
	self endon( "disconnect" );
	while(true)
	{
		self waittill( "player_revived", reviver );
		wait 2;
		if(getDvarInt("lives"))
			self.lives++;
	}
}