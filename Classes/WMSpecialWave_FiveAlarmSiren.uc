class WMSpecialWave_FiveAlarmSiren extends WMSpecialWave;

var float Defense;

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	InDamage -= Round(float(DefaultDamage) * default.Defense);
}

defaultproperties
{
	Defense=0.3f
	ZedSpawnRateFactor=1.35f
	WaveValueFactor=0.7f
	DoshFactor=1.75f

	bShouldLocalize=True
	Title="ZedternalReborn.WMSpecialWave_FiveAlarmSiren"

	bReplaceMonstertoAdd=True
	MonsterToAdd(0)=(MinWave=0,MaxWave=12,MinGr=1,MaxGr=3,MClass=class'KFGameContent.KFPawn_ZedSiren')
	MonsterToAdd(1)=(MinWave=4,MaxWave=24,MinGr=2,MaxGr=5,MClass=class'KFGameContent.KFPawn_ZedSiren')
	MonsterToAdd(2)=(MinWave=8,MaxWave=999,MinGr=3,MaxGr=6,MClass=class'KFGameContent.KFPawn_ZedSiren')
	MonsterToAdd(3)=(MinWave=12,MaxWave=999,MinGr=2,MaxGr=3,MClass=class'ZedternalReborn.WMPawn_ZedSiren_Omega')
	MonsterToAdd(4)=(MinWave=20,MaxWave=999,MinGr=3,MaxGr=4,MClass=class'ZedternalReborn.WMPawn_ZedSiren_Omega')

	Name="Default__WMSpecialWave_FiveAlarmSiren"
}
