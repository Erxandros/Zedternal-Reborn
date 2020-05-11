Class WMUpgrade_Weapon_RateOfFire extends WMUpgrade_Weapon
	abstract;

var float RateOfFire;

// Revolvers, Shotgun, Rifle, SMG and Medic weapons are compatible
static function bool IsUpgradeCompatible( class<KFWeapon> KFW )
{
	if (class<KFWeap_PistolBase>(KFW) != none)
		return true;
	else if (class<KFWeap_ShotgunBase>(KFW) != none && class<KFWeap_Shotgun_DoubleBarrel>(KFW) == none)
		return true;
	else if (class<KFWeap_RifleBase>(KFW) != none)
		return true;
	else if (class<KFWeap_SMGBase>(KFW) != none)
		return true;
	else if (class<KFWeap_MedicBase>(KFW) != none)
		return true;
	else if (class<KFWeap_Rifle_MosinNagant>(KFW) != none)
		return true;

	return false;
}

static simulated function ModifyRateOfFire( out float InRate, float DefaultRate, int upgLevel, KFWeapon KFW )
{
	InRate = DefaultRate / (DefaultRate/InRate + default.RateOfFire * upgLevel);
}

defaultproperties
{
	upgradeName="Rate Of Fire"
	upgradeDescription(0)="Increase rate of fire of this weapon by %x%%"
	WeaponBonus=(baseValue=0, incValue=15, maxValue=-1)
	RateOfFire=0.150000
}
