class WMPawn_ZedBloatKing extends KFPawn_ZedBloatKing;

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
	return False;
}

function bool CanBeGrabbed(KFPawn GrabbingPawn, optional bool bIgnoreFalling, optional bool bAllowSameTeamGrab)
{
	return False;
}

defaultproperties
{
	EntranceSound=AkEvent'WW_ZED_Abomination.Play_Abomination_Intro_Land'
	MinSpawnSquadSizeType=EST_Large
	bLargeZed=True
	DoshValue=300

	XPValues(0)=150
	XPValues(1)=150
	XPValues(2)=150
	XPValues(3)=150

	Name="Default__WMPawn_ZedBloatKing"
}
