class Config_Pickup extends Config_Common
	config(ZedternalReborn_Game);

var config int MODEVERSION;

var config S_Difficulty_Bool Pickup_bEnablePickups;
var config S_Difficulty_Bool Pickup_bEnableAmmoPickups;
var config S_Difficulty_Bool Pickup_bEnableWeaponPickups;
var config S_Difficulty_Bool Pickup_bArmorSpawnOnMap;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Pickup_bEnablePickups.Normal = True;
		default.Pickup_bEnablePickups.Hard = True;
		default.Pickup_bEnablePickups.Suicidal = True;
		default.Pickup_bEnablePickups.HoE = True;
		default.Pickup_bEnablePickups.Custom = True;

		default.Pickup_bEnableAmmoPickups.Normal = True;
		default.Pickup_bEnableAmmoPickups.Hard = True;
		default.Pickup_bEnableAmmoPickups.Suicidal = True;
		default.Pickup_bEnableAmmoPickups.HoE = True;
		default.Pickup_bEnableAmmoPickups.Custom = True;

		default.Pickup_bEnableWeaponPickups.Normal = True;
		default.Pickup_bEnableWeaponPickups.Hard = True;
		default.Pickup_bEnableWeaponPickups.Suicidal = True;
		default.Pickup_bEnableWeaponPickups.HoE = True;
		default.Pickup_bEnableWeaponPickups.Custom = True;

		default.Pickup_bArmorSpawnOnMap.Normal = True;
		default.Pickup_bArmorSpawnOnMap.Hard = True;
		default.Pickup_bArmorSpawnOnMap.Suicidal = True;
		default.Pickup_bArmorSpawnOnMap.HoE = True;
		default.Pickup_bArmorSpawnOnMap.Custom = True;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

static function CheckBasicConfigValues()
{
	local byte i;

	for (i = 0; i < NumberOfDiffs; ++i)
	{
	}
}

static function bool GetEnablePickups(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Pickup_bEnablePickups.Normal;
		case 1 : return default.Pickup_bEnablePickups.Hard;
		case 2 : return default.Pickup_bEnablePickups.Suicidal;
		case 3 : return default.Pickup_bEnablePickups.HoE;
		default: return default.Pickup_bEnablePickups.Custom;
	}
}

static function bool GetEnableAmmoPickups(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Pickup_bEnableAmmoPickups.Normal;
		case 1 : return default.Pickup_bEnableAmmoPickups.Hard;
		case 2 : return default.Pickup_bEnableAmmoPickups.Suicidal;
		case 3 : return default.Pickup_bEnableAmmoPickups.HoE;
		default: return default.Pickup_bEnableAmmoPickups.Custom;
	}
}

static function bool GetEnableWeaponPickups(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Pickup_bEnableWeaponPickups.Normal;
		case 1 : return default.Pickup_bEnableWeaponPickups.Hard;
		case 2 : return default.Pickup_bEnableWeaponPickups.Suicidal;
		case 3 : return default.Pickup_bEnableWeaponPickups.HoE;
		default: return default.Pickup_bEnableWeaponPickups.Custom;
	}
}

static function bool GetShouldArmorSpawnOnMap(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Pickup_bArmorSpawnOnMap.Normal;
		case 1 : return default.Pickup_bArmorSpawnOnMap.Hard;
		case 2 : return default.Pickup_bArmorSpawnOnMap.Suicidal;
		case 3 : return default.Pickup_bArmorSpawnOnMap.HoE;
		default: return default.Pickup_bArmorSpawnOnMap.Custom;
	}
}

defaultproperties
{
	Name="Default__Config_Pickup"
}
