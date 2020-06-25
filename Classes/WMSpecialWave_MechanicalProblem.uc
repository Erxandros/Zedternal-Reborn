class WMSpecialWave_MechanicalProblem extends WMSpecialWave;

defaultproperties
{
	Title="Mechanical Problem"
	Description="Launching Annihilation.exe"
	bReplaceMonstertoAdd=true
	zedSpawnRateFactor=0.875000
	waveValueFactor=0.700000
	doshFactor=1.600000
	MonsterToAdd(0)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=1,MClass=Class'KFGameContent.KFPawn_ZedDAR_Rocket')
	MonsterToAdd(1)=(MinWave=3,MaxWave=999,MinGr=1,MaxGr=2,MClass=Class'KFGameContent.KFPawn_ZedDAR_Rocket')
	MonsterToAdd(2)=(MinWave=5,MaxWave=999,MinGr=2,MaxGr=3,MClass=Class'KFGameContent.KFPawn_ZedDAR_Rocket')
	MonsterToAdd(3)=(MinWave=7,MaxWave=999,MinGr=2,MaxGr=4,MClass=Class'KFGameContent.KFPawn_ZedDAR_Rocket')

	Name="Default__WMSpecialWave_MechanicalProblem"
}
