class Config_Objective extends Config_Base
	config(ZedternalReborn);

var config int MODEVERSION;

var config bool Objective_bEnable;

var config float Objective_Probability;
var config float Objective_PctOfWaveKilledForMaxReward;
var config int Objective_BaseMoney;
var config S_Difficulty_Float Objective_DoshDifficultyModifier;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Objective_bEnable = true;

		default.Objective_Probability = 0.25f;
		default.Objective_PctOfWaveKilledForMaxReward = 0.75f;
		default.Objective_BaseMoney = 180;

		default.Objective_DoshDifficultyModifier.Normal = 1.0f;
		default.Objective_DoshDifficultyModifier.Hard = 1.25f;
		default.Objective_DoshDifficultyModifier.Suicidal = 1.5f;
		default.Objective_DoshDifficultyModifier.HoE = 1.75f;
		default.Objective_DoshDifficultyModifier.Custom = 2.0f;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.default.currentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.default.currentVersion;
		static.StaticSaveConfig();
	}
}

static function float GetDoshDifficultyModifier(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.Objective_DoshDifficultyModifier.Normal;
		case 1 :	return default.Objective_DoshDifficultyModifier.Hard;
		case 2 :	return default.Objective_DoshDifficultyModifier.Suicidal;
		case 3 :	return default.Objective_DoshDifficultyModifier.HoE;
		default:	return default.Objective_DoshDifficultyModifier.Custom;
	}
}

defaultproperties
{
}