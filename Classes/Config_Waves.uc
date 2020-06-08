class Config_Waves extends Config_Base
	config(ZedternalReborn);

var config int MODEVERSION;

var config int ZedSpawn_MaxSpawnedMonster;
var config int ZedSpawn_MaxNumberOfMonster;
var config S_Difficulty_Int ZedSpawn_BaseValue;
var config S_Difficulty_Int ZedSpawn_ValueIncPerwave;
var config float ZedSpawn_ValueFactorPerWave;
var config float ZedSpawn_ValuePowerPerWave;
var config array< float > ZedSpawn_ValueFactorPerPlayer;

var config S_Difficulty_Float ZedSpawn_ZedSpawnRate;
var config float ZedSpawn_ZedSpawnRateIncPerWave;
var config float ZedSpawn_ZedSpawnRatePowerPerWave;
var config array< float > ZedSpawn_ZedSpawnRatePerPlayer;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.ZedSpawn_MaxSpawnedMonster = 52;
		default.ZedSpawn_MaxNumberOfMonster = 800;

		default.ZedSpawn_BaseValue.Normal = 130;
		default.ZedSpawn_BaseValue.Hard = 150;
		default.ZedSpawn_BaseValue.Suicidal = 160;
		default.ZedSpawn_BaseValue.HoE = 170;
		default.ZedSpawn_BaseValue.Custom = 150;

		default.ZedSpawn_ValueIncPerwave.Normal = 26;
		default.ZedSpawn_ValueIncPerwave.Hard = 28;
		default.ZedSpawn_ValueIncPerwave.Suicidal = 29;
		default.ZedSpawn_ValueIncPerwave.HoE = 30;
		default.ZedSpawn_ValueIncPerwave.Custom = 28;

		default.ZedSpawn_ValueFactorPerWave = 0.052000;
		default.ZedSpawn_ValuePowerPerWave = 0.006500;

		default.ZedSpawn_ValueFactorPerPlayer[0] = 1.200000;
		default.ZedSpawn_ValueFactorPerPlayer[1] = 1.750000;
		default.ZedSpawn_ValueFactorPerPlayer[2] = 2.500000;
		default.ZedSpawn_ValueFactorPerPlayer[3] = 3.100000;
		default.ZedSpawn_ValueFactorPerPlayer[4] = 3.700000;
		default.ZedSpawn_ValueFactorPerPlayer[5] = 4.300000;

		default.ZedSpawn_ZedSpawnRate.Normal = 0.950000;
		default.ZedSpawn_ZedSpawnRate.Hard = 1.000000;
		default.ZedSpawn_ZedSpawnRate.Suicidal = 1.050000;
		default.ZedSpawn_ZedSpawnRate.HoE = 1.100000;
		default.ZedSpawn_ZedSpawnRate.Custom = 1.000000;

		default.ZedSpawn_ZedSpawnRateIncPerWave = 0.020000;
		default.ZedSpawn_ZedSpawnRatePowerPerWave = 0.140000;

		default.ZedSpawn_ZedSpawnRatePerPlayer[0] = 1.000000;
		default.ZedSpawn_ZedSpawnRatePerPlayer[1] = 1.700000;
		default.ZedSpawn_ZedSpawnRatePerPlayer[2] = 2.400000;
		default.ZedSpawn_ZedSpawnRatePerPlayer[3] = 3.000000;
		default.ZedSpawn_ZedSpawnRatePerPlayer[4] = 3.500000;
		default.ZedSpawn_ZedSpawnRatePerPlayer[5] = 4.100000;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.default.currentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.default.currentVersion;
		static.StaticSaveConfig();
	}
}

static function int GetBaseValue(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.ZedSpawn_BaseValue.Normal;
		case 1 :	return default.ZedSpawn_BaseValue.Hard;
		case 2 :	return default.ZedSpawn_BaseValue.Suicidal;
		case 3 :	return default.ZedSpawn_BaseValue.HoE;
		default:	return default.ZedSpawn_BaseValue.Custom;
	}
}

static function int GetValueIncPerwave(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.ZedSpawn_ValueIncPerwave.Normal;
		case 1 :	return default.ZedSpawn_ValueIncPerwave.Hard;
		case 2 :	return default.ZedSpawn_ValueIncPerwave.Suicidal;
		case 3 :	return default.ZedSpawn_ValueIncPerwave.HoE;
		default:	return default.ZedSpawn_ValueIncPerwave.Custom;
	}
}

static function float GetZedSpawnRate(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.ZedSpawn_ZedSpawnRate.Normal;
		case 1 :	return default.ZedSpawn_ZedSpawnRate.Hard;
		case 2 :	return default.ZedSpawn_ZedSpawnRate.Suicidal;
		case 3 :	return default.ZedSpawn_ZedSpawnRate.HoE;
		default:	return default.ZedSpawn_ZedSpawnRate.Custom;
	}
}

static function float GetValueFactor(int NbPlayer)
{
	local int arrayLength;
	local float delta;
	
	arrayLength = default.ZedSpawn_ValueFactorPerPlayer.length;
	
	if (arrayLength == 0)
		return 1.f;
	else if (NbPlayer == 0)
		return default.ZedSpawn_ValueFactorPerPlayer[0];
	else if (NbPlayer <= arrayLength)
		return default.ZedSpawn_ValueFactorPerPlayer[NbPlayer - 1];
	else
	{
		if (arrayLength == 1)
			return default.ZedSpawn_ValueFactorPerPlayer[0] * NbPlayer;
		else
		{
			delta = FMax(0.f, default.ZedSpawn_ValueFactorPerPlayer[arrayLength - 1] - default.ZedSpawn_ValueFactorPerPlayer[arrayLength - 2]);
			return delta * (NbPlayer - arrayLength) + default.ZedSpawn_ValueFactorPerPlayer[arrayLength - 1];
		}
	}
}

static function float ZedSpawnRateFactor(int NbPlayer)
{
	local int arrayLength;
	local float delta;
	
	arrayLength = default.ZedSpawn_ZedSpawnRatePerPlayer.length;
	
	if (arrayLength == 0)
		return 1.f;
	else if (NbPlayer == 0)
		return default.ZedSpawn_ZedSpawnRatePerPlayer[0];
	else if (NbPlayer <= arrayLength)
		return default.ZedSpawn_ZedSpawnRatePerPlayer[NbPlayer - 1];
	else
	{
		if (arrayLength == 1)
			return default.ZedSpawn_ZedSpawnRatePerPlayer[0] * NbPlayer;
		else
		{
			delta = FMax(0.f, default.ZedSpawn_ZedSpawnRatePerPlayer[arrayLength - 1] - default.ZedSpawn_ZedSpawnRatePerPlayer[arrayLength - 2]);
			return delta * (NbPlayer - arrayLength) + default.ZedSpawn_ZedSpawnRatePerPlayer[arrayLength - 1];
		}
	}
}

defaultproperties
{
}
