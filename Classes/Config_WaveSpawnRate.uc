class Config_WaveSpawnRate extends Config_Common
	config(ZedternalReborn_ZedWaves);

var config int MODEVERSION;

var config S_Difficulty_Float Wave_ZedSpawnRate;
var config S_Difficulty_Float Wave_ZedSpawnRateIncPerWave;
var config S_Difficulty_Float Wave_ZedSpawnRatePowerPerWave;
var config array<float> Wave_ZedSpawnRatePerPlayer;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Wave_ZedSpawnRate.Normal = 0.95f;
		default.Wave_ZedSpawnRate.Hard = 1.0f;
		default.Wave_ZedSpawnRate.Suicidal = 1.05f;
		default.Wave_ZedSpawnRate.HoE = 1.1f;
		default.Wave_ZedSpawnRate.Custom = 1.1f;

		default.Wave_ZedSpawnRateIncPerWave.Normal = 0.02f;
		default.Wave_ZedSpawnRateIncPerWave.Hard = 0.02f;
		default.Wave_ZedSpawnRateIncPerWave.Suicidal = 0.02f;
		default.Wave_ZedSpawnRateIncPerWave.HoE = 0.02f;
		default.Wave_ZedSpawnRateIncPerWave.Custom = 0.02f;

		default.Wave_ZedSpawnRatePowerPerWave.Normal = 0.14f;
		default.Wave_ZedSpawnRatePowerPerWave.Hard = 0.14f;
		default.Wave_ZedSpawnRatePowerPerWave.Suicidal = 0.14f;
		default.Wave_ZedSpawnRatePowerPerWave.HoE = 0.14f;
		default.Wave_ZedSpawnRatePowerPerWave.Custom = 0.14f;

		default.Wave_ZedSpawnRatePerPlayer[0] = 1.0f;
		default.Wave_ZedSpawnRatePerPlayer[1] = 1.7f;
		default.Wave_ZedSpawnRatePerPlayer[2] = 2.4f;
		default.Wave_ZedSpawnRatePerPlayer[3] = 3.0f;
		default.Wave_ZedSpawnRatePerPlayer[4] = 3.5f;
		default.Wave_ZedSpawnRatePerPlayer[5] = 4.1f;
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
		if (GetStructValueFloat(default.Wave_ZedSpawnRate, i) < 0.05f)
		{
			LogBadStructConfigMessage(i, "Wave_ZedSpawnRate",
				string(GetStructValueFloat(default.Wave_ZedSpawnRate, i)),
				"0.05", "5% of default spawn rate", "value >= 0.05");
			SetStructValueFloat(default.Wave_ZedSpawnRate, i, 0.05f);
		}

		if (GetStructValueFloat(default.Wave_ZedSpawnRateIncPerWave, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "Wave_ZedSpawnRateIncPerWave",
				string(GetStructValueFloat(default.Wave_ZedSpawnRateIncPerWave, i)),
				"0.0", "0%, no linear increase", "value >= 0.0");
			SetStructValueFloat(default.Wave_ZedSpawnRateIncPerWave, i, 0.0f);
		}

		if (GetStructValueFloat(default.Wave_ZedSpawnRatePowerPerWave, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "Wave_ZedSpawnRatePowerPerWave",
				string(GetStructValueFloat(default.Wave_ZedSpawnRatePowerPerWave, i)),
				"0.0", "0%, no exponential increase", "value >= 0.0");
			SetStructValueFloat(default.Wave_ZedSpawnRatePowerPerWave, i, 0.0f);
		}
	}

	for (i = 0; i < Min(128, default.Wave_ZedSpawnRatePerPlayer.Length); ++i)
	{
		if (default.Wave_ZedSpawnRatePerPlayer[i] < 1.0f)
		{
			LogBadConfigMessage("Wave_ZedSpawnRatePerPlayer - Line" @ string(i + 1),
				string(default.Wave_ZedSpawnRatePerPlayer[i]),
				"1.0", "100%, default spawn rate", "value >= 1.0");
			default.Wave_ZedSpawnRatePerPlayer[i] = 1.0f;
		}
	}
}

static function float GetZedSpawnRate(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Wave_ZedSpawnRate.Normal;
		case 1 : return default.Wave_ZedSpawnRate.Hard;
		case 2 : return default.Wave_ZedSpawnRate.Suicidal;
		case 3 : return default.Wave_ZedSpawnRate.HoE;
		default: return default.Wave_ZedSpawnRate.Custom;
	}
}

static function float GetZedSpawnRateIncPerWave(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Wave_ZedSpawnRateIncPerWave.Normal;
		case 1 : return default.Wave_ZedSpawnRateIncPerWave.Hard;
		case 2 : return default.Wave_ZedSpawnRateIncPerWave.Suicidal;
		case 3 : return default.Wave_ZedSpawnRateIncPerWave.HoE;
		default: return default.Wave_ZedSpawnRateIncPerWave.Custom;
	}
}

static function float GetZedSpawnRatePowerPerWave(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Wave_ZedSpawnRatePowerPerWave.Normal;
		case 1 : return default.Wave_ZedSpawnRatePowerPerWave.Hard;
		case 2 : return default.Wave_ZedSpawnRatePowerPerWave.Suicidal;
		case 3 : return default.Wave_ZedSpawnRatePowerPerWave.HoE;
		default: return default.Wave_ZedSpawnRatePowerPerWave.Custom;
	}
}

static function float ZedSpawnRateFactor(int NbPlayer)
{
	local int ArrayLength;
	local float Delta;

	ArrayLength = default.Wave_ZedSpawnRatePerPlayer.Length;

	if (ArrayLength == 0)
		return 1.0f;
	else if (NbPlayer == 0)
		return default.Wave_ZedSpawnRatePerPlayer[0];
	else if (NbPlayer <= ArrayLength)
		return default.Wave_ZedSpawnRatePerPlayer[NbPlayer - 1];
	else
	{
		if (ArrayLength == 1)
			return default.Wave_ZedSpawnRatePerPlayer[0] * NbPlayer;
		else
		{
			Delta = FMax(0.0f, default.Wave_ZedSpawnRatePerPlayer[ArrayLength - 1] - default.Wave_ZedSpawnRatePerPlayer[ArrayLength - 2]);
			return Delta * (NbPlayer - ArrayLength) + default.Wave_ZedSpawnRatePerPlayer[ArrayLength - 1];
		}
	}
}

defaultproperties
{
	Name="Default__Config_WaveSpawnRate"
}
