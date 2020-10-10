class WMPawn_ZedHans extends KFPawn_ZedHans;

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
	EntranceSound=AkEvent'WW_ZED_Hans.Play_Hans_Intro_Land'
	bLargeZed=True
	DoshValue=500
	XPValues(0)=250
	XPValues(1)=250
	XPValues(2)=250
	XPValues(3)=250
	MinSpawnSquadSizeType=EST_Large
	Name="Default__WMPawn_ZedHans"
}
