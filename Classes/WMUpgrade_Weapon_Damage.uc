class WMUpgrade_Weapon_Damage extends WMUpgrade_Weapon
	abstract;

var float Damage;

// All weapons are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	return True;
}

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);
}

defaultproperties
{
	Damage=0.1f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Weapon_Damage"
	WeaponBonus=(baseValue=0, incValue=10, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_Damage"
}
