class Config_SpecialWaveOverride extends Config_Common
	config(ZedternalReborn_Events);

var config int MODEVERSION;

var config bool SpecialWaveOverride_bAllowed;

struct SSpecialWaveOverride
{
	var int Wave;
	var string FirstPath, SecondPath;
	var float Probability;
};
var config array<SSpecialWaveOverride> SpecialWaveOverride_SpecialWaves;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.SpecialWaveOverride_bAllowed = False;

		default.SpecialWaveOverride_SpecialWaves.Length = 3;
		default.SpecialWaveOverride_SpecialWaves[0].Wave = 5;
		default.SpecialWaveOverride_SpecialWaves[0].FirstPath = "ZedternalReborn.WMSpecialWave_TheHorde";
		default.SpecialWaveOverride_SpecialWaves[0].SecondPath = "ZedternalReborn.WMSpecialWave_UnlimitedAmmo";
		default.SpecialWaveOverride_SpecialWaves[0].Probability = 0.8f;
		default.SpecialWaveOverride_SpecialWaves[1].Wave = 10;
		default.SpecialWaveOverride_SpecialWaves[1].FirstPath = "ZedternalReborn.WMSpecialWave_Pesticide";
		default.SpecialWaveOverride_SpecialWaves[1].SecondPath = "";
		default.SpecialWaveOverride_SpecialWaves[1].Probability = 0.65f;
		default.SpecialWaveOverride_SpecialWaves[2].Wave = 15;
		default.SpecialWaveOverride_SpecialWaves[2].FirstPath = "ZedternalReborn.WMSpecialWave_Fireworks";
		default.SpecialWaveOverride_SpecialWaves[2].SecondPath = "ZedternalReborn.WMSpecialWave_Chaos";
		default.SpecialWaveOverride_SpecialWaves[2].Probability = 0.4f;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

defaultproperties
{
	Name="Default__Config_SpecialWaveOverride"
}
