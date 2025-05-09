#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_magicbox;

displayBoxHits()
{
    level thread displayWatcher();
	level.boxhitsst.hidewheninmenu = true;
    level.boxhitsst = createserverfontstring( "objective", 1.3 );
    level.boxhitsst.y = 0;
    level.boxhitsst.x = 0;
    level.boxhitsst.fontscale = 1.4;
    level.boxhitsst.alignx = "center";
    level.boxhitsst.horzalign = "user_center";
    level.boxhitsst.vertalign = "user_top";
    level.boxhitsst.aligny = "top";
    level.boxhitsst.label = &"^3Box Hits: ^5";
    level.total_chest_accessed_mk2 = 0;
    level.total_chest_accessed_ray = 0;
    level.boxhitsst.alignx = "left";
    level.boxhitsst.horzalign = "user_left";
    level.boxhitsst.x = 2;
    level.boxhitsst.alpha = 1;
    level.boxhitsst setvalue(0);

    while(!isdefined(level.total_chest_accessed) || !isdefined(level.chest_accessed))
        wait 0.1;
    counter = 0;
    while(true)
    {
        if(counter != level.chest_accessed)
        {
            counter = level.chest_accessed;
            if(counter == 0)
                continue;

            level.total_chest_accessed++;

            if(count_for_raygun()) level.total_chest_accessed_ray++;
            if(count_for_mk2()) level.total_chest_accessed_mk2++;
            
            level.boxhitsst setvalue(level.total_chest_accessed);
        }
        wait 0.1;
    }
}

count_for_raygun()
{
    foreach(player in level.players)
        if (!player has_weapon_or_upgrade("ray_gun_zm"))
            return true;
    return false;
}
count_for_mk2()
{
    foreach(player in level.players)
        if(player has_weapon_or_upgrade("raygun_mark2_zm"))
            return false;
    return true;
}

raygun_counter()
{
    self endon("disconnect");

    if(!isDefined(level.total_mk2)) level.total_mk2 = 0;
    if(!isDefined(level.total_ray)) level.total_ray = 0;

	level.total_ray_display.hidewheninmenu = true;
    level.total_ray_display = createserverfontstring( "objective", 1.3 );
    level.total_ray_display.y = 26;
    level.total_ray_display.x = 2;
    level.total_ray_display.fontscale = 1.3;
    level.total_ray_display.alignx = "left";
    level.total_ray_display.horzalign = "user_left";
    level.total_ray_display.vertalign = "user_top";
    level.total_ray_display.aligny = "top";
    level.total_ray_display.alpha = 1;
	level.total_mk2_display.hidewheninmenu = true;
    level.total_mk2_display = createserverfontstring( "objective", 1.3 );
    level.total_mk2_display.y = 14;
    level.total_mk2_display.x = 2;
    level.total_mk2_display.fontscale = 1.3;
    level.total_mk2_display.alignx = "left";
    level.total_mk2_display.horzalign = "user_left";
    level.total_mk2_display.vertalign = "user_top";
    level.total_mk2_display.aligny = "top";
    level.total_mk2_display.alpha = 1;
    
    level.total_ray_display setvalue(0);
    level.total_mk2_display setvalue(0);

    while(true)
    {
        if(getDvarInt("avg"))
        {
            level.total_mk2_display.label = &"^3Raygun MK2 AVG: ^5";
            level.total_ray_display.label = &"^3Raygun AVG: ^5";
            if(isDefined(level.total_ray_display)) level.total_ray_display setvalue(level.total_chest_accessed_ray / level.total_ray);
            if(isDefined(level.total_mk2_display)) level.total_mk2_display setvalue(level.total_chest_accessed_mk2 / level.total_mk2);
        }
        else
        {
            level.total_mk2_display.label = &"^3Total Raygun MK2: ^5";
            level.total_ray_display.label = &"^3Total Raygun: ^5";
            if(isDefined(level.total_ray_display)) level.total_ray_display setvalue(level.total_ray);
            if(isDefined(level.total_mk2_display)) level.total_mk2_display setvalue(level.total_mk2);
        }
        wait 0.1;
    }
}

track_rays()
{
    wait 2;
    while(true)
    {
        while(self.sessionstate != "playing")
            wait 0.1;
        if(self hasweapon("ray_gun_zm")) level.total_ray++;
        if(self hasweapon("raygun_mark2_zm")) level.total_mk2++;

        while(self has_weapon_or_upgrade("ray_gun_zm") || self has_weapon_or_upgrade("raygun_mark2_zm")) 
            wait 0.1;
        wait 0.1;
    }
}

boxhits()
{
    wait 1;
    if(isdefined(level.total_mk2_display))
        return;
    level thread displayBoxHits();
    while(true)
    {
        level waittill("connecting", player);
        player thread track_rays();
    }
}

displayWatcher()
{
    while(true)
    {
        wait 0.1;
        level.total_mk2_display.alpha = getDvarInt("boxhits");
        level.total_ray_display.alpha = getDvarInt("boxhits");
        level.boxhitsst.alpha = getDvarInt("boxhits");
    }
}