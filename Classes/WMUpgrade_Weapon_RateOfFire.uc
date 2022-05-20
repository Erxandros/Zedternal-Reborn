class WMUpgrade_Weapon_RateOfFire extends WMUpgrade_Weapon
	abstract;

var float RateOfFire;

// Revolvers, Shotgun, Rifle, SMG and Medic weapons are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	if (class<KFWeap_Pistol_Blunderbuss>(KFW) != None)
		return False;
	else if (class<KFWeap_PistolBase>(KFW) != None)
		return True;
	else if (class<KFWeap_ShotgunBase>(KFW) != None && class<KFWeap_Shotgun_DoubleBarrel>(KFW) == None)
		return True;
	else if (class<KFWeap_RifleBase>(KFW) != None)
		return True;
	else if (class<KFWeap_SMGBase>(KFW) != None)
		return True;
	else if (class<KFWeap_MedicBase>(KFW) != None)
		return True;
	else if (class<KFWeap_Rifle_MosinNagant>(KFW) != None)
		return True;

	return False;
}

static simulated function ModifyRateOfFire(out float InRate, float DefaultRate, int upgLevel, KFWeapon KFW)
{
	InRate = DefaultRate / (DefaultRate / InRate + default.RateOfFire * upgLevel);
}

defaultproperties
{
	RateOfFire=0.15f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Weapon_RateOfFire"
	WeaponBonus=(baseValue=0, incValue=15, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_RateOfFire"
}
