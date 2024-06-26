class Config_Map extends Config_Common
	config(ZedternalReborn_Game);

var config int MODEVERSION;

struct S_Map
{
	var string MapName;
	var array<int> Difficulty;
	var int StartingDosh;
	var int StartingWave;
	var int FinalWave;
	var int StartingTraderTime;
	var float ZedNumberScale;
	var float ZedSpawnRate;
	var int ZedStuckThreshold;
	var int ZedStuckTimeout;
	var bool AllTraders;
	var bool EnableAmmoPickups;
	var bool EnableWeaponPickups;
	var bool ArmorSpawnOnMap;
	var bool OverrideKismetPickups;
	var float AmmoPickupBase;
	var float AmmoPickupIncPerWave;
	var float AmmoPickupMax;
	var float ItemPickupBase;
	var float ItemPickupIncPerWave;
	var float ItemPickupMax;

	structdefaultproperties
	{
		Difficulty=(0,1,2,3,4)
		StartingDosh=400
		StartingWave=1
		FinalWave=255
		StartingTraderTime=0
		ZedNumberScale=1.0f
		ZedSpawnRate=1.0f
		ZedStuckThreshold=4
		ZedStuckTimeout=150
		AllTraders=False
		EnableAmmoPickups=True
		EnableWeaponPickups=True
		ArmorSpawnOnMap=True
		OverrideKismetPickups=True
		AmmoPickupBase=0.4f
		AmmoPickupIncPerWave=0.04f
		AmmoPickupMax=0.95f
		ItemPickupBase=0.45f
		ItemPickupIncPerWave=0.03f
		ItemPickupMax=0.9f
	}
};

var config array<S_Map> Map_Settings;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Map_Settings.Length = 1;

		default.Map_Settings[0].MapName = "KF-BioticsLab";
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

