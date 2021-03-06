class WMSpecialWave_Poundamonium extends WMSpecialWave;

var float Damage;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	InDamage += Round(float(DefaultDamage) * default.Damage);
}

defaultproperties
{
	Damage=0.4f
	zedSpawnRateFactor=0.7f
	waveValueFactor=0.8f
	doshFactor=1.25f

	Title="Poundamonium"
	Description="The Fleshpound Convention is in town!"

	bReplaceMonstertoAdd=True
	MonsterToAdd(0)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=2,MClass=class'KFGameContent.KFPawn_ZedFleshpound')
	MonsterToAdd(1)=(MinWave=4,MaxWave=999,MinGr=1,MaxGr=2,MClass=class'KFGameContent.KFPawn_ZedFleshpound')
	MonsterToAdd(2)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=2,MClass=class'ZedternalReborn.WMPawn_ZedClot_Alpha_NoRiot')
	MonsterToAdd(3)=(MinWave=12,MaxWave=999,MinGr=1,MaxGr=1,MClass=class'ZedternalReborn.WMPawn_ZedFleshpound_Omega')
	MonsterToAdd(4)=(MinWave=6,MaxWave=999,MinGr=1,MaxGr=2,MClass=class'KFGameContent.KFPawn_ZedFleshpound')
	MonsterToAdd(5)=(MinWave=0,MaxWave=999,MinGr=1,MaxGr=4,MClass=class'KFGameContent.KFPawn_ZedFleshpoundMini')

	Name="Default__WMSpecialWave_Poundamonium"
}
