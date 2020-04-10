class WMPawn_ZedMatriarch extends KFPawn_ZedMatriarch;

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
   EntranceSound=AkEvent'WW_ZED_Matriarch.Play_Matriarch_Jump_Land_01'
   DoshValue=500
   XPValues(0)=250.000000
   XPValues(1)=250.000000
   XPValues(2)=250.000000
   XPValues(3)=250.000000
   Name="Default__WMPawn_ZedMatriarch"
}