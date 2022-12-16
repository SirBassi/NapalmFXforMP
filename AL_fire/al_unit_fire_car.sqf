// by ALIAS
// deletevehicle wildfire; car_4 setdamage 0.9
//null=[unit_source,life_time,_kill_time] execVM "AL_fire\al_unit_fire.sqf";

private ["_unit_surs","_life_time","_avoid_fire","_rnd","_tip"];
params ["_unit_surs","_life_time","_kill_time","_unit_afect"];

removeAllWeapons _unit_surs; [_unit_surs, "NoVoice"] remoteExec ["setSpeaker",2];
_unit_surs setBehaviour "AWARE"; _unit_surs enableFatigue false; _unit_surs forcespeed 10;_unit_surs setUnitPos "UP"; _unit_surs setSkill ["commanding", 1];[_unit_surs] joinSilent grpNull;_unit_surs setAnimSpeedCoef 1.1;
_avoid_fire= _unit_surs getRelPos [200+random 200,random 360]; _unit_surs doMove _avoid_fire;

if ((selectRandom [true,false])&&(alive _unit_surs)) then 
{
	[[_unit_surs,_life_time],"Skripte\AL_fire\al_unit_fire_sfx.sqf"] remoteExec ["execvm",2];
	// _tip = selectRandom ["01","02","03","05","04"];
	// [_unit_surs,[_tip,300]] remoteExec ["say3d"];
	sleep _life_time;
	_unit_surs setDamage 1;
};