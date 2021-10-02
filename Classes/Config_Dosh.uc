class Config_Dosh extends Config_Common
	config(ZedternalReborn_Game);

var config int MODEVERSION;

var config S_Difficulty_Int Dosh_StartingDosh;

var config S_Difficulty_Float Dosh_NormalZedDoshMultiplier;
var config S_Difficulty_Float Dosh_ExtraNormalZedDoshIncPerPlayer; //Extra amount of dosh won based on number of other players
var config S_Difficulty_Float Dosh_LargeZedDoshMultiplier;
var config S_Difficulty_Float Dosh_ExtraLargeZedDoshIncPerPlayer; //Extra amount of dosh won based on number of other players

var config S_Difficulty_Int Dosh_BaseDoshWaveReward; //Base amount of Dosh granted to every player for a completed wave
var config S_Difficulty_Int Dosh_ExtraDoshRewardPerPlayer; //Extra Dosh granted base on the number of players, PlayerCount * this variable
var config S_Difficulty_Int Dosh_ExtraDoshPerWaveBonusMultiplier; //Extra Dosh granted base on the current wave number, WaveNum * this variable
var config S_Difficulty_Int Dosh_ExtraDoshPerPerkLevelBonusMultiplier; //Extra Dosh granted base on the player's current perk level, Perk Level * this variable.

