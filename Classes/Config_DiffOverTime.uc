class Config_DiffOverTime extends Config_Common
	config(ZedternalReborn_Difficulty);

var config int MODEVERSION;

var config S_Difficulty_Float DiffOverTime_NormalZedHealthIncPerWave;
var config S_Difficulty_Float DiffOverTime_NormalZedHealthPowerPerWave;
var config S_Difficulty_Float DiffOverTime_LargeZedHealthIncPerWave;
var config S_Difficulty_Float DiffOverTime_LargeZedHealthPowerPerWave;
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
			`log("ZR Config: Linear increase for normal ZED health at difficulty" @ GetDiffString(i)
				@"is set to" @ GetStructValueFloat(default.DiffOverTime_NormalZedHealthIncPerWave, i)
				@"which is not supported. Setting the increase to the minimum value of 0.0 (0%, no linear increase) temporarily."
				@"Please change the value in the config to a value greater than or equal to 0.0.");
			SetStructValueFloat(default.DiffOverTime_NormalZedHealthIncPerWave, i, 0.0f);
		}

		if (GetStructValueFloat(default.DiffOverTime_NormalZedHealthPowerPerWave, i) < 0.0f)
		{
			`log("ZR Config: Power increase for normal ZED health at difficulty" @ GetDiffString(i)
				@"is set to" @ GetStructValueFloat(default.DiffOverTime_NormalZedHealthPowerPerWave, i)
				@"which is not supported. Setting the increase to the minimum value of 0.0 (0%, no exponential increase) temporarily."
				@"Please change the value in the config to a value greater than or equal to 0.0.");
			SetStructValueFloat(default.DiffOverTime_NormalZedHealthPowerPerWave, i, 0.0f);
		}

		if (GetStructValueFloat(default.DiffOverTime_LargeZedHealthIncPerWave, i) < 0.0f)
		{
			`log("ZR Config: Linear increase for large ZED health at difficulty" @ GetDiffString(i)
				@"is set to" @ GetStructValueFloat(default.DiffOverTime_LargeZedHealthIncPerWave, i)
				@"which is not supported. Setting the increase to the minimum value of 0.0 (0%, no linear increase) temporarily."
				@"Please change the value in the config to a value greater than or equal to 0.0.");
			SetStructValueFloat(default.DiffOverTime_LargeZedHealthIncPerWave, i, 0.0f);
		}

		if (GetStructValueFloat(default.DiffOverTime_LargeZedHealthPowerPerWave, i) < 0.0f)
		{
			`log("ZR Config: Power increase for large ZED health at difficulty" @ GetDiffString(i)
				@"is set to" @ GetStructValueFloat(default.DiffOverTime_LargeZedHealthPowerPerWave, i)
				@"which is not supported. Setting the increase to the minimum value of 0.0 (0%, no exponential increase) temporarily."
				@"Please change the value in the config to a value greater than or equal to 0.0.");
			SetStructValueFloat(default.DiffOverTime_LargeZedHealthPowerPerWave, i, 0.0f);
		}

		if (GetStructValueFloat(default.DiffOverTime_ZedDamageIncPerWave, i) < 0.0f)
		{
			`log("ZR Config: Linear increase for ZED damage at difficulty" @ GetDiffString(i)
				@"is set to" @ GetStructValueFloat(default.DiffOverTime_ZedDamageIncPerWave, i)
				@"which is not supported. Setting the increase to the minimum value of 0.0 (0%, no linear increase) temporarily."
				@"Please change the value in the config to a value greater than or equal to 0.0.");
			SetStructValueFloat(default.DiffOverTime_ZedDamageIncPerWave, i, 0.0f);
		}

		if (GetStructValueFloat(default.DiffOverTime_ZedDamagePowerPerWave, i) < 0.0f)
		{
			`log("ZR Config: Power increase for ZED damage at difficulty" @ GetDiffString(i)
				@"is set to" @ GetStructValueFloat(default.DiffOverTime_ZedDamagePowerPerWave, i)
				@"which is not supported. Setting the increase to the minimum value of 0.0 (0%, no exponential increase) temporarily."
				@"Please change the value in the config to a value greater than or equal to 0.0.");
			SetStructValueFloat(default.DiffOverTime_ZedDamagePowerPerWave, i, 0.0f);
		}

		if (GetStructValueFloat(default.DiffOverTime_ZedSpeedIncPerWave, i) < 0.0f)
		{
			`log("ZR Config: Linear increase for ZED speed at difficulty" @ GetDiffString(i)
				@"is set to" @ GetStructValueFloat(default.DiffOverTime_ZedSpeedIncPerWave, i)
				@"which is not supported. Setting the increase to the minimum value of 0.0 (0%, no linear increase) temporarily."
				@"Please change the value in the config to a value greater than or equal to 0.0.");
			SetStructValueFloat(default.DiffOverTime_ZedSpeedIncPerWave, i, 0.0f);
		}

		if (GetStructValueFloat(default.DiffOverTime_ZedSpeedPowerPerWave, i) < 0.0f)
		{
			`log("ZR Config: Power increase for ZED speed at difficulty" @ GetDiffString(i)
				@"is set to" @ GetStructValueFloat(default.DiffOverTime_ZedSpeedPowerPerWave, i)
				@"which is not supported. Setting the increase to the minimum value of 0.0 (0%, no exponential increase) temporarily."
				@"Please change the value in the config to a value greater than or equal to 0.0.");
			SetStructValueFloat(default.DiffOverTime_ZedSpeedPowerPerWave, i, 0.0f);
		}

		if (GetStructValueFloat(default.DiffOverTime_ZedSprintChanceIncPerWave, i) < 0.0f)
		{
			`log("ZR Config: Linear increase for ZED sprint chance at difficulty" @ GetDiffString(i)
				@"is set to" @ GetStructValueFloat(default.DiffOverTime_ZedSprintChanceIncPerWave, i)
				@"which is not supported. Setting the increase to the minimum value of 0.0 (0%, no linear increase) temporarily."
				@"Please change the value in the config to a value greater than or equal to 0.0.");
			SetStructValueFloat(default.DiffOverTime_ZedSprintChanceIncPerWave, i, 0.0f);
		}

		if (GetStructValueFloat(default.DiffOverTime_ZedHardAttackChanceIncPerWave, i) < 0.0f)
		{
			`log("ZR Config: Linear increase for ZED hard attack chance at difficulty" @ GetDiffString(i)
				@"is set to" @ GetStructValueFloat(default.DiffOverTime_ZedHardAttackChanceIncPerWave, i)
				@"which is not supported. Setting the increase to the minimum value of 0.0 (0%, no linear increase) temporarily."
				@"Please change the value in the config to a value greater than or equal to 0.0.");
			SetStructValueFloat(default.DiffOverTime_ZedHardAttackChanceIncPerWave, i, 0.0f);
		}

		if (GetStructValueFloat(default.DiffOverTime_ZedDoshPenaltyPerWave, i) < 0.0f)
		{
			`log("ZR Config: Modifier for ZED dosh penalty at difficulty" @ GetDiffString(i)
				@"is set to" @ GetStructValueFloat(default.DiffOverTime_ZedDoshPenaltyPerWave, i)
				@"which is not supported. Setting the increase to the minimum value of 0.0 (0%, no penalty increase) temporarily."
				@"Please change the value in the config to a value greater than or equal to 0.0.");
			SetStructValueFloat(default.DiffOverTime_ZedDoshPenaltyPerWave, i, 0.0f);
		}

		if (GetStructValueFloat(default.DiffOverTime_ZedDoshPenaltyLimit, i) < 0.0f)
		{
			`log("ZR Config: Max cap for ZED dosh penalty at difficulty" @ GetDiffString(i)
				@"is set to" @ GetStructValueFloat(default.DiffOverTime_ZedDoshPenaltyLimit, i)
				@"which is not supported. Setting the cap to the minimum value of 0.0 (0%, no penalty) temporarily."
				@"Please change the value in the config to a value greater than or equal to 0.0.");
			SetStructValueFloat(default.DiffOverTime_ZedDoshPenaltyLimit, i, 0.0f);
		}
	}
}

