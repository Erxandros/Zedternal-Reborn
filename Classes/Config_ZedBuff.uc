class Config_ZedBuff extends Config_Base
	config(ZedternalReborn);

var config int MODEVERSION;

struct S_BuffWaves
{
	var array< int > Waves;
};

var config bool ZedBuff_bEnable;

var config S_BuffWaves ZedBuff_BuffWaves;

struct S_BuffSetting
{
	var int minWave;
	var int maxWave;
	var string Path;
};

var config array< S_BuffSetting > ZedBuff_BuffPath;
var config S_Difficulty_Int ZedBuff_TraderTimeBonus;
var config S_Difficulty_Int ZedBuff_DoshBonus;

var config S_Difficulty_Float ZedBuff_MaxHealthIncPerWave;
var config S_Difficulty_Float ZedBuff_MaxHealthPowerPerWave;
var config S_Difficulty_Float ZedBuff_MaxHealthIncPerWave_LargeZed;
var config S_Difficulty_Float ZedBuff_MaxHealthPowerPerWave_LargeZed;
var config S_Difficulty_Float ZedBuff_DamageIncPerWave;
var config S_Difficulty_Float ZedBuff_DamagePowerPerWave;
var config S_Difficulty_Float ZedBuff_SpeedIncPerWave;
var config S_Difficulty_Float ZedBuff_SpeedPowerPerWave;
var config S_Difficulty_Float ZedBuff_SprintChanceIncPerWave;
var config float ZedBuff_DoshPenalityPerWave;
var config float ZedBuff_DoshPenalityLimit;
var config float ZedBuff_HardAttackChanceIncPerWave;

