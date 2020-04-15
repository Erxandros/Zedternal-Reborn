class WMSpecialWave_ClotBuster extends WMSpecialWave;


defaultproperties
{
   Title="Clot Buster"
   Description="Hordes of clots are coming!"
   bReplaceMonstertoAdd=true
   zedSpawnRateFactor=4.00000
   waveValueFactor=0.600000
   MonsterToAdd(0)=(MinWave=0,MaxWave=999,MinGr=6,MaxGr=10,MClass=Class'KFGameContent.KFPawn_ZedClot_Cyst')
   MonsterToAdd(1)=(MinWave=0,MaxWave=999,MinGr=5,MaxGr=9,MClass=Class'KFGameContent.KFPawn_ZedClot_Cyst')
   MonsterToAdd(2)=(MinWave=0,MaxWave=999,MinGr=4,MaxGr=8,MClass=Class'KFGameContent.KFPawn_ZedClot_Cyst')
   MonsterToAdd(3)=(MinWave=0,MaxWave=999,MinGr=3,MaxGr=6,MClass=Class'KFGameContent.KFPawn_ZedClot_Alpha')
   MonsterToAdd(4)=(MinWave=0,MaxWave=999,MinGr=2,MaxGr=6,MClass=Class'KFGameContent.KFPawn_ZedClot_Alpha')
   MonsterToAdd(5)=(MinWave=2,MaxWave=999,MinGr=2,MaxGr=5,MClass=Class'KFGameContent.KFPawn_ZedClot_Slasher')
   MonsterToAdd(6)=(MinWave=6,MaxWave=999,MinGr=1,MaxGr=1,MClass=Class'KFGameContent.KFPawn_ZedScrake')
   Name="Default__WMSpecialWave_ClotBuster"
}
