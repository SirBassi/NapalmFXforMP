// JBOY_NapalmFx.sqf
/*
Author:  Johnnyboy
Credits: AliasCartoons for fire fx.  Thanks brother!
		 snafu for including the Assets from SOG CDLC 1.2 Update
		 SirBassi workaround for making MP / Dedi ready
*/

//execVM this Script by init.sqf

//Change 09.12.22
//- Clutter remove
//- al_fire_deco.sqf remoteExec change to 2
//- al_fire_deco.sqf last "else" part disabled
//- al_small_fire.sqf remoteExec change to 2
//- al_small_fire.sqf last "else" part disabled
//- al_unit_fire_sfx.sq remoteExec change to 2
//- al_unit_fire.sqf remoteExec change to 2
//- al_vehicle_fire.sqf remoteExec change to 2
//- al_wild_fire_sfx.sqf waituntil added sleep
//-	al_wild_fire.sqf remoteExec change to 2
//- al_wild_fire.sqf 2x last "else" part disabled

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Vars for Napalm Script from ALIAS

player_onFire_from_vanillafire = true;	// if true the player will take fire from vanilla assets like camp fire, burning vehicle
publicVariable "player_onFire_from_vanillafire";

damage_playeron_fire = 0.5;	// amount of damage players will take from fire script
publicVariable "damage_playeron_fire";

set_vik_fire = true;          // if true by default all mission vehicles will be set in fire when they are disabled
publicVariable "set_vik_fire";

// animations used by players to get rid of fire
off_fire = ["amovppnemstpsraswrfldnon_amovppnemevaslowwrfldl","amovppnemstpsraswrfldnon_amovppnemevaslowwrfldr","amovppnemstpsnonwnondnon_amovppnemevasnonwnondl","amovppnemstpsnonwnondnon_amovppnemevasnonwnondr","amovppnemstpsraswpstdnon_amovppnemevaslowwpstdl","amovppnemstpsraswpstdnon_amovppnemevaslowwpstdr"];
publicVariable "off_fire";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

list_vegetation = ["TREE","SMALL TREE","BUSH","FOREST BORDER","FOREST TRIANGLE","FOREST SQUARE","FOREST"];
publicVariable "list_vegetation";

vik_list = ["CAR","TANK","PLANE","HELICOPTER","Motorcycle","Air","Ship"];
publicVariable "vik_list";

street_lapms = ["Land_fs_roof_F","Land_TTowerBig_2_F","Land_TTowerBig_1_F","Lamps_base_F","PowerLines_base_F","PowerLines_Small_base_F","Land_LampStreet_small_F"];
publicVariable "street_lapms";

buildings_list = ["BUILDING","HOUSE","CHURCH","CHAPEL","FUELSTATION","HOSPITAL","RUIN","BUNKER"];
publicVariable "buildings_list";

list_man = ["Civilian","SoldierGB","SoldierEB","SoldierWB"];
publicVariable "list_man";

/////////////////////// DO NOT EDIT LINES BELOW ///////////////////////////////////////////////////////////////////////

allPlayers_on = call BIS_fnc_listPlayers;
publicVariable "allPlayers_on";

all_car = allMissionObjects "CAR";
all_tank = allMissionObjects "TANK";
all_moto = allMissionObjects "Motorcycle";
all_viks = all_car+all_tank+all_moto;
publicVariable "all_viks";
if (count all_viks>0) then {
{if (isNil{_x getVariable "on_alias_fire"}) then {_life_time_fire = 10+random 60;[_x,_life_time_fire,true,true] execVM "Skripte\AL_fire\al_vehicle_fire.sqf"}} foreach all_viks};
		
NapalmAmmo = ["vn_bomb_500_blu1b_fb_ammo","vn_bomb_750_blu1b_fb_ammo","Uns_Napalm_750","Uns_Napalm_500","Uns_Napalm_blu1","uns_bomb_500_blu1b_fb_ammo","uns_bomb_750_blu1b_fb_ammo","vn_napalm_cluster_bomb_01","sticky_napalm_red_small"];
publicVariable "NapalmAmmo";

////////////////////////// Starting the Script for each new Plane which is created in Mission //////////////////////////////////////////////////////////////////////////////


