class Config_Map extends Config_Base
	config(ZedternalReborn);

var config int MODEVERSION;

struct S_Map
{
	var string mapName;
	var int startingDosh;
	var int startingWave;
	var int startingTraderTime;
	var float zedNumberScale;
	var float zedSpawnRate;
	var int zedStuckThreshold;
	var int zedStuckTimeout;
	var bool allTraders;

	structdefaultproperties
	{
		startingDosh=400
		startingWave=1
		startingTraderTime=0
		zedNumberScale=1.000000
		zedSpawnRate=1.000000
		zedStuckThreshold=4
		zedStuckTimeout=150
		allTraders=false
	}
};

var config array< S_Map > Map_Settings;

static function UpdateConfig()
{
	local int i;

	if (default.MODEVERSION < 1)
	{
		default.Map_Settings.length = 1;

		default.Map_Settings[0].mapName = "KF-BioticsLab";
		default.Map_Settings[0].zedNumberScale = 1.000000;
		default.Map_Settings[0].zedSpawnRate = 1.000000;
	}

	if (default.MODEVERSION < 2)
	{
		for (i = 0; i < default.Map_Settings.length; ++i)
		{
			default.Map_Settings[i].zedStuckThreshold = 4;
			default.Map_Settings[i].zedStuckTimeout = 150;
		}
	}

	if (default.MODEVERSION < 6)
	{
		for (i = 0; i < default.Map_Settings.length; ++i)
		{
			default.Map_Settings[i].startingDosh = 400;
			default.Map_Settings[i].startingWave = 1;
			default.Map_Settings[i].startingTraderTime = 0;
			default.Map_Settings[i].allTraders = false;
		}
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.default.currentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.default.currentVersion;
		static.StaticSaveConfig();
	}
}

static function int GetStartingDosh(string mapName)
{
	local int index;

	index = default.Map_Settings.Find('mapName', mapName);
	if (index != -1)
		return Max(default.Map_Settings[index].startingDosh, 0);
	else
		return 400;
}

static function int GetStartingWave(string mapName)
{
	local int index;

	index = default.Map_Settings.Find('mapName', mapName);
	if (index != -1)
		return Min(Max(default.Map_Settings[index].startingWave - 1, 0), 254);
	else
		return 0;
}

static function int GetStartingTraderTime(string mapName)
{
	local int index;

	index = default.Map_Settings.Find('mapName', mapName);
	if (index != -1)
		return Max(default.Map_Settings[index].startingTraderTime, 0);
	else
		return 0;
}

static function float GetZedNumberScale(string mapName)
{
	local int index;

	index = default.Map_Settings.Find('mapName', mapName);
	if (index != -1)
		return default.Map_Settings[index].zedNumberScale;
	else
		return 1.f;
}

static function float GetZedSpawnRate(string mapName)
{
	local int index;

	index = default.Map_Settings.Find('mapName', mapName);
	if (index != -1)
		return default.Map_Settings[index].zedSpawnRate;
	else
		return 1.f;
}

static function int GetZedStuckThreshold(string mapName)
{
	local int index;

	index = default.Map_Settings.Find('mapName', mapName);
	if (index != -1)
		return default.Map_Settings[index].zedStuckThreshold;
	else
		return 4;
}

static function int GetZedStuckTimeout(string mapName)
{
	local int index;

	index = default.Map_Settings.Find('mapName', mapName);
	if (index != -1)
		return default.Map_Settings[index].zedStuckTimeout;
	else
		return 150;
}

static function bool GetAllTraders(string mapName)
{
	local int index;

	index = default.Map_Settings.Find('mapName', mapName);
	if (index != -1)
		return default.Map_Settings[index].allTraders;
	else
		return false;
}

defaultproperties
{
}
