class Config_Map extends Config_Base
	config(ZedternalReborn);

var config int MODEVERSION;

struct S_Map
{
	var string mapName;
	var float zedNumberScale;
	var float zedSpawnRate;
	
	structdefaultproperties
	{
		zedNumberScale = 1.000000;
		zedSpawnRate = 1.000000;
	}
};

var config array< S_Map > Map_Settings;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Map_Settings.length = 1;

		default.Map_Settings[0].mapName = "KF-BioticsLab";
		default.Map_Settings[0].zedNumberScale = 1.000000;
		default.Map_Settings[0].zedSpawnRate = 1.000000;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.default.currentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.default.currentVersion;
		static.StaticSaveConfig();
	}
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

defaultproperties
{
}