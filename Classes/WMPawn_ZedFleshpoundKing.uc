class WMPawn_ZedFleshpoundKing extends KFPawn_ZedFleshpoundKing;

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
	EntranceSound=AkEvent'ww_zed_fleshpound_2.Play_FP_Charge'
	bLargeZed=true
	DoshValue=300
	XPValues(0)=150.000000
	XPValues(1)=150.000000
	XPValues(2)=150.000000
	XPValues(3)=150.000000
	MinSpawnSquadSizeType=EST_Large
	Name="Default__WMPawn_ZedFleshpoundKing"
}
