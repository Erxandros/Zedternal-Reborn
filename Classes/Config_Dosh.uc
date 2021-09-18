class Config_Dosh extends Config_Common
	config(ZedternalReborn_Game);

var config int MODEVERSION;

var config S_Difficulty_Float Dosh_NormalZedDoshFactor;
var config S_Difficulty_Float Dosh_ExtraNormalZedDoshFactorPerPlayer; //Extra amount of dosh won based on number of other players
var config S_Difficulty_Float Dosh_LargeZedDoshFactor;
var config S_Difficulty_Float Dosh_ExtraLargeZedDoshFactorPerPlayer; //Extra amount of dosh won based on number of other players

var config S_Difficulty_Int Dosh_BaseDoshWaveReward; //Base amount of Dosh granted to every player for a completed wave
var config S_Difficulty_Int Dosh_ExtraDoshRewardPerPlayer; //Extra Dosh granted base on the number of players, PlayerCount * this variable
var config S_Difficulty_Int Dosh_ExtraDoshPerWaveBonusMultiplier; //Extra Dosh granted base on the current wave number, WaveNum * this variable
var config S_Difficulty_Int Dosh_ExtraDoshPerPerkLevelBonusMultiplier; //Extra Dosh granted base on the player's current perk level, Perk Level * this variable.

