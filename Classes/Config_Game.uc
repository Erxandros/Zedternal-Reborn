class Config_Game extends Config_Base
	config(Zedternal);
	
var config int MODEVERSION;

var config int Game_DoshPerWavePerPlayer; 			//each player win that amount of dosh every wave
var config int Game_ExtraDoshPerWavePerPlayer; 		//extra amount of dosh won based on number of player
var config float Game_LateJoinerTotalDoshFactor;		//when new player join in mid-game, give him dosh won (by toher players) * this variable

var config S_Difficulty_Float Game_NormalZedDoshFactor;
var config S_Difficulty_Float Game_LargeZedDoshFactor;
var config float Game_ExtraNormalZedDoshFactorPerPlayer;	//extra amount of dosh won based on number of players
var config float Game_ExtraLargeZedDoshFactorPerPlayer;		//extra amount of dosh won based on number of players

var config S_Difficulty_Int Game_ArmorPrice;
var config S_Difficulty_Float Game_AmmoPriceFactor;

var config S_Difficulty_Int Game_TimeBetweenWave;
var config S_Difficulty_Int Game_TimeBetweenWaveIfPlayerDead;

var config bool Game_bUsePatriarchTraderVoice;
var config bool Game_bUseHansTraderVoice;
var config bool Game_bUseLockheartTraderVoice;
var config bool Game_bUseSantaTraderVoice;
var config bool Game_bUseDefaultTraderVoice;

// version 8
var config bool Game_bAllowZedTeleport;
var config bool Game_bAllowFastSpawning;
	
static function UpdateConfig()
{

	if (default.MODEVERSION < 2)
	{
		default.Game_DoshPerWavePerPlayer = 550;
		default.Game_ExtraDoshPerWavePerPlayer = 20;
		default.Game_LateJoinerTotalDoshFactor = 0.700000;
		
		default.Game_NormalZedDoshFactor.Normal = 1.250000;
		default.Game_NormalZedDoshFactor.Hard = 1.225000;
		default.Game_NormalZedDoshFactor.Suicidal = 1.200000;
		default.Game_NormalZedDoshFactor.HoE = 1.200000;
		default.Game_NormalZedDoshFactor.Custom = 1.200000;
		default.Game_ExtraNormalZedDoshFactorPerPlayer = 0.050000;
		
		default.Game_LargeZedDoshFactor.Normal = 0.700000;
		default.Game_LargeZedDoshFactor.Hard = 0.700000;
		default.Game_LargeZedDoshFactor.Suicidal = 0.700000;
		default.Game_LargeZedDoshFactor.HoE = 0.700000;
		default.Game_LargeZedDoshFactor.Custom = 0.700000;
		default.Game_ExtraLargeZedDoshFactorPerPlayer = 0.080000;
		
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

		default.Game_bUsePatriarchTraderVoice = false;
	}
	
	if (default.MODEVERSION < 4)
	{
		if (default.Game_DoshPerWavePerPlayer == 550)
			default.Game_DoshPerWavePerPlayer = 620;
	}
	
	if (default.MODEVERSION < 8)
	{
		default.Game_bAllowZedTeleport = false;
		default.Game_bAllowFastSpawning = true;
	}
	
	if (default.MODEVERSION < 9)
	{
		default.Game_bUseHansTraderVoice = false;
		default.Game_bUseLockheartTraderVoice = false;
	}
	
	if (default.MODEVERSION < 13)
	{
		default.Game_bUseSantaTraderVoice = false;
		// turn default trader voice on only if user did not specify custom trader voice
		if (!default.Game_bUsePatriarchTraderVoice && !default.Game_bUseHansTraderVoice && !default.Game_bUseLockheartTraderVoice)
			default.Game_bUseDefaultTraderVoice = true;
		else
			default.Game_bUseDefaultTraderVoice = false;
		
		if (default.Game_DoshPerWavePerPlayer == 620)
			default.Game_DoshPerWavePerPlayer = 660;
	}
	
	if (default.MODEVERSION < class'Zedternal.Config_Base'.default.currentVersion)
	{
		default.MODEVERSION = class'Zedternal.Config_Base'.default.currentVersion;
		static.StaticSaveConfig();
	}
	
	static.StaticSaveConfig();

}

static function float GetNormalZedDoshFactor(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.Game_NormalZedDoshFactor.Normal;		break;
		case 1 :	return default.Game_NormalZedDoshFactor.Hard;		break;
		case 2 :	return default.Game_NormalZedDoshFactor.Suicidal;	break;
		case 3 :	return default.Game_NormalZedDoshFactor.HoE;		break;
	}
	return default.Game_NormalZedDoshFactor.Custom;
}
static function float GetLargeZedDoshFactor(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.Game_LargeZedDoshFactor.Normal;		break;
		case 1 :	return default.Game_LargeZedDoshFactor.Hard;		break;
		case 2 :	return default.Game_LargeZedDoshFactor.Suicidal;	break;
		case 3 :	return default.Game_LargeZedDoshFactor.HoE;			break;
	}
	return default.Game_LargeZedDoshFactor.Custom;
}
static function int GetArmorPrice(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.Game_ArmorPrice.Normal;		break;
		case 1 :	return default.Game_ArmorPrice.Hard;		break;
		case 2 :	return default.Game_ArmorPrice.Suicidal;	break;
		case 3 :	return default.Game_ArmorPrice.HoE;			break;
	}
	return default.Game_ArmorPrice.Custom;
}
static function float GetAmmoPriceFactor(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.Game_AmmoPriceFactor.Normal;		break;
		case 1 :	return default.Game_AmmoPriceFactor.Hard;		break;
		case 2 :	return default.Game_AmmoPriceFactor.Suicidal;	break;
		case 3 :	return default.Game_AmmoPriceFactor.HoE;		break;
	}
	return default.Game_AmmoPriceFactor.Custom;
}
static function int GetTimeBetweenWave(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.Game_TimeBetweenWave.Normal;		break;
		case 1 :	return default.Game_TimeBetweenWave.Hard;		break;
		case 2 :	return default.Game_TimeBetweenWave.Suicidal;	break;
		case 3 :	return default.Game_TimeBetweenWave.HoE;		break;
	}
	return default.Game_TimeBetweenWave.Custom;
}
static function int GetTimeBetweenWaveHumanDied(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.Game_TimeBetweenWaveIfPlayerDead.Normal;		break;
		case 1 :	return default.Game_TimeBetweenWaveIfPlayerDead.Hard;		break;
		case 2 :	return default.Game_TimeBetweenWaveIfPlayerDead.Suicidal;	break;
		case 3 :	return default.Game_TimeBetweenWaveIfPlayerDead.HoE;		break;
	}
	return default.Game_TimeBetweenWaveIfPlayerDead.Custom;
}

defaultproperties
{
}