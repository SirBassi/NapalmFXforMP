// by ALIAS

fnc_player_fire = {
	private ["_unit","_spot","_fire_p","_life_time","_unit_surs"];
	params ["_spot","_unit"];
	_fire_p = "#particlesource" createVehicleLocal (getPosATL _spot);
	_fire_p setParticleCircle [0,[0,0,0]];
	_fire_p setParticleRandom [0.1,[0,0,0],[0,0,0],7,0.1,[0,0,0,0.1],1,0];
	_fire_p setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d",16,15,16,1],"","Billboard",1,0.5,[0,0,0],[0,0,0],15,7,7.9,1,[0.5,0.5,0.1],[[1,1,1,1],[1,1,1,1],[1,1,1,0]],[1],1,0,"","",_spot];
	_fire_p setDropInterval 0.1;
	waitUntil {!(_unit getVariable "set_on_fire")};
	deleteVehicle _fire_p;
};

fnc_player_fum = {
	private ["_unit","_fum","_life_time","_unit_surs","_li_fire"];
	_unit = _this#0;
	_fum = "#particlesource" createVehicleLocal (getpos _unit);
	_fum setParticleRandom [1,[0.2,0.2,0],[0,0,0],10,0.5,[0,0,0,0.1],1,0];
	_fum setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d",8,0,40,1],"","Billboard",1,3,[0,0,0],[0,0,0],15,8,7.9,0.1,[1,3,5],[[0.5,0.2,0.2,0],[0,0,0,0.5],[1,1,1,0]],[1],1,0,"","",_unit];
	_fum setDropInterval 0.1;

	_li_fire = "#lightpoint" createVehicle getPosATL _unit;
	_li_fire lightAttachObject [_unit, [0,0,1]];
	_li_fire setLightAttenuation [0,0,0,0,0.1,10];
	_li_fire setLightBrightness 1;
	_li_fire setLightDayLight true;	
	_li_fire setLightAmbient[1,0.2,0.1];
	_li_fire setLightColor[1,0.2,0.1];
	[_li_fire] spawn 
	{
		private ["_lit"];
		_lit = _this#0;
		sleep 0.5;
		_lit setLightBrightness 10;
		while {alive _lit} do 
		{
			_lit setLightBrightness 0.1+(random 0.9);
			_lit setLightAttenuation [0,0,100,0,0.1,5+(random 5)];
			sleep 0.05+(random 0.1);
		};
	};
	waitUntil {(!alive _unit)||(_unit getVariable "time_in_fire" > 6)|| !(_unit getVariable "set_on_fire")};
	deleteVehicle _li_fire; deleteVehicle _fum;
	_unit setVariable ["set_on_fire",false,true];
};

if (!hasInterface) exitwith {};
params ["_unit","_fire_obj_player"];
[_unit] spawn fnc_player_fum;
{[_x,_unit] spawn fnc_player_fire} forEach _fire_obj_player;