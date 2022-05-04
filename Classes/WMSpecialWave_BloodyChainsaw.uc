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
	WaveValueFactor=0.8f
	DoshFactor=1.25f

	Title="Bloody Chainsaws"
	Description="Scrakes are everywhere!"

	bReplaceMonstertoAdd=True
	MonsterToAdd(0)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=1,MClass=class'KFGameContent.KFPawn_ZedScrake')
	MonsterToAdd(1)=(MinWave=4,MaxWave=999,MinGr=1,MaxGr=3,MClass=class'KFGameContent.KFPawn_ZedScrake')
	MonsterToAdd(2)=(MinWave=6,MaxWave=999,MinGr=1,MaxGr=5,MClass=class'KFGameContent.KFPawn_ZedScrake')
	MonsterToAdd(3)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=3,MClass=class'KFGameContent.KFPawn_ZedClot_Cyst')
	MonsterToAdd(4)=(MinWave=9,MaxWave=999,MinGr=1,MaxGr=2,MClass=class'ZedternalReborn.WMPawn_ZedScrake_Omega')
	MonsterToAdd(5)=(MinWave=7,MaxWave=999,MinGr=1,MaxGr=5,MClass=class'KFGameContent.KFPawn_ZedScrake')
	MonsterToAdd(6)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=1,MClass=class'ZedternalReborn.WMPawn_ZedScrake_Tiny')

	Name="Default__WMSpecialWave_BloodyChainsaw"
}
