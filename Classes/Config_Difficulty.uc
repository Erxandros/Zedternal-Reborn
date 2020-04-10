class Config_Difficulty extends Config_Base
	config(ZedternalReborn);
	
var config int MODEVERSION;

var config S_Difficulty_Float ZedStat_HealthMod;
var config S_Difficulty_Float ZedStat_LargeZedHealthModPerPlayer;
var config S_Difficulty_Float ZedStat_HeadHealthMod;
var config S_Difficulty_Float ZedStat_DamageMod;
var config S_Difficulty_Float ZedStat_SoloDamageMod;
var config S_Difficulty_Float ZedStat_SpeedMod;
	

static function UpdateConfig()
{

	if (default.MODEVERSION < 2)
	{
		default.ZedStat_HealthMod.Normal = 0.900000;
		default.ZedStat_HealthMod.Hard = 1.000000;
		default.ZedStat_HealthMod.Suicidal = 1.000000;
		default.ZedStat_HealthMod.HoE = 1.000000;
		default.ZedStat_HealthMod.Custom = 1.000000;
		
		default.ZedStat_LargeZedHealthModPerPlayer.Normal = 0.080000;
		default.ZedStat_LargeZedHealthModPerPlayer.Hard = 0.080000;
		default.ZedStat_LargeZedHealthModPerPlayer.Suicidal = 0.080000;
		default.ZedStat_LargeZedHealthModPerPlayer.HoE = 0.080000;
		default.ZedStat_LargeZedHealthModPerPlayer.Custom = 0.080000;
		
		default.ZedStat_HeadHealthMod.Normal = 0.950000;
		default.ZedStat_HeadHealthMod.Hard = 1.000000;
		default.ZedStat_HeadHealthMod.Suicidal = 1.000000;
		default.ZedStat_HeadHealthMod.HoE = 1.000000;
		default.ZedStat_HeadHealthMod.Custom = 1.000000;
		
		default.ZedStat_DamageMod.Normal = 0.600000;
		default.ZedStat_DamageMod.Hard = 0.700000;
		default.ZedStat_DamageMod.Suicidal = 0.800000;
		default.ZedStat_DamageMod.HoE = 0.900000;
		default.ZedStat_DamageMod.Custom = 0.700000;
		
		default.ZedStat_SoloDamageMod.Normal = 0.550000;
		default.ZedStat_SoloDamageMod.Hard = 0.700000;
		default.ZedStat_SoloDamageMod.Suicidal = 0.800000;
		default.ZedStat_SoloDamageMod.HoE = 0.900000;
		default.ZedStat_SoloDamageMod.Custom = 0.700000;
		
		default.ZedStat_SpeedMod.Normal = 0.925000;
		default.ZedStat_SpeedMod.Hard = 0.950000;
		default.ZedStat_SpeedMod.Suicidal = 0.975000;
		default.ZedStat_SpeedMod.HoE = 1.000000;
		default.ZedStat_SpeedMod.Custom = 0.950000;
	}
	if (default.MODEVERSION < 13)
	{
		if (default.ZedStat_DamageMod.Normal == 0.600000)
			default.ZedStat_DamageMod.Normal = 0.650000;
		if (default.ZedStat_SoloDamageMod.Normal == 0.550000)
			default.ZedStat_SoloDamageMod.Normal = 0.600000;
	}
	
	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.default.currentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.default.currentVersion;
		static.StaticSaveConfig();
	}

}


static function float GetZedHealthMod(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.ZedStat_HealthMod.Normal;	break;
		case 1 :	return default.ZedStat_HealthMod.Hard;		break;
		case 2 :	return default.ZedStat_HealthMod.Suicidal;	break;
		case 3 :	return default.ZedStat_HealthMod.HoE;		break;
	}
	return default.ZedStat_HealthMod.Custom;
}

static function float GetLargeZedHealthModPerPlayer(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.ZedStat_LargeZedHealthModPerPlayer.Normal;	break;
		case 1 :	return default.ZedStat_LargeZedHealthModPerPlayer.Hard;		break;
		case 2 :	return default.ZedStat_LargeZedHealthModPerPlayer.Suicidal;	break;
		case 3 :	return default.ZedStat_LargeZedHealthModPerPlayer.HoE;		break;
	}
	return default.ZedStat_LargeZedHealthModPerPlayer.Custom;
}

static function float GetZedHeadHealthMod(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.ZedStat_HeadHealthMod.Normal;	break;
		case 1 :	return default.ZedStat_HeadHealthMod.Hard;		break;
		case 2 :	return default.ZedStat_HeadHealthMod.Suicidal;	break;
		case 3 :	return default.ZedStat_HeadHealthMod.HoE;		break;
	}
	return default.ZedStat_HeadHealthMod.Custom;
}

static function float GetZedDamageMod(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.ZedStat_DamageMod.Normal;	break;
		case 1 :	return default.ZedStat_DamageMod.Hard;		break;
		case 2 :	return default.ZedStat_DamageMod.Suicidal;	break;
		case 3 :	return default.ZedStat_DamageMod.HoE;		break;
	}
	return default.ZedStat_DamageMod.Custom;
}

static function float GetZedSoloDamageMod(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.ZedStat_SoloDamageMod.Normal;	break;
		case 1 :	return default.ZedStat_SoloDamageMod.Hard;		break;
		case 2 :	return default.ZedStat_SoloDamageMod.Suicidal;	break;
		case 3 :	return default.ZedStat_SoloDamageMod.HoE;		break;
	}
	return default.ZedStat_SoloDamageMod.Custom;
}

static function float GetZedSpeedMod(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.ZedStat_SpeedMod.Normal;	break;
		case 1 :	return default.ZedStat_SpeedMod.Hard;		break;
		case 2 :	return default.ZedStat_SpeedMod.Suicidal;	break;
		case 3 :	return default.ZedStat_SpeedMod.HoE;		break;
	}
	return default.ZedStat_SpeedMod.Custom;
}


defaultproperties
{
}