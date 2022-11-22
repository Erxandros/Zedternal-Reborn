class WMSpecialWave_ClotBuster extends WMSpecialWave;

defaultproperties
{
	ZedSpawnRateFactor=4.0f
	WaveValueFactor=0.8f

	bShouldLocalize=True
	Title="ZedternalReborn.WMSpecialWave_ClotBuster"

	bReplaceMonstertoAdd=True
	MonsterToAdd(0)=(MinWave=0,MaxWave=8,MinGr=4,MaxGr=8,MClass=class'KFGameContent.KFPawn_ZedClot_Cyst')
	MonsterToAdd(1)=(MinWave=0,MaxWave=16,MinGr=5,MaxGr=8,MClass=class'KFGameContent.KFPawn_ZedClot_Cyst')
	MonsterToAdd(2)=(MinWave=0,MaxWave=999,MinGr=6,MaxGr=8,MClass=class'KFGameContent.KFPawn_ZedClot_Cyst')
	MonsterToAdd(3)=(MinWave=0,MaxWave=14,MinGr=2,MaxGr=6,MClass=class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot')
	MonsterToAdd(4)=(MinWave=0,MaxWave=999,MinGr=3,MaxGr=7,MClass=class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot')
	MonsterToAdd(5)=(MinWave=2,MaxWave=22,MinGr=2,MaxGr=5,MClass=class'KFGameContent.KFPawn_ZedClot_Slasher')
	MonsterToAdd(6)=(MinWave=4,MaxWave=999,MinGr=4,MaxGr=6,MClass=class'KFGameContent.KFPawn_ZedClot_Slasher')
	MonsterToAdd(7)=(MinWave=6,MaxWave=16,MinGr=1,MaxGr=1,MClass=class'ZedternalReborn.WMPawn_ZedClot_Slasher_Omega')
	MonsterToAdd(8)=(MinWave=14,MaxWave=999,MinGr=2,MaxGr=4,MClass=class'ZedternalReborn.WMPawn_ZedClot_Slasher_Omega')
	MonsterToAdd(9)=(MinWave=22,MaxWave=999,MinGr=3,MaxGr=6,MClass=class'ZedternalReborn.WMPawn_ZedClot_Slasher_Omega')
	MonsterToAdd(10)=(MinWave=32,MaxWave=999,MinGr=5,MaxGr=8,MClass=class'ZedternalReborn.WMPawn_ZedClot_Slasher_Omega')

	Name="Default__WMSpecialWave_ClotBuster"
}
