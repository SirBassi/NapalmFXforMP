// by ALIAS

private ["_unit_afect","_life_time","_kill_vik","_crew_fire","_burn_now"];

if (!isServer) exitwith {};
params ["_unit_afect","_life_time","_kill_vik","_crew_fire",["_burn_now",false]];

//if (!isNil {_unit_afect getVariable "on_alias_fire"}) exitWith {};
_unit_afect setVariable ["on_alias_fire",true,true];
//waitUntil {!isNil "allPlayers_on"};

//waitUntil {!(canMove _unit_afect)};
waitUntil {(((_unit_afect) getHitPointDamage "hitEngine") >0.7)||(((_unit_afect) getHitPointDamage "HitFuel") >0.5) || _burn_now};
sleep 10+(random 20);

[[_unit_afect,_life_time,_crew_fire],"Skripte\AL_fire\al_vehicle_fire_sfx.sqf"] remoteExec ["execvm",2,true];

[_unit_afect,_life_time,_kill_vik] spawn 
{
	params ["_unit_afect","_life_time","_kill_vik"];	
	sleep _life_time;//_unit_afect setVariable ["on_alias_fire",nil,true];
	sleep 0.5;
	if (_kill_vik) then {_unit_afect setDamage 1}
};

if ((_crew_fire)and(_kill_vik)) then 
{
	_unit_afect setHitPointDamage ["hitEngine",1];
	_pasageri = fullCrew _unit_afect;
	if (count _pasageri > 0) then 
	{
		{
			if (isPlayer (_x select 0)) then {(_x select 0) setVariable ["set_on_fire",true,true]} else {_life_time= 5+random 10; [_x select 0,_life_time,15,_unit_afect] execvm "AL_fire\al_unit_fire_car.sqf"; doGetOut _x; /*_x leaveVehicle _unit_afect*/}
		} forEach _pasageri
	};
};