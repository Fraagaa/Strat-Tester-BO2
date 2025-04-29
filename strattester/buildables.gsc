#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_equipment;

changecraftableoption( index )
{
	foreach (craftable in level.a_uts_craftables)
		if (craftable.equipname == "open_table")
			craftable thread setcraftableoption( index );
}

setcraftableoption( index )
{
	self endon("death");

	while (self.a_uts_open_craftables_available.size <= 0)
		wait 0.05;

	if (self.a_uts_open_craftables_available.size > 1)
	{
		self.n_open_craftable_choice = index;
		self.equipname = self.a_uts_open_craftables_available[self.n_open_craftable_choice].equipname;
		self.hint_string = self.a_uts_open_craftables_available[self.n_open_craftable_choice].hint_string;
		foreach (trig in self.playertrigger)
			trig sethintstring( self.hint_string );
	}
}


takecraftableparts( buildable )
{
	player = get_players()[ 0 ];
	foreach (stub in level.zombie_include_craftables)
    {
        foreach (piece in stub.a_piecestubs)
        {
            piecespawn = piece.piecespawn;
            if ( isDefined( piecespawn ) && buildable == "gramaphone" )
                player player_take_piece_gramophone( piecespawn );
            else
                player player_take_piece(piecespawn);
        }
    }
			return;
}

get_craftable_piece( str_craftable, str_piece )
{
	foreach (uts_craftable in level.a_uts_craftables)
		if ( uts_craftable.craftablestub.name == str_craftable )
			foreach (piecespawn in uts_craftable.craftablespawn.a_piecespawns)
				if ( piecespawn.piecename == str_piece )
					return piecespawn;
	return undefined;
}

player_take_piece_gramophone( piecespawn )
{
	piecestub = piecespawn.piecestub;
	damage = piecespawn.damage;

	if ( isDefined( piecestub.onpickup ) )
		piecespawn [[ piecestub.onpickup ]]( self );

	piecespawn piece_unspawn();
	piecespawn notify( "pickup" );

	if ( isDefined( piecestub.is_shared ) && piecestub.is_shared )
		piecespawn.in_shared_inventory = 1;

	self adddstat( "buildables", piecespawn.craftablename, "pieces_pickedup", 1 );
}

player_take_piece( piecespawn )
{
	piecestub = piecespawn.piecestub;
	damage = piecespawn.damage;

	if ( isDefined( piecestub.onpickup ) )
		piecespawn [[ piecestub.onpickup ]]( self );

	if ( isDefined( piecestub.is_shared ) && piecestub.is_shared  && isDefined( piecestub.client_field_id ))
        level setclientfield( piecestub.client_field_id, 1 );

	else if ( isDefined( piecestub.client_field_state ) )
		self setclientfieldtoplayer( "craftable", piecestub.client_field_state );

	piecespawn piece_unspawn();
	piecespawn notify( "pickup" );

	if ( isDefined( piecestub.is_shared ) && piecestub.is_shared )
		piecespawn.in_shared_inventory = 1;

	self adddstat( "buildables", piecespawn.craftablename, "pieces_pickedup", 1 );
}

piece_unspawn()
{
	if ( isDefined( self.model ) )
		self.model delete();

	self.model = undefined;

	if ( isDefined( self.unitrigger ) )
		thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger( self.unitrigger );

	self.unitrigger = undefined;
}

takeAllParts() 
{
    p = getPlayers()[0];
    foreach ( craftable in level.a_uts_craftables ) 
	{
        foreach ( piece in craftable.craftablespawn.a_piecespawns )
		{
            p player_take_piece(piece);
            wait 0.1;
        }
    }

    p player_drop_piece();

    level notify("allPartsTaken");
}

equipment_buy( equipment )
{
    if ( isdefined( self.current_equipment ) && equipment != self.current_equipment )
        self equipment_drop( self.current_equipment );

    if ( ( equipment == "riotshield_zm" || equipment == "alcatraz_shield_zm" || equipment == "tomb_shield_zm" ) && isdefined( self.player_shield_reset_health ) )
        self [[ self.player_shield_reset_health ]]();
    else
        self player_set_equipment_damage( equipment, 0 );

    self equipment_give( equipment );
}


spawn_buildable_trigger_shield(origin, build, string)
{
	trigger = spawn("trigger_radius", origin, 40, 70, 140);
	trigger.targetname = "shield_trigger";
	trigger SetCursorHint("HINT_NOICON");
	trigger SetHintString(string);
	while(true)
	{
		trigger waittill( "trigger", player );
		if( player UseButtonPressed() )
			if( !player hasWeapon( build ) )
				player equipment_buy( build );

		if(!level.shield)
			trigger.origin = (0, -10000, 0);
		wait 0.1;
	}
}

spawn_buildable_trigger(origin, build, string, limit)
{
	trigger = spawn("trigger_radius", origin, 40, 70, 140);
	trigger.targetname = "shield_trigger";
	trigger SetCursorHint("HINT_NOICON");
	trigger SetHintString(string);
	while(true)
	{
		trigger waittill( "trigger", player);
		if( player UseButtonPressed() )
			if(!isdefined(limit))
			{
				if( !player hasWeapon( build ) )
					player equipment_buy( build );
			}
			else
				if(player.origin[limit] > origin[limit])
				{
					if( !player hasWeapon( build ) )
						player equipment_buy( build );
				}


		wait 0.1;
	}
}
