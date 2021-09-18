class Config_WaveOptions extends Config_Common
	config(ZedternalReborn_ZedWaves);

var config int MODEVERSION;

var config S_Difficulty_Bool Wave_bAllowZedTeleport;
var config S_Difficulty_Bool Wave_bAllowFastSpawning;
var config S_Difficulty_Int Wave_MaxUniqueZedsInWave;
var config S_Difficulty_Int Wave_MaxSpawnedZedsOnLevel;
var config S_Difficulty_Int Wave_MaxNumberOfZedsToSpawn;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Wave_bAllowZedTeleport.Normal = False;
		default.Wave_bAllowZedTeleport.Hard = False;
		default.Wave_bAllowZedTeleport.Suicidal = False;
		default.Wave_bAllowZedTeleport.HoE = False;
		default.Wave_bAllowZedTeleport.Custom = False;

		default.Wave_bAllowFastSpawning.Normal = True;
		default.Wave_bAllowFastSpawning.Hard = True;
		default.Wave_bAllowFastSpawning.Suicidal = True;
		default.Wave_bAllowFastSpawning.HoE = True;
		default.Wave_bAllowFastSpawning.Custom = True;

		default.Wave_MaxUniqueZedsInWave.Normal = 12;
		default.Wave_MaxUniqueZedsInWave.Hard = 12;
		default.Wave_MaxUniqueZedsInWave.Suicidal = 12;
		default.Wave_MaxUniqueZedsInWave.HoE = 12;
		default.Wave_MaxUniqueZedsInWave.Custom = 12;

		default.Wave_MaxSpawnedZedsOnLevel.Normal = 52;
		default.Wave_MaxSpawnedZedsOnLevel.Hard = 52;
		default.Wave_MaxSpawnedZedsOnLevel.Suicidal = 52;
		default.Wave_MaxSpawnedZedsOnLevel.HoE = 52;
		default.Wave_MaxSpawnedZedsOnLevel.Custom = 52;

		default.Wave_MaxNumberOfZedsToSpawn.Normal = 800;
		default.Wave_MaxNumberOfZedsToSpawn.Hard = 1200;
		default.Wave_MaxNumberOfZedsToSpawn.Suicidal = 1600;
		default.Wave_MaxNumberOfZedsToSpawn.HoE = 2000;
		default.Wave_MaxNumberOfZedsToSpawn.Custom = 2000;
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
		if (GetStructValueInt(default.Wave_MaxUniqueZedsInWave, i) < 1)
		{
			LogBadStructConfigMessage(i, "Wave_MaxUniqueZedsInWave",
				string(GetStructValueInt(default.Wave_MaxUniqueZedsInWave, i)),
				"1", "1 unique zed in wave", "value >= 1");
			SetStructValueInt(default.Wave_MaxUniqueZedsInWave, i, 1);
		}

		if (GetStructValueInt(default.Wave_MaxSpawnedZedsOnLevel, i) < 1)
		{
			LogBadStructConfigMessage(i, "Wave_MaxSpawnedZedsOnLevel",
				string(GetStructValueInt(default.Wave_MaxSpawnedZedsOnLevel, i)),
				"1", "1 zed on level", "value >= 1");
			SetStructValueInt(default.Wave_MaxSpawnedZedsOnLevel, i, 1);
		}

		if (GetStructValueInt(default.Wave_MaxNumberOfZedsToSpawn, i) < 1)
		{
			LogBadStructConfigMessage(i, "Wave_MaxNumberOfZedsToSpawn",
				string(GetStructValueInt(default.Wave_MaxNumberOfZedsToSpawn, i)),
				"1", "1 zed", "value >= 1");
			SetStructValueInt(default.Wave_MaxNumberOfZedsToSpawn, i, 1);
		}
	}
}

static function bool GetAllowZedTeleport(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Wave_bAllowZedTeleport.Normal;
		case 1 : return default.Wave_bAllowZedTeleport.Hard;
		case 2 : return default.Wave_bAllowZedTeleport.Suicidal;
		case 3 : return default.Wave_bAllowZedTeleport.HoE;
		default: return default.Wave_bAllowZedTeleport.Custom;
	}
}

static function bool GetAllowFastSpawning(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Wave_bAllowFastSpawning.Normal;
		case 1 : return default.Wave_bAllowFastSpawning.Hard;
		case 2 : return default.Wave_bAllowFastSpawning.Suicidal;
		case 3 : return default.Wave_bAllowFastSpawning.HoE;
		default: return default.Wave_bAllowFastSpawning.Custom;
	}
}

static function int GetMaxUniqueZedsInWave(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Wave_MaxUniqueZedsInWave.Normal;
		case 1 : return default.Wave_MaxUniqueZedsInWave.Hard;
		case 2 : return default.Wave_MaxUniqueZedsInWave.Suicidal;
		case 3 : return default.Wave_MaxUniqueZedsInWave.HoE;
		default: return default.Wave_MaxUniqueZedsInWave.Custom;
	}
}

static function int GetMaxSpawnedZedsOnLevel(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Wave_MaxSpawnedZedsOnLevel.Normal;
		case 1 : return default.Wave_MaxSpawnedZedsOnLevel.Hard;
		case 2 : return default.Wave_MaxSpawnedZedsOnLevel.Suicidal;
		case 3 : return default.Wave_MaxSpawnedZedsOnLevel.HoE;
		default: return default.Wave_MaxSpawnedZedsOnLevel.Custom;
	}
}

static function int GetMaxNumberOfZedsToSpawn(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Wave_MaxNumberOfZedsToSpawn.Normal;
		case 1 : return default.Wave_MaxNumberOfZedsToSpawn.Hard;
		case 2 : return default.Wave_MaxNumberOfZedsToSpawn.Suicidal;
		case 3 : return default.Wave_MaxNumberOfZedsToSpawn.HoE;
		default: return default.Wave_MaxNumberOfZedsToSpawn.Custom;
	}
}

defaultproperties
{
	Name="Default__Config_WaveOptions"
}