static function UpdateConfig()
{
	local int i;
	local S_BuffSetting TempObj;
	
	if (default.MODEVERSION < 2)
	{
		default.ZedBuff_bEnable = true;
		
		default.ZedBuff_BuffWaves.Waves.length = 8;
		default.ZedBuff_BuffWaves.Waves[0] = 6;
		default.ZedBuff_BuffWaves.Waves[1] = 11;
		default.ZedBuff_BuffWaves.Waves[2] = 16;
		default.ZedBuff_BuffWaves.Waves[3] = 21;
		default.ZedBuff_BuffWaves.Waves[4] = 26;
		default.ZedBuff_BuffWaves.Waves[5] = 31;
		default.ZedBuff_BuffWaves.Waves[6] = 36;
		default.ZedBuff_BuffWaves.Waves[7] = 41;
		
		default.ZedBuff_TraderTimeBonus.Normal = 25;
		default.ZedBuff_TraderTimeBonus.Hard = 25;
		default.ZedBuff_TraderTimeBonus.Suicidal = 25;
		default.ZedBuff_TraderTimeBonus.HoE = 25;
		default.ZedBuff_TraderTimeBonus.Custom = 25;
		
		default.ZedBuff_DoshBonus.Normal = 500;
		default.ZedBuff_DoshBonus.Hard = 500;
		default.ZedBuff_DoshBonus.Suicidal = 500;
		default.ZedBuff_DoshBonus.HoE = 500;
		default.ZedBuff_DoshBonus.Custom = 500;
		
		default.ZedBuff_BuffPath.length = 14;
		default.ZedBuff_BuffPath[0].Path = "ZedternalReborn.WMZedBuff_PukeMine";
		default.ZedBuff_BuffPath[1].Path = "ZedternalReborn.WMZedBuff_SpawnRate";
		default.ZedBuff_BuffPath[2].Path = "ZedternalReborn.WMZedBuff_Slasher_Enraged";
		default.ZedBuff_BuffPath[3].Path = "ZedternalReborn.WMZedBuff_Crawler_Health";
		default.ZedBuff_BuffPath[4].Path = "ZedternalReborn.WMZedBuff_Crawler_Faster";
		default.ZedBuff_BuffPath[5].Path = "ZedternalReborn.WMZedBuff_Gorefast_Damage";
		default.ZedBuff_BuffPath[6].Path = "ZedternalReborn.WMZedBuff_Gorefast_Enraged";
		default.ZedBuff_BuffPath[7].Path = "ZedternalReborn.WMZedBuff_Siren_Heal";
		default.ZedBuff_BuffPath[8].Path = "ZedternalReborn.WMZedBuff_Scrake_Enraged";
		default.ZedBuff_BuffPath[9].Path = "ZedternalReborn.WMZedBuff_Fleshpound_Stronger";
		default.ZedBuff_BuffPath[10].Path = "ZedternalReborn.WMZedBuff_Health";
		default.ZedBuff_BuffPath[11].Path = "ZedternalReborn.WMZedBuff_Damage";
		default.ZedBuff_BuffPath[12].Path = "ZedternalReborn.WMZedBuff_Speed";
		default.ZedBuff_BuffPath[13].Path = "ZedternalReborn.WMZedBuff_Hostility";
		
		// Constant Buffs (per wave)
		// Buffs are more intense at normal difficulty than at HoE.
		// Otherwise, normal/hard games will be too long and suicidal/HoE games will be near impossible to survive (not fun)
		
		default.ZedBuff_MaxHealthIncPerWave.Normal = 0.000000;
		default.ZedBuff_MaxHealthIncPerWave.Hard = 0.000000;
		default.ZedBuff_MaxHealthIncPerWave.Suicidal = 0.000000;
		default.ZedBuff_MaxHealthIncPerWave.HoE = 0.000000;
		default.ZedBuff_MaxHealthIncPerWave.Custom = 0.000000;
		
		default.ZedBuff_DamageIncPerWave.Normal = 0.015000;
		default.ZedBuff_DamageIncPerWave.Hard = 0.015000;
		default.ZedBuff_DamageIncPerWave.Suicidal = 0.015000;
		default.ZedBuff_DamageIncPerWave.HoE = 0.015000;
		default.ZedBuff_DamageIncPerWave.Custom = 0.015000;
		
		default.ZedBuff_SpeedIncPerWave.Normal = 0.015000;
		default.ZedBuff_SpeedIncPerWave.Hard = 0.015000;
		default.ZedBuff_SpeedIncPerWave.Suicidal = 0.015000;
		default.ZedBuff_SpeedIncPerWave.HoE = 0.015000;
		default.ZedBuff_SpeedIncPerWave.Custom = 0.015000;
		
		default.ZedBuff_SprintChanceIncPerWave.Normal = 0.025000;
		default.ZedBuff_SprintChanceIncPerWave.Hard = 0.020000;
		default.ZedBuff_SprintChanceIncPerWave.Suicidal = 0.015000;
		default.ZedBuff_SprintChanceIncPerWave.HoE = 0.012500;
		default.ZedBuff_SprintChanceIncPerWave.Custom = 0.020000;
		
		default.ZedBuff_DoshPenalityPerWave = 0.020000;
		default.ZedBuff_DoshPenalityLimit = 0.600000;
		
		default.ZedBuff_HardAttackChanceIncPerWave = 0.030000;
	}
	
	if (default.MODEVERSION < 4)
	{
		// ZED buff appear sooner (each 4 waves instead of 5)
		for (i=0; i<default.ZedBuff_BuffWaves.Waves.length; i+=1)
		{
			if (default.ZedBuff_BuffWaves.Waves[i] == i*5 + 6)
				default.ZedBuff_BuffWaves.Waves[i] = i*4 + 5;
		}
	}
	
	if (default.MODEVERSION < 6)
	{
		// New Buff system
		// clear current array
		default.ZedBuff_BuffPath.length = 0;
		
		// rebuild buff list
		default.ZedBuff_BuffPath.length = 17;
		
		// tier 1
		default.ZedBuff_BuffPath[0].Path = "ZedternalReborn.WMZedBuff_Slasher_Enraged";
		default.ZedBuff_BuffPath[1].Path = "ZedternalReborn.WMZedBuff_Crawler_Health";
		default.ZedBuff_BuffPath[2].Path = "ZedternalReborn.WMZedBuff_Crawler_Faster";
		for (i=0; i<=2; i+=1)
		{
			default.ZedBuff_BuffPath[i].minWave = 0;
			default.ZedBuff_BuffPath[i].maxWave = 9;
		}
		
		// tier 2
		default.ZedBuff_BuffPath[3].Path = "ZedternalReborn.WMZedBuff_Gorefast_Damage";
		default.ZedBuff_BuffPath[4].Path = "ZedternalReborn.WMZedBuff_Gorefast_Enraged";
		default.ZedBuff_BuffPath[5].Path = "ZedternalReborn.WMZedBuff_SpawnRate";
		for (i=3; i<=5; i+=1)
		{
			default.ZedBuff_BuffPath[i].minWave = 9;
			default.ZedBuff_BuffPath[i].maxWave = 13;
		}
		
		// tier 3
		default.ZedBuff_BuffPath[6].Path = "ZedternalReborn.WMZedBuff_Health";
		default.ZedBuff_BuffPath[7].Path = "ZedternalReborn.WMZedBuff_Damage";
		default.ZedBuff_BuffPath[8].Path = "ZedternalReborn.WMZedBuff_Speed";
		for (i=6; i<=8; i+=1)
		{
			default.ZedBuff_BuffPath[i].minWave = 13;
			default.ZedBuff_BuffPath[i].maxWave = 17;
		}
		
		// tier 4		
		default.ZedBuff_BuffPath[9].Path = "ZedternalReborn.WMZedBuff_PukeMine";
		default.ZedBuff_BuffPath[10].Path = "ZedternalReborn.WMZedBuff_Siren_Heal";
		default.ZedBuff_BuffPath[11].Path = "ZedternalReborn.WMZedBuff_Hostility";
		for (i=9; i<=11; i+=1)
		{
			default.ZedBuff_BuffPath[i].minWave = 17;
			default.ZedBuff_BuffPath[i].maxWave = 21;
		}
		
		// tier 5
		default.ZedBuff_BuffPath[12].Path = "ZedternalReborn.WMZedBuff_Scrake_Enraged";
		default.ZedBuff_BuffPath[13].Path = "ZedternalReborn.WMZedBuff_Fleshpound_Stronger";
		for (i=12; i<=13; i+=1)
		{
			default.ZedBuff_BuffPath[i].minWave = 21;
			default.ZedBuff_BuffPath[i].maxWave = 999;
		}
		
		// tier 6
		default.ZedBuff_BuffPath[14].Path = "ZedternalReborn.WMZedBuff_Health_II";
		default.ZedBuff_BuffPath[15].Path = "ZedternalReborn.WMZedBuff_Damage_II";
		default.ZedBuff_BuffPath[16].Path = "ZedternalReborn.WMZedBuff_Speed_II";
		for (i=14; i<=16; i+=1)
		{
			default.ZedBuff_BuffPath[i].minWave = 25;
			default.ZedBuff_BuffPath[i].maxWave = 999;
		}

	}
	
	if (default.MODEVERSION < 7)
	{
		// new tier 1
		TempObj.Path = "ZedternalReborn.WMZedBuff_Clot_Stronger";
		TempObj.minWave = 0;
		TempObj.maxWave = 9;
		default.ZedBuff_BuffPath.AddItem(TempObj);
		
		// new tier 2
		TempObj.Path = "ZedternalReborn.WMZedBuff_Siren_ScreamRate";
		TempObj.minWave = 9;
		TempObj.maxWave = 13;
		default.ZedBuff_BuffPath.AddItem(TempObj);		
		
		// new tier 4
		TempObj.Path = "ZedternalReborn.WMZedBuff_Husk_SuicideRate";
		TempObj.minWave = 17;
		TempObj.maxWave = 21;
		default.ZedBuff_BuffPath.AddItem(TempObj);
		
		// new tier 5
		TempObj.Path = "ZedternalReborn.WMZedBuff_Beefcake";
		TempObj.minWave = 21;
		TempObj.maxWave = 999;
		default.ZedBuff_BuffPath.AddItem(TempObj);
	}
	
	if (default.MODEVERSION < 8)
	{
		// reduce dosh gained at late waves
		if (default.ZedBuff_DoshPenalityPerWave == 0.020000)
			default.ZedBuff_DoshPenalityPerWave = 0.022000;
		
		// rework on zed buff
		
		// clear current array
		default.ZedBuff_BuffPath.length = 0;
		
		// rebuild buff list
		default.ZedBuff_BuffPath.length = 21;
		
		// tier 1
		default.ZedBuff_BuffPath[0].Path = "ZedternalReborn.WMZedBuff_Slasher_Enraged";
		default.ZedBuff_BuffPath[1].Path = "ZedternalReborn.WMZedBuff_Crawler_Health";
		default.ZedBuff_BuffPath[2].Path = "ZedternalReborn.WMZedBuff_Crawler_Faster";
		default.ZedBuff_BuffPath[3].Path = "ZedternalReborn.WMZedBuff_Gorefast_Damage";
		default.ZedBuff_BuffPath[4].Path = "ZedternalReborn.WMZedBuff_Gorefast_Enraged";
		default.ZedBuff_BuffPath[5].Path = "ZedternalReborn.WMZedBuff_SpawnRate";
		default.ZedBuff_BuffPath[6].Path = "ZedternalReborn.WMZedBuff_Clot_Stronger";
		for (i=0; i<=6; i+=1)
		{
			default.ZedBuff_BuffPath[i].minWave = 0;
			default.ZedBuff_BuffPath[i].maxWave = 13;
		}
		
		// tier 2
		default.ZedBuff_BuffPath[7].Path = "ZedternalReborn.WMZedBuff_Siren_ScreamRate";
		default.ZedBuff_BuffPath[8].Path = "ZedternalReborn.WMZedBuff_Health";
		default.ZedBuff_BuffPath[9].Path = "ZedternalReborn.WMZedBuff_Damage";
		default.ZedBuff_BuffPath[10].Path = "ZedternalReborn.WMZedBuff_Speed";
		default.ZedBuff_BuffPath[11].Path = "ZedternalReborn.WMZedBuff_PukeMine";
		default.ZedBuff_BuffPath[12].Path = "ZedternalReborn.WMZedBuff_Siren_Heal";
		default.ZedBuff_BuffPath[13].Path = "ZedternalReborn.WMZedBuff_Hostility";
		for (i=7; i<=13; i+=1)
		{
			default.ZedBuff_BuffPath[i].minWave = 9;
			default.ZedBuff_BuffPath[i].maxWave = 21;
		}
		
		// tier 3
		default.ZedBuff_BuffPath[14].Path = "ZedternalReborn.WMZedBuff_Husk_SuicideRate";
		default.ZedBuff_BuffPath[15].Path = "ZedternalReborn.WMZedBuff_Scrake_Enraged";
		default.ZedBuff_BuffPath[16].Path = "ZedternalReborn.WMZedBuff_Fleshpound_Stronger";
		default.ZedBuff_BuffPath[17].Path = "ZedternalReborn.WMZedBuff_Health_II";
		default.ZedBuff_BuffPath[18].Path = "ZedternalReborn.WMZedBuff_Damage_II";
		default.ZedBuff_BuffPath[19].Path = "ZedternalReborn.WMZedBuff_Speed_II";
		default.ZedBuff_BuffPath[20].Path = "ZedternalReborn.WMZedBuff_Beefcake";
		for (i=14; i<=20; i+=1)
		{
			default.ZedBuff_BuffPath[i].minWave = 17;
			default.ZedBuff_BuffPath[i].maxWave = 999;
		}
	}
	if (default.MODEVERSION < 11)
	{
		default.ZedBuff_MaxHealthPowerPerWave.Normal = 0.000000;
		default.ZedBuff_MaxHealthPowerPerWave.Hard = 0.000000;
		default.ZedBuff_MaxHealthPowerPerWave.Suicidal = 0.000000;
		default.ZedBuff_MaxHealthPowerPerWave.HoE = 0.000000;
		default.ZedBuff_MaxHealthPowerPerWave.Custom = 0.000000;
		
		default.ZedBuff_DamagePowerPerWave.Normal = 0.005000;
		default.ZedBuff_DamagePowerPerWave.Hard = 0.005000;
		default.ZedBuff_DamagePowerPerWave.Suicidal = 0.005000;
		default.ZedBuff_DamagePowerPerWave.HoE = 0.005000;
		default.ZedBuff_DamagePowerPerWave.Custom = 0.005000;
		
		default.ZedBuff_SpeedPowerPerWave.Normal = 0.003500;
		default.ZedBuff_SpeedPowerPerWave.Hard = 0.003500;
		default.ZedBuff_SpeedPowerPerWave.Suicidal = 0.003500;
		default.ZedBuff_SpeedPowerPerWave.HoE = 0.003500;
		default.ZedBuff_SpeedPowerPerWave.Custom = 0.003500;
	}
	if (default.MODEVERSION < 13)
	{
		default.ZedBuff_MaxHealthIncPerWave.Normal = 0.007000;
		default.ZedBuff_MaxHealthIncPerWave.Hard = 0.007000;
		default.ZedBuff_MaxHealthIncPerWave.Suicidal = 0.007000;
		default.ZedBuff_MaxHealthIncPerWave.HoE = 0.007000;
		default.ZedBuff_MaxHealthIncPerWave.Custom = 0.007000;

		default.ZedBuff_MaxHealthPowerPerWave.Normal = 0.050000;
		default.ZedBuff_MaxHealthPowerPerWave.Hard = 0.050000;
		default.ZedBuff_MaxHealthPowerPerWave.Suicidal = 0.050000;
		default.ZedBuff_MaxHealthPowerPerWave.HoE = 0.050000;
		default.ZedBuff_MaxHealthPowerPerWave.Custom = 0.050000;
		
		default.ZedBuff_MaxHealthIncPerWave_LargeZed.Normal = 0.004500;
		default.ZedBuff_MaxHealthIncPerWave_LargeZed.Hard = 0.004500;
		default.ZedBuff_MaxHealthIncPerWave_LargeZed.Suicidal = 0.004500;
		default.ZedBuff_MaxHealthIncPerWave_LargeZed.HoE = 0.004500;
		default.ZedBuff_MaxHealthIncPerWave_LargeZed.Custom = 0.004500;

		default.ZedBuff_MaxHealthPowerPerWave_LargeZed.Normal = 0.050000;
		default.ZedBuff_MaxHealthPowerPerWave_LargeZed.Hard = 0.050000;
		default.ZedBuff_MaxHealthPowerPerWave_LargeZed.Suicidal = 0.050000;
		default.ZedBuff_MaxHealthPowerPerWave_LargeZed.HoE = 0.050000;
		default.ZedBuff_MaxHealthPowerPerWave_LargeZed.Custom = 0.050000;
		
		// new tier 1
		TempObj.Path = "ZedternalReborn.WMZedBuff_Stalker_Faster";
		TempObj.minWave = 0;
		TempObj.maxWave = 13;
		default.ZedBuff_BuffPath.AddItem(TempObj);
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.default.currentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.default.currentVersion;
		static.StaticSaveConfig();
	}

}

