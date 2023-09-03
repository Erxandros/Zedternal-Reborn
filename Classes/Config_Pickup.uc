class Config_Pickup extends Config_Common
	config(ZedternalReborn_Game);

var config int MODEVERSION;

var config S_Difficulty_Bool Pickup_bEnablePickups;
var config S_Difficulty_Bool Pickup_bEnableAmmoPickups;
var config S_Difficulty_Bool Pickup_bEnableWeaponPickups;
var config S_Difficulty_Bool Pickup_bArmorSpawnOnMap;

var config S_Difficulty_Float Pickup_AmmoPickupBasePercentage;
var config S_Difficulty_Float Pickup_AmmoPickupPercentageIncPerWave;
var config S_Difficulty_Float Pickup_AmmoPickupMaxPercentage;

var config S_Difficulty_Float Pickup_WeaponPickupBasePercentage;
var config S_Difficulty_Float Pickup_WeaponPickupPercentageIncPerWave;
var config S_Difficulty_Float Pickup_WeaponPickupMaxPercentage;

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

		default.Pickup_AmmoPickupBasePercentage.Normal = 0.4f;
		default.Pickup_AmmoPickupBasePercentage.Hard = 0.35f;
		default.Pickup_AmmoPickupBasePercentage.Suicidal = 0.3f;
		default.Pickup_AmmoPickupBasePercentage.HoE = 0.25f;
		default.Pickup_AmmoPickupBasePercentage.Custom = 0.25f;

		default.Pickup_AmmoPickupPercentageIncPerWave.Normal = 0.04f;
		default.Pickup_AmmoPickupPercentageIncPerWave.Hard = 0.03f;
		default.Pickup_AmmoPickupPercentageIncPerWave.Suicidal = 0.02f;
		default.Pickup_AmmoPickupPercentageIncPerWave.HoE = 0.015f;
		default.Pickup_AmmoPickupPercentageIncPerWave.Custom = 0.015f;

		default.Pickup_AmmoPickupMaxPercentage.Normal = 0.95f;
		default.Pickup_AmmoPickupMaxPercentage.Hard = 0.90f;
		default.Pickup_AmmoPickupMaxPercentage.Suicidal = 0.85f;
		default.Pickup_AmmoPickupMaxPercentage.HoE = 0.8f;
		default.Pickup_AmmoPickupMaxPercentage.Custom = 0.8f;

		default.Pickup_WeaponPickupBasePercentage.Normal = 0.45f;
		default.Pickup_WeaponPickupBasePercentage.Hard = 0.35f;
		default.Pickup_WeaponPickupBasePercentage.Suicidal = 0.25f;
		default.Pickup_WeaponPickupBasePercentage.HoE = 0.1f;
		default.Pickup_WeaponPickupBasePercentage.Custom = 0.1f;

		default.Pickup_WeaponPickupPercentageIncPerWave.Normal = 0.03f;
		default.Pickup_WeaponPickupPercentageIncPerWave.Hard = 0.025f;
		default.Pickup_WeaponPickupPercentageIncPerWave.Suicidal = 0.02f;
		default.Pickup_WeaponPickupPercentageIncPerWave.HoE = 0.015f;
		default.Pickup_WeaponPickupPercentageIncPerWave.Custom = 0.015f;

		default.Pickup_WeaponPickupMaxPercentage.Normal = 0.9f;
		default.Pickup_WeaponPickupMaxPercentage.Hard = 0.8f;
		default.Pickup_WeaponPickupMaxPercentage.Suicidal = 0.7f;
		default.Pickup_WeaponPickupMaxPercentage.HoE = 0.55f;
		default.Pickup_WeaponPickupMaxPercentage.Custom = 0.55f;
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

static function int GetAmmoPickupAmount(int Difficulty, int NumAmmoPickups, int WaveNum)
{
	local float base, inc, max;
	local int wave;

	switch (Difficulty)
	{
		case 0 : base = default.Pickup_AmmoPickupBasePercentage.Normal; inc = default.Pickup_AmmoPickupPercentageIncPerWave.Normal; max = default.Pickup_AmmoPickupMaxPercentage.Normal; break;
		case 1 : base = default.Pickup_AmmoPickupBasePercentage.Hard; inc = default.Pickup_AmmoPickupPercentageIncPerWave.Hard; max = default.Pickup_AmmoPickupMaxPercentage.Hard; break;
		case 2 : base = default.Pickup_AmmoPickupBasePercentage.Suicidal; inc = default.Pickup_AmmoPickupPercentageIncPerWave.Suicidal; max = default.Pickup_AmmoPickupMaxPercentage.Suicidal; break;
		case 3 : base = default.Pickup_AmmoPickupBasePercentage.HoE; inc = default.Pickup_AmmoPickupPercentageIncPerWave.HoE; max = default.Pickup_AmmoPickupMaxPercentage.HoE; break;
		default: base = default.Pickup_AmmoPickupBasePercentage.Custom; inc = default.Pickup_AmmoPickupPercentageIncPerWave.Custom; max = default.Pickup_AmmoPickupMaxPercentage.Custom; break;
	}

	wave = WaveNum - 1;
	return Min(Round(float(NumAmmoPickups) * (base + inc * float(wave))), Round(float(NumAmmoPickups) * max));
}

static function int GetWeaponPickupAmount(int Difficulty, int NumWeaponPickups, int WaveNum)
{
	local float base, inc, max;
	local int wave;

	switch (Difficulty)
	{
		case 0 : base = default.Pickup_WeaponPickupBasePercentage.Normal; inc = default.Pickup_WeaponPickupPercentageIncPerWave.Normal; max = default.Pickup_WeaponPickupMaxPercentage.Normal; break;
		case 1 : base = default.Pickup_WeaponPickupBasePercentage.Hard; inc = default.Pickup_WeaponPickupPercentageIncPerWave.Hard; max = default.Pickup_WeaponPickupMaxPercentage.Hard; break;
		case 2 : base = default.Pickup_WeaponPickupBasePercentage.Suicidal; inc = default.Pickup_WeaponPickupPercentageIncPerWave.Suicidal; max = default.Pickup_WeaponPickupMaxPercentage.Suicidal; break;
		case 3 : base = default.Pickup_WeaponPickupBasePercentage.HoE; inc = default.Pickup_WeaponPickupPercentageIncPerWave.HoE; max = default.Pickup_WeaponPickupMaxPercentage.HoE; break;
		default: base = default.Pickup_WeaponPickupBasePercentage.Custom; inc = default.Pickup_WeaponPickupPercentageIncPerWave.Custom; max = default.Pickup_WeaponPickupMaxPercentage.Custom; break;
	}

	wave = WaveNum - 1;
	return Min(Round(float(NumWeaponPickups) * (base + inc * float(wave))), Round(float(NumWeaponPickups) * max));
}

defaultproperties
{
	Name="Default__Config_Pickup"
}