private _eventHandlerId = addMissionEventHandler ["entityCreated", 
{
  	if (_this isKindOf "Plane") then 
  	{
		_this addEventHandler ["fired" ,
		{
			params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
			//Triggered when the unit fires a weapon.
			//This EH will not trigger if a unit fires out of a vehicle. For those cases an EH has to be attached to that particular vehicle.
			if (_ammo in NapalmAmmo ) then
				{
					//hint "inside loop";
					//unit: Object - object the event handler is assigned to
					// typeOf: Returns the class name of a given object.
					_aircraftType = typeOf _unit;
					publicVariable "_aircraftType";
					//systemChat str ["aircraftType: ", _aircraftType];
					_napalmcarrier = _unit;
					publicVariable "_napalmcarrier";
					//systemChat str ["Napalmcarrier", _napalmcarrier];
					typeofNapalmAmmo = _ammo;
					publicVariableServer "typeofNapalmAmmo";
					//systemChat str ["Ammo: ", typeofNapalmAmmo];
					_xpositionNapalmcarrier = position _unit select 0;
					_ypositionNapalmcarrier = position _unit select 1;
					_position = [_xpositionNapalmcarrier,_ypositionNapalmcarrier];
					[_aircraftType, _position] spawn JBOY_NapalmFxFindBombs;
				} 
			else
				{
					this removeEventHandler [_thisEvent, _thisEventHandler];
				};
		}];
	} 
	else	
	{
		removeMissionEventHandler ["entityCreated", 1];
	};
}]; 

