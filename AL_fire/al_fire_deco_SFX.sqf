// by ALIAS

fnc_fire_deco_SFX = 
{
	private ["_source","_diameter","_flame_sz","_smoke","_fum_mare"];
	params ["_source","_diameter","_flame_sz","_smoke"];
	
	if (_smoke) then {
		_fum_mare = "#particlesource" createVehicleLocal (getPosATL _source);
		_fum_mare setParticleCircle [0,[0,0,0]];
		_fum_mare setParticleRandom [7,[_diameter/4,_diameter/4,0],[-2,-2,0],5,0.5,[0,0,0,0.1],1,0];
		_fum_mare setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d",8,0,40,1],"","Billboard",1,30,[0,0,-5],[1,1,4],13,10,7.9,0.1,[10,15,30,40,60],[[0,0,0,0.1],[0,0,0,0.5],[0.2,0.2,0.2,0.2],[0.5,0.5,0.5,0.1],[0.5,0.5,0.5,0]],[0.5],1, 0, "", "", _source];
		_fum_mare setDropInterval 0.1;
	};

	_fum_foc = "#particlesource" createVehicleLocal (getPosATL _source);
	_fum_foc setParticleCircle [0,[0,0,0]];
	_fum_foc setParticleRandom [0.1,[_diameter/2.5,_diameter/2.5,2],[0,0,0],11,0.1,[0,0,0,0],0,0];
	_fum_foc setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d",8,0,40,1], "", "Billboard",1,10,[0,0,0],[0,0,0],7,10,7.9,0,[_flame_sz*2,_flame_sz,_flame_sz*3],[[1,0.3,0.01,0],[0.5,0,0,1],[0.5,0.1,0,0]],[1], 1, 0, "", "", _source];
	_fum_foc setDropInterval 0.1;

	// flama
	_flama = "#particlesource" createVehicleLocal (getPosATL _source);
	_flama setParticleCircle [0,[0,0,0]];
	_flama setParticleRandom [1,[_diameter/2,_diameter/2,0],[0,0,0],0.1,0.1,[0,0,0,0.1],1,0];
	_flama setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal",16,10,32,1],"","Billboard",1,30,[0,0,0],[0,0,0],0,10.07,7.9,0,[_flame_sz,_flame_sz,_flame_sz],[[1,1,1,0],[1,1,1,1],[1,1,1,0]],[0.8],0, 0, "", "", _source,0,true];
	_flama setDropInterval 0.5;

	// refrct
	_caldura = "#particlesource" createVehicleLocal (getPosATL _source);
	_caldura setParticleCircle [0,[0,0,0]];
	_caldura setParticleRandom [0,[_diameter/3,_diameter/3,0],[0.175,0.175,0],0,0.25,[0,0,0,0.1],0,0];
	_caldura setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1],"","Billboard",1,10,[0,0,0],[0,0,0.75],30,10.2,7.9,0.1,[_flame_sz*2,_flame_sz*2,_flame_sz*2],[[1,1,1,0],[1,1,1,0.5],[1,1,1,0]],[0.08],1,0,"","",_source];
	_caldura setDropInterval 0.5;

	waitUntil {isNil{_source getVariable "on_alias_fire"} or (!alive _source) or !(isObjectHidden _source)};
	deleteVehicle _flama;
	deleteVehicle _caldura;
	deleteVehicle _fum_foc;
	if (_smoke) then {deleteVehicle _fum_mare};
};

private ["_source","_diameter","_flame_sz","_smoke"];

if (!hasInterface) exitWith {};
params ["_source","_diameter","_flame_sz","_smoke","_briti"];

if (isNil {_source getVariable "on_alias_fire"} ) exitWith {};

	_luminafoc = "#lightpoint" createVehicleLocal (getposATL _source); 
	_luminafoc lightAttachObject [_source,[0,0,5]];
	_luminafoc setLightAttenuation [/*start*/0.2,/*constant*/0,/*linear*/50, /*quadratic*/0, /*hardlimitstart*/_diameter/8,/* hardlimitend*/_diameter*5];
	_luminafoc setLightBrightness _briti;
	_luminafoc setLightAmbient [1,0.1,0];
	_luminafoc setLightColor [1,0.1,0];
	_luminafoc setLightDayLight true;

	[_luminafoc,_source,_diameter,_briti] spawn 
	{
		params ["_luminafoc_tmp","_source_tmp","_diameter_tmp","_briti"];	
		_radius_curr = _diameter_tmp/2;
		while {(_source_tmp getVariable "on_alias_fire")&&(alive _source_tmp) } do 
		{
			_luminafoc_tmp setLightBrightness _briti+(random 0.5);
			_luminafoc_tmp setLightAttenuation [0.1,0,0,0,0,_radius_curr*10];
			if (player distance _source_tmp < _radius_curr) then {player setVariable ["set_on_fire",true,true]};
			sleep 0.5;
		};
		_brit = 3;
		while {_brit>0} do 
		{
			_luminafoc_tmp setLightBrightness _brit;
			_brit = _brit-0.13;
			sleep 0.1;
		};
		deleteVehicle _luminafoc_tmp;	
	};

[_source,_diameter] spawn 
{
	params ["_source_tmp","_diameter_tmp"];
	if (isNull _source_tmp) exitWith {};
	while {!(isNull _source_tmp)} do 
	{
		if ((_source_tmp getVariable "on_alias_fire")&&(alive _source_tmp) ) then
		{
		//_source_tmp say3D ["furnal",_diameter_tmp*10];
		_s = selectRandom ["a3\sounds_f\sfx\fire3_loop.wss"]; 
		playSound3D [_s,_source_tmp];
		sleep 4;
		};
	};
};
	
[_source,_diameter,_flame_sz,_smoke] call fnc_fire_deco_SFX;