class WMSpecialWave_HellFire extends WMSpecialWave;

var float Defense;

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	if (ClassIsChildOf(DamageType, class'KFDT_Fire'))
		InDamage -= DefaultDamage * default.Defense;
}

defaultproperties
{
	Defense=0.25f
	ZedSpawnRateFactor=0.85f
	WaveValueFactor=0.8f
	DoshFactor=1.15f

	bShouldLocalize=True
	Title="ZedternalReborn.WMSpecialWave_HellFire"

	bReplaceMonstertoAdd=True
	MonsterToAdd(0)=(MinWave=0,MaxWave=20,MinGr=1,MaxGr=3,MClass=class'ZedternalReborn.WMPawn_ZedHusk_NoDAR')
	MonsterToAdd(1)=(MinWave=5,MaxWave=999,MinGr=2,MaxGr=5,MClass=class'ZedternalReborn.WMPawn_ZedHusk_NoDAR')
	MonsterToAdd(2)=(MinWave=9,MaxWave=999,MinGr=1,MaxGr=2,MClass=class'ZedternalReborn.WMPawn_ZedHusk_Omega')
	MonsterToAdd(3)=(MinWave=14,MaxWave=999,MinGr=2,MaxGr=4,MClass=class'ZedternalReborn.WMPawn_ZedHusk_Omega')

	Name="Default__WMSpecialWave_HellFire"
}
