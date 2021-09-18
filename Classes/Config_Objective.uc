class Config_Objective extends Config_Common
	config(ZedternalReborn_Events);

var config int MODEVERSION;

var config S_Difficulty_Bool Objective_bEnable;
var config S_Difficulty_Float Objective_Probability;
var config S_Difficulty_Int Objective_BaseDosh;
var config S_Difficulty_Float Objective_PctOfWaveKilledForMaxReward;
var config S_Difficulty_Float Objective_DoshIncreaseModifierPerWave;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Objective_bEnable.Normal = True;
		default.Objective_bEnable.Hard = True;
		default.Objective_bEnable.Suicidal = True;
		default.Objective_bEnable.HoE = True;
		default.Objective_bEnable.Custom = True;

		default.Objective_Probability.Normal = 0.25f;
		default.Objective_Probability.Hard = 0.25f;
		default.Objective_Probability.Suicidal = 0.25f;
		default.Objective_Probability.HoE = 0.25f;
		default.Objective_Probability.Custom = 0.25f;

		default.Objective_BaseDosh.Normal = 180;
		default.Objective_BaseDosh.Hard = 225;
		default.Objective_BaseDosh.Suicidal = 270;
		default.Objective_BaseDosh.HoE = 315;
		default.Objective_BaseDosh.Custom = 315;

		default.Objective_PctOfWaveKilledForMaxReward.Normal = 0.65f;
		default.Objective_PctOfWaveKilledForMaxReward.Hard = 0.70f;
		default.Objective_PctOfWaveKilledForMaxReward.Suicidal = 0.75f;
		default.Objective_PctOfWaveKilledForMaxReward.HoE = 0.80f;
		default.Objective_PctOfWaveKilledForMaxReward.Custom = 0.80f;

		default.Objective_DoshIncreaseModifierPerWave.Normal = 0.15f;
		default.Objective_DoshIncreaseModifierPerWave.Hard = 0.10f;
		default.Objective_DoshIncreaseModifierPerWave.Suicidal = 0.10f;
		default.Objective_DoshIncreaseModifierPerWave.HoE = 0.05f;
		default.Objective_DoshIncreaseModifierPerWave.Custom = 0.05f;
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
		if (GetStructValueFloat(default.Objective_Probability, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "Objective_Probability",
				string(GetStructValueFloat(default.Objective_Probability, i)),
				"0.0", "0%, never activates", "1.0 >= value >= 0.0");
			SetStructValueFloat(default.Objective_Probability, i, 0.0f);
		}

		if (GetStructValueFloat(default.Objective_Probability, i) > 1.0f)
		{
			LogBadStructConfigMessage(i, "Objective_Probability",
				string(GetStructValueFloat(default.Objective_Probability, i)),
				"1.0", "100%, always activates", "1.0 >= value >= 0.0");
			SetStructValueFloat(default.Objective_Probability, i, 1.0f);
		}

		if (GetStructValueInt(default.Objective_BaseDosh, i) < 0)
		{
			LogBadStructConfigMessage(i, "Objective_BaseDosh",
				string(GetStructValueInt(default.Objective_BaseDosh, i)),
				"0", "0 dosh, no reward", "value >= 0");
			SetStructValueInt(default.Objective_BaseDosh, i, 0);
		}

		if (GetStructValueFloat(default.Objective_PctOfWaveKilledForMaxReward, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "Objective_PctOfWaveKilledForMaxReward",
				string(GetStructValueFloat(default.Objective_PctOfWaveKilledForMaxReward, i)),
				"0.0", "0%, none of the wave", "1.0 >= value >= 0.0");
			SetStructValueFloat(default.Objective_PctOfWaveKilledForMaxReward, i, 0.0f);
		}

		if (GetStructValueFloat(default.Objective_PctOfWaveKilledForMaxReward, i) > 1.0f)
		{
			LogBadStructConfigMessage(i, "Objective_PctOfWaveKilledForMaxReward",
				string(GetStructValueFloat(default.Objective_PctOfWaveKilledForMaxReward, i)),
				"1.0", "100%, the entire wave", "1.0 >= value >= 0.0");
			SetStructValueFloat(default.Objective_PctOfWaveKilledForMaxReward, i, 1.0f);
		}

		if (GetStructValueFloat(default.Objective_DoshIncreaseModifierPerWave, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "Objective_DoshIncreaseModifierPerWave",
				string(GetStructValueFloat(default.Objective_DoshIncreaseModifierPerWave, i)),
				"0.0", "0%, no increase", "value >= 0.0");
			SetStructValueFloat(default.Objective_DoshIncreaseModifierPerWave, i, 0.0f);
		}
	}
}

static function bool GetShouldEnableObjective(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Objective_bEnable.Normal;
		case 1 : return default.Objective_bEnable.Hard;
		case 2 : return default.Objective_bEnable.Suicidal;
		case 3 : return default.Objective_bEnable.HoE;
		default: return default.Objective_bEnable.Custom;
	}
}

static function float GetObjectiveProbability(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Objective_Probability.Normal;
		case 1 : return default.Objective_Probability.Hard;
		case 2 : return default.Objective_Probability.Suicidal;
		case 3 : return default.Objective_Probability.HoE;
		default: return default.Objective_Probability.Custom;
	}
}

static function int GetObjectiveBaseDoshReward(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Objective_BaseDosh.Normal;
		case 1 : return default.Objective_BaseDosh.Hard;
		case 2 : return default.Objective_BaseDosh.Suicidal;
		case 3 : return default.Objective_BaseDosh.HoE;
		default: return default.Objective_BaseDosh.Custom;
	}
}

static function float GetPctOfWaveKilledForMaxReward(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Objective_PctOfWaveKilledForMaxReward.Normal;
		case 1 : return default.Objective_PctOfWaveKilledForMaxReward.Hard;
		case 2 : return default.Objective_PctOfWaveKilledForMaxReward.Suicidal;
		case 3 : return default.Objective_PctOfWaveKilledForMaxReward.HoE;
		default: return default.Objective_PctOfWaveKilledForMaxReward.Custom;
	}
}

static function float GetDoshIncreaseModifierPerWave(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Objective_DoshIncreaseModifierPerWave.Normal;
		case 1 : return default.Objective_DoshIncreaseModifierPerWave.Hard;
		case 2 : return default.Objective_DoshIncreaseModifierPerWave.Suicidal;
		case 3 : return default.Objective_DoshIncreaseModifierPerWave.HoE;
		default: return default.Objective_DoshIncreaseModifierPerWave.Custom;
	}
}

defaultproperties
{
	Name="Default__Config_Objective"
}