static function CheckBasicConfigValues()
{
	local int i;

	for (i = 0; i < default.Map_Settings.Length; ++i)
	{
		if (default.Map_Settings[i].StartingDosh < INDEX_NONE)
		{
			LogBadConfigMessage("Map_Settings -" @ default.Map_Settings[i].MapName @ "- Line" @ string(i + 1) @ "- StartingDosh",
				string(default.Map_Settings[i].StartingDosh),
				"-1", "skip starting dosh, using Dosh_StartingDosh variable instead", "value >= -1");
			default.Map_Settings[i].StartingDosh = INDEX_NONE;
		}

		if (default.Map_Settings[i].StartingWave < 1)
		{
			LogBadConfigMessage("Map_Settings -" @ default.Map_Settings[i].MapName @ "- Line" @ string(i + 1) @ "- StartingWave",
				string(default.Map_Settings[i].StartingWave),
				"1", "wave 1, first wave", "255 >= value >= 1");
			default.Map_Settings[i].StartingWave = 1;
		}

		if (default.Map_Settings[i].StartingWave > 255)
		{
			LogBadConfigMessage("Map_Settings -" @ default.Map_Settings[i].MapName @ "- Line" @ string(i + 1) @ "- StartingWave",
				string(default.Map_Settings[i].StartingWave),
				"255", "wave 255, last valid wave", "255 >= value >= 1");
			default.Map_Settings[i].StartingWave = 255;
		}

		if (default.Map_Settings[i].FinalWave < 1)
		{
			LogBadConfigMessage("Map_Settings -" @ default.Map_Settings[i].MapName @ "- Line" @ string(i + 1) @ "- FinalWave",
				string(default.Map_Settings[i].FinalWave),
				"1", "end of wave 1, first wave", "255 >= value >= 1");
			default.Map_Settings[i].FinalWave = 1;
		}

		if (default.Map_Settings[i].FinalWave > 255)
		{
			LogBadConfigMessage("Map_Settings -" @ default.Map_Settings[i].MapName @ "- Line" @ string(i + 1) @ "- FinalWave",
				string(default.Map_Settings[i].FinalWave),
				"255", "end of wave 255, last valid wave", "255 >= value >= 1");
			default.Map_Settings[i].FinalWave = 255;
		}

		if (default.Map_Settings[i].StartingTraderTime < 0)
		{
			LogBadConfigMessage("Map_Settings -" @ default.Map_Settings[i].MapName @ "- Line" @ string(i + 1) @ "- StartingTraderTime",
				string(default.Map_Settings[i].StartingTraderTime),
				"0", "0 seconds, no starting trader time", "value >= 0");
			default.Map_Settings[i].StartingTraderTime = 0;
		}

		if (default.Map_Settings[i].ZedNumberScale < 0.05f)
		{
			LogBadConfigMessage("Map_Settings -" @ default.Map_Settings[i].MapName @ "- Line" @ string(i + 1) @ "- ZedNumberScale",
				string(default.Map_Settings[i].ZedNumberScale),
				"0.05", "5%, minimum wave points multiplier", "value >= 0.05");
			default.Map_Settings[i].ZedNumberScale = 0.05f;
		}

		if (default.Map_Settings[i].ZedSpawnRate < 0.05f)
		{
			LogBadConfigMessage("Map_Settings -" @ default.Map_Settings[i].MapName @ "- Line" @ string(i + 1) @ "- ZedSpawnRate",
				string(default.Map_Settings[i].ZedSpawnRate),
				"0.05", "5%, minimum spawn rate factor", "value >= 0.05");
			default.Map_Settings[i].ZedSpawnRate = 0.05f;
		}

		if (default.Map_Settings[i].ZedStuckThreshold < 1)
		{
			LogBadConfigMessage("Map_Settings -" @ default.Map_Settings[i].MapName @ "- Line" @ string(i + 1) @ "- ZedStuckThreshold",
				string(default.Map_Settings[i].ZedStuckThreshold),
				"1", "1 zed stuck", "value >= 1");
			default.Map_Settings[i].ZedStuckThreshold = 1;
		}

		if (default.Map_Settings[i].ZedStuckTimeout < 15)
		{
			LogBadConfigMessage("Map_Settings -" @ default.Map_Settings[i].MapName @ "- Line" @ string(i + 1) @ "- ZedStuckTimeout",
				string(default.Map_Settings[i].ZedStuckTimeout),
				"15", "15 seconds before stuck zeds are respawned", "value >= 15");
			default.Map_Settings[i].ZedStuckTimeout = 15;
		}

		if (default.Map_Settings[i].AmmoPickupBase < 0.0f)
		{
			LogBadConfigMessage("Map_Settings -" @ default.Map_Settings[i].MapName @ "- Line" @ string(i + 1) @ "- AmmoPickupBase",
				string(default.Map_Settings[i].AmmoPickupBase),
				"0.0", "0% base ammo pickups enabled", "1.0 >= value >= 0.0");
			default.Map_Settings[i].AmmoPickupBase = 0.0f;
		}

		if (default.Map_Settings[i].AmmoPickupBase > 1.0f)
		{
			LogBadConfigMessage("Map_Settings -" @ default.Map_Settings[i].MapName @ "- Line" @ string(i + 1) @ "- AmmoPickupBase",
				string(default.Map_Settings[i].AmmoPickupBase),
				"1.0", "100% base ammo pickups enabled", "1.0 >= value >= 0.0");
			default.Map_Settings[i].AmmoPickupBase = 1.0f;
		}

		if (default.Map_Settings[i].AmmoPickupIncPerWave < 0.0f)
		{
			LogBadConfigMessage("Map_Settings -" @ default.Map_Settings[i].MapName @ "- Line" @ string(i + 1) @ "- AmmoPickupIncPerWave",
				string(default.Map_Settings[i].AmmoPickupIncPerWave),
				"0.0", "0%, no increase per wave", "value >= 0.0");
			default.Map_Settings[i].AmmoPickupIncPerWave = 0.0f;
		}

		if (default.Map_Settings[i].AmmoPickupMax < 0.0f)
		{
			LogBadConfigMessage("Map_Settings -" @ default.Map_Settings[i].MapName @ "- Line" @ string(i + 1) @ "- AmmoPickupMax",
				string(default.Map_Settings[i].AmmoPickupMax),
				"0.0", "0% max ammo pickups allowed", "1.0 >= value >= 0.0");
			default.Map_Settings[i].AmmoPickupMax = 0.0f;
		}

		if (default.Map_Settings[i].AmmoPickupMax > 1.0f)
		{
			LogBadConfigMessage("Map_Settings -" @ default.Map_Settings[i].MapName @ "- Line" @ string(i + 1) @ "- AmmoPickupMax",
				string(default.Map_Settings[i].AmmoPickupMax),
				"1.0", "100% max ammo pickups allowed", "1.0 >= value >= 0.0");
			default.Map_Settings[i].AmmoPickupMax = 1.0f;
		}

		if (default.Map_Settings[i].ItemPickupBase < 0.0f)
		{
			LogBadConfigMessage("Map_Settings -" @ default.Map_Settings[i].MapName @ "- Line" @ string(i + 1) @ "- ItemPickupBase",
				string(default.Map_Settings[i].ItemPickupBase),
				"0.0", "0% base item pickups enabled", "1.0 >= value >= 0.0");
			default.Map_Settings[i].ItemPickupBase = 0.0f;
		}

		if (default.Map_Settings[i].ItemPickupBase > 1.0f)
		{
			LogBadConfigMessage("Map_Settings -" @ default.Map_Settings[i].MapName @ "- Line" @ string(i + 1) @ "- ItemPickupBase",
				string(default.Map_Settings[i].ItemPickupBase),
				"1.0", "100% base item pickups enabled", "1.0 >= value >= 0.0");
			default.Map_Settings[i].ItemPickupBase = 1.0f;
		}

		if (default.Map_Settings[i].ItemPickupIncPerWave < 0.0f)
		{
			LogBadConfigMessage("Map_Settings -" @ default.Map_Settings[i].MapName @ "- Line" @ string(i + 1) @ "- ItemPickupIncPerWave",
				string(default.Map_Settings[i].ItemPickupIncPerWave),
				"0.0", "0%, no increase per wave", "value >= 0.0");
			default.Map_Settings[i].ItemPickupIncPerWave = 0.0f;
		}

		if (default.Map_Settings[i].ItemPickupMax < 0.0f)
		{
			LogBadConfigMessage("Map_Settings -" @ default.Map_Settings[i].MapName @ "- Line" @ string(i + 1) @ "- ItemPickupMax",
				string(default.Map_Settings[i].ItemPickupMax),
				"0.0", "0% max item pickups allowed", "1.0 >= value >= 0.0");
			default.Map_Settings[i].ItemPickupMax = 0.0f;
		}

		if (default.Map_Settings[i].ItemPickupMax > 1.0f)
		{
			LogBadConfigMessage("Map_Settings -" @ default.Map_Settings[i].MapName @ "- Line" @ string(i + 1) @ "- ItemPickupMax",
				string(default.Map_Settings[i].ItemPickupMax),
				"1.0", "100% max item pickups allowed", "1.0 >= value >= 0.0");
			default.Map_Settings[i].ItemPickupMax = 1.0f;
		}
	}
}

