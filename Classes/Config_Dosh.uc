class Config_Dosh extends Config_Common
	config(ZedternalReborn_Game);

var config int MODEVERSION;

var config S_Difficulty_Float Dosh_NormalZedDoshFactor;
var config S_Difficulty_Float Dosh_LargeZedDoshFactor;
var config float Dosh_ExtraNormalZedDoshFactorPerPlayer; //extra amount of dosh won based on number of players
var config float Dosh_ExtraLargeZedDoshFactorPerPlayer; //extra amount of dosh won based on number of players

var config int Dosh_BaseDoshWaveRewardPerPlayer; //Base amount of Dosh granted to every player for a completed wave
var config int Dosh_ExtraDoshPerWavePerPlayer; //Extra Dosh granted base on the number of players, PlayerCount * this variable
var config int Dosh_ExtraDoshWaveBonusMultiplier; //Extra Dosh granted base on the current wave number, WaveNum * this variable
var config int Dosh_ExtraDoshPerkBonusDivider; //Extra Dosh granted base on the player's current perk level, this variable divides the DoshPerWavePerPlayer variable and sets the result as the max possible bonus Dosh.
var config int Dosh_ExtraDoshPerkBonusMaxThreshold; //Extra Dosh granted base on the player's current perk level, this variable determines the minimum perk level needed to get the maximum bonus Dosh.

var config float Dosh_LateJoinerTotalDoshFactor; //When a new player joins mid-game, give him Dosh won (by other players) * this variable
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

		default.Dosh_LargeZedDoshFactor.Normal = 0.7f;
		default.Dosh_LargeZedDoshFactor.Hard = 0.7f;
		default.Dosh_LargeZedDoshFactor.Suicidal = 0.7f;
		default.Dosh_LargeZedDoshFactor.HoE = 0.7f;
		default.Dosh_LargeZedDoshFactor.Custom = 0.7f;

		default.Dosh_ExtraNormalZedDoshFactorPerPlayer = 0.05f;
		default.Dosh_ExtraLargeZedDoshFactorPerPlayer = 0.08f;

		default.Dosh_BaseDoshWaveRewardPerPlayer = 660;
		default.Dosh_ExtraDoshPerWavePerPlayer = 20;
		default.Dosh_ExtraDoshWaveBonusMultiplier = 5;
		default.Dosh_ExtraDoshPerkBonusDivider = 2;
		default.Dosh_ExtraDoshPerkBonusMaxThreshold = 140;

		default.Dosh_LateJoinerTotalDoshFactor = 0.7f;

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

static function float GetNormalZedDoshFactor(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.Dosh_NormalZedDoshFactor.Normal;
		case 1 :	return default.Dosh_NormalZedDoshFactor.Hard;
		case 2 :	return default.Dosh_NormalZedDoshFactor.Suicidal;
		case 3 :	return default.Dosh_NormalZedDoshFactor.HoE;
		default:	return default.Dosh_NormalZedDoshFactor.Custom;
	}
}

static function float GetLargeZedDoshFactor(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.Dosh_LargeZedDoshFactor.Normal;
		case 1 :	return default.Dosh_LargeZedDoshFactor.Hard;
		case 2 :	return default.Dosh_LargeZedDoshFactor.Suicidal;
		case 3 :	return default.Dosh_LargeZedDoshFactor.HoE;
		default:	return default.Dosh_LargeZedDoshFactor.Custom;
	}
}

static function int GetBasePlayerWaveDoshReward(int PlayerCount)
{
	return default.Dosh_BaseDoshWaveRewardPerPlayer + default.Dosh_ExtraDoshPerWavePerPlayer * PlayerCount;
}

static function int GetBonusPlayerWaveDoshReward(int PlayerLevel)
{
	if (default.Dosh_ExtraDoshPerkBonusDivider > 0 && default.Dosh_ExtraDoshPerkBonusMaxThreshold > 0)
	{
		return Min(PlayerLevel, default.Dosh_ExtraDoshPerkBonusMaxThreshold) * default.Dosh_BaseDoshWaveRewardPerPlayer
		/ (default.Dosh_ExtraDoshPerkBonusDivider * default.Dosh_ExtraDoshPerkBonusMaxThreshold);
	}
	else
		return 0;
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
