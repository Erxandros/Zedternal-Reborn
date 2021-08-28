class Config_ZedInject extends Config_Common
	config(ZedternalReborn_ZedWaves);

var config int MODEVERSION;

var config bool Zed_bEnableWaveGroupInjection;

struct SZedSpawnGroup
{
	var array< class<KFPawn_Monster> > ZedClasses;
	var int WaveNum;
	var string Position;
	var int MinDiff, MaxDiff;
};
var config array<SZedSpawnGroup> Zed_WaveGroupInject;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.Zed_bEnableWaveGroupInjection = False;

		default.Zed_WaveGroupInject.Length = 1;
		default.Zed_WaveGroupInject[0].ZedClasses.Length = 3;

		default.Zed_WaveGroupInject[0].ZedClasses[0] = class'ZedternalReborn.WMPawn_ZedCrawler_Ultra';
		default.Zed_WaveGroupInject[0].ZedClasses[1] = class'ZedternalReborn.WMPawn_ZedCrawler_Ultra';
		default.Zed_WaveGroupInject[0].ZedClasses[2] = class'ZedternalReborn.WMPawn_ZedCrawler_Ultra';
		default.Zed_WaveGroupInject[0].WaveNum = 10;
		default.Zed_WaveGroupInject[0].Position = "END";
		default.Zed_WaveGroupInject[0].MinDiff = 0;
		default.Zed_WaveGroupInject[0].MaxDiff = 4;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

defaultproperties
{
	Name="Default__Config_ZedInject"
}