static function bool IsWaveBuffZed(int Wave)
{
	local int i;
	
	if (!default.ZedBuff_bEnable)
		return false;
	
	for (i=0; i < default.ZedBuff_BuffWaves.Waves.length; i+=1)
	{
		if (default.ZedBuff_BuffWaves.Waves[i] == Wave)
			return true;
	}
	
	return false;
}

static function int GetTraderTimeBonus(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.ZedBuff_TraderTimeBonus.Normal;		break;
		case 1 :	return default.ZedBuff_TraderTimeBonus.Hard;		break;
		case 2 :	return default.ZedBuff_TraderTimeBonus.Suicidal;	break;
		case 3 :	return default.ZedBuff_TraderTimeBonus.HoE;			break;
	}
	return default.ZedBuff_TraderTimeBonus.Custom;
}

static function int GetDoshBonus(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 :	return default.ZedBuff_DoshBonus.Normal;		break;
		case 1 :	return default.ZedBuff_DoshBonus.Hard;			break;
		case 2 :	return default.ZedBuff_DoshBonus.Suicidal;		break;
		case 3 :	return default.ZedBuff_DoshBonus.HoE;			break;
	}
	return default.ZedBuff_DoshBonus.Custom;
}

////////////////////
// Constant buffs //
////////////////////