static function float GetNormalZedHealthModifierOverTime(float mod, int Difficulty, int WaveNum)
{
	local float factor, power, wave;

	switch (Difficulty)
	{
		case 0 : factor = default.DiffOverTime_NormalZedHealthIncPerWave.Normal; power = default.DiffOverTime_NormalZedHealthPowerPerWave.Normal; break;
		case 1 : factor = default.DiffOverTime_NormalZedHealthIncPerWave.Hard; power = default.DiffOverTime_NormalZedHealthPowerPerWave.Hard; break;
		case 2 : factor = default.DiffOverTime_NormalZedHealthIncPerWave.Suicidal; power = default.DiffOverTime_NormalZedHealthPowerPerWave.Suicidal; break;
		case 3 : factor = default.DiffOverTime_NormalZedHealthIncPerWave.HoE; power = default.DiffOverTime_NormalZedHealthPowerPerWave.HoE; break;
		default: factor = default.DiffOverTime_NormalZedHealthIncPerWave.Custom; power = default.DiffOverTime_NormalZedHealthPowerPerWave.Custom; break;
	}

	wave = float(WaveNum - 1);
	return (mod + factor * wave) ** (1.0f + power * wave);
}

static function float GetLargeZedHealthModifierOverTime(float mod, int Difficulty, int WaveNum)
{
	local float factor, power, wave;

	switch (Difficulty)
	{
		case 0 : factor = default.DiffOverTime_LargeZedHealthIncPerWave.Normal; power = default.DiffOverTime_LargeZedHealthPowerPerWave.Normal; break;
		case 1 : factor = default.DiffOverTime_LargeZedHealthIncPerWave.Hard; power = default.DiffOverTime_LargeZedHealthPowerPerWave.Hard; break;
		case 2 : factor = default.DiffOverTime_LargeZedHealthIncPerWave.Suicidal; power = default.DiffOverTime_LargeZedHealthPowerPerWave.Suicidal; break;
		case 3 : factor = default.DiffOverTime_LargeZedHealthIncPerWave.HoE; power = default.DiffOverTime_LargeZedHealthPowerPerWave.HoE; break;
		default: factor = default.DiffOverTime_LargeZedHealthIncPerWave.Custom;	power = default.DiffOverTime_LargeZedHealthPowerPerWave.Custom; break;
	}

	wave = float(WaveNum - 1);
	return (mod + factor * wave) ** (1.0f + power * wave);
}

