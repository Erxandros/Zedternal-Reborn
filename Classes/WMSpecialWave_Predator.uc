class WMSpecialWave_Predator extends WMSpecialWave;

var class<KFPawn_Monster> PredatorClass;

function PostBeginPlay()
{
	SetTimer(6.0f, false, nameof(SpawnPredator));
	super.PostBeginPlay();
}

function SpawnPredator()
{
	local WMAISpawnManager WMAISP;
	local KFPlayerController KFPC;
	local byte i, NbPlayer, NbPredator;
	local SGroupToSpawn predGroup;

	foreach DynamicActors(class'KFPlayerController', KFPC)
	{
		if (KFPC.GetTeamNum() != 255)
			++NbPlayer;
	}

	NbPredator = Clamp(NbPlayer, 3, 12); //Predators based on the number of players, with a max of 12.
	predGroup.Delay = 0;
	WMAISP = WMAISpawnManager(WMGameInfo_Endless(Class'WorldInfo'.static.GetWorldInfo().Game).SpawnManager);
	while (WMAISP != none && WMAISP.groupList.Length > 0 && NbPredator > 0)
	{
		predGroup.MClass.Length = 0;
		for (i = 0; i < (NbPredator - Max(0, NbPredator - 3)); ++i) //Group 3 of them at a time
		{
			predGroup.MClass.AddItem(PredatorClass);
		}

		NbPredator -= predGroup.MClass.Length;

		WMAISP.groupList.InsertItem(0, predGroup);
	}
}

function WaveEnded()
{
	SetTimer(3.0f, false, nameof(KillAllPredators));
}

function KillAllPredators()
{
	local WMPawn_ZedFleshpound_Predator Predator;
	local vector NullLocation;

	foreach DynamicActors(class'WMPawn_ZedFleshpound_Predator', Predator)
	{
		Predator.Died(None, None, NullLocation);
	}

	super.WaveEnded();
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