JBOY_NapalmFxFindBombs =
{
	params["_aircraftType","_pos"];
	sleep 1;
	waitUntil {sleep .3; count (_pos nearObjects [_aircraftType, 2000]) > 0};
	_jet = (_pos nearObjects [_aircraftType, 2000]) #0;
	//systemChat str ["Jet found, Geschwindigkeit:",speed _jet];
	_dir = getDir _jet;
	_future = time + 60;
	waitUntil {count (_jet nearObjects [typeofNapalmAmmo, 1000]) > 0 or time > _future};
	_future = time + 60;
	_bombs = _jet nearObjects [typeofNapalmAmmo, 1000];
	//player globalChat str ["bombs found, Anzahl:", count _bombs];
	{
			[_x,_dir] spawn JBOY_trackBombImpact;
			//systemChat "JBOY_trackBombImpact spawned";
	} forEach _bombs;
};
JBOY_trackBombImpact =
{
	params["_bomb","_dir"];
	_airPos = getPos _bomb;
	_tempPos = [];
	while {getPos _bomb #2 >0} do 
	{
		_tempPos = getpos _bomb;
		if (_tempPos #2 > 0) then {_airPos = _tempPos};
	};
	_bombPos = [_airPos #0, _airPos #1,0];
	_helper = ["Sign_Arrow_Yellow_F",_bombPos] call JBOY_createHelperObj;
	_helper hideObjectGlobal true;
	_helper setDir _dir;
	_napalmCenter = _helper modelToWorld [0,10,0];
	[_napalmCenter,27] spawn JBOY_NapalmFX;
	//systemchat "JBOY_NapalmFX spawned";
	deleteVehicle _helper;
};


// ["Sign_Arrow_Yellow_F",_pos] call JBOY_createHelper;
JBOY_createHelperObj =
{
	params["_objType","_pos"];
	_obj = _objType createVehicleLocal [0,0,0];
	_obj setpos _pos;
	_obj
};


//[getpos player,50] call JBOY_NapalmFX;
JBOY_NapalmFX =
{ 
	params ["_pos","_radius",["_percentToReplace",100],["_delaySecs",5]];
	//systemchat str ["JBOY_NapalmFX, Position und Radius",_pos,_radius];
	//Medium Trees (burned ones tart with lowercase l
	_mediumBurnedTrees = [
	"land_vn_burned_t_cocosnucifera_03",
	"land_vn_burned_t_cocosnucifera_02",
	"land_vn_embers_t_cocosnucifera_01",
	"land_vn_embers_t_cocosnucifera_02",
	"land_vn_embers_t_cocosnucifera_03",
	"land_vn_embers_t_cocosnucifera_01",
	"land_vn_embers_t_ficus_medium_02",
	"land_vn_embers_t_ficus_medium_01",
	"Land_vn_d_fagussylvatica_stumpb",
	"Land_vn_d_fagussylvatica_stumpc",
	"Land_vn_misc_burnspruce_pmc",
	"Land_vn_misc_torzotree_pmc",
	"Land_vn_misc_fallenspruce_pmc",
	"Land_vn_d_fagussylvatica_fallenc",
	"Land_vn_t_piceaabies_2d",
	"Land_vn_d_betula_pendula_stem",
	"Land_vn_d_betula_pendula_stump",
	"Land_vn_d_fagussylvatica_fallenb",
	"Land_vn_d_fagussylvatica_fallenb",
	"Land_vn_misc_fallenspruce_1xtrunk_pmc",
	"Land_vn_misc_stubleafs_pmc",
	"Land_vn_misc_brokenspruce_pmc"];

	// Large Trees
	_largeBurnedTrees = [
	"land_vn_burned_t_ficus_big_01",
	"land_vn_burned_t_cocosnucifera_01",
	"land_vn_burned_t_ficus_big_04",
	"land_vn_burned_t_ficus_big_03",
	"land_vn_burned_t_ficus_medium_01",
	"land_vn_burned_t_ficus_big_02",
	"land_vn_embers_t_ficus_big_01",
	"land_vn_embers_t_ficus_big_02",
	"land_vn_embers_t_ficus_big_04",
	"land_vn_embers_t_ficus_big_03",
	"Land_vn_t_fagussylvatica_2d",
	"Land_vn_t_fagussylvatica_3d",
	"Land_vn_misc_fallentrunk_pmc",
	"Land_vn_d_fagussylvatica_fallen"];

	// bushes
	_bushTypes = [
	"Land_vn_b_ficusc2d_tanoa_f",
	"Land_vn_b_ficusc2d_tanoa_f",
	"Land_vn_b_ficusc2d_tanoa_f",
	"vn_ground_embers_01",
	"Land_vn_b_ficusc2d_tanoa_f"
	//,"Land_vn_d_fagussylvatica_fallenc"
	];

	sleep _delaySecs;

	// Cut the grss
	_trees = nearestTerrainObjects [_pos vectorAdd [0,0,4], ["tree"], _radius]; 
	//systemChat str ["count trees",count _trees];
	{ 
		if (random 100 <= _percentToReplace
			and !(isObjectHidden _x)) then
		{
			_tree = objNull;
			if ((boundingBox _x #1 #2) > 3.5) then
			{
				 _tree = createSimpleObject [selectRandom _largeBurnedTrees, [0,0,0]]; 
				_crater = createVehicle ["crater",getposatl _x ,[],0,"can_collide"];
				_crater setdir (random 360);
			} else
			{
				 _tree = createSimpleObject [selectRandom _mediumBurnedTrees, [0,0,0]]; 
				_crater = createVehicle ["crater",getposatl _x ,[],0,"can_collide"];
				_crater setdir (random 360);
				_crater setObjectScale (.5 min (1 - ((random 10)/10)));
			};
			hideObjectGlobal _x;
			_tree setposatl getposatl _x;
			_tree setdir (random 360);
			_tree setVectorUp (surfaceNormal getpos _tree);
			if ( selectRandom [true,true, false]
				or ((typeOf _tree) find "burned" >=0)) then {null=[_tree,0,30+random 50,false,false] execVM "Skripte\AL_fire\al_small_fire.sqf";};
		} else
		{
			hideObjectGlobal _x;
		};
	} forEach _trees;
	// hide all bushes
	_bushes = nearestTerrainObjects [_pos, ["bush"], _radius]; 
	{
		if (random 100 <= _percentToReplace
			and (boundingBox _x #1 #2) > .5
			and !(isObjectHidden _x)) then
		{
			_bushType = selectRandom _bushTypes;
			_bush = createSimpleObject [_bushType, [0,0,0]]; 
			hideObjectGlobal _x;
			_bush setposatl (getposatl _x vectorAdd [3-(random 6),3-(random 6),0]);
			if (_bushType == "Land_vn_b_ficusc2d_tanoa_f") then {_bush setpos (_bush modelToWorld [0,0,0-((random 3)/10)]); };
			_bush setdir (random 360);
			_bush setVectorUp (surfaceNormal getpos _bush);
				_crater = createVehicle ["vn_ground_burned_01",getposatl _x ,[],0,"can_collide"];
				_crater setdir (random 360);
				_crater setObjectScale (.4 min (.7 - ((random 7)/10)));
			if ( selectRandom [true, false, false]) then {null=[_bush,0,30+random 20,false,false] execVM "Skripte\AL_fire\al_small_fire.sqf";};
		} else
		{
			hideObjectGlobal _x;
		};
	} foreach _bushes; 
	// Burn vehicles
	{
		//systemchat str ["vehicle",_x,typeOf _x];
		null=[_x,30+random 40,true,true,true] execVM "Skripte\AL_fire\al_vehicle_fire.sqf";
	} forEach nearestObjects [_pos, ["CAR","TANK","Motorcycle","Ship"], _radius];
	_manTypes = ["Civilian","SoldierGB","SoldierEB","SoldierWB"]; // Note that nearestObjects using "Man" also returns animal entities
	// Burn men
	{
		null=[_x,30+random 40,10] execVM "Skripte\AL_fire\al_unit_fire.sqf";
	} forEach nearestObjects [_pos, _manTypes, _radius];
	// Remove all ground clutter
	[_radius,_pos] call JBOY_cutClutter;
	//systemChat "JBOY_cutClutter spawned";
	// Burn buildings and other man-made stuff
	[_pos,_radius] call JBOY_burnBuildingsEtc;
	//systemChat "JBOY_burnBuildingsEtc spawned";	
};
// *******************************************************
// algorithm for concentric circles to cover circle.
// *******************************************************
//[50,getpos player] spawn
JBOY_cutClutter =
{
	params ["_radius","_centerPos"];
	_cutterRadius = 5.0;
	_vertCirclesToCreate = round (_radius / _cutterRadius);
	if (_vertCirclesToCreate mod 2 == 0) then {_vertCirclesToCreate = _vertCirclesToCreate + 1};
	_centerY = _centerPos #1;
	_bottomY = _centerY - (((_vertCirclesToCreate -1)/2) * _cutterRadius);
	_bottomPos = [_centerPos #0,_bottomY, 0];
	//systemchat str ["_centerPos",_centerPos,"_bottomPos",_bottomPos];
	_increment = 0;
	for "_i" from 1 to _vertCirclesToCreate do 
	{
		_cutter = createVehicle ["Land_ClutterCutter_large_F",[_bottomPos #0, (_bottomPos #1) + _increment,0] ,[],0,"can_collide"];
		_cutter setdir (random 360);
		_increment = _increment + _cutterRadius;
		deleteVehicle _cutter;
	};
	_stepOuts = round (_vertCirclesToCreate / 2);
	_Xincrement = _cutterRadius;
	for "_i" from 1 to _stepOuts do 
	{
		_vertCirclesToCreate = _vertCirclesToCreate -1;
		_increment = 0;
		_bottomY = _bottomY + (_cutterRadius/2);
		_bottomPos = [(_centerPos #0)-_Xincrement,_bottomY, 0];
		for "_j" from 1 to _vertCirclesToCreate do 
		{
			_cutterPos = [(_bottomPos #0), (_bottomPos #1) + _increment,0] ;
			_cutter = createVehicle ["Land_ClutterCutter_large_F",_cutterPos ,[],0,"can_collide"];
			_cutter setdir (random 360);
			//_helper = ["Sign_Arrow_Yellow_F",_cutterPos] call JBOY_createHelperObj;
			if (count (_cutter nearObjects ["Crater",4]) == 0) then // add more burnt craters if no bushes/trees were near
			{
				_crater = createVehicle ["crater",[_cutterPos #0 +(3 - (random 6) ), _cutterPos #1, 0]  ,[],0,"can_collide"];
				_crater setdir (random 360);
				_crater setObjectScale (.7 min (1 - ((random 10)/10)));
			};
			deleteVehicle _cutter;
			_cutterPos = [(_bottomPos #0)+(_Xincrement*2), (_bottomPos #1) + _increment,0] ;
			_cutter = createVehicle ["vn_ground_burned_01",_cutterPos ,[],0,"can_collide"];
			_cutter setdir (random 360);
			//_helper = ["Sign_Arrow_Yellow_F",_cutterPos] call JBOY_createHelperObj;
			if (count (_cutter nearObjects ["Crater",3]) == 0) then // add more burnt craters if no bushes/trees were near
			{
				_crater = createVehicle ["crater",[_cutterPos #0 +(3 - (random 6) ), _cutterPos #1, 0]  ,[],0,"can_collide"];
				_crater setdir (random 360);
				_crater setObjectScale (.7 min (1 - ((random 10)/10)));
			};
			deleteVehicle _cutter;
			_increment = _increment + _cutterRadius;
		};
		_Xincrement = _Xincrement + _cutterRadius;
	};
};

// Destroy and burn other objects
//[getpos player, 10] call JBOY_burnBuildingsEtc;
JBOY_burnBuildingsEtc =
{
	params ["_pos","_radius"];
	{
		if !(_x getVariable ["alreadyBurned",false]) then 
		{
			_x setVariable ["alreadyBurned",true,true];
			_type = toLower (typeOf _x);
			if ((!(_x isKindOf "Man")  // kill all men
				and !(_x isKindOf "Building")
				and (random 100) > 33)
				or (_type find "cable" >=0)) // and power/phone lines between poles, else they are in air without a pole
				then
			{
				_x setDamage 1;
			};
			if (_x isKindOf "House" 
				and !(_type find "pole" >=0)
				and !(_type find "lamp" >=0)
				and !(_type find "cable" >=0)
				and !(_type find "shelter" >=0)
				and !(_type find "crater" >=0)  // craters are buildings
				and !(_type find "burned" >=0)  // burned trees are buildings
				) then
			{
				_housePos = getpos _x;
				_width = (0 boundingBoxReal _x) #1 #0;
				if (_type find "slum" >=0) then 
				{
					_helper = ["Sign_Arrow_Yellow_F",[0,0,0]] call JBOY_createHelperObj; 
					hideObjectGlobal _helper;
					_yOffset = ((0 boundingBoxReal _x) #1 #2);
					//_helper setpos ( getposatl _x vectorAdd [0,0,_yOffset-1]); 
					_helper setpos _housePos; 
					null=[_helper,30+random 60,1,1.5,0.5,true,0.5] execVM "Skripte\AL_fire\AL_fire_deco.sqf";
					_x setDamage 1;
					[_x,_width] spawn JBOY_hideObjToExposeRuins;
				} else
				{
					//systemChat typeOf _x;
					_helper = ["Sign_Arrow_Yellow_F",[0,0,0]] call JBOY_createHelperObj; 
					hideObjectGlobal _helper;
					_yOffset = ((0 boundingBoxReal _x) #1 #2);
					//_helper setpos ( getposatl _x vectorAdd [0,0,_yOffset]); 
					_helper setpos _housePos; 
					null=[_x,30+random 60,2.5,2,0.5,true,0.5] execVM "Skripte\AL_fire\AL_fire_deco.sqf";
					if (_width < 8 or (_type find "hut" >=0)) then 
					{
						_x setDamage 1;
						[_x,_width] spawn JBOY_hideObjToExposeRuins;
						//systemChat "JBOY_hideObjToExposeRuins spawned";
					};
				};
				if (_type find "addon" >= 0) then 
				{
					hideObjectGlobal _x;
				};
			};
			if (_x isKindOf "Building" 
				and ((_type find "pole" >=0)
				or (_type find "lamp" >=0)
				)) then
			{
				if ( selectRandom [true,false, false]) then {null=[_x,0,30+random 50,false,false] execVM "Skripte\AL_fire\al_small_fire.sqf";};
			};
		};
	} foreach (nearestObjects [_pos, [], _radius]);
};
// For some reason some Prairie Fire objects don't hide original buildign when destroyed (but still have ruins created
// in same spot).
JBOY_hideObjToExposeRuins =
{
	params["_house","_width"];
	_mediumRuins = ["Land_vn_hut_04_ruin","Land_vn_hut_03_ruin","Land_Shed_07_ruins_F"];
	_smallRuins = ["Land_Slum_House02_ruins_F","Land_Slum_House03_ruins_F","Land_Slum_House01_ruins_F","Land_BusStop_02_shelter_ruins_F","Land_vn_hut_04_ruin","Land_House_Native_02_ruins_F"];
	_hutRuins = ["Land_vn_hut_04_ruin","Land_vn_hut_03_ruin","Land_vn_hut_04_ruin","Land_House_Native_02_ruins_F"];

	sleep 1;
	_pos = getpos _house;
	_dir = getdir _house;
	_type = typeOf _house;
		hideObjectGlobal _house;
	if (damage _house == 1) then 
	{
		hideObjectGlobal _house;
		_ruin = objNull;
		if (_type find "hut" >= 0 or _type find "native" >= 0) then 
		{
			_ruin = createSimpleObject [selectRandom _hutRuins, [0,0,0]]; 
			_pos = _pos vectorAdd [0,0,3.5];
			null=[_ruin,0,30+random 40,false,false] execVM "Skripte\AL_fire\al_small_fire.sqf";
		} else
		{
			if (_width <= 5) then 
			{
				_ruin = createSimpleObject [selectRandom _smallRuins, [0,0,0]]; 
				_pos = _pos vectorAdd [0,0,1.5];
			} else
			{
				_ruin = createSimpleObject [selectRandom _mediumRuins, [0,0,0]]; 			
			};
		};
		_ruin setpos _pos;
		_ruin setDir _dir;
	};
};
//[getpos player, 10] call JBOY_burnBuildingsEtc;