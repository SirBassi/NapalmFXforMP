// by ALIAS

private ["_unit_afect","_life_time","_kill_vik"];

if (!hasInterface) exitWith {};
params ["_unit_afect","_life_time","_not_move"];

if (!alive _unit_afect) exitWith {};

_bbr = boundingBoxReal vehicle _unit_afect;
_p1 = _bbr select 0;
_p2 = _bbr select 1;
_maxWidth = abs ((_p2 select 0) - (_p1 select 0));
_maxLength = abs ((_p2 select 1) - (_p1 select 1));
_maxHeight = abs ((_p2 select 2) - (_p1 select 2));

_li_exp = "#lightpoint" createVehicle getPosATL _unit_afect;
_li_exp lightAttachObject [_unit_afect, [0,0,2]];
_li_exp setLightAttenuation [0,0,0,0,1,100];
_li_exp setLightBrightness 5;
_li_exp setLightDayLight true;	
_li_exp setLightAmbient[1,0.3,0.1];
_li_exp setLightColor[1,0.3,0.1];

_source01 = "#particlesource" createVehicleLocal getpos _unit_afect;
_source01 setParticleClass "ObjectDestructionFire1Smallx";
_source01 attachto [_unit_afect,[0,0,0.5]];
//_unit_afect say3D ["foc_initial_2",500];

_flame_heat = "#particlesource" createVehicleLocal (getposATL _unit_afect);
_flame_heat setParticleCircle [0,[0,0,0]];
_flame_heat setParticleRandom [0.1,[_maxWidth/6,_maxWidth/6,0],[0,0,0],8,0.1,[0,0,0,0.1],1,0];
_flame_heat setParticleParams [["\A3\data_f\ParticleEffects\Universal\Refract.p3d", 1, 0, 1], "", "Billboard", 1,1,[0,1,-1],[0,0,0.5],15,10.05,7.9,0.1,[1,1,0.1],[[1,1,1,0],[1,1,1,1],[1,1,1,0]],[0.08],1,0,"","",_unit_afect];
_flame_heat setDropInterval 0.1;
[_flame_heat,_life_time] spawn {_de_sters = _this select 0; _life_time = _this select 1; sleep _life_time;deleteVehicle _de_sters};

_flames_1 = "#particlesource" createVehicleLocal (getpos _unit_afect);
_flames_1 attachTo [_unit_afect, [0,0,-1],"camo1"];
_flames_1 setParticleCircle [0,[0,0,0]];
_flames_1 setParticleRandom [0.5,[_maxWidth/7,_maxWidth/7,0],[0,0,0],2,0.1,[0,0,0,0.1],0,0];
_flames_1 setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal.p3d",16,1,16,0],"","Billboard",1,2,[0,1,-1],[0,0,0],15,8,7.9,0.5,[1,0.5,0.2],[[1,1,1,0.5],[1,1,1,1],[1,1,1,1]],[1],0,0,"","",_unit_afect];
_flames_1 setDropInterval 0.05;
[_flames_1,_life_time] spawn {_de_sters = _this select 0; _life_time = _this select 1; sleep _life_time;deleteVehicle _de_sters};

_fum = "#particlesource" createVehicleLocal (getPos _unit_afect);
_fum setParticleCircle [0,[0,0,0]];
_fum setParticleRandom [0.2,[_maxWidth/3,_maxWidth/3,0.5],[0,0,0.5],0,0.02,[0,0,0,1],1,0];
_fum setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d",8,0,40,1],"","Billboard",1,7,[0,1,-1.5],[0,0,1],15,10,7.9,0.1,[2,3,5],[[0.5,0.2,0.2,0],[0,0,0,0.5],[1,1,1,0]],[1],1,0,"","",_unit_afect];
_fum setDropInterval 0.1;
[_fum,_life_time] spawn {_de_sters = _this select 0; _life_time = _this select 1; sleep _life_time;deleteVehicle _de_sters};

_sparks = "#particlesource" createVehicleLocal (getpos _unit_afect);
_sparks setParticleCircle [0,[0,0,0]];
_sparks setParticleRandom [0.5,[0.5,0.5,0.5],[0,0,0],10,0.01,[0,0,0,0.1],1,0.5];
_sparks setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal_02.p3d",16,15,16,1],"","Billboard",1,1,[0,1,0],[0,0,2],15,9,8,0.1,[0.05,0.05,0.01],[[1,1,1,1],[1,1,1,1],[1,1,1,1]],[1],1,0.5,"","",_unit_afect];
_sparks setDropInterval 0.1;

sleep 0.5;
deleteVehicle _source01;

[_li_exp] spawn {
	_lit = _this select 0;
	sleep 0.5;
	_lit setLightBrightness 10;
	while {alive _lit} do 
	{
		_lit setLightBrightness 3+(random 1);
		_lit setLightAttenuation [random 1,0,100,0,1,98+(random 2)];
		sleep 0.05+(random 0.1);
	};
};

//[_li_exp] spawn {_unit_afect=_this select 0; while {!isNull _unit_afect} do {_unit_afect say3d ["furnal",400]; sleep 3.5}};

sleep _life_time;
deleteVehicle _flame_heat;
deleteVehicle _flames_1;
deleteVehicle _fum;
deleteVehicle _li_exp;
deleteVehicle _sparks;

// gogo=selectionNames car_3;
// _fum attachTo [_unit_afect, [0,0,-1],"camo1"];