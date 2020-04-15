class WMSpecialWave_DoubleDamage extends WMSpecialWave;

var float Damage;

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	InDamage += Round(float(InDamage) * default.Damage);
}

defaultproperties
{
   Title="Double Damage"
   Description="Double your damage!"
   zedSpawnRateFactor=1.300000
   waveValueFactor=1.300000
   doshFactor=0.750000
   Damage = 1.000000
   Name="Default__WMSpecialWave_DoubleDamage"
}
