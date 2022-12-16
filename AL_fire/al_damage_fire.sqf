// by ALIAS

private ["_source","_diameter","_life_time","_sleep_int"];

_source		= _this select 0;
_diameter	= _this select 1;
_life_time	= _this select 2;
_hide_destr_veg	= _this select 3;

_obj_x = nearestTerrainObjects [position _source,list_vegetation,5+_diameter/2,false];
_hide_veg = _obj_x;

if (count _obj_x >0) then 
{
	_sleep_int = _life_time/(count _obj_x);
	while {(count _obj_x > 0) and (_source getVariable "on_alias_fire")} do 
	{
		_jeton = selectRandom _obj_x;
		_jeton setDamage [1,false]; _jeton enableSimulation false;
		_obj_x = _obj_x - [_jeton];
		sleep _sleep_int-random(_sleep_int/2);
	};
};

if (_hide_destr_veg) then 
{
	if (count _hide_veg >0) then 
	{
		{_x hideObjectGlobal true; sleep _sleep_int-random(_sleep_int/2)} foreach _hide_veg
	};
};