var config S_Difficulty_Float Dosh_LateJoinerTotalDoshMultiplier; //When a new player joins mid-game, give him Dosh won (by other players) * this variable
var config S_Difficulty_Float Dosh_DeathPenaltyDoshPct; //Dosh percentage penalty when dying

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Dosh_StartingDosh.Normal = 400;
		default.Dosh_StartingDosh.Hard = 400;
		default.Dosh_StartingDosh.Suicidal = 400;
		default.Dosh_StartingDosh.HoE = 400;
		default.Dosh_StartingDosh.Custom = 400;

		default.Dosh_NormalZedDoshMultiplier.Normal = 1.25f;
		default.Dosh_NormalZedDoshMultiplier.Hard = 1.225f;
		default.Dosh_NormalZedDoshMultiplier.Suicidal = 1.2f;
		default.Dosh_NormalZedDoshMultiplier.HoE = 1.2f;
		default.Dosh_NormalZedDoshMultiplier.Custom = 1.2f;

		default.Dosh_ExtraNormalZedDoshIncPerPlayer.Normal = 0.05f;
		default.Dosh_ExtraNormalZedDoshIncPerPlayer.Hard = 0.05f;
		default.Dosh_ExtraNormalZedDoshIncPerPlayer.Suicidal = 0.05f;
		default.Dosh_ExtraNormalZedDoshIncPerPlayer.HoE = 0.05f;
		default.Dosh_ExtraNormalZedDoshIncPerPlayer.Custom = 0.05f;

		default.Dosh_LargeZedDoshMultiplier.Normal = 0.75f;
		default.Dosh_LargeZedDoshMultiplier.Hard = 0.725f;
		default.Dosh_LargeZedDoshMultiplier.Suicidal = 0.7f;
		default.Dosh_LargeZedDoshMultiplier.HoE = 0.7f;
		default.Dosh_LargeZedDoshMultiplier.Custom = 0.7f;

		default.Dosh_ExtraLargeZedDoshIncPerPlayer.Normal = 0.08f;
		default.Dosh_ExtraLargeZedDoshIncPerPlayer.Hard = 0.08f;
		default.Dosh_ExtraLargeZedDoshIncPerPlayer.Suicidal = 0.08f;
		default.Dosh_ExtraLargeZedDoshIncPerPlayer.HoE = 0.08f;
		default.Dosh_ExtraLargeZedDoshIncPerPlayer.Custom = 0.08f;

		default.Dosh_BaseDoshWaveReward.Normal = 660;
		default.Dosh_BaseDoshWaveReward.Hard = 660;
		default.Dosh_BaseDoshWaveReward.Suicidal = 660;
		default.Dosh_BaseDoshWaveReward.HoE = 660;
		default.Dosh_BaseDoshWaveReward.Custom = 660;

		default.Dosh_ExtraDoshRewardPerPlayer.Normal = 20;
		default.Dosh_ExtraDoshRewardPerPlayer.Hard = 20;
		default.Dosh_ExtraDoshRewardPerPlayer.Suicidal = 20;
		default.Dosh_ExtraDoshRewardPerPlayer.HoE = 20;
		default.Dosh_ExtraDoshRewardPerPlayer.Custom = 20;

		default.Dosh_ExtraDoshPerWaveBonusMultiplier.Normal = 5;
		default.Dosh_ExtraDoshPerWaveBonusMultiplier.Hard = 5;
		default.Dosh_ExtraDoshPerWaveBonusMultiplier.Suicidal = 5;
		default.Dosh_ExtraDoshPerWaveBonusMultiplier.HoE = 5;
		default.Dosh_ExtraDoshPerWaveBonusMultiplier.Custom = 5;

		default.Dosh_ExtraDoshPerPerkLevelBonusMultiplier.Normal = 3;
		default.Dosh_ExtraDoshPerPerkLevelBonusMultiplier.Hard = 3;
		default.Dosh_ExtraDoshPerPerkLevelBonusMultiplier.Suicidal = 3;
		default.Dosh_ExtraDoshPerPerkLevelBonusMultiplier.HoE = 3;
		default.Dosh_ExtraDoshPerPerkLevelBonusMultiplier.Custom = 3;

		default.Dosh_LateJoinerTotalDoshMultiplier.Normal = 0.7f;
		default.Dosh_LateJoinerTotalDoshMultiplier.Hard = 0.7f;
		default.Dosh_LateJoinerTotalDoshMultiplier.Suicidal = 0.7f;
		default.Dosh_LateJoinerTotalDoshMultiplier.HoE = 0.7f;
		default.Dosh_LateJoinerTotalDoshMultiplier.Custom = 0.7f;

		default.Dosh_DeathPenaltyDoshPct.Normal = 0.05f;
		default.Dosh_DeathPenaltyDoshPct.Hard = 0.1f;
		default.Dosh_DeathPenaltyDoshPct.Suicidal = 0.2f;
		default.Dosh_DeathPenaltyDoshPct.HoE = 0.25f;
		default.Dosh_DeathPenaltyDoshPct.Custom = 0.25f;
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
		if (GetStructValueInt(default.Dosh_StartingDosh, i) < 0)
		{
			LogBadStructConfigMessage(i, "Dosh_StartingDosh",
				string(GetStructValueInt(default.Dosh_StartingDosh, i)),
				"0", "0 dosh, no starting dosh", "value >= 0");
			SetStructValueInt(default.Dosh_StartingDosh, i, 0);
		}

		if (GetStructValueFloat(default.Dosh_NormalZedDoshMultiplier, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "Dosh_NormalZedDoshMultiplier",
				string(GetStructValueFloat(default.Dosh_NormalZedDoshMultiplier, i)),
				"0.0", "0%, no dosh reward", "value >= 0.0");
			SetStructValueFloat(default.Dosh_NormalZedDoshMultiplier, i, 0.0f);
		}

		if (GetStructValueFloat(default.Dosh_ExtraNormalZedDoshIncPerPlayer, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "Dosh_ExtraNormalZedDoshIncPerPlayer",
				string(GetStructValueFloat(default.Dosh_ExtraNormalZedDoshIncPerPlayer, i)),
				"0.0", "0% increase, no extra dosh reward", "value >= 0.0");
			SetStructValueFloat(default.Dosh_ExtraNormalZedDoshIncPerPlayer, i, 0.0f);
		}

		if (GetStructValueFloat(default.Dosh_LargeZedDoshMultiplier, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "Dosh_LargeZedDoshMultiplier",
				string(GetStructValueFloat(default.Dosh_LargeZedDoshMultiplier, i)),
				"0.0", "0%, no dosh reward", "value >= 0.0");
			SetStructValueFloat(default.Dosh_LargeZedDoshMultiplier, i, 0.0f);
		}

		if (GetStructValueFloat(default.Dosh_ExtraLargeZedDoshIncPerPlayer, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "Dosh_ExtraLargeZedDoshIncPerPlayer",
				string(GetStructValueFloat(default.Dosh_ExtraLargeZedDoshIncPerPlayer, i)),
				"0.0", "0% increase, no extra dosh reward", "value >= 0.0");
			SetStructValueFloat(default.Dosh_ExtraLargeZedDoshIncPerPlayer, i, 0.0f);
		}

		if (GetStructValueInt(default.Dosh_BaseDoshWaveReward, i) < 0)
		{
			LogBadStructConfigMessage(i, "Dosh_BaseDoshWaveReward",
				string(GetStructValueInt(default.Dosh_BaseDoshWaveReward, i)),
				"0", "0 dosh, no base dosh reward", "value >= 0");
			SetStructValueInt(default.Dosh_BaseDoshWaveReward, i, 0);
		}

		if (GetStructValueInt(default.Dosh_ExtraDoshRewardPerPlayer, i) < 0)
		{
			LogBadStructConfigMessage(i, "Dosh_ExtraDoshRewardPerPlayer",
				string(GetStructValueInt(default.Dosh_ExtraDoshRewardPerPlayer, i)),
				"0", "0 dosh, no extra dosh reward", "value >= 0");
			SetStructValueInt(default.Dosh_ExtraDoshRewardPerPlayer, i, 0);
		}

		if (GetStructValueInt(default.Dosh_ExtraDoshPerWaveBonusMultiplier, i) < 0)
		{
			LogBadStructConfigMessage(i, "Dosh_ExtraDoshPerWaveBonusMultiplier",
				string(GetStructValueInt(default.Dosh_ExtraDoshPerWaveBonusMultiplier, i)),
				"0", "0x, no extra dosh multiplier", "value >= 0");
			SetStructValueInt(default.Dosh_ExtraDoshPerWaveBonusMultiplier, i, 0);
		}

		if (GetStructValueInt(default.Dosh_ExtraDoshPerPerkLevelBonusMultiplier, i) < 0)
		{
			LogBadStructConfigMessage(i, "Dosh_ExtraDoshPerPerkLevelBonusMultiplier",
				string(GetStructValueInt(default.Dosh_ExtraDoshPerPerkLevelBonusMultiplier, i)),
				"0", "0x, no extra dosh multiplier", "value >= 0");
			SetStructValueInt(default.Dosh_ExtraDoshPerPerkLevelBonusMultiplier, i, 0);
		}

		if (GetStructValueFloat(default.Dosh_LateJoinerTotalDoshMultiplier, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "Dosh_LateJoinerTotalDoshMultiplier",
				string(GetStructValueFloat(default.Dosh_LateJoinerTotalDoshMultiplier, i)),
				"0.0", "0%, no late joiner dosh", "value >= 0.0");
			SetStructValueFloat(default.Dosh_LateJoinerTotalDoshMultiplier, i, 0.0f);
		}

		if (GetStructValueFloat(default.Dosh_DeathPenaltyDoshPct, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "Dosh_DeathPenaltyDoshPct",
				string(GetStructValueFloat(default.Dosh_DeathPenaltyDoshPct, i)),
				"0.0", "0%, no dosh penalty", "1.0 >= value >= 0.0");
			SetStructValueFloat(default.Dosh_DeathPenaltyDoshPct, i, 0.0f);
		}

		if (GetStructValueFloat(default.Dosh_DeathPenaltyDoshPct, i) > 1.0f)
		{
			LogBadStructConfigMessage(i, "Dosh_DeathPenaltyDoshPct",
				string(GetStructValueFloat(default.Dosh_DeathPenaltyDoshPct, i)),
				"1.0", "100%, loose all wave dosh on death", "1.0 >= value >= 0.0");
			SetStructValueFloat(default.Dosh_DeathPenaltyDoshPct, i, 1.0f);
		}
	}
}

