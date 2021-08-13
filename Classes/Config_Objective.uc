class Config_Objective extends Config_Common
	config(ZedternalReborn);

var config int MODEVERSION;

var config bool Objective_bEnable;

var config float Objective_Probability;
var config int Objective_BaseMoney;
var config S_Difficulty_Float Objective_PctOfWaveKilledForMaxReward;
var config S_Difficulty_Float Objective_DoshDifficultyModifier;
var config S_Difficulty_Float Objective_DoshDifficultyModifierIncPerWave;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Objective_bEnable = true;

		default.Objective_Probability = 0.25f;
		default.Objective_BaseMoney = 180;

		default.Objective_PctOfWaveKilledForMaxReward.Normal = 0.65f;
		default.Objective_PctOfWaveKilledForMaxReward.Hard = 0.70f;
		default.Objective_PctOfWaveKilledForMaxReward.Suicidal = 0.75f;
		default.Objective_PctOfWaveKilledForMaxReward.HoE = 0.80f;
		default.Objective_PctOfWaveKilledForMaxReward.Custom = 0.80f;

		default.Objective_DoshDifficultyModifier.Normal = 1.0f;
		default.Objective_DoshDifficultyModifier.Hard = 1.25f;
		default.Objective_DoshDifficultyModifier.Suicidal = 1.5f;
		default.Objective_DoshDifficultyModifier.HoE = 1.75f;
		default.Objective_DoshDifficultyModifier.Custom = 2.0f;

		default.Objective_DoshDifficultyModifierIncPerWave.Normal = 0.15f;
		default.Objective_DoshDifficultyModifierIncPerWave.Hard = 0.10f;
		default.Objective_DoshDifficultyModifierIncPerWave.Suicidal = 0.10f;
		default.Objective_DoshDifficultyModifierIncPerWave.HoE = 0.05f;
		default.Objective_DoshDifficultyModifierIncPerWave.Custom = 0.05f;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.currentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.currentVersion;
		static.StaticSaveConfig();
	}
}

static function float GetPctOfWaveKilledForMaxReward(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.Objective_PctOfWaveKilledForMaxReward.Normal;
		case 1 :	return default.Objective_PctOfWaveKilledForMaxReward.Hard;
		case 2 :	return default.Objective_PctOfWaveKilledForMaxReward.Suicidal;
		case 3 :	return default.Objective_PctOfWaveKilledForMaxReward.HoE;
		default:	return default.Objective_PctOfWaveKilledForMaxReward.Custom;
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

static function float GetDoshDifficultyModifierIncPerWave(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.Objective_DoshDifficultyModifierIncPerWave.Normal;
		case 1 :	return default.Objective_DoshDifficultyModifierIncPerWave.Hard;
		case 2 :	return default.Objective_DoshDifficultyModifierIncPerWave.Suicidal;
		case 3 :	return default.Objective_DoshDifficultyModifierIncPerWave.HoE;
		default:	return default.Objective_DoshDifficultyModifierIncPerWave.Custom;
	}
}

defaultproperties
{
}
