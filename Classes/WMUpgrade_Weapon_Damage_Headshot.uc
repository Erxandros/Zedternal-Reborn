Class WMUpgrade_Weapon_Damage_Headshot extends WMUpgrade_Weapon
	abstract;

var float Damage;

// Revolvers, Rifles and SMGs are compatible
static function bool IsUpgradeCompatible( class<KFWeapon> KFW )
{	
	if (class<KFWeap_PistolBase>(KFW) != none)
		return true;
	else if (class<KFWeap_RifleBase>(KFW) != none)
		return true;
	else if (class<KFWeap_SMGBase>(KFW) != none)
		return true;
	else if (class<KFWeap_ScopedBase>(KFW) != none)
		return true;

	return false;
}

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (HitZoneIdx == HZI_HEAD)
		InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);
}


defaultproperties
{
	upgradeName="Headshot Damage"
	upgradeDescription(0)="Increase head shot damage with this weapon %x%%"
	WeaponBonus=(baseValue=0, incValue=15, maxValue=-1)
	Damage=0.150000
}