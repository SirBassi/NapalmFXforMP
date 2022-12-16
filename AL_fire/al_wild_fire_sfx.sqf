// by ALIAS

fnc_fire_SFX = {
	private ["_source","_diameter"];
	params ["_source","_diameter"];
	
	_fum_mare_drop = linearConversion [50,300,_diameter,0.2,0.1,true];
	_caldura_drop = linearConversion [10,300,_diameter,1,0.5,true];
	_sparks_f_drop = linearConversion [50,300,_diameter,1,0.05,true];
	_flama_drop = linearConversion [5,300,_diameter,1,0.1,true];
	_fum_foc_drop = linearConversion [5,300,_diameter,1,0.1,true];

	_fum_mare_size_1 = linearConversion [50,300,_diameter,35,60,true];
	_fum_mare_size_2 = linearConversion [50,300,_diameter,30,55,true];
	_fum_mare_size_3 = linearConversion [50,300,_diameter,40,65,true];
	_fum_mare_size_4 = linearConversion [50,300,_diameter,150,200,true];

	_fum_size_1 = linearConversion [50,300,_diameter,20,30,true];
	_fum_size_2 = linearConversion [50,300,_diameter,25,35,true];
	_fum_size_3 = linearConversion [50,300,_diameter,30,50,true];

	_caldura_size_1 = linearConversion [50,300,_diameter,10,20,true];
	_caldura_size_2 = linearConversion [50,300,_diameter,15,30,true];
	_caldura_size_3 = linearConversion [50,300,_diameter,20,40,true];

	_flama_size_1 = linearConversion [10,300,_diameter,5,20,true];
	_flama_size_2 = linearConversion [10,300,_diameter,5,20,true];
	_flama_size_3 = linearConversion [10,300,_diameter,5,20,true];

	_fum_mare = "#particlesource" createVehicleLocal (getPosATL _source);
	_fum_mare setParticleCircle [_diameter/4, [5,5,0]];
	_fum_mare setParticleRandom [7,[0,0,0],[-5,-5,0],11,0.2,[0,0,0,0],0.5,0];
	_fum_mare setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d",8,0,40,1], "", "Billboard",1,60,[0,0,0],[5,5,11],13,9.5,7.9,0.4,[_fum_mare_size_1,_fum_mare_size_2,_fum_mare_size_3,_fum_mare_size_4],[[0,0,0,0.5],[0,0,0,0.5],[0.1,0.1,0.1,0.3],[0.5,0.5,0.5,0]],[0.5],0.5, 0, "", "", _source];
	_fum_mare setDropInterval _fum_mare_drop;

	_fum_foc = "#particlesource" createVehicleLocal (getPosATL _source);
	_fum_foc setParticleCircle [_diameter/8, [0,0,0]];
	_fum_foc setParticleRandom [0.1,[_diameter/4,_diameter/4,5],[0,0,0],11,0.1,[0,0,0,0],0,0];
	_fum_foc setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d",8,0,40,1], "", "Billboard",1,35,[0,0,0],[0,0,0],7,10.05,7.9,0,[20,15,20],[[1,0.3,0.01,0],[0.5,0,0,1],[0.5,0.1,0,0]],[0.5], 1, 0, "", "", _source];
	_fum_foc setDropInterval _fum_foc_drop;

	// flama
	_flama = "#particlesource" createVehicleLocal (getPosATL _source);
	_flama setParticleCircle [_diameter/4,[0,0,0]];
	_flama setParticleRandom [1,[_diameter/5.5,_diameter/5.5,0],[0,0,0],0.1,0.1,[0,0,0,0.1],1,0];
	_flama setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal",16,10,32,1],"","Billboard",1,30,[0,0,0],[0,0,0],0,10.06,7.9,0,[_flama_size_1,_flama_size_2,_flama_size_3],[[1,1,1,0],[1,1,1,1],[1,1,1,0]],[0.8],0, 0, "", "", _source,0,true];
	_flama setDropInterval _flama_drop;

	// refrct
	_caldura = "#particlesource" createVehicleLocal (getPosATL _source);
	_caldura setParticleCircle [_diameter/3,[0,0,0]];
	_caldura setParticleRandom [0,[0,0,0],[0.175,0.175,0],0,0.25,[0,0,0,0.1],0,0];
	_caldura setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard",1,10,[0,0,0],[0,0,0.75],30,10,7.9,0.2,[_caldura_size_1,_caldura_size_2,_caldura_size_3],[[1,1,1,0],[1,1,1,1],[1,1,1,0]],[0.08],1,0,"","",_source];
	_caldura setDropInterval _caldura_drop;

	// scantei
	_sparks_f = "#particlesource" createVehicleLocal (getPosATL _source);
	_sparks_f setParticleCircle [_diameter/2-10,[-2,-2,0]];
	_sparks_f setParticleRandom [0.1,[0,0,3],[5,5,0],0.1,0.1,[0,0,0,0],1,0];
	_sparks_f setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d",16,2,48,0],"","Billboard",1,5,[0,0,5],[0,0,3],15,7,7.9,1,[0.5,0.5,0.1],[[1,1,1,1],[1,1,1,1],[1,1,1,0.5]],[1],1,1,"","",_source];
	_sparks_f setDropInterval _sparks_f_drop;
	
	waitUntil {sleep 1; isNil{_source getVariable "on_alias_fire"} or isNil{_source getVariable "spreading"} or (!alive _source)};
	deleteVehicle _flama;
	deleteVehicle _sparks_f;
	deleteVehicle _caldura;
	deleteVehicle _fum_foc;
	deleteVehicle _fum_mare;
};

