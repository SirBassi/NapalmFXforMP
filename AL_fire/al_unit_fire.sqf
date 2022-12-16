// by ALIAS

//null=[unit_source,life_time,_kill_time] execVM "AL_fire\al_unit_fire.sqf";
params ["_unit_surs","_life_time","_kill_time"];

_unit_surs setVariable ["killed_by_fire",false];
_screams = ["a3\sounds_f_orange\missionsfx\pastambiences\idaphospitaltent\orange_idaphospitaltent_pain_01.wss",
	"a3\sounds_f_orange\missionsfx\pastambiences\idaphospitaltent\orange_idaphospitaltent_pain_03.wss",
	"a3\sounds_f_orange\missionsfx\pastambiences\idaphospitaltent\orange_idaphospitaltent_pain_05.wss",
	"a3\dubbing_radio_f_exp\data\fre\male03fre\radioprotocolfre\combat\200_combatshouts\screaminge_1.ogg"] call BIS_fnc_arrayShuffle; 

if (_kill_time>_life_time) exitWith {hint "The fire's lifetime must be longer than killtime"};

removeAllWeapons _unit_surs;
[_unit_surs, "NoVoice"] remoteExec ["setSpeaker",2];_unit_surs setBehaviour "AWARE"; _unit_surs enableFatigue false; _unit_surs forcespeed 13;_unit_surs setUnitPos "UP"; _unit_surs setSkill ["commanding", 1];[_unit_surs] joinSilent grpNull;
_unit_surs setSpeedMode "FULL";
_unit_surs setAnimSpeedCoef 1.1;

[_unit_surs,_kill_time] spawn {
	params ["_unit_surs","_kill_time"];
	sleep _kill_time;
	_unit_surs setVariable ["killed_by_fire",true,true];
};
if (alive _unit_surs) then {[[_unit_surs,_life_time],"Skripte\AL_fire\al_unit_fire_sfx.sqf"] remoteExec ["execvm",2]};
//[_unit_surs,["01",200]] remoteExec ["say3d"];
playSound3D [selectRandom _screams, _unit_surs, false, getPosASL _unit_surs]; 
sleep 1;
_tip_prec="";
_avoid_fire= _unit_surs getRelPos [200+random 200,random 360]; _unit_surs doMove _avoid_fire;

waitUntil {_unit_surs getVariable ["killed_by_fire",false]};
playSound3D [selectRandom _screams, _unit_surs, false, getPosASL _unit_surs]; 
//waitUntil {!isNil{_unit_surs getVariable "killed_by_fire"}};
//[_unit_surs,["05",200]] remoteExec ["say3d"];
sleep 0.7 + random 0.5;
_unit_surs setDamage 1;