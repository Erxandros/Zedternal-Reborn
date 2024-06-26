class Config_DiffOverTime extends Config_Common
	config(ZedternalReborn_Difficulty);

var config int MODEVERSION;

var config S_Difficulty_Float DiffOverTime_NormalZedHealthIncPerWave;
var config S_Difficulty_Float DiffOverTime_NormalZedHealthPowerPerWave;
var config S_Difficulty_Float DiffOverTime_LargeZedHealthIncPerWave;
var config S_Difficulty_Float DiffOverTime_LargeZedHealthPowerPerWave;
var config S_Difficulty_Float DiffOverTime_OmegaZedHealthIncPerWave;
var config S_Difficulty_Float DiffOverTime_OmegaZedHealthPowerPerWave;
var config S_Difficulty_Float DiffOverTime_ZedDamageIncPerWave;
var config S_Difficulty_Float DiffOverTime_ZedDamagePowerPerWave;
var config S_Difficulty_Float DiffOverTime_ZedSpeedIncPerWave;
var config S_Difficulty_Float DiffOverTime_ZedSpeedPowerPerWave;
var config S_Difficulty_Float DiffOverTime_ZedSprintChanceIncPerWave;
var config S_Difficulty_Float DiffOverTime_ZedHardAttackChanceIncPerWave;
var config S_Difficulty_Float DiffOverTime_ZedDoshPenaltyPerWave;
var config S_Difficulty_Float DiffOverTime_ZedDoshPenaltyLimit;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.DiffOverTime_NormalZedHealthIncPerWave.Normal = 0.007f;
		default.DiffOverTime_NormalZedHealthIncPerWave.Hard = 0.007f;
		default.DiffOverTime_NormalZedHealthIncPerWave.Suicidal = 0.007f;
		default.DiffOverTime_NormalZedHealthIncPerWave.HoE = 0.007f;
		default.DiffOverTime_NormalZedHealthIncPerWave.Custom = 0.007f;

		default.DiffOverTime_NormalZedHealthPowerPerWave.Normal = 0.05f;
		default.DiffOverTime_NormalZedHealthPowerPerWave.Hard = 0.05f;
		default.DiffOverTime_NormalZedHealthPowerPerWave.Suicidal = 0.05f;
		default.DiffOverTime_NormalZedHealthPowerPerWave.HoE = 0.05f;
		default.DiffOverTime_NormalZedHealthPowerPerWave.Custom = 0.05f;

		default.DiffOverTime_LargeZedHealthIncPerWave.Normal = 0.0045f;
		default.DiffOverTime_LargeZedHealthIncPerWave.Hard = 0.0045f;
		default.DiffOverTime_LargeZedHealthIncPerWave.Suicidal = 0.0045f;
		default.DiffOverTime_LargeZedHealthIncPerWave.HoE = 0.0045f;
		default.DiffOverTime_LargeZedHealthIncPerWave.Custom = 0.0045f;

		default.DiffOverTime_LargeZedHealthPowerPerWave.Normal = 0.05f;
		default.DiffOverTime_LargeZedHealthPowerPerWave.Hard = 0.05f;
		default.DiffOverTime_LargeZedHealthPowerPerWave.Suicidal = 0.05f;
		default.DiffOverTime_LargeZedHealthPowerPerWave.HoE = 0.05f;
		default.DiffOverTime_LargeZedHealthPowerPerWave.Custom = 0.05f;

		default.DiffOverTime_OmegaZedHealthIncPerWave.Normal = 0.003f;
		default.DiffOverTime_OmegaZedHealthIncPerWave.Hard = 0.003f;
		default.DiffOverTime_OmegaZedHealthIncPerWave.Suicidal = 0.003f;
		default.DiffOverTime_OmegaZedHealthIncPerWave.HoE = 0.003f;
		default.DiffOverTime_OmegaZedHealthIncPerWave.Custom = 0.003f;

		default.DiffOverTime_OmegaZedHealthPowerPerWave.Normal = 0.05f;
		default.DiffOverTime_OmegaZedHealthPowerPerWave.Hard = 0.05f;
		default.DiffOverTime_OmegaZedHealthPowerPerWave.Suicidal = 0.05f;
		default.DiffOverTime_OmegaZedHealthPowerPerWave.HoE = 0.05f;
		default.DiffOverTime_OmegaZedHealthPowerPerWave.Custom = 0.05f;

		default.DiffOverTime_ZedDamageIncPerWave.Normal = 0.015f;
		default.DiffOverTime_ZedDamageIncPerWave.Hard = 0.015f;
		default.DiffOverTime_ZedDamageIncPerWave.Suicidal = 0.015f;
		default.DiffOverTime_ZedDamageIncPerWave.HoE = 0.015f;
		default.DiffOverTime_ZedDamageIncPerWave.Custom = 0.015f;

		default.DiffOverTime_ZedDamagePowerPerWave.Normal = 0.005f;
		default.DiffOverTime_ZedDamagePowerPerWave.Hard = 0.005f;
		default.DiffOverTime_ZedDamagePowerPerWave.Suicidal = 0.005f;
		default.DiffOverTime_ZedDamagePowerPerWave.HoE = 0.005f;
		default.DiffOverTime_ZedDamagePowerPerWave.Custom = 0.005f;

		default.DiffOverTime_ZedSpeedIncPerWave.Normal = 0.015f;
		default.DiffOverTime_ZedSpeedIncPerWave.Hard = 0.015f;
		default.DiffOverTime_ZedSpeedIncPerWave.Suicidal = 0.015f;
		default.DiffOverTime_ZedSpeedIncPerWave.HoE = 0.015f;
		default.DiffOverTime_ZedSpeedIncPerWave.Custom = 0.015f;

		default.DiffOverTime_ZedSpeedPowerPerWave.Normal = 0.0035f;
		default.DiffOverTime_ZedSpeedPowerPerWave.Hard = 0.0035f;
		default.DiffOverTime_ZedSpeedPowerPerWave.Suicidal = 0.0035f;
		default.DiffOverTime_ZedSpeedPowerPerWave.HoE = 0.0035f;
		default.DiffOverTime_ZedSpeedPowerPerWave.Custom = 0.0035f;

		default.DiffOverTime_ZedSprintChanceIncPerWave.Normal = 0.025f;
		default.DiffOverTime_ZedSprintChanceIncPerWave.Hard = 0.02f;
		default.DiffOverTime_ZedSprintChanceIncPerWave.Suicidal = 0.015f;
		default.DiffOverTime_ZedSprintChanceIncPerWave.HoE = 0.0125f;
		default.DiffOverTime_ZedSprintChanceIncPerWave.Custom = 0.0125f;

		default.DiffOverTime_ZedHardAttackChanceIncPerWave.Normal = 0.03f;
		default.DiffOverTime_ZedHardAttackChanceIncPerWave.Hard = 0.03f;
		default.DiffOverTime_ZedHardAttackChanceIncPerWave.Suicidal = 0.03f;
		default.DiffOverTime_ZedHardAttackChanceIncPerWave.HoE = 0.03f;
		default.DiffOverTime_ZedHardAttackChanceIncPerWave.Custom = 0.03f;

		default.DiffOverTime_ZedDoshPenaltyPerWave.Normal = 0.02f;
		default.DiffOverTime_ZedDoshPenaltyPerWave.Hard = 0.02f;
		default.DiffOverTime_ZedDoshPenaltyPerWave.Suicidal = 0.02f;
		default.DiffOverTime_ZedDoshPenaltyPerWave.HoE = 0.02f;
		default.DiffOverTime_ZedDoshPenaltyPerWave.Custom = 0.02f;

		default.DiffOverTime_ZedDoshPenaltyLimit.Normal = 0.6f;
		default.DiffOverTime_ZedDoshPenaltyLimit.Hard = 0.6f;
		default.DiffOverTime_ZedDoshPenaltyLimit.Suicidal = 0.6f;
		default.DiffOverTime_ZedDoshPenaltyLimit.HoE = 0.6f;
		default.DiffOverTime_ZedDoshPenaltyLimit.Custom = 0.6f;
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
		if (GetStructValueFloat(default.DiffOverTime_NormalZedHealthIncPerWave, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "DiffOverTime_NormalZedHealthIncPerWave",
				string(GetStructValueFloat(default.DiffOverTime_NormalZedHealthIncPerWave, i)),
				"0.0", "0%, no linear increase", "value >= 0.0");
			SetStructValueFloat(default.DiffOverTime_NormalZedHealthIncPerWave, i, 0.0f);
		}

		if (GetStructValueFloat(default.DiffOverTime_NormalZedHealthPowerPerWave, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "DiffOverTime_NormalZedHealthPowerPerWave",
				string(GetStructValueFloat(default.DiffOverTime_NormalZedHealthPowerPerWave, i)),
				"0.0", "0%, no exponential increase", "value >= 0.0");
			SetStructValueFloat(default.DiffOverTime_NormalZedHealthPowerPerWave, i, 0.0f);
		}

		if (GetStructValueFloat(default.DiffOverTime_LargeZedHealthIncPerWave, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "DiffOverTime_LargeZedHealthIncPerWave",
				string(GetStructValueFloat(default.DiffOverTime_LargeZedHealthIncPerWave, i)),
				"0.0", "0%, no linear increase", "value >= 0.0");
			SetStructValueFloat(default.DiffOverTime_LargeZedHealthIncPerWave, i, 0.0f);
		}

		if (GetStructValueFloat(default.DiffOverTime_LargeZedHealthPowerPerWave, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "DiffOverTime_LargeZedHealthPowerPerWave",
				string(GetStructValueFloat(default.DiffOverTime_LargeZedHealthPowerPerWave, i)),
				"0.0", "0%, no exponential increase", "value >= 0.0");
			SetStructValueFloat(default.DiffOverTime_LargeZedHealthPowerPerWave, i, 0.0f);
		}

		if (GetStructValueFloat(default.DiffOverTime_OmegaZedHealthIncPerWave, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "DiffOverTime_OmegaZedHealthIncPerWave",
				string(GetStructValueFloat(default.DiffOverTime_OmegaZedHealthIncPerWave, i)),
				"0.0", "0%, no linear increase", "value >= 0.0");
			SetStructValueFloat(default.DiffOverTime_OmegaZedHealthIncPerWave, i, 0.0f);
		}

		if (GetStructValueFloat(default.DiffOverTime_OmegaZedHealthPowerPerWave, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "DiffOverTime_OmegaZedHealthPowerPerWave",
				string(GetStructValueFloat(default.DiffOverTime_OmegaZedHealthPowerPerWave, i)),
				"0.0", "0%, no exponential increase", "value >= 0.0");
			SetStructValueFloat(default.DiffOverTime_OmegaZedHealthPowerPerWave, i, 0.0f);
		}

		if (GetStructValueFloat(default.DiffOverTime_ZedDamageIncPerWave, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "DiffOverTime_ZedDamageIncPerWave",
				string(GetStructValueFloat(default.DiffOverTime_ZedDamageIncPerWave, i)),
				"0.0", "0%, no linear increase", "value >= 0.0");
			SetStructValueFloat(default.DiffOverTime_ZedDamageIncPerWave, i, 0.0f);
		}

		if (GetStructValueFloat(default.DiffOverTime_ZedDamagePowerPerWave, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "DiffOverTime_ZedDamagePowerPerWave",
				string(GetStructValueFloat(default.DiffOverTime_ZedDamagePowerPerWave, i)),
				"0.0", "0%, no exponential increase", "value >= 0.0");
			SetStructValueFloat(default.DiffOverTime_ZedDamagePowerPerWave, i, 0.0f);
		}

		if (GetStructValueFloat(default.DiffOverTime_ZedSpeedIncPerWave, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "DiffOverTime_ZedSpeedIncPerWave",
				string(GetStructValueFloat(default.DiffOverTime_ZedSpeedIncPerWave, i)),
				"0.0", "0%, no linear increase", "value >= 0.0");
			SetStructValueFloat(default.DiffOverTime_ZedSpeedIncPerWave, i, 0.0f);
		}

		if (GetStructValueFloat(default.DiffOverTime_ZedSpeedPowerPerWave, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "DiffOverTime_ZedSpeedPowerPerWave",
				string(GetStructValueFloat(default.DiffOverTime_ZedSpeedPowerPerWave, i)),
				"0.0", "0%, no exponential increase", "value >= 0.0");
			SetStructValueFloat(default.DiffOverTime_ZedSpeedPowerPerWave, i, 0.0f);
		}

		if (GetStructValueFloat(default.DiffOverTime_ZedSprintChanceIncPerWave, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "DiffOverTime_ZedSprintChanceIncPerWave",
				string(GetStructValueFloat(default.DiffOverTime_ZedSprintChanceIncPerWave, i)),
				"0.0", "0%, no linear increase", "value >= 0.0");
			SetStructValueFloat(default.DiffOverTime_ZedSprintChanceIncPerWave, i, 0.0f);
		}

		if (GetStructValueFloat(default.DiffOverTime_ZedHardAttackChanceIncPerWave, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "DiffOverTime_ZedHardAttackChanceIncPerWave",
				string(GetStructValueFloat(default.DiffOverTime_ZedHardAttackChanceIncPerWave, i)),
				"0.0", "0%, no linear increase", "value >= 0.0");
			SetStructValueFloat(default.DiffOverTime_ZedHardAttackChanceIncPerWave, i, 0.0f);
		}

		if (GetStructValueFloat(default.DiffOverTime_ZedDoshPenaltyPerWave, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "DiffOverTime_ZedDoshPenaltyPerWave",
				string(GetStructValueFloat(default.DiffOverTime_ZedDoshPenaltyPerWave, i)),
				"0.0", "0%, no penalty increase", "value >= 0.0");
			SetStructValueFloat(default.DiffOverTime_ZedDoshPenaltyPerWave, i, 0.0f);
		}

		if (GetStructValueFloat(default.DiffOverTime_ZedDoshPenaltyLimit, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "DiffOverTime_ZedDoshPenaltyLimit",
				string(GetStructValueFloat(default.DiffOverTime_ZedDoshPenaltyLimit, i)),
				"0.0", "0%, no penalty", "value >= 0.0");
			SetStructValueFloat(default.DiffOverTime_ZedDoshPenaltyLimit, i, 0.0f);
		}
	}
}

