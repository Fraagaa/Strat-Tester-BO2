
timer()
{
	self endon("disconnect");

	self thread round_timer();
	self.timer = newclienthudelem(self);
	self.timer.alpha = !getDvarInt("st") * 0;
	self.timer.color = (1, 1, 1);
	self.timer.hidewheninmenu = 1;
	self.timer.fontscale = 1.7;
	flag_wait("initial_blackscreen_passed");
	while(true)
	{
		self.timer settimer( int(gettime() / 1000) - level.start_time);
		wait 0.05;
	}
}

round_timer()
{
	self endon("disconnect");

	self.round_timer = newclienthudelem(self);
	self.round_timer.alpha = 0;
	self.round_timer.fontscale = 1.7;
	self.round_timer.color = (0.8, 0.8, 0.8);
	self.round_timer.hidewheninmenu = 1;
	self.round_timer.x = self.timer.x;
	self.round_timer.y = self.timer.y + 15;
	flag_wait("initial_blackscreen_passed");
	level.fade_time = 0.2;

	while(1)
	{
		zombies_this_round = level.zombie_total + get_round_enemy_array().size;
		hordes = zombies_this_round / 24;
		dog_round = flag("dog_round");
		leaper_round = flag("leaper_round");
		self.round_timer settimerup(0);
		start_time = int(GetTime() / 1000);
		level waittill("end_of_round");
		end_time = int(GetTime() / 1000);
		time = end_time - start_time;
		self display_round_time(time, hordes, dog_round, leaper_round);
		level waittill("start_of_round");
		self.round_timer.label = &"";
		self.round_timer fadeovertime(level.fade_time);
		self.round_timer.alpha = 1;
	}
}

display_round_time(time, hordes, dog_round, leaper_round)
{
	timer_for_hud = time - 0.1;
	sph_off = 1;

	if(level.round_number > GetDvarInt("sph") && !dog_round && !leaper_round)
		sph_off = 0;
	self.round_timer.alpha = 1;
	if(sph_off)
	{
		for(i = 0; i < 228; i++)
		{
			self.round_timer settimer(timer_for_hud);
			wait(0.05);
		}
	}
	else
	{
		for(i = 0; i < 100; i++)
		{
			self.round_timer settimer(timer_for_hud);
			wait(0.05);
		}
		self.round_timer fadeovertime(level.fade_time);
		self.round_timer.alpha = 0;
		wait(level.fade_time * 2);
		self display_sph(time, hordes);
	}
}

display_sph(time, hordes)
{
	sph = time / hordes;
	self.round_timer fadeovertime(level.fade_time);
	self.round_timer.alpha = 1;
	self.round_timer.label = &"SPH: ";
	self.round_timer setvalue(sph);

	for(i = 0; i < 5; i++)
	{
		wait(1);
	}

	self.round_timer fadeovertime(level.fade_time);
	self.round_timer.alpha = 0;
	wait(level.fade_time);
}

