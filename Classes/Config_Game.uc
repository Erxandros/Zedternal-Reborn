class Config_Game extends Config_Common
	config(ZedternalReborn);

var config int MODEVERSION;

var config int Game_DoshPerWavePerPlayer; //Base amount of Dosh granted to every player
var config int Game_ExtraDoshPerWavePerPlayer; //Extra Dosh granted base on the number of players, PlayerCount * this variable
var config int Game_ExtraDoshWaveBonusMultiplier; //Extra Dosh granted base on the current wave number, WaveNum * this variable
var config int Game_ExtraDoshPerkBonusDivider; //Extra Dosh granted base on the player's current perk level, this variable divides the DoshPerWavePerPlayer variable and sets the result as the max possible bonus Dosh.
var config int Game_ExtraDoshPerkBonusMaxThreshold; //Extra Dosh granted base on the player's current perk level, this variable determines the minimum perk level needed to get the maximum bonus Dosh.
var config float Game_LateJoinerTotalDoshFactor; //When a new player joins mid-game, give him Dosh won (by other players) * this variable

var config S_Difficulty_Float Game_NormalZedDoshFactor;
var config S_Difficulty_Float Game_LargeZedDoshFactor;
var config float Game_ExtraNormalZedDoshFactorPerPlayer;	//extra amount of dosh won based on number of players
var config float Game_ExtraLargeZedDoshFactorPerPlayer;		//extra amount of dosh won based on number of players
var config S_Difficulty_Float Game_DeathPenaltyDoshPct; //Dosh percentage penalty when dying

var config S_Difficulty_Int Game_ArmorPrice;
var config S_Difficulty_Int Game_GrenadePrice;
var config S_Difficulty_Float Game_AmmoPriceFactor;
var config bool Game_bArmorSpawnOnMap;

var config S_Difficulty_Int Game_TimeBetweenWave;
var config S_Difficulty_Int Game_TimeBetweenWaveIfPlayerDead;

var config bool Game_bUseDefaultTraderVoice;
var config bool Game_bUsePatriarchTraderVoice;
var config bool Game_bUseHansTraderVoice;
var config bool Game_bUseLockheartTraderVoice;
var config bool Game_bUseSantaTraderVoice;
var config bool Game_bUseObjectiveTraderVoice;

var config bool Game_bAllowZedTeleport;
var config bool Game_bAllowFastSpawning;

var config bool Game_bAllowZedternalUpgradeMenuCommand;
var config bool Game_bZedternalUpgradeMenuCommandAllWave;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Game_DoshPerWavePerPlayer = 660;
		default.Game_ExtraDoshPerWavePerPlayer = 20;
		default.Game_LateJoinerTotalDoshFactor = 0.700000;

		default.Game_NormalZedDoshFactor.Normal = 1.250000;
		default.Game_NormalZedDoshFactor.Hard = 1.225000;
		default.Game_NormalZedDoshFactor.Suicidal = 1.200000;
		default.Game_NormalZedDoshFactor.HoE = 1.200000;
		default.Game_NormalZedDoshFactor.Custom = 1.200000;

		default.Game_LargeZedDoshFactor.Normal = 0.700000;
		default.Game_LargeZedDoshFactor.Hard = 0.700000;
		default.Game_LargeZedDoshFactor.Suicidal = 0.700000;
		default.Game_LargeZedDoshFactor.HoE = 0.700000;
		default.Game_LargeZedDoshFactor.Custom = 0.700000;

		default.Game_ExtraNormalZedDoshFactorPerPlayer = 0.050000;
		default.Game_ExtraLargeZedDoshFactorPerPlayer = 0.080000;

		default.Game_ArmorPrice.Normal = 2;
		default.Game_ArmorPrice.Hard = 2;
		default.Game_ArmorPrice.Suicidal = 2;
		default.Game_ArmorPrice.HoE = 2;
		default.Game_ArmorPrice.Custom = 2;

		default.Game_AmmoPriceFactor.Normal = 0.700000;
		default.Game_AmmoPriceFactor.Hard = 0.700000;
		default.Game_AmmoPriceFactor.Suicidal = 0.750000;
		default.Game_AmmoPriceFactor.HoE = 0.800000;
		default.Game_AmmoPriceFactor.Custom = 0.700000;

		default.Game_TimeBetweenWave.Normal = 90;
		default.Game_TimeBetweenWave.Hard = 80;
		default.Game_TimeBetweenWave.Suicidal = 70;
		default.Game_TimeBetweenWave.HoE = 70;
		default.Game_TimeBetweenWave.Custom = 80;

		default.Game_TimeBetweenWaveIfPlayerDead.Normal = 100;
		default.Game_TimeBetweenWaveIfPlayerDead.Hard = 100;
		default.Game_TimeBetweenWaveIfPlayerDead.Suicidal = 80;
		default.Game_TimeBetweenWaveIfPlayerDead.HoE = 80;
		default.Game_TimeBetweenWaveIfPlayerDead.Custom = 100;

		default.Game_bUseDefaultTraderVoice = false;
		default.Game_bUsePatriarchTraderVoice = true;
		default.Game_bUseHansTraderVoice = true;
		default.Game_bUseLockheartTraderVoice = false;
		default.Game_bUseSantaTraderVoice = false;

		default.Game_bAllowZedTeleport = false;
		default.Game_bAllowFastSpawning = true;
	}

	if (default.MODEVERSION < 5)
	{
		default.Game_DeathPenaltyDoshPct.Normal = 0.050000;
		default.Game_DeathPenaltyDoshPct.Hard = 0.100000;
		default.Game_DeathPenaltyDoshPct.Suicidal = 0.200000;
		default.Game_DeathPenaltyDoshPct.HoE = 0.250000;
		default.Game_DeathPenaltyDoshPct.Custom = 0.300000;

		default.Game_GrenadePrice.Normal = 40;
		default.Game_GrenadePrice.Hard = 40;
		default.Game_GrenadePrice.Suicidal = 40;
		default.Game_GrenadePrice.HoE = 40;
		default.Game_GrenadePrice.Custom = 40;

		default.Game_bArmorSpawnOnMap = true;
	}

	if (default.MODEVERSION < 6)
	{
		default.Game_bAllowZedternalUpgradeMenuCommand = false;
		default.Game_bZedternalUpgradeMenuCommandAllWave = false;
	}

	if (default.MODEVERSION < 7)
	{
		default.Game_ExtraDoshWaveBonusMultiplier = 5;
		default.Game_ExtraDoshPerkBonusDivider = 2;
		default.Game_ExtraDoshPerkBonusMaxThreshold = 140;
	}

	if (default.MODEVERSION < 10)
	{
		default.Game_bUseObjectiveTraderVoice = false;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.currentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.currentVersion;
		static.StaticSaveConfig();
	}
}