static function float GetNormalZedHealthModifierOverTime(float mod, int Difficulty, int WaveNum)
{
	local float multiplier, power, wave;

	switch (Difficulty)
	{
		case 0 : multiplier = default.DiffOverTime_NormalZedHealthIncPerWave.Normal; power = default.DiffOverTime_NormalZedHealthPowerPerWave.Normal; break;
		case 1 : multiplier = default.DiffOverTime_NormalZedHealthIncPerWave.Hard; power = default.DiffOverTime_NormalZedHealthPowerPerWave.Hard; break;
		case 2 : multiplier = default.DiffOverTime_NormalZedHealthIncPerWave.Suicidal; power = default.DiffOverTime_NormalZedHealthPowerPerWave.Suicidal; break;
		case 3 : multiplier = default.DiffOverTime_NormalZedHealthIncPerWave.HoE; power = default.DiffOverTime_NormalZedHealthPowerPerWave.HoE; break;
		default: multiplier = default.DiffOverTime_NormalZedHealthIncPerWave.Custom; power = default.DiffOverTime_NormalZedHealthPowerPerWave.Custom; break;
	}

	wave = float(WaveNum - 1);
	return (mod + multiplier * wave) ** (1.0f + power * wave);
}

static function float GetLargeZedHealthModifierOverTime(float mod, int Difficulty, int WaveNum)
{
	local float multiplier, power, wave;

	switch (Difficulty)
	{
		case 0 : multiplier = default.DiffOverTime_LargeZedHealthIncPerWave.Normal; power = default.DiffOverTime_LargeZedHealthPowerPerWave.Normal; break;
		case 1 : multiplier = default.DiffOverTime_LargeZedHealthIncPerWave.Hard; power = default.DiffOverTime_LargeZedHealthPowerPerWave.Hard; break;
		case 2 : multiplier = default.DiffOverTime_LargeZedHealthIncPerWave.Suicidal; power = default.DiffOverTime_LargeZedHealthPowerPerWave.Suicidal; break;
		case 3 : multiplier = default.DiffOverTime_LargeZedHealthIncPerWave.HoE; power = default.DiffOverTime_LargeZedHealthPowerPerWave.HoE; break;
		default: multiplier = default.DiffOverTime_LargeZedHealthIncPerWave.Custom;	power = default.DiffOverTime_LargeZedHealthPowerPerWave.Custom; break;
	}

	wave = float(WaveNum - 1);
	return (mod + multiplier * wave) ** (1.0f + power * wave);
}

