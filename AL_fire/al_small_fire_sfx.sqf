// by ALIAS

private ["_blow_source","_dir_blast","_press_implicit_x","_press_implicit_y","_blast_blow","_li_exp","_burst","_z_speed"];

if (!hasInterface) exitWith {};
params ["_blow_source","_blast_blow","_life_time"];

if (isNil{_blow_source getVariable "on_alias_fire"}) exitWith {};

_dir_blast = getdir _blow_source;
if (_blast_blow == 0) then {_z_speed=3} else {_z_speed=0};

_flow = (getposasl _blow_source vectorFromTo (_blow_source getRelPos [10,0])) vectorMultiply _blast_blow;

_li_exp = "#lightpoint" createVehicle getPosATL _blow_source;
_li_exp lightAttachObject [_blow_source, [0,0,0.5]];
_li_exp setLightAttenuation [0,0,0,0,1,100];
_li_exp setLightBrightness 5;
_li_exp setLightDayLight true;	
_li_exp setLightAmbient[1,0.2,0.1];
_li_exp setLightColor[1,0.2,0.1];
[_li_exp] spawn {
	_lit = _this select 0;
	sleep 0.5;
	_lit setLightBrightness 10;
	while {alive _lit} do 
	{
		_lit setLightBrightness 3+(random 1);
		_lit setLightAttenuation [0,0,100,0,1,98+(random 2)];
		sleep 0.05+(random 0.1);
	};
};

_flame_heat = "#particlesource" createVehicleLocal (getposATL _blow_source);
_flame_heat setParticleCircle [0,[0,0,0]];
_flame_heat setParticleRandom [0.1,[0,0,0],[0,0,0],8,0.1,[0,0,0,0.1],1,0];
_flame_heat setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1,1,[0,0,0],[0,0,0.5],15,10.05,7.9,0.1,[1,1,1],[[1,1,1,0],[1,1,1,1],[1,1,1,0]],[0.08],1,0,"","",_blow_source];
_flame_heat setDropInterval 0.1;

_flames_1 = "#particlesource" createVehicleLocal (getpos _blow_source);
_flames_1 setParticleCircle [0,[0,0,0]];
_flames_1 setParticleRandom [0.5,[0.3,0.3,0],[0,0,0],2,0.5,[0,0,0,0.1],0,0];
_flames_1 setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d",16,1,16,0],"","Billboard",1,2,[0,0,0],[_blast_blow*(_flow select 0),_blast_blow*(_flow select 1),_z_speed],15,7.5,7.9,0.5,[1,1,1],[[1,1,1,1],[1,1,1,1],[1,1,1,1]],[2],0,0,"","",_blow_source];
_flames_1 setDropInterval 0.05;

_sparks = "#particlesource" createVehicleLocal (getpos _blow_source);
_sparks setParticleCircle [0,[0,0,0]];
_sparks setParticleRandom [0.5,[0.5,0.5,0.5],[0,0,0],10,0.1,[0,0,0,0.1],1,0.5];
_sparks setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d",16,15,16,1],"","Billboard",1,1.5,[0,0,0],[_blast_blow*(_flow select 0),_blast_blow*(_flow select 1),_z_speed],15,9,8,0.1,[0.1,0.1,0.05],[[1,1,1,1],[1,1,1,1],[1,1,1,1]],[1],1,0.5,"","",_blow_source];
_sparks setDropInterval 0.1;

_fum = "#particlesource" createVehicleLocal (getpos _blow_source);
_fum setParticleCircle [0,[0,0,0]];
_fum setParticleRandom [1,[0.5,0.5,0.5],[0,0,0],10,0.5,[0,0,0,0.1],1,0];
_fum setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d",8,0,40,1],"","Billboard",1,5,[0,0,0],[_blast_blow*(_flow select 0),_blast_blow*(_flow select 1),_z_speed],15,9.5,7.9,0.1,[1.5,3,5],[[0.5,0.2,0.2,0.5],[0,0,0,0.5],[1,1,1,0]],[0.5],1,0,"","",_blow_source];
_fum setDropInterval 0.1;

while {_blow_source getVariable "on_alias_fire"} do 
{
	if (player distance _blow_source < 2) then {player setVariable ["set_on_fire",true,true]};
	//_blow_source say3d ["furnal",200]; 
	_s = selectRandom ["a3\sounds_f\sfx\fire3_loop.wss"]; 
	playSound3D [_s,_blow_source];
	sleep 7;
};

sleep _life_time;
deleteVehicle _li_exp;
sleep 0.5;
deleteVehicle _flame_heat;
sleep 1;
deleteVehicle _flames_1;
deleteVehicle _sparks;
sleep 0.5;
deleteVehicle _fum;