protected static function int FindMap(string MapName, int Difficulty)
{
	local int i;

	for (i = 0; i < default.Map_Settings.Length; ++i)
	{
		if (default.Map_Settings[i].MapName ~= MapName && default.Map_Settings[i].Difficulty.Find(Difficulty) != INDEX_NONE)
			return i;
	}

	return INDEX_NONE;
}

static function int GetStartingDosh(string MapName, int Difficulty)
{
	local int index;

	index = FindMap(MapName, Difficulty);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].StartingDosh;
	else
		return -1;
}

static function int GetStartingWave(string MapName, int Difficulty)
{
	local int index;

	index = FindMap(MapName, Difficulty);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].StartingWave - 1;
	else
		return 0;
}

static function int GetFinalWave(string MapName, int Difficulty)
{
	local int index;

	index = FindMap(MapName, Difficulty);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].FinalWave;
	else
		return 255;
}

static function int GetStartingTraderTime(string MapName, int Difficulty)
{
	local int index;

	index = FindMap(MapName, Difficulty);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].StartingTraderTime;
	else
		return 0;
}

static function float GetZedNumberScale(string MapName, int Difficulty)
{
	local int index;

	index = FindMap(MapName, Difficulty);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].ZedNumberScale;
	else
		return 1.0f;
}

