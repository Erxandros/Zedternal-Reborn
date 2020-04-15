class WMSpecialWave_PurpleAlert extends WMSpecialWave;

defaultproperties
{
   Title="Purple Alert"
   Description="Elite ZEDs incoming!"
   bReplaceMonstertoAdd=true
   zedSpawnRateFactor=0.850000
   waveValueFactor=0.800000
   doshFactor=1.250000
   MonsterToAdd(0)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=4,MClass=Class'Zedternal.WMPawn_ZedClot_Slasher_Omega')
   MonsterToAdd(1)=(MinWave=0,MaxWave=999,MinGr=2,MaxGr=4,MClass=Class'Zedternal.WMPawn_ZedClot_Slasher_Omega')
   MonsterToAdd(2)=(MinWave=0,MaxWave=999,MinGr=2,MaxGr=5,MClass=Class'Zedternal.WMPawn_ZedStalker_Omega')
   MonsterToAdd(3)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=3,MClass=Class'Zedternal.WMPawn_ZedGorefast_Omega')
   MonsterToAdd(5)=(MinWave=6,MaxWave=999,MinGr=1,MaxGr=2,MClass=Class'Zedternal.WMPawn_ZedHusk_Omega')
   MonsterToAdd(6)=(MinWave=8,MaxWave=999,MinGr=1,MaxGr=1,MClass=Class'Zedternal.WMPawn_ZedScrake_Omega')
   MonsterToAdd(7)=(MinWave=11,MaxWave=999,MinGr=1,MaxGr=1,MClass=Class'Zedternal.WMPawn_ZedFleshpound_Omega')
   Name="Default__WMSpecialWave_PurpleAlert"
}
