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
	zedSpawnRateFactor=0.925f
	waveValueFactor=0.6f
	doshFactor=1.65f

	Title="HellFire"
	Description="Say welcome to Hell!"

	bReplaceMonstertoAdd=True
	MonsterToAdd(0)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=4,MClass=class'ZedternalReborn.WMPawn_ZedHusk_NoDAR')
	MonsterToAdd(1)=(MinWave=0,MaxWave=12,MinGr=2,MaxGr=5,MClass=class'ZedternalReborn.WMPawn_ZedCrawler_NoElite')
	MonsterToAdd(2)=(MinWave=5,MaxWave=999,MinGr=1,MaxGr=2,MClass=class'ZedternalReborn.WMPawn_ZedHusk_NoDAR')
	MonsterToAdd(3)=(MinWave=4,MaxWave=25,MinGr=1,MaxGr=3,MClass=class'ZedternalReborn.WMPawn_ZedCrawler_NoElite')
	MonsterToAdd(4)=(MinWave=5,MaxWave=999,MinGr=1,MaxGr=1,MClass=class'ZedternalReborn.WMPawn_ZedHusk_Omega')

	Name="Default__WMSpecialWave_HellFire"
}
