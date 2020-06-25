class Config_SpecialWave extends Config_Base
	config(ZedternalReborn);

var config int MODEVERSION;

var config bool SpecialWave_bAllowed;
var config float SpecialWave_Probability;
var config float SpecialWave_DoubleProbability;

struct SSpecialWave
{
	var string Path;
	var int MinWave, MaxWave;
};

var config array< SSpecialWave > SpecialWave_SpecialWaves;

static function UpdateConfig()
{
	local int i;
	local SSpecialWave sWave;

	if (default.MODEVERSION < 1)
	{
		default.SpecialWave_bAllowed = true;
		default.SpecialWave_Probability = 0.270000;
		default.SpecialWave_DoubleProbability = 0.220000;

		default.SpecialWave_SpecialWaves.length = 41;
		default.SpecialWave_SpecialWaves[0].Path = "ZedternalReborn.WMSpecialWave_ClotBuster";
		default.SpecialWave_SpecialWaves[1].Path = "ZedternalReborn.WMSpecialWave_Popcorn";
		default.SpecialWave_SpecialWaves[2].Path = "ZedternalReborn.WMSpecialWave_CatchMe";
		default.SpecialWave_SpecialWaves[3].Path = "ZedternalReborn.WMSpecialWave_Dosh";
		default.SpecialWave_SpecialWaves[4].Path = "ZedternalReborn.WMSpecialWave_DoubleDamage";
		default.SpecialWave_SpecialWaves[5].Path = "ZedternalReborn.WMSpecialWave_Pop";
		default.SpecialWave_SpecialWaves[6].Path = "ZedternalReborn.WMSpecialWave_GoredFast";
		default.SpecialWave_SpecialWaves[7].Path = "ZedternalReborn.WMSpecialWave_Haemorrhage";
		default.SpecialWave_SpecialWaves[8].Path = "ZedternalReborn.WMSpecialWave_Regeneration";
		default.SpecialWave_SpecialWaves[9].Path = "ZedternalReborn.WMSpecialWave_Locked";
		default.SpecialWave_SpecialWaves[10].Path = "ZedternalReborn.WMSpecialWave_GiftFromAbove";
		default.SpecialWave_SpecialWaves[11].Path = "ZedternalReborn.WMSpecialWave_Vampire";
		default.SpecialWave_SpecialWaves[12].Path = "ZedternalReborn.WMSpecialWave_BuffUp";
		default.SpecialWave_SpecialWaves[13].Path = "ZedternalReborn.WMSpecialWave_Shrink";
		default.SpecialWave_SpecialWaves[14].Path = "ZedternalReborn.WMSpecialWave_Virus";
		default.SpecialWave_SpecialWaves[15].Path = "ZedternalReborn.WMSpecialWave_Earthquake";
		default.SpecialWave_SpecialWaves[16].Path = "ZedternalReborn.WMSpecialWave_UnlimitedAmmo";
		default.SpecialWave_SpecialWaves[17].Path = "ZedternalReborn.WMSpecialWave_Featherweight";
		default.SpecialWave_SpecialWaves[18].Path = "ZedternalReborn.WMSpecialWave_GodMode";
		default.SpecialWave_SpecialWaves[19].Path = "ZedternalReborn.WMSpecialWave_Chaos";
		default.SpecialWave_SpecialWaves[20].Path = "ZedternalReborn.WMSpecialWave_Fireworks";
		for (i = 0; i <= 20; ++i)
		{
			default.SpecialWave_SpecialWaves[i].MinWave = 0;
			default.SpecialWave_SpecialWaves[i].MaxWave = 999;
		}

		default.SpecialWave_SpecialWaves[21].Path = "ZedternalReborn.WMSpecialWave_Phoenix";
		default.SpecialWave_SpecialWaves[22].Path = "ZedternalReborn.WMSpecialWave_Predator";
		for (i = 21; i <= 22; ++i)
		{
			default.SpecialWave_SpecialWaves[i].MinWave = 3;
			default.SpecialWave_SpecialWaves[i].MaxWave = 999;
		}

		default.SpecialWave_SpecialWaves[23].Path = "ZedternalReborn.WMSpecialWave_UpUpDecay";
		default.SpecialWave_SpecialWaves[24].Path = "ZedternalReborn.WMSpecialWave_Division";
		default.SpecialWave_SpecialWaves[25].Path = "ZedternalReborn.WMSpecialWave_Emperor";
		default.SpecialWave_SpecialWaves[26].Path = "ZedternalReborn.WMSpecialWave_Lethargic";
		default.SpecialWave_SpecialWaves[27].Path = "ZedternalReborn.WMSpecialWave_Titans";
		for (i = 23; i <= 27; ++i)
		{
			default.SpecialWave_SpecialWaves[i].MinWave = 3;
			default.SpecialWave_SpecialWaves[i].MaxWave = 10;
		}

		default.SpecialWave_SpecialWaves[28].Path = "ZedternalReborn.WMSpecialWave_BobbleZed";
		default.SpecialWave_SpecialWaves[29].Path = "ZedternalReborn.WMSpecialWave_Acceleration";
		default.SpecialWave_SpecialWaves[30].Path = "ZedternalReborn.WMSpecialWave_HellFire";
		default.SpecialWave_SpecialWaves[31].Path = "ZedternalReborn.WMSpecialWave_FiveAlarmSiren";
		default.SpecialWave_SpecialWaves[32].Path = "ZedternalReborn.WMSpecialWave_Poundamonium";
		default.SpecialWave_SpecialWaves[33].Path = "ZedternalReborn.WMSpecialWave_Pesticide";
		default.SpecialWave_SpecialWaves[34].Path = "ZedternalReborn.WMSpecialWave_ToxicNightmare";
		default.SpecialWave_SpecialWaves[35].Path = "ZedternalReborn.WMSpecialWave_BloodyChainsaw";
		default.SpecialWave_SpecialWaves[36].Path = "ZedternalReborn.WMSpecialWave_MechanicalProblem";
		default.SpecialWave_SpecialWaves[37].Path = "ZedternalReborn.WMSpecialWave_PurpleAlert";
		for (i = 28; i <= 37; ++i)
		{
			default.SpecialWave_SpecialWaves[i].MinWave = 3;
			default.SpecialWave_SpecialWaves[i].MaxWave = 15;
		}

		default.SpecialWave_SpecialWaves[38].Path = "ZedternalReborn.WMSpecialWave_TinyTerror";
		default.SpecialWave_SpecialWaves[39].Path = "ZedternalReborn.WMSpecialWave_BackupPlan";
		for (i = 38; i <= 39; ++i)
		{
			default.SpecialWave_SpecialWaves[i].MinWave = 0;
			default.SpecialWave_SpecialWaves[i].MaxWave = 7;
		}

		default.SpecialWave_SpecialWaves[40].Path = "ZedternalReborn.WMSpecialWave_TheHorde";
		default.SpecialWave_SpecialWaves[40].MinWave = 7;
		default.SpecialWave_SpecialWaves[40].MaxWave = 999;
	}

	if (default.MODEVERSION < 4)
	{
		if (default.SpecialWave_SpecialWaves.Find('Path', "ZedternalReborn.WMSpecialWave_InstaKill") == -1)
		{
			sWave.Path = "ZedternalReborn.WMSpecialWave_InstaKill";
			sWave.MinWave = 0;
			sWave.MaxWave = 15;
			default.SpecialWave_SpecialWaves.AddItem(sWave);
		}
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.default.currentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.default.currentVersion;
		static.StaticSaveConfig();
	}
}

defaultproperties
{
}
