class Config_WaveValue extends Config_Common
	config(ZedternalReborn_ZedWaves);

var config int MODEVERSION;

var config S_Difficulty_Int Wave_BaseValue;
var config S_Difficulty_Int Wave_ValueIncPerwave;
var config S_Difficulty_Float Wave_ValueMultiplierPerWave;
var config S_Difficulty_Float Wave_ValuePowerPerWave;
var config array<float> Wave_ValueMultiplierPerPlayer;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Wave_BaseValue.Normal = 130;
		default.Wave_BaseValue.Hard = 145;
		default.Wave_BaseValue.Suicidal = 160;
		default.Wave_BaseValue.HoE = 175;
		default.Wave_BaseValue.Custom = 175;

		default.Wave_ValueIncPerwave.Normal = 26;
		default.Wave_ValueIncPerwave.Hard = 28;
		default.Wave_ValueIncPerwave.Suicidal = 30;
		default.Wave_ValueIncPerwave.HoE = 32;
		default.Wave_ValueIncPerwave.Custom = 32;

		default.Wave_ValueMultiplierPerWave.Normal = 0.052f;
		default.Wave_ValueMultiplierPerWave.Hard = 0.052f;
		default.Wave_ValueMultiplierPerWave.Suicidal = 0.052f;
		default.Wave_ValueMultiplierPerWave.HoE = 0.052f;
		default.Wave_ValueMultiplierPerWave.Custom = 0.052f;

		default.Wave_ValuePowerPerWave.Normal = 0.0065f;
		default.Wave_ValuePowerPerWave.Hard = 0.0065f;
		default.Wave_ValuePowerPerWave.Suicidal = 0.0065f;
		default.Wave_ValuePowerPerWave.HoE = 0.0065f;
		default.Wave_ValuePowerPerWave.Custom = 0.0065f;

		default.Wave_ValueMultiplierPerPlayer[0] = 1.0f;
		default.Wave_ValueMultiplierPerPlayer[1] = 1.7f;
		default.Wave_ValueMultiplierPerPlayer[2] = 2.4f;
		default.Wave_ValueMultiplierPerPlayer[3] = 3.1f;
		default.Wave_ValueMultiplierPerPlayer[4] = 3.8f;
		default.Wave_ValueMultiplierPerPlayer[5] = 4.4f;
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
		if (GetStructValueInt(default.Wave_BaseValue, i) < 0)
		{
			LogBadStructConfigMessage(i, "Wave_BaseValue",
				string(GetStructValueInt(default.Wave_BaseValue, i)),
				"0", "0 points", "value >= 0");
			SetStructValueInt(default.Wave_BaseValue, i, 0);
		}

		if (GetStructValueInt(default.Wave_ValueIncPerwave, i) < 0)
		{
			LogBadStructConfigMessage(i, "Wave_ValueIncPerwave",
				string(GetStructValueInt(default.Wave_ValueIncPerwave, i)),
				"0", "0 points, no linear points increase", "value >= 0");
			SetStructValueInt(default.Wave_ValueIncPerwave, i, 0);
		}

		if (GetStructValueFloat(default.Wave_ValueMultiplierPerWave, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "Wave_ValueMultiplierPerWave",
				string(GetStructValueFloat(default.Wave_ValueMultiplierPerWave, i)),
				"0.0", "0%, no linear increase multiplier", "value >= 0.0");
			SetStructValueFloat(default.Wave_ValueMultiplierPerWave, i, 0.0f);
		}

		if (GetStructValueFloat(default.Wave_ValuePowerPerWave, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "Wave_ValuePowerPerWave",
				string(GetStructValueFloat(default.Wave_ValuePowerPerWave, i)),
				"0.0", "0%, no exponential increase", "value >= 0.0");
			SetStructValueFloat(default.Wave_ValuePowerPerWave, i, 0.0f);
		}
	}

	for (i = 0; i < Min(128, default.Wave_ValueMultiplierPerPlayer.Length); ++i)
	{
		if (default.Wave_ValueMultiplierPerPlayer[i] < 1.0f)
		{
			LogBadConfigMessage("Wave_ValueMultiplierPerPlayer - Line" @ string(i + 1),
				string(default.Wave_ValueMultiplierPerPlayer[i]),
				"1.0", "1x, no points change", "value >= 1.0");
			default.Wave_ValueMultiplierPerPlayer[i] = 1.0f;
		}
	}
}

static function int GetBaseValue(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Wave_BaseValue.Normal;
		case 1 : return default.Wave_BaseValue.Hard;
		case 2 : return default.Wave_BaseValue.Suicidal;
		case 3 : return default.Wave_BaseValue.HoE;
		default: return default.Wave_BaseValue.Custom;
	}
}

static function int GetValueIncPerwave(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Wave_ValueIncPerwave.Normal;
		case 1 : return default.Wave_ValueIncPerwave.Hard;
		case 2 : return default.Wave_ValueIncPerwave.Suicidal;
		case 3 : return default.Wave_ValueIncPerwave.HoE;
		default: return default.Wave_ValueIncPerwave.Custom;
	}
}

static function float GetValueMultiplierPerWave(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Wave_ValueMultiplierPerWave.Normal;
		case 1 : return default.Wave_ValueMultiplierPerWave.Hard;
		case 2 : return default.Wave_ValueMultiplierPerWave.Suicidal;
		case 3 : return default.Wave_ValueMultiplierPerWave.HoE;
		default: return default.Wave_ValueMultiplierPerWave.Custom;
	}
}

static function float GetValuePowerPerWave(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Wave_ValuePowerPerWave.Normal;
		case 1 : return default.Wave_ValuePowerPerWave.Hard;
		case 2 : return default.Wave_ValuePowerPerWave.Suicidal;
		case 3 : return default.Wave_ValuePowerPerWave.HoE;
		default: return default.Wave_ValuePowerPerWave.Custom;
	}
}

static function float GetValueMultiplier(int NbPlayer)
{
	local int ArrayLength;
	local float Delta;

	ArrayLength = default.Wave_ValueMultiplierPerPlayer.Length;

	if (ArrayLength == 0)
		return 1.0f;
	else if (NbPlayer == 0)
		return default.Wave_ValueMultiplierPerPlayer[0];
	else if (NbPlayer <= ArrayLength)
		return default.Wave_ValueMultiplierPerPlayer[NbPlayer - 1];
	else
	{
		if (ArrayLength == 1)
			return default.Wave_ValueMultiplierPerPlayer[0] * NbPlayer;
		else
		{
			Delta = FMax(0.0f, default.Wave_ValueMultiplierPerPlayer[ArrayLength - 1] - default.Wave_ValueMultiplierPerPlayer[ArrayLength - 2]);
			return Delta * (NbPlayer - ArrayLength) + default.Wave_ValueMultiplierPerPlayer[ArrayLength - 1];
		}
	}
}

defaultproperties
{
	Name="Default__Config_WaveValue"
}