var config S_Difficulty_Float Dosh_LateJoinerTotalDoshFactor; //When a new player joins mid-game, give him Dosh won (by other players) * this variable
var config S_Difficulty_Float Dosh_DeathPenaltyDoshPct; //Dosh percentage penalty when dying

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Dosh_NormalZedDoshFactor.Normal = 1.25f;
		default.Dosh_NormalZedDoshFactor.Hard = 1.225f;
		default.Dosh_NormalZedDoshFactor.Suicidal = 1.2f;
		default.Dosh_NormalZedDoshFactor.HoE = 1.2f;
		default.Dosh_NormalZedDoshFactor.Custom = 1.2f;

		default.Dosh_ExtraNormalZedDoshFactorPerPlayer.Normal = 0.05f;
		default.Dosh_ExtraNormalZedDoshFactorPerPlayer.Hard = 0.05f;
		default.Dosh_ExtraNormalZedDoshFactorPerPlayer.Suicidal = 0.05f;
		default.Dosh_ExtraNormalZedDoshFactorPerPlayer.HoE = 0.05f;
		default.Dosh_ExtraNormalZedDoshFactorPerPlayer.Custom = 0.05f;

		default.Dosh_LargeZedDoshFactor.Normal = 0.75f;
		default.Dosh_LargeZedDoshFactor.Hard = 0.725f;
		default.Dosh_LargeZedDoshFactor.Suicidal = 0.7f;
		default.Dosh_LargeZedDoshFactor.HoE = 0.7f;
		default.Dosh_LargeZedDoshFactor.Custom = 0.7f;

		default.Dosh_ExtraLargeZedDoshFactorPerPlayer.Normal = 0.08f;
		default.Dosh_ExtraLargeZedDoshFactorPerPlayer.Hard = 0.08f;
		default.Dosh_ExtraLargeZedDoshFactorPerPlayer.Suicidal = 0.08f;
		default.Dosh_ExtraLargeZedDoshFactorPerPlayer.HoE = 0.08f;
		default.Dosh_ExtraLargeZedDoshFactorPerPlayer.Custom = 0.08f;

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

		default.Dosh_LateJoinerTotalDoshFactor.Normal = 0.7f;
		default.Dosh_LateJoinerTotalDoshFactor.Hard = 0.7f;
		default.Dosh_LateJoinerTotalDoshFactor.Suicidal = 0.7f;
		default.Dosh_LateJoinerTotalDoshFactor.HoE = 0.7f;
		default.Dosh_LateJoinerTotalDoshFactor.Custom = 0.7f;

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
		if (GetStructValueFloat(default.Dosh_NormalZedDoshFactor, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "Dosh_NormalZedDoshFactor",
				string(GetStructValueFloat(default.Dosh_NormalZedDoshFactor, i)),
				"0.0", "0%, no dosh reward", "value >= 0.0");
			SetStructValueFloat(default.Dosh_NormalZedDoshFactor, i, 0.0f);
		}

		if (GetStructValueFloat(default.Dosh_ExtraNormalZedDoshFactorPerPlayer, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "Dosh_ExtraNormalZedDoshFactorPerPlayer",
				string(GetStructValueFloat(default.Dosh_ExtraNormalZedDoshFactorPerPlayer, i)),
				"0.0", "0%, no extra dosh reward", "value >= 0.0");
			SetStructValueFloat(default.Dosh_ExtraNormalZedDoshFactorPerPlayer, i, 0.0f);
		}

		if (GetStructValueFloat(default.Dosh_LargeZedDoshFactor, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "Dosh_LargeZedDoshFactor",
				string(GetStructValueFloat(default.Dosh_LargeZedDoshFactor, i)),
				"0.0", "0%, no dosh reward", "value >= 0.0");
			SetStructValueFloat(default.Dosh_LargeZedDoshFactor, i, 0.0f);
		}

		if (GetStructValueFloat(default.Dosh_ExtraLargeZedDoshFactorPerPlayer, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "Dosh_ExtraLargeZedDoshFactorPerPlayer",
				string(GetStructValueFloat(default.Dosh_ExtraLargeZedDoshFactorPerPlayer, i)),
				"0.0", "0%, no extra dosh reward", "value >= 0.0");
			SetStructValueFloat(default.Dosh_ExtraLargeZedDoshFactorPerPlayer, i, 0.0f);
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

		if (GetStructValueFloat(default.Dosh_LateJoinerTotalDoshFactor, i) < 0.0f)
		{
			LogBadStructConfigMessage(i, "Dosh_LateJoinerTotalDoshFactor",
				string(GetStructValueFloat(default.Dosh_LateJoinerTotalDoshFactor, i)),
				"0.0", "0%, no late joiner dosh", "value >= 0.0");
			SetStructValueFloat(default.Dosh_LateJoinerTotalDoshFactor, i, 0.0f);
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

static function float GetNormalZedDoshFactor(int Difficulty, int PlayerCount)
{
	local float Factor, Extra;

	switch (Difficulty)
	{
		case 0 : Factor = default.Dosh_NormalZedDoshFactor.Normal; Extra = default.Dosh_ExtraNormalZedDoshFactorPerPlayer.Normal; break;
		case 1 : Factor = default.Dosh_NormalZedDoshFactor.Hard; Extra = default.Dosh_ExtraNormalZedDoshFactorPerPlayer.Hard; break;
		case 2 : Factor = default.Dosh_NormalZedDoshFactor.Suicidal; Extra = default.Dosh_ExtraNormalZedDoshFactorPerPlayer.Suicidal; break;
		case 3 : Factor = default.Dosh_NormalZedDoshFactor.HoE; Extra = default.Dosh_ExtraNormalZedDoshFactorPerPlayer.HoE; break;
		default: Factor = default.Dosh_NormalZedDoshFactor.Custom; Extra = default.Dosh_ExtraNormalZedDoshFactorPerPlayer.Custom; break;
	}

	return Factor * (1.0f + (PlayerCount - 1) * Extra);
}

static function float GetLargeZedDoshFactor(int Difficulty, int PlayerCount)
{
	local float Factor, Extra;

	switch (Difficulty)
	{
		case 0 : Factor = default.Dosh_LargeZedDoshFactor.Normal; Extra = default.Dosh_ExtraLargeZedDoshFactorPerPlayer.Normal; break;
		case 1 : Factor = default.Dosh_LargeZedDoshFactor.Hard; Extra = default.Dosh_ExtraLargeZedDoshFactorPerPlayer.Hard; break;
		case 2 : Factor = default.Dosh_LargeZedDoshFactor.Suicidal; Extra = default.Dosh_ExtraLargeZedDoshFactorPerPlayer.Suicidal; break;
		case 3 : Factor = default.Dosh_LargeZedDoshFactor.HoE; Extra = default.Dosh_ExtraLargeZedDoshFactorPerPlayer.HoE; break;
		default: Factor = default.Dosh_LargeZedDoshFactor.Custom; Extra = default.Dosh_ExtraLargeZedDoshFactorPerPlayer.Custom; break;
	}

	return Factor * (1.0f + (PlayerCount - 1) * Extra);
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

	return Base + Extra * PlayerCount;
}

static function int GetBonusWaveDoshReward(int Difficulty, int WaveNum)
{
	local float Multiplier;

	switch (Difficulty)
	{
		case 0 : Multiplier = default.Dosh_ExtraDoshPerWaveBonusMultiplier.Normal; break;
		case 1 : Multiplier = default.Dosh_ExtraDoshPerWaveBonusMultiplier.Hard; break;
		case 2 : Multiplier = default.Dosh_ExtraDoshPerWaveBonusMultiplier.Suicidal; break;
		case 3 : Multiplier = default.Dosh_ExtraDoshPerWaveBonusMultiplier.HoE; break;
		default: Multiplier = default.Dosh_ExtraDoshPerWaveBonusMultiplier.Custom; break;
	}

	return WaveNum * Multiplier;
}

static function int GetBonusPlayerLevelDoshReward(int Difficulty, int PlayerLevel)
{
	local float Multiplier;

	switch (Difficulty)
	{
		case 0 : Multiplier = default.Dosh_ExtraDoshPerPerkLevelBonusMultiplier.Normal; break;
		case 1 : Multiplier = default.Dosh_ExtraDoshPerPerkLevelBonusMultiplier.Hard; break;
		case 2 : Multiplier = default.Dosh_ExtraDoshPerPerkLevelBonusMultiplier.Suicidal; break;
		case 3 : Multiplier = default.Dosh_ExtraDoshPerPerkLevelBonusMultiplier.HoE; break;
		default: Multiplier = default.Dosh_ExtraDoshPerPerkLevelBonusMultiplier.Custom; break;
	}

	return PlayerLevel * Multiplier;
}

static function float GetLateJoinerDoshPct(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.Dosh_LateJoinerTotalDoshFactor.Normal;
		case 1 : return default.Dosh_LateJoinerTotalDoshFactor.Hard;
		case 2 : return default.Dosh_LateJoinerTotalDoshFactor.Suicidal;
		case 3 : return default.Dosh_LateJoinerTotalDoshFactor.HoE;
		default: return default.Dosh_LateJoinerTotalDoshFactor.Custom;
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
