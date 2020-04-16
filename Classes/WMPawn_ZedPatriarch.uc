class WMPawn_ZedPatriarch extends KFPawn_ZedPatriarch;

var AkEvent EntranceSound;

simulated event PostBeginPlay()
{
	// add entrance sound
	SoundGroupArch.EntranceSound = default.EntranceSound;
	
    Super.PostBeginPlay();
}


/** Summon some children */
function SummonChildren()
{
}

/** Play music for this boss (overridden for each boss) */
function PlayBossMusic()
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
   EntranceSound=AkEvent'WW_ZED_Patriarch.Play_Pat_Intro_Roar'
   DoshValue=500
   XPValues(0)=250.000000
   XPValues(1)=250.000000
   XPValues(2)=250.000000
   XPValues(3)=250.000000
   MinSpawnSquadSizeType=EST_Large
   Name="Default__WMPawn_ZedPatriarch"
}
