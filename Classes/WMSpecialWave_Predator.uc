class WMSpecialWave_Predator extends WMSpecialWave;

var class<KFPawn_Monster> PredatorClass;

function PostBeginPlay()
{
	SetTimer(6.000000,false,nameof(SpawnPredator));
	super.PostBeginPlay();
}

function SpawnPredator()
{
	local WMAISpawnManager WMAISP;

	WMAISP = WMAISpawnManager(WMGameInfo_Endless(Class'WorldInfo'.static.GetWorldInfo().Game).SpawnManager);
	if (WMAISP != none && WMAISP.groupList.Length > 0)
	{
		WMAISP.groupList[0].MClass[0] = PredatorClass;
		WMAISP.groupList[0].MClass[1] = PredatorClass;
		WMAISP.groupList[0].MClass[2] = PredatorClass;
	}
}

function WaveEnded()
{
	local WMPawn_ZedFleshpound_Predator Predator;

	foreach DynamicActors(class'WMPawn_ZedFleshpound_Predator', Predator)
	{
		Predator.Health = 5;
		Predator.ApplyDamageOverTime(5, Predator.Controller, Class'KFGame.KFDT_Bleeding');
	}
}

defaultproperties
{
	Title="Predator"
	Description="The enemy of my enemy is my friend!"
	zedSpawnRateFactor=1.200000
	waveValueFactor=1.200000
	PredatorClass=class'ZedternalReborn.WMPawn_ZedFleshpound_Predator'
	Name="Default__WMSpecialWave_Predator"
}