static function float GetOmegaZedHealthModifierOverTime(float mod, int Difficulty, int WaveNum)
{
	local float multiplier, power, wave;

	switch (Difficulty)
	{
		case 0 : multiplier = default.DiffOverTime_OmegaZedHealthIncPerWave.Normal; power = default.DiffOverTime_OmegaZedHealthPowerPerWave.Normal; break;
		case 1 : multiplier = default.DiffOverTime_OmegaZedHealthIncPerWave.Hard; power = default.DiffOverTime_OmegaZedHealthPowerPerWave.Hard; break;
		case 2 : multiplier = default.DiffOverTime_OmegaZedHealthIncPerWave.Suicidal; power = default.DiffOverTime_OmegaZedHealthPowerPerWave.Suicidal; break;
		case 3 : multiplier = default.DiffOverTime_OmegaZedHealthIncPerWave.HoE; power = default.DiffOverTime_OmegaZedHealthPowerPerWave.HoE; break;
		default: multiplier = default.DiffOverTime_OmegaZedHealthIncPerWave.Custom;	power = default.DiffOverTime_OmegaZedHealthPowerPerWave.Custom; break;
	}

	wave = float(WaveNum - 1);
	return (mod + multiplier * wave) ** (1.0f + power * wave);
}

static function float GetZedDamageModifierOverTime(float mod, int Difficulty, int WaveNum)
{
	local float multiplier, power, wave;

	switch (Difficulty)
	{
		case 0 : multiplier = default.DiffOverTime_ZedDamageIncPerWave.Normal; power = default.DiffOverTime_ZedDamagePowerPerWave.Normal; break;
		case 1 : multiplier = default.DiffOverTime_ZedDamageIncPerWave.Hard; power = default.DiffOverTime_ZedDamagePowerPerWave.Hard; break;
		case 2 : multiplier = default.DiffOverTime_ZedDamageIncPerWave.Suicidal; power = default.DiffOverTime_ZedDamagePowerPerWave.Suicidal; break;
		case 3 : multiplier = default.DiffOverTime_ZedDamageIncPerWave.HoE; power = default.DiffOverTime_ZedDamagePowerPerWave.HoE;	 break;
		default: multiplier = default.DiffOverTime_ZedDamageIncPerWave.Custom; power = default.DiffOverTime_ZedDamagePowerPerWave.Custom; break;
	}

	wave = float(WaveNum - 1);
	return (mod + multiplier * wave) ** (1.0f + power * wave);
}

