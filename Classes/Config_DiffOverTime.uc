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
var config float DiffOverTime_ZedDoshPenaltyPerWave;
var config float DiffOverTime_ZedDoshPenaltyLimit;
var config float DiffOverTime_ZedHardAttackChanceIncPerWave;

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

		default.DiffOverTime_ZedDoshPenaltyPerWave = 0.022f;
		default.DiffOverTime_ZedDoshPenaltyLimit = 0.6f;

		default.DiffOverTime_ZedHardAttackChanceIncPerWave = 0.03f;
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
	}

	if (default.DiffOverTime_ZedDoshPenaltyPerWave < 0.0f)
	{
		`log("ZR Config: Modifier for ZED dosh penalty"
			@"is set to" @ default.DiffOverTime_ZedDoshPenaltyPerWave
			@"which is not supported. Setting the increase to the minimum value of 0.0 (0%, no penalty increase) temporarily."
			@"Please change the value in the config to a value greater than or equal to 0.0.");
		default.DiffOverTime_ZedDoshPenaltyPerWave = 0.0f;
	}

	if (default.DiffOverTime_ZedDoshPenaltyLimit < 0.0f)
	{
		`log("ZR Config: Max cap for ZED dosh penalty"
			@"is set to" @ default.DiffOverTime_ZedDoshPenaltyLimit
			@"which is not supported. Setting the cap to the minimum value of 0.0 (0%, no penalty) temporarily."
			@"Please change the value in the config to a value greater than or equal to 0.0.");
		default.DiffOverTime_ZedDoshPenaltyLimit = 0.0f;
	}

	if (default.DiffOverTime_ZedHardAttackChanceIncPerWave < 0.0f)
	{
		`log("ZR Config: Linear increase for ZED hard attack chance"
			@"is set to" @ default.DiffOverTime_ZedHardAttackChanceIncPerWave
			@"which is not supported. Setting the increase to the minimum value of 0.0 (0%, no linear increase) temporarily."
			@"Please change the value in the config to a value greater than or equal to 0.0.");
		default.DiffOverTime_ZedHardAttackChanceIncPerWave = 0.0f;
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

static function float GetZedDoshPenaltyModifierOverTime(int WaveNum)
{
	return FMin(default.DiffOverTime_ZedDoshPenaltyLimit, default.DiffOverTime_ZedDoshPenaltyPerWave * float(WaveNum - 1));
}

static function float GetZedHardAttackChanceModifierOverTime(int WaveNum)
{
	return default.DiffOverTime_ZedHardAttackChanceIncPerWave * float(WaveNum - 1);
}

defaultproperties
{
	Name="Default__Config_DiffOverTime"
}