static function int GetStartingDosh(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Dosh_StartingDosh.Normal;
		case 1 : return default.Dosh_StartingDosh.Hard;
		case 2 : return default.Dosh_StartingDosh.Suicidal;
		case 3 : return default.Dosh_StartingDosh.HoE;
		default: return default.Dosh_StartingDosh.Custom;
	}
}

static function float GetNormalZedDoshMultiplier(int Difficulty, int PlayerCount)
{
	local float Base, Extra;

	switch (Difficulty)
	{
		case 0 : Base = default.Dosh_NormalZedDoshMultiplier.Normal; Extra = default.Dosh_ExtraNormalZedDoshIncPerPlayer.Normal; break;
		case 1 : Base = default.Dosh_NormalZedDoshMultiplier.Hard; Extra = default.Dosh_ExtraNormalZedDoshIncPerPlayer.Hard; break;
		case 2 : Base = default.Dosh_NormalZedDoshMultiplier.Suicidal; Extra = default.Dosh_ExtraNormalZedDoshIncPerPlayer.Suicidal; break;
		case 3 : Base = default.Dosh_NormalZedDoshMultiplier.HoE; Extra = default.Dosh_ExtraNormalZedDoshIncPerPlayer.HoE; break;
		default: Base = default.Dosh_NormalZedDoshMultiplier.Custom; Extra = default.Dosh_ExtraNormalZedDoshIncPerPlayer.Custom; break;
	}

	return Base * (1.0f + (PlayerCount - 1) * Extra);
}

