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

static simulated event bool IsABoss()
{ 
   return false; 
}

function bool CanBeGrabbed(KFPawn GrabbingPawn, optional bool bIgnoreFalling, optional bool bAllowSameTeamGrab)
{
	return false;
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
   MinSpawnSquadSizeType=EST_Large
   Name="Default__WMPawn_ZedBloatKing"
}
