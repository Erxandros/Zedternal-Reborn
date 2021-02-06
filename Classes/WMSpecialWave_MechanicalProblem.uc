class WMSpecialWave_MechanicalProblem extends WMSpecialWave;

defaultproperties
{
	zedSpawnRateFactor=0.875f
	waveValueFactor=0.7f
	doshFactor=1.6f

	Title="Mechanical Problem"
	Description="Launching Annihilation.exe"

	bReplaceMonstertoAdd=True
	MonsterToAdd(0)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=1,MClass=class'KFGameContent.KFPawn_ZedDAR_Rocket')
	MonsterToAdd(1)=(MinWave=3,MaxWave=999,MinGr=1,MaxGr=2,MClass=class'KFGameContent.KFPawn_ZedDAR_Rocket')
	MonsterToAdd(2)=(MinWave=5,MaxWave=999,MinGr=2,MaxGr=3,MClass=class'KFGameContent.KFPawn_ZedDAR_Rocket')
	MonsterToAdd(3)=(MinWave=7,MaxWave=999,MinGr=2,MaxGr=4,MClass=class'KFGameContent.KFPawn_ZedDAR_Rocket')

	Name="Default__WMSpecialWave_MechanicalProblem"
}
