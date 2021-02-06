class WMSpecialWave_ClotBuster extends WMSpecialWave;

defaultproperties
{
	zedSpawnRateFactor=4.0f
	waveValueFactor=0.6f

	Title="Clot Buster"
	Description="Hordes of clots are coming!"

	bReplaceMonstertoAdd=True
	MonsterToAdd(0)=(MinWave=0,MaxWave=999,MinGr=6,MaxGr=10,MClass=class'KFGameContent.KFPawn_ZedClot_Cyst')
	MonsterToAdd(1)=(MinWave=0,MaxWave=999,MinGr=5,MaxGr=9,MClass=class'KFGameContent.KFPawn_ZedClot_Cyst')
	MonsterToAdd(2)=(MinWave=0,MaxWave=999,MinGr=4,MaxGr=8,MClass=class'KFGameContent.KFPawn_ZedClot_Cyst')
	MonsterToAdd(3)=(MinWave=0,MaxWave=999,MinGr=3,MaxGr=6,MClass=class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot')
	MonsterToAdd(4)=(MinWave=0,MaxWave=999,MinGr=2,MaxGr=6,MClass=class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot')
	MonsterToAdd(5)=(MinWave=2,MaxWave=999,MinGr=2,MaxGr=5,MClass=class'KFGameContent.KFPawn_ZedClot_Slasher')
	MonsterToAdd(6)=(MinWave=6,MaxWave=999,MinGr=1,MaxGr=1,MClass=class'KFGameContent.KFPawn_ZedScrake')

	Name="Default__WMSpecialWave_ClotBuster"
}
