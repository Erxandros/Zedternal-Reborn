class WMSpecialWave_ClotBuster extends WMSpecialWave;

defaultproperties
{
	ZedSpawnRateFactor=8.0f
	WaveValueFactor=0.8f

	bShouldLocalize=True
	Title="ZedternalReborn.WMSpecialWave_ClotBuster"

	bReplaceMonstertoAdd=True
	MonsterToAdd(0)=(MinWave=0,MaxWave=4,MinGr=4,MaxGr=6,MClass=class'KFGameContent.KFPawn_ZedClot_Cyst')
	MonsterToAdd(1)=(MinWave=2,MaxWave=8,MinGr=5,MaxGr=7,MClass=class'KFGameContent.KFPawn_ZedClot_Cyst')
	MonsterToAdd(2)=(MinWave=4,MaxWave=12,MinGr=6,MaxGr=8,MClass=class'KFGameContent.KFPawn_ZedClot_Cyst')

	MonsterToAdd(3)=(MinWave=0,MaxWave=12,MinGr=3,MaxGr=6,MClass=class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot')
	MonsterToAdd(4)=(MinWave=5,MaxWave=17,MinGr=4,MaxGr=7,MClass=class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot')
	MonsterToAdd(5)=(MinWave=10,MaxWave=23,MinGr=5,MaxGr=8,MClass=class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot')

	MonsterToAdd(6)=(MinWave=0,MaxWave=9,MinGr=2,MaxGr=4,MClass=class'KFGameContent.KFPawn_ZedClot_Slasher')
	MonsterToAdd(7)=(MinWave=3,MaxWave=12,MinGr=3,MaxGr=5,MClass=class'KFGameContent.KFPawn_ZedClot_Slasher')
	MonsterToAdd(8)=(MinWave=7,MaxWave=17,MinGr=4,MaxGr=6,MClass=class'KFGameContent.KFPawn_ZedClot_Slasher')
	MonsterToAdd(9)=(MinWave=11,MaxWave=23,MinGr=6,MaxGr=8,MClass=class'KFGameContent.KFPawn_ZedClot_Slasher')

	MonsterToAdd(10)=(MinWave=9,MaxWave=17,MinGr=1,MaxGr=2,MClass=class'KFGameContent.KFPawn_ZedClot_AlphaKing')
	MonsterToAdd(11)=(MinWave=18,MaxWave=999,MinGr=3,MaxGr=4,MClass=class'KFGameContent.KFPawn_ZedClot_AlphaKing')

	MonsterToAdd(12)=(MinWave=6,MaxWave=17,MinGr=1,MaxGr=1,MClass=class'ZedternalReborn.WMPawn_ZedClot_Slasher_Omega')
	MonsterToAdd(13)=(MinWave=12,MaxWave=23,MinGr=2,MaxGr=3,MClass=class'ZedternalReborn.WMPawn_ZedClot_Slasher_Omega')
	MonsterToAdd(14)=(MinWave=18,MaxWave=999,MinGr=4,MaxGr=6,MClass=class'ZedternalReborn.WMPawn_ZedClot_Slasher_Omega')
	MonsterToAdd(15)=(MinWave=18,MaxWave=999,MinGr=6,MaxGr=8,MClass=class'ZedternalReborn.WMPawn_ZedClot_Slasher_Omega')
	MonsterToAdd(16)=(MinWave=24,MaxWave=999,MinGr=8,MaxGr=8,MClass=class'ZedternalReborn.WMPawn_ZedClot_Slasher_Omega')

	Name="Default__WMSpecialWave_ClotBuster"
}
