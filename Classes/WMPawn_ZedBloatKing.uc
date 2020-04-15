class WMPawn_ZedBloatKing extends KFPawn_ZedBloatKing;

var AkEvent EntranceSound;

simulated event PostBeginPlay()
{
	// add entrance sound
	SoundGroupArch.EntranceSound = default.EntranceSound;
	
	Super.PostBeginPlay();
}

/** Play music for this boss (overridden for each boss) */
function PlayBossMusic()
{
}

/** Summon some children */
function SummonChildren()
{
}



function SpawnPoopMonster()
{
	local KFPawn_Monster NewZed;
	local Vector X,Y,Z;

	if (IsTimerActive(NameOf(AllowNextPoopMonster)))
	{
		++CurrentDelayedSpawns;
		return;
	}

	GetAxes(Rotation, X, Y, Z);
	NewZed = Spawn(class'KFPawn_ZedBloatKingSubspawn', , , Location  + (X * PoopMonsterOffset), Rotation, , true);
	if (NewZed != None)
	{
		NewZed.SetPhysics(PHYS_Falling);
		KFGameInfo(WorldInfo.Game).SetMonsterDefaults(NewZed);
		NewZed.SpawnDefaultController();
		NewZed.Knockdown(, vect(1, 1, 1), NewZed.Location, 1000, 100);
		if (KFAIController(NewZed.Controller) != None)
		{
			KFGameInfo(WorldInfo.Game).GetAIDirector().AIList.AddItem(KFAIController(NewZed.Controller));
			KFAIController(NewZed.Controller).SetTeam(1);
		}

		++PoopMonsterFXNotify;
		PlayPoopSpawnFX();
		
		// increase remaining zeds
		KFGameReplicationInfo(WorldInfo.GRI).AIRemaining += 1;
	}

	SetTimer(PoopMonsterSpawnDelay, false, NameOf(AllowNextPoopMonster));
}

defaultproperties
{
   EntranceSound=AkEvent'WW_ZED_Abomination.Play_Abomination_Intro_Land'
   bLargeZed=true
   DoshValue=300
   XPValues(0)=150.000000
   XPValues(1)=150.000000
   XPValues(2)=150.000000
   XPValues(3)=150.000000
   Name="Default__WMPawn_ZedBloatKing"
}
