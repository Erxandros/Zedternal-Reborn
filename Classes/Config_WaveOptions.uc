class Config_WaveOptions extends Config_Common
	config(ZedternalReborn_ZedWaves);

var config int MODEVERSION;

var config bool Wave_bAllowZedTeleport;
var config bool Wave_bAllowFastSpawning;
var config int Wave_MaxUniqueZedsInWave;
var config int Wave_MaxSpawnedZedsOnLevel;
var config int Wave_MaxNumberOfZedsToSpawn;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Wave_bAllowZedTeleport = False;
		default.Wave_bAllowFastSpawning = True;
		default.Wave_MaxUniqueZedsInWave = 12;
		default.Wave_MaxSpawnedZedsOnLevel = 52;
		default.Wave_MaxNumberOfZedsToSpawn = 800;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

defaultproperties
{
	Name="Default__Config_WaveOptions"
}
