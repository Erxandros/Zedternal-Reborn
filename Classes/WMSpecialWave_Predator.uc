class WMSpecialWave_Predator extends WMSpecialWave;

var class<KFPawn_Monster> PredatorClass;

function PostBeginPlay()
{
	super.PostBeginPlay();
	SetTimer(6.0f, False, NameOf(SpawnPredator));
}

function SpawnPredator()
{
	local KFPlayerController KFPC;
	local byte i, NbPlayer, NbPredator;
	local array< class<KFPawn_Monster> > Predator;

	Predator.AddItem(default.PredatorClass);

	foreach DynamicActors(class'KFPlayerController', KFPC)
	{
		if (KFPC.GetTeamNum() != 255)
			++NbPlayer;
	}

	NbPredator = Clamp(NbPlayer, 3, 12); //Predators based on the number of players, with a max of 12.

	for (i = 0; i < NbPredator; ++i)
	{
		AddNewZedGroupToSpawnList(0, Predator);
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
	ZedSpawnRateFactor=1.2f
	WaveValueFactor=1.2f

	bShouldLocalize=True
	Title="ZedternalReborn.WMSpecialWave_Predator"

	Name="Default__WMSpecialWave_Predator"
}