static function float GetZedDamageModifierOverTime(float mod, int Difficulty, int WaveNum)
{
	local float factor, power, wave;

	switch (Difficulty)
	{
		case 0 : factor = default.DiffOverTime_ZedDamageIncPerWave.Normal; power = default.DiffOverTime_ZedDamagePowerPerWave.Normal; break;
		case 1 : factor = default.DiffOverTime_ZedDamageIncPerWave.Hard; power = default.DiffOverTime_ZedDamagePowerPerWave.Hard; break;
		case 2 : factor = default.DiffOverTime_ZedDamageIncPerWave.Suicidal; power = default.DiffOverTime_ZedDamagePowerPerWave.Suicidal; break;
		case 3 : factor = default.DiffOverTime_ZedDamageIncPerWave.HoE; power = default.DiffOverTime_ZedDamagePowerPerWave.HoE;	 break;
		default: factor = default.DiffOverTime_ZedDamageIncPerWave.Custom; power = default.DiffOverTime_ZedDamagePowerPerWave.Custom; break;
	}

	wave = float(WaveNum - 1);
	return (mod + factor * wave) ** (1.0f + power * wave);
}

static function float GetZedSpeedModifierOverTime(float mod, int Difficulty, int WaveNum)
{
	local float factor, power, wave;

	switch (Difficulty)
	{
		case 0 : factor = default.DiffOverTime_ZedSpeedIncPerWave.Normal; power = default.DiffOverTime_ZedSpeedPowerPerWave.Normal; break;
		case 1 : factor = default.DiffOverTime_ZedSpeedIncPerWave.Hard; power = default.DiffOverTime_ZedSpeedPowerPerWave.Hard; break;
		case 2 : factor = default.DiffOverTime_ZedSpeedIncPerWave.Suicidal; power = default.DiffOverTime_ZedSpeedPowerPerWave.Suicidal; break;
		case 3 : factor = default.DiffOverTime_ZedSpeedIncPerWave.HoE; power = default.DiffOverTime_ZedSpeedPowerPerWave.HoE; break;
		default: factor = default.DiffOverTime_ZedSpeedIncPerWave.Custom; power = default.DiffOverTime_ZedSpeedPowerPerWave.Custom; break;
	}

	wave = float(WaveNum - 1);
	return (mod + factor * wave) ** (1.0f + power * wave);
}

