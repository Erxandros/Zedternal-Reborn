class Config_WaveValue extends Config_Common
	config(ZedternalReborn_ZedWaves);

var config int MODEVERSION;

var config S_Difficulty_Int Wave_BaseValue;
var config S_Difficulty_Int Wave_ValueIncPerwave;
var config float Wave_ValueFactorPerWave;
var config float Wave_ValuePowerPerWave;
var config array<float> Wave_ValueFactorPerPlayer;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Wave_BaseValue.Normal = 130;
		default.Wave_BaseValue.Hard = 150;
		default.Wave_BaseValue.Suicidal = 160;
		default.Wave_BaseValue.HoE = 170;
		default.Wave_BaseValue.Custom = 150;

		default.Wave_ValueIncPerwave.Normal = 26;
		default.Wave_ValueIncPerwave.Hard = 28;
		default.Wave_ValueIncPerwave.Suicidal = 29;
		default.Wave_ValueIncPerwave.HoE = 30;
		default.Wave_ValueIncPerwave.Custom = 28;

		default.Wave_ValueFactorPerWave = 0.052f;
		default.Wave_ValuePowerPerWave = 0.0065f;

		default.Wave_ValueFactorPerPlayer[0] = 1.2f;
		default.Wave_ValueFactorPerPlayer[1] = 1.75f;
		default.Wave_ValueFactorPerPlayer[2] = 2.5f;
		default.Wave_ValueFactorPerPlayer[3] = 3.1f;
		default.Wave_ValueFactorPerPlayer[4] = 3.7f;
		default.Wave_ValueFactorPerPlayer[5] = 4.3f;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
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

static function float GetValueFactor(int NbPlayer)
{
	local int arrayLength;
	local float delta;

	arrayLength = default.Wave_ValueFactorPerPlayer.Length;

	if (arrayLength == 0)
		return 1.0f;
	else if (NbPlayer == 0)
		return default.Wave_ValueFactorPerPlayer[0];
	else if (NbPlayer <= arrayLength)
		return default.Wave_ValueFactorPerPlayer[NbPlayer - 1];
	else
	{
		if (arrayLength == 1)
			return default.Wave_ValueFactorPerPlayer[0] * NbPlayer;
		else
		{
			delta = FMax(0.0f, default.Wave_ValueFactorPerPlayer[arrayLength - 1] - default.Wave_ValueFactorPerPlayer[arrayLength - 2]);
			return delta * (NbPlayer - arrayLength) + default.Wave_ValueFactorPerPlayer[arrayLength - 1];
		}
	}
}

defaultproperties
{
	Name="Default__Config_WaveValue"
}