static function float GetNormalZedDoshFactor(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.Game_NormalZedDoshFactor.Normal;
		case 1 :	return default.Game_NormalZedDoshFactor.Hard;
		case 2 :	return default.Game_NormalZedDoshFactor.Suicidal;
		case 3 :	return default.Game_NormalZedDoshFactor.HoE;
		default:	return default.Game_NormalZedDoshFactor.Custom;
	}
}

static function float GetLargeZedDoshFactor(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.Game_LargeZedDoshFactor.Normal;
		case 1 :	return default.Game_LargeZedDoshFactor.Hard;
		case 2 :	return default.Game_LargeZedDoshFactor.Suicidal;
		case 3 :	return default.Game_LargeZedDoshFactor.HoE;
		default:	return default.Game_LargeZedDoshFactor.Custom;
	}
}

static function float GetDeathPenaltyDoshPct(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.Game_DeathPenaltyDoshPct.Normal;
		case 1 :	return default.Game_DeathPenaltyDoshPct.Hard;
		case 2 :	return default.Game_DeathPenaltyDoshPct.Suicidal;
		case 3 :	return default.Game_DeathPenaltyDoshPct.HoE;
		default:	return default.Game_DeathPenaltyDoshPct.Custom;
	}
}

static function int GetArmorPrice(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.Game_ArmorPrice.Normal;
		case 1 :	return default.Game_ArmorPrice.Hard;
		case 2 :	return default.Game_ArmorPrice.Suicidal;
		case 3 :	return default.Game_ArmorPrice.HoE;
		default:	return default.Game_ArmorPrice.Custom;
	}
}

static function int GetGrenadePrice(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.Game_GrenadePrice.Normal;
		case 1 :	return default.Game_GrenadePrice.Hard;
		case 2 :	return default.Game_GrenadePrice.Suicidal;
		case 3 :	return default.Game_GrenadePrice.HoE;
		default:	return default.Game_GrenadePrice.Custom;
	}
}

static function float GetAmmoPriceFactor(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.Game_AmmoPriceFactor.Normal;
		case 1 :	return default.Game_AmmoPriceFactor.Hard;
		case 2 :	return default.Game_AmmoPriceFactor.Suicidal;
		case 3 :	return default.Game_AmmoPriceFactor.HoE;
		default:	return default.Game_AmmoPriceFactor.Custom;
	}
}

static function int GetTimeBetweenWave(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.Game_TimeBetweenWave.Normal;
		case 1 :	return default.Game_TimeBetweenWave.Hard;
		case 2 :	return default.Game_TimeBetweenWave.Suicidal;
		case 3 :	return default.Game_TimeBetweenWave.HoE;
		default:	return default.Game_TimeBetweenWave.Custom;
	}
}

static function int GetTimeBetweenWaveHumanDied(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.Game_TimeBetweenWaveIfPlayerDead.Normal;
		case 1 :	return default.Game_TimeBetweenWaveIfPlayerDead.Hard;
		case 2 :	return default.Game_TimeBetweenWaveIfPlayerDead.Suicidal;
		case 3 :	return default.Game_TimeBetweenWaveIfPlayerDead.HoE;
		default:	return default.Game_TimeBetweenWaveIfPlayerDead.Custom;
	}
}

defaultproperties
{
}