static function float GetZedSpeedModifierOverTime(float mod, int Difficulty, int WaveNum)
{
	local float multiplier, power, wave;

	switch (Difficulty)
	{
		case 0 : multiplier = default.DiffOverTime_ZedSpeedIncPerWave.Normal; power = default.DiffOverTime_ZedSpeedPowerPerWave.Normal; break;
		case 1 : multiplier = default.DiffOverTime_ZedSpeedIncPerWave.Hard; power = default.DiffOverTime_ZedSpeedPowerPerWave.Hard; break;
		case 2 : multiplier = default.DiffOverTime_ZedSpeedIncPerWave.Suicidal; power = default.DiffOverTime_ZedSpeedPowerPerWave.Suicidal; break;
		case 3 : multiplier = default.DiffOverTime_ZedSpeedIncPerWave.HoE; power = default.DiffOverTime_ZedSpeedPowerPerWave.HoE; break;
		default: multiplier = default.DiffOverTime_ZedSpeedIncPerWave.Custom; power = default.DiffOverTime_ZedSpeedPowerPerWave.Custom; break;
	}

	wave = float(WaveNum - 1);
	return (mod + multiplier * wave) ** (1.0f + power * wave);
}

static function float GetZedSprintChanceModifierOverTime(int Difficulty, int WaveNum)
{
	local float multiplier;

	switch (Difficulty)
	{
		case 0 : multiplier = default.DiffOverTime_ZedSprintChanceIncPerWave.Normal; break;
		case 1 : multiplier = default.DiffOverTime_ZedSprintChanceIncPerWave.Hard; break;
		case 2 : multiplier = default.DiffOverTime_ZedSprintChanceIncPerWave.Suicidal; break;
		case 3 : multiplier = default.DiffOverTime_ZedSprintChanceIncPerWave.HoE; break;
		default: multiplier = default.DiffOverTime_ZedSprintChanceIncPerWave.Custom; break;
	}

	return multiplier * float(WaveNum - 1);
}

