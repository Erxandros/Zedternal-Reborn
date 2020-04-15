class Config_SpecialWave extends Config_Base
	config(Zedternal);

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
	local SSpecialWave tempObj;
	
	if (default.MODEVERSION < 2)
	{
		default.SpecialWave_bAllowed = true;
		default.SpecialWave_Probability = 0.270000;
		
		default.SpecialWave_SpecialWaves.length = 35;
		default.SpecialWave_SpecialWaves[0].Path="Zedternal.WMSpecialWave_ClotBuster";
		default.SpecialWave_SpecialWaves[1].Path="Zedternal.WMSpecialWave_Popcorn";
		default.SpecialWave_SpecialWaves[2].Path="Zedternal.WMSpecialWave_CatchMe";
		default.SpecialWave_SpecialWaves[3].Path="Zedternal.WMSpecialWave_Dosh";
		default.SpecialWave_SpecialWaves[4].Path="Zedternal.WMSpecialWave_DoubleDamage";
		default.SpecialWave_SpecialWaves[5].Path="Zedternal.WMSpecialWave_Pop";
		default.SpecialWave_SpecialWaves[6].Path="Zedternal.WMSpecialWave_GoredFast";
		default.SpecialWave_SpecialWaves[7].Path="Zedternal.WMSpecialWave_Haemorrhage";
		default.SpecialWave_SpecialWaves[8].Path="Zedternal.WMSpecialWave_Regeneration";
		default.SpecialWave_SpecialWaves[9].Path="Zedternal.WMSpecialWave_Locked";
		default.SpecialWave_SpecialWaves[10].Path="Zedternal.WMSpecialWave_GiftFromAbove";
		default.SpecialWave_SpecialWaves[11].Path="Zedternal.WMSpecialWave_Vampire";
		default.SpecialWave_SpecialWaves[12].Path="Zedternal.WMSpecialWave_BuffUp";
		default.SpecialWave_SpecialWaves[13].Path="Zedternal.WMSpecialWave_Shrink";
		default.SpecialWave_SpecialWaves[14].Path="Zedternal.WMSpecialWave_Virus";
		default.SpecialWave_SpecialWaves[15].Path="Zedternal.WMSpecialWave_Earthquake";
		default.SpecialWave_SpecialWaves[16].Path="Zedternal.WMSpecialWave_UnlimitedAmmo";
		default.SpecialWave_SpecialWaves[17].Path="Zedternal.WMSpecialWave_Featherweight";
		default.SpecialWave_SpecialWaves[18].Path="Zedternal.WMSpecialWave_GodMode";
		default.SpecialWave_SpecialWaves[19].Path="Zedternal.WMSpecialWave_Chaos";
		for (i=0; i<=19; i+=1)
		{
			default.SpecialWave_SpecialWaves[i].MinWave=0;
			default.SpecialWave_SpecialWaves[i].MaxWave=999;
		}
		
		default.SpecialWave_SpecialWaves[20].Path="Zedternal.WMSpecialWave_UpUpDecay";
		default.SpecialWave_SpecialWaves[21].Path="Zedternal.WMSpecialWave_Division";
		default.SpecialWave_SpecialWaves[22].Path="Zedternal.WMSpecialWave_Emperor";
		default.SpecialWave_SpecialWaves[23].Path="Zedternal.WMSpecialWave_Lethargic";
		default.SpecialWave_SpecialWaves[24].Path="Zedternal.WMSpecialWave_Titans";
		for (i=20; i<=24; i+=1)
		{
			default.SpecialWave_SpecialWaves[i].MinWave=3;
			default.SpecialWave_SpecialWaves[i].MaxWave=10;
		}
		
		default.SpecialWave_SpecialWaves[25].Path="Zedternal.WMSpecialWave_BobbleZed";
		default.SpecialWave_SpecialWaves[26].Path="Zedternal.WMSpecialWave_Acceleration";
		default.SpecialWave_SpecialWaves[27].Path="Zedternal.WMSpecialWave_HellFire";
		default.SpecialWave_SpecialWaves[28].Path="Zedternal.WMSpecialWave_FiveAlarmSiren";
		default.SpecialWave_SpecialWaves[29].Path="Zedternal.WMSpecialWave_Poundamonium";
		default.SpecialWave_SpecialWaves[30].Path="Zedternal.WMSpecialWave_Pesticide";
		default.SpecialWave_SpecialWaves[31].Path="Zedternal.WMSpecialWave_ToxicNightmare";
		default.SpecialWave_SpecialWaves[32].Path="Zedternal.WMSpecialWave_BloodyChainsaw";
		for (i=25; i<=32; i+=1)
		{
			default.SpecialWave_SpecialWaves[i].MinWave=3;
			default.SpecialWave_SpecialWaves[i].MaxWave=15;
		}

		default.SpecialWave_SpecialWaves[33].Path="Zedternal.WMSpecialWave_TinyTerror";
		default.SpecialWave_SpecialWaves[34].Path="Zedternal.WMSpecialWave_BackupPlan";
		for (i=33; i<=34; i+=1)
		{
			default.SpecialWave_SpecialWaves[i].MinWave=0;
			default.SpecialWave_SpecialWaves[i].MaxWave=7;
		}
	}
	
	if (default.MODEVERSION < 8)
	{
		tempObj.Path = "Zedternal.WMSpecialWave_MechanicalProblem";
		tempObj.MinWave = 3;
		tempObj.MaxWave = 15;
		default.SpecialWave_SpecialWaves.AddItem(tempObj);
		
		tempObj.Path = "Zedternal.WMSpecialWave_Phoenix";
		tempObj.MinWave = 3;
		tempObj.MaxWave = 999;
		default.SpecialWave_SpecialWaves.AddItem(tempObj);
	}
	
	if (default.MODEVERSION < 10)
	{
		tempObj.Path = "Zedternal.WMSpecialWave_PurpleAlert";
		tempObj.MinWave = 3;
		tempObj.MaxWave = 15;
		default.SpecialWave_SpecialWaves.AddItem(tempObj);
	}
	
	if (default.MODEVERSION < 13)
	{		
		tempObj.Path = "Zedternal.WMSpecialWave_Fireworks";
		tempObj.MinWave = 0;
		tempObj.MaxWave = 999;
		default.SpecialWave_SpecialWaves.AddItem(tempObj);
		
		tempObj.Path = "Zedternal.WMSpecialWave_Predator";
		tempObj.MinWave = 3;
		tempObj.MaxWave = 999;
		default.SpecialWave_SpecialWaves.AddItem(tempObj);	
		
		tempObj.Path = "Zedternal.WMSpecialWave_TheHorde";
		tempObj.MinWave = 7;
		tempObj.MaxWave = 999;
		default.SpecialWave_SpecialWaves.AddItem(tempObj);
		
		default.SpecialWave_DoubleProbability = 0.220000;
	}
	
	if (default.MODEVERSION < class'Zedternal.Config_Base'.default.currentVersion)
	{
		default.MODEVERSION = class'Zedternal.Config_Base'.default.currentVersion;
		static.StaticSaveConfig();
	}

}
	
defaultproperties
{
}