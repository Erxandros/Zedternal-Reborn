class WMSpecialWave_BloodyChainsaw extends WMSpecialWave;

var float Damage;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	InDamage += Round(float(DefaultDamage) * default.Damage);
}

defaultproperties
{
	Damage=0.6f
	ZedSpawnRateFactor=0.7f
	WaveValueFactor=1.2f
	DoshFactor=1.25f

	bShouldLocalize=True
	Title="ZedternalReborn.WMSpecialWave_BloodyChainsaw"

	bReplaceMonstertoAdd=True
	MonsterToAdd(0)=(MinWave=0,MaxWave=5,MinGr=1,MaxGr=1,MClass=class'KFGameContent.KFPawn_ZedScrake')
	MonsterToAdd(1)=(MinWave=5,MaxWave=999,MinGr=1,MaxGr=3,MClass=class'KFGameContent.KFPawn_ZedScrake')
	MonsterToAdd(2)=(MinWave=12,MaxWave=999,MinGr=2,MaxGr=5,MClass=class'KFGameContent.KFPawn_ZedScrake')
	MonsterToAdd(3)=(MinWave=0,MaxWave=7,MinGr=1,MaxGr=1,MClass=class'ZedternalReborn.WMPawn_ZedScrake_Tiny')
	MonsterToAdd(4)=(MinWave=7,MaxWave=999,MinGr=2,MaxGr=4,MClass=class'ZedternalReborn.WMPawn_ZedScrake_Tiny')
	MonsterToAdd(5)=(MinWave=9,MaxWave=999,MinGr=1,MaxGr=2,MClass=class'ZedternalReborn.WMPawn_ZedScrake_Omega')
	MonsterToAdd(6)=(MinWave=16,MaxWave=999,MinGr=2,MaxGr=5,MClass=class'ZedternalReborn.WMPawn_ZedScrake_Omega')

	Name="Default__WMSpecialWave_BloodyChainsaw"
}
