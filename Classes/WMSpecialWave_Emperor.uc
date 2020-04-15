class WMSpecialWave_Emperor extends WMSpecialWave;

var class<KFPawn_Monster> EmperorClass;

function PostBeginPlay()
{	
	SetTimer(6.000000,false,nameof(SpawnEmperor));
	super.PostBeginPlay();
}

function SpawnEmperor()
{
	local WMAISpawnManager WMAISP;
	
	WMAISP = WMAISpawnManager(WMGameInfo_Endless(Class'WorldInfo'.static.GetWorldInfo().Game).SpawnManager);
	if (WMAISP != none && WMAISP.groupList.Length > 0)
		WMAISP.groupList[0].MClass[0] = EmperorClass;
}

defaultproperties
{
   Title="Emperor"
   Description="He is scary..."
   zedSpawnRateFactor=0.950000
   waveValueFactor=0.750000
   doshFactor=1.400000
   EmperorClass=class'Zedternal.WMPawn_ZedScrake_Emperor'
   Name="Default__WMSpecialWave_Emperor"
}
