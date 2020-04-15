class WMSpecialWave_HellFire extends WMSpecialWave;

var float Defense;

static function ModifyDamageTaken( out int InDamage, int DefaultDamage, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if (ClassIsChildOf(DamageType, class'KFDT_Fire'))
		InDamage -= DefaultDamage * default.Defense;
}

defaultproperties
{
   Title="HellFire"
   Description="Say welcome to Hell!"
   zedSpawnRateFactor=0.925000
   waveValueFactor=0.600000
   doshFactor=1.650000
   bReplaceMonstertoAdd=true
   MonsterToAdd(0)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=4,MClass=Class'KFGameContent.KFPawn_ZedHusk')
   MonsterToAdd(1)=(MinWave=0,MaxWave=12,MinGr=2,MaxGr=5,MClass=Class'KFGameContent.KFPawn_ZedCrawler')
   MonsterToAdd(2)=(MinWave=5,MaxWave=999,MinGr=1,MaxGr=2,MClass=Class'KFGameContent.KFPawn_ZedHusk')
   MonsterToAdd(3)=(MinWave=4,MaxWave=25,MinGr=1,MaxGr=3,MClass=Class'KFGameContent.KFPawn_ZedCrawler')
   MonsterToAdd(4)=(MinWave=5,MaxWave=999,MinGr=1,MaxGr=1,MClass=Class'Zedternal.WMPawn_ZedHusk_Omega')
   
   Defense=0.250000

   Name="Default__WMSpecialWave_HellFire"
}
