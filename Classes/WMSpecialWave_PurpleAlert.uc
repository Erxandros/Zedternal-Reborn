class WMSpecialWave_PurpleAlert extends WMSpecialWave;

defaultproperties
{
	ZedSpawnRateFactor=0.85f
	WaveValueFactor=1.1f
	DoshFactor=1.25f

	bShouldLocalize=True
	Title="ZedternalReborn.WMSpecialWave_PurpleAlert"

	bReplaceMonstertoAdd=True
	MonsterToAdd(0)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=4,MClass=class'ZedternalReborn.WMPawn_ZedClot_Slasher_Omega')
	MonsterToAdd(1)=(MinWave=0,MaxWave=999,MinGr=2,MaxGr=4,MClass=class'ZedternalReborn.WMPawn_ZedClot_Slasher_Omega')
	MonsterToAdd(2)=(MinWave=0,MaxWave=999,MinGr=2,MaxGr=5,MClass=class'ZedternalReborn.WMPawn_ZedStalker_Omega')
	MonsterToAdd(3)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=3,MClass=class'ZedternalReborn.WMPawn_ZedGorefast_Omega')
	MonsterToAdd(4)=(MinWave=6,MaxWave=999,MinGr=1,MaxGr=2,MClass=class'ZedternalReborn.WMPawn_ZedHusk_Omega')
	MonsterToAdd(5)=(MinWave=7,MaxWave=999,MinGr=1,MaxGr=2,MClass=class'ZedternalReborn.WMPawn_ZedSiren_Omega')
	MonsterToAdd(6)=(MinWave=8,MaxWave=999,MinGr=1,MaxGr=1,MClass=class'ZedternalReborn.WMPawn_ZedScrake_Omega')
	MonsterToAdd(7)=(MinWave=11,MaxWave=999,MinGr=1,MaxGr=1,MClass=class'ZedternalReborn.WMPawn_ZedFleshpound_Omega')

	Name="Default__WMSpecialWave_PurpleAlert"
}