static function float GetLargeZedDoshMultiplier(int Difficulty, int PlayerCount)
{
	local float Base, Extra;

	switch (Difficulty)
	{
		case 0 : Base = default.Dosh_LargeZedDoshMultiplier.Normal; Extra = default.Dosh_ExtraLargeZedDoshIncPerPlayer.Normal; break;
		case 1 : Base = default.Dosh_LargeZedDoshMultiplier.Hard; Extra = default.Dosh_ExtraLargeZedDoshIncPerPlayer.Hard; break;
		case 2 : Base = default.Dosh_LargeZedDoshMultiplier.Suicidal; Extra = default.Dosh_ExtraLargeZedDoshIncPerPlayer.Suicidal; break;
		case 3 : Base = default.Dosh_LargeZedDoshMultiplier.HoE; Extra = default.Dosh_ExtraLargeZedDoshIncPerPlayer.HoE; break;
		default: Base = default.Dosh_LargeZedDoshMultiplier.Custom; Extra = default.Dosh_ExtraLargeZedDoshIncPerPlayer.Custom; break;
	}

	return Base * (1.0f + (PlayerCount - 1) * Extra);
}

static function int GetBaseWaveDoshReward(int Difficulty, int PlayerCount)
{
	local float Base, Extra;

	switch (Difficulty)
	{
		case 0 : Base = default.Dosh_BaseDoshWaveReward.Normal; Extra = default.Dosh_ExtraDoshRewardPerPlayer.Normal; break;
		case 1 : Base = default.Dosh_BaseDoshWaveReward.Hard; Extra = default.Dosh_ExtraDoshRewardPerPlayer.Hard; break;
		case 2 : Base = default.Dosh_BaseDoshWaveReward.Suicidal; Extra = default.Dosh_ExtraDoshRewardPerPlayer.Suicidal; break;
		case 3 : Base = default.Dosh_BaseDoshWaveReward.HoE; Extra = default.Dosh_ExtraDoshRewardPerPlayer.HoE; break;
		default: Base = default.Dosh_BaseDoshWaveReward.Custom; Extra = default.Dosh_ExtraDoshRewardPerPlayer.Custom; break;
	}

	return Base + PlayerCount * Extra;
}

static function int GetBonusWaveDoshReward(int Difficulty, int WaveNum)
{
	local float Base;

	switch (Difficulty)
	{
		case 0 : Base = default.Dosh_ExtraDoshPerWaveBonusMultiplier.Normal; break;
		case 1 : Base = default.Dosh_ExtraDoshPerWaveBonusMultiplier.Hard; break;
		case 2 : Base = default.Dosh_ExtraDoshPerWaveBonusMultiplier.Suicidal; break;
		case 3 : Base = default.Dosh_ExtraDoshPerWaveBonusMultiplier.HoE; break;
		default: Base = default.Dosh_ExtraDoshPerWaveBonusMultiplier.Custom; break;
	}

	return Base * WaveNum;
}

static function int GetBonusPlayerLevelDoshReward(int Difficulty, int PlayerLevel)
{
	local float Base;

	switch (Difficulty)
	{
		case 0 : Base = default.Dosh_ExtraDoshPerPerkLevelBonusMultiplier.Normal; break;
		case 1 : Base = default.Dosh_ExtraDoshPerPerkLevelBonusMultiplier.Hard; break;
		case 2 : Base = default.Dosh_ExtraDoshPerPerkLevelBonusMultiplier.Suicidal; break;
		case 3 : Base = default.Dosh_ExtraDoshPerPerkLevelBonusMultiplier.HoE; break;
		default: Base = default.Dosh_ExtraDoshPerPerkLevelBonusMultiplier.Custom; break;
	}

	return Base * PlayerLevel;
}

static function float GetLateJoinerDoshPct(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Dosh_LateJoinerTotalDoshMultiplier.Normal;
		case 1 : return default.Dosh_LateJoinerTotalDoshMultiplier.Hard;
		case 2 : return default.Dosh_LateJoinerTotalDoshMultiplier.Suicidal;
		case 3 : return default.Dosh_LateJoinerTotalDoshMultiplier.HoE;
		default: return default.Dosh_LateJoinerTotalDoshMultiplier.Custom;
	}
}

static function float GetDeathPenaltyDoshPct(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Dosh_DeathPenaltyDoshPct.Normal;
		case 1 : return default.Dosh_DeathPenaltyDoshPct.Hard;
		case 2 : return default.Dosh_DeathPenaltyDoshPct.Suicidal;
		case 3 : return default.Dosh_DeathPenaltyDoshPct.HoE;
		default: return default.Dosh_DeathPenaltyDoshPct.Custom;
	}
}

defaultproperties
{
	Name="Default__Config_Dosh"
}