timerlocation()
{
	self endon("disconnect");

	while(true)
	{
		switch(getDvarInt("timer"))
		{
			case 0:
				self.timer.alpha = !getDvarInt("st") * 0;
				self.round_timer.alpha = 0;
				break;
			case 1:
				self.round_timer.alignx = "right";
				self.round_timer.aligny = "top";
				self.round_timer.horzalign = "user_right";
				self.round_timer.vertalign = "user_top";
				self.timer.alignx = "right";
				self.timer.aligny = "top";
				self.timer.horzalign = "user_right";
				self.timer.vertalign = "user_top";
				self.timer.x = -1;
				self.timer.y = 13;
				self.timer.alpha = !getDvarInt("st") * 1;
				self.round_timer.alpha = 1;
				if(getDvar("cg_drawFPS") != "Off")
					self.timer.y += 4;
				if(getDvar("cg_drawFPS") != "Off" && GetDvar("language") == "japanese")
					self.timer.y += 10;
				if(ismob())
				{
					self.timer.y = 40;
					self.trap_timer.y = 19;
				}
				if(isdierise())
					self.timer.y = 30;
				break;
			case 2:
				self.round_timer.alignx = "left";
				self.round_timer.aligny = "top";
				self.round_timer.horzalign = "user_left";
				self.round_timer.vertalign = "user_top";
				self.timer.alignx = "left";
				self.timer.aligny = "top";
				self.timer.horzalign = "user_left";
				self.timer.vertalign = "user_top";
				self.timer.x = 1;
				self.timer.y = 0;
				self.timer.alpha = !getDvarInt("st") * 1;
				self.round_timer.alpha = 1;
				if(isorigins())
					self.timer.y = 45;
				if(issurvivalmap())
					self.timer.y = 40;
				if(isdierise() && level.springpad_hud.alpha != 0)
					self.timer.y = 10;
				if(isburied() && level.springpad_hud.alpha != 0)
					self.timer.y = 35;
				if(istranzit() && getDvarInt("bus"))
					self.timer.y = 21;
				if(istranzit() && getDvarInt("bus") && GetDvar("language") == "japanese")
					self.timer.y = 25;
				break;
			case 3:
				self.timer.alignx = "left";
				self.timer.aligny = "top";
				self.timer.horzalign = "user_left";
				self.timer.vertalign = "user_top";
				self.round_timer.alignx = "left";
				self.round_timer.aligny = "top";
				self.round_timer.horzalign = "user_left";
				self.round_timer.vertalign = "user_top";
				self.timer.x = 1;
				self.timer.y = 250;
				self.timer.alpha = !getDvarInt("st") * 1;
				self.round_timer.alpha = 1;
				break;
			case 4:
				self.round_timer.alignx = "right";
				self.round_timer.aligny = "top";
				self.round_timer.horzalign = "user_right";
				self.round_timer.vertalign = "user_top";
				self.timer.alignx = "right";
				self.timer.aligny = "top";
				self.timer.horzalign = "user_right";
				self.timer.vertalign = "user_top";
				self.timer.x = -170;
				self.timer.y = 415;
				self.timer.alpha = !getDvarInt("st") * 1;
				self.round_timer.alpha = 1;
				break;

			default: break;
		}
		self.round_timer.x = self.timer.x;
		self.round_timer.y = self.timer.y + 15;
		
		wait 0.1;
		if(GetDvar("language") == "japanese")
		{
			self.timer.fontscale = 1.5;
			self.round_timer.fontscale = self.timer.fontscale;
		}
	}
}


trap_timer()
{
	self endon( "disconnect" );

	self.trap_timer = newclienthudelem( self );
	self.trap_timer.alignx = "right";
	self.trap_timer.aligny = "top";
	self.trap_timer.horzalign = "user_right";
	self.trap_timer.vertalign = "user_top";
	self.trap_timer.x = -2;
	self.trap_timer.y = 14;
	self.trap_timer.fontscale = 1.4;
	self.trap_timer.hidewheninmenu = 1;
	self.trap_timer.hidden = 0;
	self.trap_timer.label = &"";

	while(true)
	{
		if(getDvarInt("traptimer"))
		{
			level waittill( "trap_activated" );
			if( level.trap_activated )
			{
				wait 0.1;
				self.trap_timer.color = ( 0, 1, 0 );
				self.trap_timer.alpha = 1;
				self.trap_timer settimer( 25 );
				wait 25;
				self.trap_timer settimer( 25 );
				self.trap_timer.color = ( 1, 0, 0 );
				wait 25;
				self.trap_timer.alpha = 0;
			}
		}
		wait 0.1;
	}
}



trap_timer()
{
	self endon( "disconnect" );

	self.trap_timer = newclienthudelem( self );
	self.trap_timer.alignx = "right";
	self.trap_timer.aligny = "top";
	self.trap_timer.horzalign = "user_right";
	self.trap_timer.vertalign = "user_top";
	self.trap_timer.x = -2;
	self.trap_timer.y = 14;
	self.trap_timer.fontscale = 1.4;
	self.trap_timer.hidewheninmenu = 1;
	self.trap_timer.hidden = 0;
	self.trap_timer.label = &"";

	while(true)
	{
		if(getDvarInt("traptimer"))
		{
			level waittill( "trap_activated" );
			if( level.trap_activated )
			{
				wait 0.1;
				self.trap_timer.color = ( 0, 1, 0 );
				self.trap_timer.alpha = 1;
				self.trap_timer settimer( 25 );
				wait 25;
				self.trap_timer settimer( 25 );
				self.trap_timer.color = ( 1, 0, 0 );
				wait 25;
				self.trap_timer.alpha = 0;
			}
		}
		wait 0.1;
	}
}