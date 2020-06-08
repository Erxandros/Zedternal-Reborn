class Config_Game extends Config_Base
	config(ZedternalReborn);

var config int MODEVERSION;

var config int Game_DoshPerWavePerPlayer; 			//each player win that amount of dosh every wave
var config int Game_ExtraDoshPerWavePerPlayer; 		//extra amount of dosh won based on number of player
var config float Game_LateJoinerTotalDoshFactor;		//when new player join in mid-game, give him dosh won (by other players) * this variable

var config S_Difficulty_Float Game_NormalZedDoshFactor;
var config S_Difficulty_Float Game_LargeZedDoshFactor;
var config float Game_ExtraNormalZedDoshFactorPerPlayer;	//extra amount of dosh won based on number of players
var config float Game_ExtraLargeZedDoshFactorPerPlayer;		//extra amount of dosh won based on number of players

var config S_Difficulty_Int Game_ArmorPrice;
var config S_Difficulty_Float Game_AmmoPriceFactor;

var config S_Difficulty_Int Game_TimeBetweenWave;
var config S_Difficulty_Int Game_TimeBetweenWaveIfPlayerDead;

var config bool Game_bUseDefaultTraderVoice;
var config bool Game_bUsePatriarchTraderVoice;
var config bool Game_bUseHansTraderVoice;
var config bool Game_bUseLockheartTraderVoice;
var config bool Game_bUseSantaTraderVoice;

var config bool Game_bAllowZedTeleport;
var config bool Game_bAllowFastSpawning;

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
	
	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.default.currentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.default.currentVersion;
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