private ["_source","_diameter","_life_time","_spreading","_craters"];

if (!hasInterface) exitWith {};
params ["_source","_diameter","_life_time","_spreading","_craters"];

if (isNil {_source getVariable "on_alias_fire"}) exitWith {};

	_luminafoc = "#lightpoint" createVehicleLocal (getposATL _source); 
	_luminafoc lightAttachObject [_source,[0,0,5]];
	_luminafoc setLightAttenuation [/*start*/0.2,/*constant*/0,/*linear*/50, /*quadratic*/0, /*hardlimitstart*/_diameter/8,/* hardlimitend*/_diameter*5];
	_luminafoc setLightBrightness 20;
	_luminafoc setLightAmbient [1,0.1,0];
	_luminafoc setLightColor [1,0.2,0];
	_luminafoc setLightDayLight true;

	[_luminafoc,_source,_craters] spawn {
		params ["_luminafoc_tmp","_source_tmp","_craters_tmp"];
		while {_source_tmp getVariable "on_alias_fire"} do 
		{
			_radius_curr = _source_tmp getVariable "sync_radius";
			_luminafoc_tmp setLightBrightness 30+(random 5);
			_luminafoc_tmp setLightAttenuation [0.2,0,0,0,_radius_curr/2,_radius_curr*10];
			_source_tmp say3D ["furnal",(_source_tmp getVariable "sync_radius")*20];
			if (player distance _source_tmp < (_source_tmp getVariable "sync_radius")+5) then {player setVariable ["set_on_fire",true,true]};
			if (_craters_tmp) then {[_source_tmp,_radius_curr] execVM "Skripte\AL_fire\al_crater_fire.sqf"};
			sleep 4;
		};
		_brit = 30;
		while {_brit>0} do 
		{
			_luminafoc_tmp setLightBrightness _brit;
			_brit = _brit-0.13;
			sleep 0.1;
		};
		deleteVehicle _luminafoc_tmp;	
	};

if (_spreading>_diameter) then 
{
	while {_source getVariable "on_alias_fire"} do 
	{
		_source setVariable ["spreading",true,true];
		_radius_curr = _source getVariable "sync_radius";
		[_source,_radius_curr*2] spawn fnc_fire_SFX;
		sleep 0.5;
		_source setVariable ["spreading",nil,true];
		sleep 0.5;
	};
} else {[_source,_diameter] call fnc_fire_SFX};