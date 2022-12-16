// by ALIAS
//null=[wildfire,200,120,0.1,-1,false,true] execVM "AL_fire\al_wild_fire.sqf";

private ["_op_dir","_diameter","_life_time"];

if (!isServer) exitwith {};
params ["_source","_diameter","_life_time","_spreading","_craters","_hide_destr_veg","_building_damage"];//_source		= _this select 0;_diameter	= _this select 1;_life_time	= _this select 2;_spreading	= _this select 3;_craters	= _this select 4;_hide_destr_veg	= _this select 5;_building_damage = _this select 6;

if (!isNil {_source getVariable "on_alias_fire"}) exitWith {};
_source setVariable ["on_alias_fire",true,true];
_source setVariable ["spreading",true,true];

waitUntil {!isNil "allPlayers_on"};

[_life_time,_source] spawn 
{
	params ["_life_dur","_source_det"];
	sleep _life_dur;
	_source_det setVariable ["on_alias_fire",nil,true];
	_source_det setVariable ["spreading",nil,true];
};

if (_spreading>_diameter) then 
{
	_increase_ratio = floor((_spreading-_diameter)/_life_time)+1;
	_curr_radius = _diameter/2;
	_source setVariable ["sync_radius",_curr_radius,true];
	[[_source,_diameter,_life_time,_spreading,_craters],"Skripte\AL_fire\al_wild_fire_sfx.sqf"] remoteExec ["execvm",2,true];
	while {_source getVariable "on_alias_fire"} do 
	{
		_buildings_fly = nearestObjects [position _source,buildings_list,_curr_radius-10,false];
		_buildings_fly = _buildings_fly - [_source];
		if (count _buildings_fly >0) then {{if (isNil{_x getVariable "burned_already"}) then {_x setVariable ["burned_already",true]; _x setDamage [(_building_damage+getDammage _x),false]}} foreach _buildings_fly};
		_lamps = nearestObjects [position _source,street_lapms,5+_curr_radius,false];
		_lamps = _lamps - [_source];
		if (count _lamps >0) then {{if (alive _x) then {_x setDamage [1,false]}} foreach _lamps};		
		_vik_fly = nearestObjects [position _source,vik_list,_curr_radius-10,false];
		_vik_fly = _vik_fly - [_source];
		if (count _vik_fly >0) then {{if (alive _x) then {_x setDamage [1,false]}}foreach _vik_fly};
		_obj_x = nearestTerrainObjects [position _source,list_vegetation,_curr_radius-10,false];
		{if (alive _x) then {_x setDamage [1,false]; _x enableSimulation false;if (_hide_destr_veg) then {_x hideObjectGlobal true}}} foreach _obj_x;		
		_near_foc_footmobil = _source nearEntities [list_man,_diameter*3];
		if (count _near_foc_footmobil >0) then 
		{
			{
				if !(_x in allPlayers_on) then 
				{
					if (_x distance _source < _curr_radius) then 
						{
							if (isNil{_x getVariable "killed_by_fire"}) then 
								{
									_rnd_lf = 10+(random 20);
									[_x,_rnd_lf,_rnd_lf-2] execVM "Skripte\AL_fire\al_unit_fire.sqf"
								};
						}; 
						/*else 
							{
								_x setBehaviour "AWARE"; _x enableFatigue false; _x forcespeed 10;_x setUnitPos "UP"; _x setSkill ["commanding", 1];[_x] joinSilent grpNull;
								_reldir = _x getDir _source;
								_fct = selectRandom [1,-1];
								_avoid_fire = _source getPos [200+random 200,(_reldir + 140 + (random 40)*_fct)];
								_x doMove _avoid_fire;
							} */
				}
			} foreach _near_foc_footmobil
		};
		_source setVariable ["sync_radius",_curr_radius,true];
		sleep 10;
		_curr_radius = _curr_radius+_increase_ratio;
	};
	sleep 5;
	_source setVariable ["sync_radius",nil,true];
} else {
	_source setVariable ["sync_radius",_diameter/2,true];
	[[_source,_diameter,_life_time,_spreading,_craters],"Skripte\AL_fire\al_wild_fire_sfx.sqf"] remoteExec ["execvm",2,true];
	[_source,_diameter,_life_time,_hide_destr_veg] execvm "Skripte\AL_fire\al_damage_fire.sqf";
	_lamps = nearestObjects [position _source,street_lapms,5+_diameter/2,false];
	_lamps = _lamps - [_source];
	if (count _lamps >0) then {{_x setDamage [1,false]} foreach _lamps};
	while {(_source getVariable "on_alias_fire")&&(alive _source)} do 
	{
	_buildings_fly = nearestObjects [position _source,buildings_list,5+_diameter/2,false];
	_buildings_fly = _buildings_fly - [_source];
	if (count _buildings_fly >0) then {_bld_rnd = selectRandom _buildings_fly; _bld_rnd setDamage [(_building_damage+getDammage _bld_rnd),false]};
	_near_foc_footmobil = _source nearEntities [list_man,_diameter*3];
		_vik_fly = nearestObjects [position _source,vik_list,5+_diameter/2,false];
		_vik_fly = _vik_fly - [_source];
		if (count _vik_fly >0) then 
		{
			{if (alive _x) then {_x setDamage [1,false]}}foreach _vik_fly;
		};
		if (count _near_foc_footmobil >0) then 
		{
			{
				if !(_x in allPlayers_on) then 
				{
					if (_x distance _source < _diameter/2) then 
						{
							if (isNil{_x getVariable "killed_by_fire"}) then 
								{
									_rnd_lf = 10+(random 20);
									[_x,_rnd_lf,_rnd_lf-1] execVM "Skripte\AL_fire\al_unit_fire.sqf"
								};
						}; 
						/*else 
							{
								_x setBehaviour "AWARE"; _x enableFatigue false; _x forcespeed 10;_x setUnitPos "UP"; _x setSkill ["commanding", 1];[_x] joinSilent grpNull;
								_reldir = _x getDir _source;
								_fct = selectRandom [1,-1];
								_avoid_fire = _source getPos [200+random 200,(_reldir + 140 + (random 40)*_fct)];
								_x doMove _avoid_fire;
							}  */
				}
			} foreach _near_foc_footmobil
		};
	sleep 5;
	};
	sleep 5;
	_source setVariable ["sync_radius",nil,true];
};

/*	
_fct = [30,-30] call BIS_fnc_selectRandom;
if (_reldir<180) then {_op_dir=_reldir+180+_fct} else {_op_dir=_reldir-180+_fct};
_del_grass = createVehicle["Land_ClutterCutter_large_F",position _x,[],0,"CAN_COLLIDE"];