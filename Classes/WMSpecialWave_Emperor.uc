class WMSpecialWave_Emperor extends WMSpecialWave;

var class<KFPawn_Monster> EmperorClass;

function PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(6.0f, False, NameOf(SpawnEmperor));
}

function SpawnEmperor()
{
	local WMAISpawnManager WMAISP;

	WMAISP = WMAISpawnManager(WMGameInfo_Endless(class'WorldInfo'.static.GetWorldInfo().Game).SpawnManager);
	if (WMAISP != None && WMAISP.GroupList.Length > 0)
		WMAISP.GroupList[0].ZedClasses[0] = EmperorClass;
}

defaultproperties
{
	EmperorClass=class'ZedternalReborn.WMPawn_ZedScrake_Emperor'
	zedSpawnRateFactor=0.95f
	waveValueFactor=0.75f
	doshFactor=1.4f

	Title="Emperor"
	Description="He is scary..."

	Name="Default__WMSpecialWave_Emperor"
}