static function float GetMaxHealthBuff(float mod, int Difficulty, int WaveNum)
{
	local float factor, power, wave;
	
	switch (Difficulty)
	{
		case 0 :	factor = default.ZedBuff_MaxHealthIncPerWave.Normal;	power = default.ZedBuff_MaxHealthPowerPerWave.Normal;		break;
		case 1 :	factor = default.ZedBuff_MaxHealthIncPerWave.Hard;		power = default.ZedBuff_MaxHealthPowerPerWave.Hard;			break;
		case 2 :	factor = default.ZedBuff_MaxHealthIncPerWave.Suicidal;	power = default.ZedBuff_MaxHealthPowerPerWave.Suicidal;		break;
		case 3 :	factor = default.ZedBuff_MaxHealthIncPerWave.HoE;		power = default.ZedBuff_MaxHealthPowerPerWave.HoE;			break;
		default:	factor = default.ZedBuff_MaxHealthIncPerWave.Custom;	power = default.ZedBuff_MaxHealthPowerPerWave.Custom;		break;
	}

	wave = float(WaveNum-1);
	return (mod + factor*wave)**(1.f + power*wave);
}
static function float GetMaxHealthBuff_LargeZed(float mod, int Difficulty, int WaveNum)
{
	local float factor, power, wave;
	
	switch (Difficulty)
	{
		case 0 :	factor = default.ZedBuff_MaxHealthIncPerWave_LargeZed.Normal;	power = default.ZedBuff_MaxHealthPowerPerWave_LargeZed.Normal;		break;
		case 1 :	factor = default.ZedBuff_MaxHealthIncPerWave_LargeZed.Hard;		power = default.ZedBuff_MaxHealthPowerPerWave_LargeZed.Hard;		break;
		case 2 :	factor = default.ZedBuff_MaxHealthIncPerWave_LargeZed.Suicidal;	power = default.ZedBuff_MaxHealthPowerPerWave_LargeZed.Suicidal;	break;
		case 3 :	factor = default.ZedBuff_MaxHealthIncPerWave_LargeZed.HoE;		power = default.ZedBuff_MaxHealthPowerPerWave_LargeZed.HoE;			break;
		default:	factor = default.ZedBuff_MaxHealthIncPerWave_LargeZed.Custom;	power = default.ZedBuff_MaxHealthPowerPerWave_LargeZed.Custom;		break;
	}

	wave = float(WaveNum-1);
	return (mod + factor*wave)**(1.f + power*wave);
}

