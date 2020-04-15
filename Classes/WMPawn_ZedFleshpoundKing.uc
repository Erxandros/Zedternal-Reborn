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

defaultproperties
{
   EntranceSound=AkEvent'ww_zed_fleshpound_2.Play_FP_Charge'
   DoshValue=300
   XPValues(0)=150.000000
   XPValues(1)=150.000000
   XPValues(2)=150.000000
   XPValues(3)=150.000000
   Name="Default__WMPawn_ZedFleshpoundKing"
}