static function float GetZedSpawnRate(string MapName, int Difficulty)
{
	local int index;

	index = FindMap(MapName, Difficulty);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].ZedSpawnRate;
	else
		return 1.0f;
}

static function int GetZedStuckThreshold(string MapName, int Difficulty)
{
	local int index;

	index = FindMap(MapName, Difficulty);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].ZedStuckThreshold;
	else
		return 4;
}

static function int GetZedStuckTimeout(string MapName, int Difficulty)
{
	local int index;

	index = FindMap(MapName, Difficulty);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].ZedStuckTimeout;
	else
		return 150;
}

static function byte GetAllTraders(string MapName, int Difficulty)
{
	local int index;

	index = FindMap(MapName, Difficulty);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].AllTraders ? 2 : 1;
	else
		return 0;
}

static function byte GetEnableAmmoPickups(string MapName, int Difficulty)
{
	local int index;

	index = FindMap(MapName, Difficulty);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].EnableAmmoPickups ? 2 : 1;
	else
		return 0;
}

static function byte GetEnableWeaponPickups(string MapName, int Difficulty)
{
	local int index;

	index = FindMap(MapName, Difficulty);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].EnableWeaponPickups ? 2 : 1;
	else
		return 0;
}

static function byte GetArmorSpawnOnMap(string MapName, int Difficulty)
{
	local int index;

	index = FindMap(MapName, Difficulty);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].ArmorSpawnOnMap ? 2 : 1;
	else
		return 0;
}

static function byte GetOverrideKismetPickups(string MapName, int Difficulty)
{
	local int index;

	index = FindMap(MapName, Difficulty);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].OverrideKismetPickups ? 2 : 1;
	else
		return 0;
}

static function float GetAmmoPickupBase(string MapName, int Difficulty)
{
	local int index;

	index = FindMap(MapName, Difficulty);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].AmmoPickupBase;
	else
		return -1;
}

static function float GetAmmoPickupIncPerWave(string MapName, int Difficulty)
{
	local int index;

	index = FindMap(MapName, Difficulty);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].AmmoPickupIncPerWave;
	else
		return -1;
}

static function float GetAmmoPickupMax(string MapName, int Difficulty)
{
	local int index;

	index = FindMap(MapName, Difficulty);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].AmmoPickupMax;
	else
		return -1;
}

static function float GetItemPickupBase(string MapName, int Difficulty)
{
	local int index;

	index = FindMap(MapName, Difficulty);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].ItemPickupBase;
	else
		return -1;
}

static function float GetItemPickupIncPerWave(string MapName, int Difficulty)
{
	local int index;

	index = FindMap(MapName, Difficulty);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].ItemPickupIncPerWave;
	else
		return -1;
}

static function float GetItemPickupMax(string MapName, int Difficulty)
{
	local int index;

	index = FindMap(MapName, Difficulty);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].ItemPickupMax;
	else
		return -1;
}

defaultproperties
{
	Name="Default__Config_Map"
}
