class WMSpecialWave_BloodyChainsaw extends WMSpecialWave;

var float Damage;

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	InDamage += Round(float(DefaultDamage) * default.Damage);
}

defaultproperties
{
   Title="Bloody Chainsaws"
   Description="Scrakes are everywhere!"
   zedSpawnRateFactor=0.700000
   waveValueFactor=0.800000
   doshFactor=1.250000
   bReplaceMonstertoAdd=true
   MonsterToAdd(0)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=1,MClass=Class'KFGameContent.KFPawn_ZedScrake')
   MonsterToAdd(1)=(MinWave=4,MaxWave=999,MinGr=1,MaxGr=3,MClass=Class'KFGameContent.KFPawn_ZedScrake')
   MonsterToAdd(2)=(MinWave=6,MaxWave=999,MinGr=1,MaxGr=5,MClass=Class'KFGameContent.KFPawn_ZedScrake')
   MonsterToAdd(3)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=3,MClass=Class'KFGameContent.KFPawn_ZedClot_Cyst')
   MonsterToAdd(4)=(MinWave=9,MaxWave=999,MinGr=1,MaxGr=2,MClass=Class'ZedternalReborn.WMPawn_ZedScrake_Omega')
   MonsterToAdd(5)=(MinWave=7,MaxWave=999,MinGr=1,MaxGr=5,MClass=Class'KFGameContent.KFPawn_ZedScrake')
   MonsterToAdd(6)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=1,MClass=Class'ZedternalReborn.WMPawn_ZedScrake_Tiny')
   
   Damage = 0.600000
   
   Name="Default__WMSpecialWave_BloodyChainsaw"
}
