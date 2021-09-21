class Config_ZedBuff extends Config_Common
	config(ZedternalReborn_Events);

var config int MODEVERSION;

var config S_Difficulty_Bool ZedBuff_bEnable;
var config S_Difficulty_Bool ZedBuff_bBonusDoshGivenPerBuff;
var config S_Difficulty_Bool ZedBuff_bBonusTraderTimeGivenPerBuff;

var config S_Difficulty_Int ZedBuff_TraderTimeBonus;
var config S_Difficulty_Int ZedBuff_DoshBonus;

struct S_BuffWaves
{
	var array<int> Waves;
};
var config S_BuffWaves ZedBuff_BuffWaves;

struct S_BuffSetting
{
	var int MinWave, MaxWave;
	var string Path;
};
var config array<S_BuffSetting> ZedBuff_BuffPath;

static function UpdateConfig()
{
	local int i;

	if (default.MODEVERSION < 1)
	{
		default.ZedBuff_bEnable.Normal = True;
		default.ZedBuff_bEnable.Hard = True;
		default.ZedBuff_bEnable.Suicidal = True;
		default.ZedBuff_bEnable.HoE = True;
		default.ZedBuff_bEnable.Custom = True;

		default.ZedBuff_bBonusDoshGivenPerBuff.Normal = False;
		default.ZedBuff_bBonusDoshGivenPerBuff.Hard = False;
		default.ZedBuff_bBonusDoshGivenPerBuff.Suicidal = False;
		default.ZedBuff_bBonusDoshGivenPerBuff.HoE = False;
		default.ZedBuff_bBonusDoshGivenPerBuff.Custom = False;

		default.ZedBuff_bBonusTraderTimeGivenPerBuff.Normal = False;
		default.ZedBuff_bBonusTraderTimeGivenPerBuff.Hard = False;
		default.ZedBuff_bBonusTraderTimeGivenPerBuff.Suicidal = False;
		default.ZedBuff_bBonusTraderTimeGivenPerBuff.HoE = False;
		default.ZedBuff_bBonusTraderTimeGivenPerBuff.Custom = False;

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
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

static function CheckBasicConfigValues()
{
	local int i, temp;

	for (i = 0; i < NumberOfDiffs; ++i)
	{
		if (GetStructValueInt(default.ZedBuff_TraderTimeBonus, i) < 0)
		{
			LogBadStructConfigMessage(i, "ZedBuff_TraderTimeBonus",
				string(GetStructValueInt(default.ZedBuff_TraderTimeBonus, i)),
				"0", "0 seconds, no bonus trader time", "value >= 0");
			SetStructValueInt(default.ZedBuff_TraderTimeBonus, i, 0);
		}

		if (GetStructValueInt(default.ZedBuff_DoshBonus, i) < 0)
		{
			LogBadStructConfigMessage(i, "ZedBuff_DoshBonus",
				string(GetStructValueInt(default.ZedBuff_DoshBonus, i)),
				"0", "0 dosh, no bonus dosh", "value >= 0");
			SetStructValueInt(default.ZedBuff_DoshBonus, i, 0);
		}
	}

	for (i = 0; i < default.ZedBuff_BuffWaves.Waves.Length; ++i)
	{
		if (default.ZedBuff_BuffWaves.Waves[i] < 0)
		{
			LogBadConfigMessage("ZedBuff_BuffWaves - Position" @ string(i + 1),
				string(default.ZedBuff_BuffWaves.Waves[i]),
				"0", "first wave", "value >= 0");
			default.ZedBuff_BuffWaves.Waves[i] = 0;
		}
	}

	for (i = 0; i < default.ZedBuff_BuffPath.Length; ++i)
	{
		if (default.ZedBuff_BuffPath[i].MinWave < 0)
		{
			LogBadConfigMessage("ZedBuff_BuffPath - Line" @ string(i + 1) @ "- MinWave",
				string(default.ZedBuff_BuffPath[i].MinWave),
				"0", "first wave", "value >= 0");
			default.ZedBuff_BuffPath[i].MinWave = 0;
		}

		if (default.ZedBuff_BuffPath[i].MaxWave < 0)
		{
			LogBadConfigMessage("ZedBuff_BuffPath - Line" @ string(i + 1) @ "- MaxWave",
				string(default.ZedBuff_BuffPath[i].MaxWave),
				"0", "first wave", "value >= 0");
			default.ZedBuff_BuffPath[i].MaxWave = 0;
		}

		if (default.ZedBuff_BuffPath[i].MinWave > default.ZedBuff_BuffPath[i].MaxWave)
		{
			`log("ZR Config:" @ "ZedBuff_BuffPath - Line" @ string(i + 1)
				@ "- MinWave is greater than MaxWave which is invalid. Flipping the values temporarily.");
			temp = default.ZedBuff_BuffPath[i].MinWave;
			default.ZedBuff_BuffPath[i].MinWave = default.ZedBuff_BuffPath[i].MaxWave;
			default.ZedBuff_BuffPath[i].MaxWave = temp;
		}
	}
}

static function bool GetZedBuffEnable(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedBuff_bEnable.Normal;
		case 1 : return default.ZedBuff_bEnable.Hard;
		case 2 : return default.ZedBuff_bEnable.Suicidal;
		case 3 : return default.ZedBuff_bEnable.HoE;
		default: return default.ZedBuff_bEnable.Custom;
	}
}

static function bool GetBonusDoshGivenPerBuff(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedBuff_bBonusDoshGivenPerBuff.Normal;
		case 1 : return default.ZedBuff_bBonusDoshGivenPerBuff.Hard;
		case 2 : return default.ZedBuff_bBonusDoshGivenPerBuff.Suicidal;
		case 3 : return default.ZedBuff_bBonusDoshGivenPerBuff.HoE;
		default: return default.ZedBuff_bBonusDoshGivenPerBuff.Custom;
	}
}

static function bool GetBonusTraderTimeGivenPerBuff(int Difficulty)
{
	switch (Difficulty)
	{
		case 0 : return default.ZedBuff_bBonusTraderTimeGivenPerBuff.Normal;
		case 1 : return default.ZedBuff_bBonusTraderTimeGivenPerBuff.Hard;
		case 2 : return default.ZedBuff_bBonusTraderTimeGivenPerBuff.Suicidal;
		case 3 : return default.ZedBuff_bBonusTraderTimeGivenPerBuff.HoE;
		default: return default.ZedBuff_bBonusTraderTimeGivenPerBuff.Custom;
	}
}

static function bool IsWaveBuffZed(int Wave, out byte Count)
{
	local int i, Buffs;

	Buffs = 0;
	for (i = 0; i < default.ZedBuff_BuffWaves.Waves.Length; ++i)
	{
		if (default.ZedBuff_BuffWaves.Waves[i] == Wave)
			++Buffs;
	}

	Count = Min(Buffs, 255);

	return Buffs > 0;
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