static function float GetDamageBuff(float mod, int Difficulty, int WaveNum)
{
	local float factor, power, wave;
	
	switch (Difficulty)
	{
		case 0 :	factor = default.ZedBuff_DamageIncPerWave.Normal;	power = default.ZedBuff_DamagePowerPerWave.Normal;		break;
		case 1 :	factor = default.ZedBuff_DamageIncPerWave.Hard;		power = default.ZedBuff_DamagePowerPerWave.Hard;		break;
		case 2 :	factor = default.ZedBuff_DamageIncPerWave.Suicidal;	power = default.ZedBuff_DamagePowerPerWave.Suicidal;	break;
		case 3 :	factor = default.ZedBuff_DamageIncPerWave.HoE;		power = default.ZedBuff_DamagePowerPerWave.HoE;			break;
		default:	factor = default.ZedBuff_DamageIncPerWave.Custom;	power = default.ZedBuff_DamagePowerPerWave.Custom;		break;
	}

	wave = float(WaveNum-1);
	return (mod + factor*wave)**(1.f + power*wave);
}

static function float GetSpeedBuff(float mod, int Difficulty, int WaveNum)
{
	local float factor, power, wave;
	
	switch (Difficulty)
	{
		case 0 :	factor = default.ZedBuff_SpeedIncPerWave.Normal;	power = default.ZedBuff_SpeedPowerPerWave.Normal;		break;
		case 1 :	factor = default.ZedBuff_SpeedIncPerWave.Hard;		power = default.ZedBuff_SpeedPowerPerWave.Hard;			break;
		case 2 :	factor = default.ZedBuff_SpeedIncPerWave.Suicidal;	power = default.ZedBuff_SpeedPowerPerWave.Suicidal;		break;
		case 3 :	factor = default.ZedBuff_SpeedIncPerWave.HoE;		power = default.ZedBuff_SpeedPowerPerWave.HoE;			break;
		default:	factor = default.ZedBuff_SpeedIncPerWave.Custom;	power = default.ZedBuff_SpeedPowerPerWave.Custom;		break;
	}
	
	wave = float(WaveNum-1);
	return (mod + factor*wave)**(1.f + power*wave);
}

static function float GetSprintChanceBuff(int Difficulty, int WaveNum)
{
	local float factor;
	
	switch (Difficulty)
	{
		case 0 :	factor = default.ZedBuff_SprintChanceIncPerWave.Normal;		break;
		case 1 :	factor = default.ZedBuff_SprintChanceIncPerWave.Hard;		break;
		case 2 :	factor = default.ZedBuff_SprintChanceIncPerWave.Suicidal;	break;
		case 3 :	factor = default.ZedBuff_SprintChanceIncPerWave.HoE;		break;
		default:	factor = default.ZedBuff_SprintChanceIncPerWave.Custom;		break;
	}

	return factor * float(WaveNum-1);
}

static function float GetDoshPenalityBuff(int WaveNum)
{
	return FMin(default.ZedBuff_DoshPenalityLimit, default.ZedBuff_DoshPenalityPerWave * float(WaveNum-1));
}

static function float GetHardAttackChanceBuff(int WaveNum)
{
	return default.ZedBuff_HardAttackChanceIncPerWave * float(WaveNum-1);
}

defaultproperties
{
}