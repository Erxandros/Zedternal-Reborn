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

defaultproperties
{
   EntranceSound=AkEvent'WW_ZED_Hans.Play_Hans_Intro_Land'
   DoshValue=500
   XPValues(0)=250.000000
   XPValues(1)=250.000000
   XPValues(2)=250.000000
   XPValues(3)=250.000000   
   Name="Default__WMPawn_ZedHans"
}
