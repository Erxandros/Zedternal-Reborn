class WMSpecialWave_DoubleDamage extends WMSpecialWave;

var float Damage;

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	InDamage += Round(float(InDamage) * default.Damage);
}

defaultproperties
{
	Damage=1.0f
	zedSpawnRateFactor=1.3f
	waveValueFactor=1.3f
	doshFactor=0.75f

	Title="Double Damage"
	Description="Double your damage!"

	Name="Default__WMSpecialWave_DoubleDamage"
}