static function float GetZedSprintChanceModifierOverTime(int Difficulty, int WaveNum)
{
	local float factor;

	switch (Difficulty)
	{
		case 0 : factor = default.DiffOverTime_ZedSprintChanceIncPerWave.Normal; break;
		case 1 : factor = default.DiffOverTime_ZedSprintChanceIncPerWave.Hard; break;
		case 2 : factor = default.DiffOverTime_ZedSprintChanceIncPerWave.Suicidal; break;
		case 3 : factor = default.DiffOverTime_ZedSprintChanceIncPerWave.HoE; break;
		default: factor = default.DiffOverTime_ZedSprintChanceIncPerWave.Custom; break;
	}

	return factor * float(WaveNum - 1);
}

static function float GetZedHardAttackChanceModifierOverTime(int Difficulty, int WaveNum)
{
	local float factor;

	switch (Difficulty)
	{
		case 0 : factor = default.DiffOverTime_ZedHardAttackChanceIncPerWave.Normal; break;
		case 1 : factor = default.DiffOverTime_ZedHardAttackChanceIncPerWave.Hard; break;
		case 2 : factor = default.DiffOverTime_ZedHardAttackChanceIncPerWave.Suicidal; break;
		case 3 : factor = default.DiffOverTime_ZedHardAttackChanceIncPerWave.HoE; break;
		default: factor = default.DiffOverTime_ZedHardAttackChanceIncPerWave.Custom; break;
	}

	return factor * float(WaveNum - 1);
}

static function float GetZedDoshPenaltyModifierOverTime(int Difficulty, int WaveNum)
{
	local float factor, limit;

	switch (Difficulty)
	{
		case 0 : factor = default.DiffOverTime_ZedDoshPenaltyPerWave.Normal; limit = default.DiffOverTime_ZedDoshPenaltyLimit.Normal; break;
		case 1 : factor = default.DiffOverTime_ZedDoshPenaltyPerWave.Hard; limit = default.DiffOverTime_ZedDoshPenaltyLimit.Hard; break;
		case 2 : factor = default.DiffOverTime_ZedDoshPenaltyPerWave.Suicidal; limit = default.DiffOverTime_ZedDoshPenaltyLimit.Suicidal; break;
		case 3 : factor = default.DiffOverTime_ZedDoshPenaltyPerWave.HoE; limit = default.DiffOverTime_ZedDoshPenaltyLimit.HoE; break;
		default: factor = default.DiffOverTime_ZedDoshPenaltyPerWave.Custom; limit = default.DiffOverTime_ZedDoshPenaltyLimit.Custom; break;
	}

	return FMin(limit, factor * float(WaveNum - 1));
}

defaultproperties
{
	Name="Default__Config_DiffOverTime"
}