static function float GetZedHardAttackChanceModifierOverTime(int Difficulty, int WaveNum)
{
	local float multiplier;

	switch (Difficulty)
	{
		case 0 : multiplier = default.DiffOverTime_ZedHardAttackChanceIncPerWave.Normal; break;
		case 1 : multiplier = default.DiffOverTime_ZedHardAttackChanceIncPerWave.Hard; break;
		case 2 : multiplier = default.DiffOverTime_ZedHardAttackChanceIncPerWave.Suicidal; break;
		case 3 : multiplier = default.DiffOverTime_ZedHardAttackChanceIncPerWave.HoE; break;
		default: multiplier = default.DiffOverTime_ZedHardAttackChanceIncPerWave.Custom; break;
	}

	return multiplier * float(WaveNum - 1);
}

static function float GetZedDoshPenaltyModifierOverTime(int Difficulty, int WaveNum)
{
	local float multiplier, limit;

	switch (Difficulty)
	{
		case 0 : multiplier = default.DiffOverTime_ZedDoshPenaltyPerWave.Normal; limit = default.DiffOverTime_ZedDoshPenaltyLimit.Normal; break;
		case 1 : multiplier = default.DiffOverTime_ZedDoshPenaltyPerWave.Hard; limit = default.DiffOverTime_ZedDoshPenaltyLimit.Hard; break;
		case 2 : multiplier = default.DiffOverTime_ZedDoshPenaltyPerWave.Suicidal; limit = default.DiffOverTime_ZedDoshPenaltyLimit.Suicidal; break;
		case 3 : multiplier = default.DiffOverTime_ZedDoshPenaltyPerWave.HoE; limit = default.DiffOverTime_ZedDoshPenaltyLimit.HoE; break;
		default: multiplier = default.DiffOverTime_ZedDoshPenaltyPerWave.Custom; limit = default.DiffOverTime_ZedDoshPenaltyLimit.Custom; break;
	}

	return FMin(limit, multiplier * float(WaveNum - 1));
}

defaultproperties
{
	Name="Default__Config_DiffOverTime"
}
