#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

st_sph()
{
	self.sph = newclienthudelem(self);
	self.sph.fontscale = 1.7;
	self.sph.color = (0.8, 0.8, 0.8);
	self.sph.hidewheninmenu = 1;
	self.sph.x = 2;
	self.sph.y = 75;
	self.sph.alpha = getDvarInt("sph");
	self.sph.label = &"^3SPH:^5 ";
	self.sph.alignx = "left";
	self.sph.aligny = "top";
	self.sph.horzalign = "user_left";
	self.sph.vertalign = "user_top";
	self.sph setvalue(0);

	level waittill("start_of_round");
	while(isdefined(level.countdown_hud))
		wait 0.1;
	self.sph.time_start = gettime() / 1000;
	self.sph.zombies_total_start = level.zombie_total + get_round_enemy_array().size;
	self.sph.kills = 0;
	foreach(player in level.players)
		player.last_kills_check = 0;
    self thread updateSPH();

	while (true) 
	{
		level waittill("start_of_round");
		self.sph.time_start = gettime() / 1000;
    	self.sph.zombies_total_start = level.zombie_total + get_round_enemy_array().size;
	}
}

updateSPH()
{
    while (true) 
	{
        wait 0.1;
        time = gettime() / 1000;
        self.sph.time_elapsed = int(time - self.sph.time_start);
		self.sph.kills = self.sph.zombies_total_start - (maps\mp\zombies\_zm_utility::get_round_enemy_array().size + level.zombie_total);
        self.sph.hordas_fraction = self.sph.kills / 24.0;
        if (self.sph.hordas_fraction > 0)
            self.sph.sph_value = self.sph.time_elapsed / self.sph.hordas_fraction;
        else
            self.sph.sph_value = 0;
        self.sph setvalue(self.sph.sph_value);
		self.sph.alpha = getDvarInt("sph");
    }
}


health_bar_hud()
{
	level endon("end_game");
	self endon("disconnect");
	flag_wait("initial_blackscreen_passed");

	health_bar = self createprimaryprogressbar();
	health_bar.hidewheninmenu = 1;
	health_bar.bar.hidewheninmenu = 1;
	health_bar.barframe.hidewheninmenu = 1;
	health_bar_text = self createprimaryprogressbartext();
	health_bar_text.hidewheninmenu = 1;
	
	health_bar setpoint(undefined, "BOTTOM", 0, 5);
	health_bar_text setpoint(undefined, "BOTTOM", 75, 5);

	while(true)
	{
		if(!getDvarInt("healthbar"))
		{
			health_bar.alpha = 0;
			health_bar.bar.alpha = 0;
			health_bar.barframe.alpha = 0;
			health_bar_text.alpha = 0;
			while(!getDvarInt("healthbar"))
				wait 0.1;
		}
		if (isDefined(self.e_afterlife_corpse))
		{
			if (health_bar.alpha != 0)
			{
				health_bar.alpha = 0;
				health_bar.bar.alpha = 0;
				health_bar.barframe.alpha = 0;
				health_bar_text.alpha = 0;
			}
			
			wait 0.05;
			continue;
		}

		if (health_bar.alpha != 1)
		{
			health_bar.alpha = 1;
			health_bar.bar.alpha = 1;
			health_bar.barframe.alpha = 1;
			health_bar_text.alpha = 1;
		}

		health_bar updatebar (self.health / self.maxhealth);
		health_bar_text setvalue(self.health);
		health_bar.bar.color = (1 - self.health / self.maxhealth, self.health / self.maxhealth, 0);
		wait 0.05;
	}
}


zombie_remaining_hud()
{
	self endon( "disconnect" );
	level endon( "end_game" );

    self.zombie_counter_hud = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1.4 );
    self.zombie_counter_hud maps\mp\gametypes_zm\_hud_util::setPoint( "CENTER", "CENTER", "CENTER", 190 );
    self.zombie_counter_hud.alpha = 0;
    self.zombie_counter_hud.label = &"^3Zombies: ^5";
	self thread zombie_remaining_hud_watcher();

    while(true)
    {
        self.zombie_counter_hud setValue((maps\mp\zombies\_zm_utility::get_round_enemy_array().size + level.zombie_total));
        wait 0.05; 
    }
}

zombie_remaining_hud_watcher()
{	
	self endon("disconnect");
	level endon( "end_game" );

	while(true)
	{
		self.zombie_counter_hud.alpha = getDvarInt("remaining");
        wait 0.1;
	}
}
