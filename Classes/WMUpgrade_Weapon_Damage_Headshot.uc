class WMUpgrade_Weapon_Damage_Headshot extends WMUpgrade_Weapon
	abstract;

var float Damage;

// Revolvers, Rifles and SMGs are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	if (class<KFWeap_Pistol_Blunderbuss>(KFW) != None)
		return False;
	else if (class<KFWeap_PistolBase>(KFW) != None)
		return True;
	else if (class<KFWeap_RifleBase>(KFW) != None)
		return True;
	else if (class<KFWeap_SMGBase>(KFW) != None)
		return True;
	else if (class<KFWeap_ScopedBase>(KFW) != None)
		return True;
	else if (class<KFWeap_Rifle_MosinNagant>(KFW) != None)
		return True;
	else if (class<KFWeap_Bow_CompoundBow>(KFW) != None)
		return True;
	else if (class<KFWeap_HRG_Nailgun>(KFW) != None)
		return True;

	return False;
}

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (HitZoneIdx == HZI_HEAD)
		InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);
}

defaultproperties
{
	Damage=0.15f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Weapon_Damage_Headshot"
	WeaponBonus=(baseValue=0, incValue=15, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_Damage_Headshot"
}
