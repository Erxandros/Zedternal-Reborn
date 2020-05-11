Class WMUpgrade_Weapon_Damage_Clot extends WMUpgrade_Weapon
	abstract;

var float Damage;

// Only SWAT weapons are compatible
static function bool IsUpgradeCompatible( class<KFWeapon> KFW )
{
	if (class<KFWeap_SMGBase>(KFW) != none)
		return true;
	else if (class<KFWeap_HRG_Nailgun>(KFW) != none)
		return true;

	return false;
}

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (MyKFPM != none && KFPawn_ZedClot(MyKFPM) != none)
		InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);
}

defaultproperties
{
	upgradeName="Damage against clots"
	upgradeDescription(0)="Increase damage with this weapon %x%% against clots"
	WeaponBonus=(baseValue=0, incValue=50, maxValue=-1)
	Damage=0.500000
}
