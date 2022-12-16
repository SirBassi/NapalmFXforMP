// by ALIAS

if (!isServer) exitWith {};
params ["_source","_life_time","_diameter","_flame_sz","_bld_dam","_smoke","_briti"];

if (!isNil {_source getVariable "on_alias_fire"}) exitWith {};
_source setVariable ["on_alias_fire",true,true];

waitUntil {sleep 1; !isNil "allPlayers_on"};

[_life_time,_source] spawn 
{
	params ["_life_dur","_source_det"];
	sleep _life_dur; 
	_source_det setVariable ["on_alias_fire",nil,true];
};

[[_source,_diameter,_flame_sz,_smoke,_briti],"Skripte\AL_fire\al_fire_deco_SFX.sqf"] remoteExec ["execvm",2,true];

[_source,_diameter,_life_time,false] execvm "Skripte\AL_fire\al_damage_fire.sqf";
_lamps = nearestObjects [position _source,street_lapms,5+_diameter/2,false];
_lamps = _lamps - [_source];
if (count _lamps >0) then {{_x setDamage [1,false]} foreach _lamps};
_buildings_fly = nearestObjects [position _source,buildings_list,5+_diameter/2,false];
_buildings_fly = _buildings_fly - [_source];
if (count _buildings_fly >0) then { {_x setDamage [(_bld_dam+getDammage _x),false]} foreach _buildings_fly};

while {(_source getVariable "on_alias_fire")&&(alive _source) } do 
{
	_near_foc_footmobil = _source nearEntities [list_man,_diameter];
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
						} */
			}
		} foreach _near_foc_footmobil
	};
	sleep 5;
};
sleep 5;
_source setVariable ["sync_radius",nil,true];