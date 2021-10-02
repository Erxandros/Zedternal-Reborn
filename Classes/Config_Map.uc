class Config_Map extends Config_Common
	config(ZedternalReborn_Game);

var config int MODEVERSION;

struct S_Map
{
	var string MapName;
	var int StartingDosh;
	var int StartingWave;
	var int FinalWave;
	var int StartingTraderTime;
	var float ZedNumberScale;
	var float ZedSpawnRate;
	var int ZedStuckThreshold;
	var int ZedStuckTimeout;
	var bool AllTraders;

	structdefaultproperties
	{
		StartingDosh=400
		StartingWave=1
		FinalWave=255
		StartingTraderTime=0
		ZedNumberScale=1.0f
		ZedSpawnRate=1.0f
		ZedStuckThreshold=4
		ZedStuckTimeout=150
		AllTraders=False
	}
};

var config array<S_Map> Map_Settings;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Map_Settings.Length = 1;

		default.Map_Settings[0].MapName = "KF-BioticsLab";
		default.Map_Settings[0].StartingDosh = 400;
		default.Map_Settings[0].StartingWave = 1;
		default.Map_Settings[0].FinalWave = 255;
		default.Map_Settings[0].StartingTraderTime = 0;
		default.Map_Settings[0].ZedNumberScale = 1.0f;
		default.Map_Settings[0].ZedSpawnRate = 1.0f;
		default.Map_Settings[0].ZedStuckThreshold = 4;
		default.Map_Settings[0].ZedStuckTimeout = 150;
		default.Map_Settings[0].AllTraders = False;
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
		if (default.Map_Settings[i].StartingDosh < 0)
		{
			LogBadConfigMessage("Map_Settings -" @ default.Map_Settings[i].MapName @ "- Line" @ string(i + 1) @ "- StartingDosh",
				string(default.Map_Settings[i].StartingDosh),
				"0", "0 dosh, no starting dosh", "value >= 0");
			default.Map_Settings[i].StartingDosh = 0;
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
	}
}

static function int GetStartingDosh(string MapName)
{
	local int index;

	index = default.Map_Settings.Find('MapName', MapName);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].StartingDosh;
	else
		return 400;
}

static function int GetStartingWave(string MapName)
{
	local int index;

	index = default.Map_Settings.Find('MapName', MapName);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].StartingWave - 1;
	else
		return 0;
}

static function int GetFinalWave(string MapName)
{
	local int index;

	index = default.Map_Settings.Find('MapName', MapName);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].FinalWave;
	else
		return 255;
}

static function int GetStartingTraderTime(string MapName)
{
	local int index;

	index = default.Map_Settings.Find('MapName', MapName);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].StartingTraderTime;
	else
		return 0;
}

static function float GetZedNumberScale(string MapName)
{
	local int index;

	index = default.Map_Settings.Find('MapName', MapName);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].ZedNumberScale;
	else
		return 1.0f;
}

static function float GetZedSpawnRate(string MapName)
{
	local int index;

	index = default.Map_Settings.Find('MapName', MapName);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].ZedSpawnRate;
	else
		return 1.0f;
}

static function int GetZedStuckThreshold(string MapName)
{
	local int index;

	index = default.Map_Settings.Find('MapName', MapName);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].ZedStuckThreshold;
	else
		return 4;
}

static function int GetZedStuckTimeout(string MapName)
{
	local int index;

	index = default.Map_Settings.Find('MapName', MapName);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].ZedStuckTimeout;
	else
		return 150;
}

static function bool GetAllTraders(string MapName)
{
	local int index;

	index = default.Map_Settings.Find('MapName', MapName);
	if (index != INDEX_NONE)
		return default.Map_Settings[index].AllTraders;
	else
		return False;
}

defaultproperties
{
	Name="Default__Config_Map"
}
