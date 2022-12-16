// by ALIAS

private ["_source","_radius_curr"];
params ["_source","_radius_curr"]; //_source = _this select 0;_radius_curr = _this select 1;

_burn = selectRandom [false,true];
_radius_curr = _source getVariable "sync_radius";
if (_burn) then 
{
	_burned_land = "Crater" createVehiclelocal [0,0,0];
	_burned_land setdir (random 360);
	_pos_brun = _source getPos [random _radius_curr/2,random 360];
	_burned_land setpos _pos_brun;
	_burned_land enableSimulation false;
};




/*
_burned_ground = "#particlesource" createVehicleLocal (getPosATL wildfire); 
_burned_ground setParticleCircle [0,[0,0,0]]; 
_burned_ground setParticleRandom [0,[0,0,0],[0,0,0],0,0,[0,0,0,0],0,0]; 
_burned_ground setParticleParams [["\A3\data_f\Krater",1,0,1,0],"","SpaceObject",1,200,[0,0,0],[0,0,0],0,1,0,0,[10],[[1,1,1,1]],[0],0,0,"","",wildfire,0,true]; 
_burned_ground setDropInterval 300;