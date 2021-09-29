class WMSpecialWave_Predator extends WMSpecialWave;

var class<KFPawn_Monster> PredatorClass;

function PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(6.0f, False, NameOf(SpawnPredator));
}

function SpawnPredator()
{
	local WMAISpawnManager WMAISP;
	local KFPlayerController KFPC;
	local byte i, NbPlayer, NbPredator;
	local S_Spawn_Group PredGroup;

	foreach DynamicActors(class'KFPlayerController', KFPC)
	{
		if (KFPC.GetTeamNum() != 255)
			++NbPlayer;
	}

	NbPredator = Clamp(NbPlayer, 3, 12); //Predators based on the number of players, with a max of 12.
	PredGroup.Delay = 0;
	WMAISP = WMAISpawnManager(WMGameInfo_Endless(class'WorldInfo'.static.GetWorldInfo().Game).SpawnManager);
	while (WMAISP != None && WMAISP.groupList.Length > 0 && NbPredator > 0)
	{
		PredGroup.ZedClasses.Length = 0;
		for (i = 0; i < (NbPredator - Max(0, NbPredator - 3)); ++i) //Group 3 of them at a time
		{
			PredGroup.ZedClasses.AddItem(PredatorClass);
		}

		NbPredator -= PredGroup.ZedClasses.Length;

		WMAISP.groupList.InsertItem(0, PredGroup);
	}
}

function WaveEnded()
{
	SetTimer(3.0f, False, NameOf(KillAllPredators));
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
	PredatorClass=class'ZedternalReborn.WMPawn_ZedFleshpound_Predator'
	zedSpawnRateFactor=1.2f
	waveValueFactor=1.2f

	Title="Predator"
	Description="The enemy of my enemy is my friend!"

	Name="Default__WMSpecialWave_Predator"
}
