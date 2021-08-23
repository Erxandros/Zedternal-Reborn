class Config_ZedBuff extends Config_Common
	config(ZedternalReborn);

var config int MODEVERSION;

struct S_BuffWaves
{
	var array<int> Waves;
};

var config bool ZedBuff_bEnable;
var config bool ZedBuff_bBonusDoshGivenPerBuff;
var config bool ZedBuff_bBonusTraderTimeGivenPerBuff;

var config S_BuffWaves ZedBuff_BuffWaves;

struct S_BuffSetting
{
	var int MinWave;
	var int MaxWave;
	var string Path;
};

var config array<S_BuffSetting> ZedBuff_BuffPath;
var config S_Difficulty_Int ZedBuff_TraderTimeBonus;
var config S_Difficulty_Int ZedBuff_DoshBonus;

static function UpdateConfig()
{
	local int i;

	if (default.MODEVERSION < 1)
	{
		default.ZedBuff_bEnable = True;
		default.ZedBuff_bBonusDoshGivenPerBuff = False;
		default.ZedBuff_bBonusTraderTimeGivenPerBuff = False;

		default.ZedBuff_BuffWaves.Waves.Length = 8;
		default.ZedBuff_BuffWaves.Waves[0] = 5;
		default.ZedBuff_BuffWaves.Waves[1] = 9;
		default.ZedBuff_BuffWaves.Waves[2] = 13;
		default.ZedBuff_BuffWaves.Waves[3] = 17;
		default.ZedBuff_BuffWaves.Waves[4] = 21;
		default.ZedBuff_BuffWaves.Waves[5] = 25;
		default.ZedBuff_BuffWaves.Waves[6] = 29;
		default.ZedBuff_BuffWaves.Waves[7] = 33;

		default.ZedBuff_BuffPath.Length = 22;
		default.ZedBuff_BuffPath[0].Path = "ZedternalReborn.WMZedBuff_Slasher_Enraged";
		default.ZedBuff_BuffPath[1].Path = "ZedternalReborn.WMZedBuff_Crawler_Health";
		default.ZedBuff_BuffPath[2].Path = "ZedternalReborn.WMZedBuff_Crawler_Faster";
		default.ZedBuff_BuffPath[3].Path = "ZedternalReborn.WMZedBuff_Gorefast_Damage";
		default.ZedBuff_BuffPath[4].Path = "ZedternalReborn.WMZedBuff_Gorefast_Enraged";
		default.ZedBuff_BuffPath[5].Path = "ZedternalReborn.WMZedBuff_SpawnRate";
		default.ZedBuff_BuffPath[6].Path = "ZedternalReborn.WMZedBuff_Clot_Stronger";
		default.ZedBuff_BuffPath[7].Path = "ZedternalReborn.WMZedBuff_Stalker_Faster";
		for (i = 0; i <= 7; ++i)
		{
			default.ZedBuff_BuffPath[i].MinWave = 0;
			default.ZedBuff_BuffPath[i].MaxWave = 13;
		}

		default.ZedBuff_BuffPath[8].Path = "ZedternalReborn.WMZedBuff_Siren_ScreamRate";
		default.ZedBuff_BuffPath[9].Path = "ZedternalReborn.WMZedBuff_Health";
		default.ZedBuff_BuffPath[10].Path = "ZedternalReborn.WMZedBuff_Damage";
		default.ZedBuff_BuffPath[11].Path = "ZedternalReborn.WMZedBuff_Speed";
		default.ZedBuff_BuffPath[12].Path = "ZedternalReborn.WMZedBuff_PukeMine";
		default.ZedBuff_BuffPath[13].Path = "ZedternalReborn.WMZedBuff_Siren_Heal";
		default.ZedBuff_BuffPath[14].Path = "ZedternalReborn.WMZedBuff_Hostility";
		for (i = 8; i <= 14; ++i)
		{
			default.ZedBuff_BuffPath[i].MinWave = 9;
			default.ZedBuff_BuffPath[i].MaxWave = 21;
		}

		default.ZedBuff_BuffPath[15].Path = "ZedternalReborn.WMZedBuff_Husk_SuicideRate";
		default.ZedBuff_BuffPath[16].Path = "ZedternalReborn.WMZedBuff_Scrake_Enraged";
		default.ZedBuff_BuffPath[17].Path = "ZedternalReborn.WMZedBuff_Fleshpound_Stronger";
		default.ZedBuff_BuffPath[18].Path = "ZedternalReborn.WMZedBuff_Health_II";
		default.ZedBuff_BuffPath[19].Path = "ZedternalReborn.WMZedBuff_Damage_II";
		default.ZedBuff_BuffPath[20].Path = "ZedternalReborn.WMZedBuff_Speed_II";
		default.ZedBuff_BuffPath[21].Path = "ZedternalReborn.WMZedBuff_Beefcake";
		for (i = 15; i <= 21; ++i)
		{
			default.ZedBuff_BuffPath[i].MinWave = 17;
			default.ZedBuff_BuffPath[i].MaxWave = 999;
		}

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
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

static function bool IsWaveBuffZed(int Wave, out byte count)
{
	local int i;

	if (!default.ZedBuff_bEnable)
		return False;

	count = 0;
	for (i = 0; i < default.ZedBuff_BuffWaves.Waves.length; ++i)
	{
		if (default.ZedBuff_BuffWaves.Waves[i] == Wave)
			++count;

		if (count >= 255)
			break;
	}

	return count > 0;
}

static function int GetTraderTimeBonus(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedBuff_TraderTimeBonus.Normal;
		case 1 : return default.ZedBuff_TraderTimeBonus.Hard;
		case 2 : return default.ZedBuff_TraderTimeBonus.Suicidal;
		case 3 : return default.ZedBuff_TraderTimeBonus.HoE;
		default: return default.ZedBuff_TraderTimeBonus.Custom;
	}
}

static function int GetDoshBonus(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedBuff_DoshBonus.Normal;
		case 1 : return default.ZedBuff_DoshBonus.Hard;
		case 2 : return default.ZedBuff_DoshBonus.Suicidal;
		case 3 : return default.ZedBuff_DoshBonus.HoE;
		default: return default.ZedBuff_DoshBonus.Custom;
	}
}

defaultproperties
{
	Name="Default__Config_ZedBuff"
}
