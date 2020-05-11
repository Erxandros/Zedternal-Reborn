Class WMUpgrade_Weapon_Recoil extends WMUpgrade_Weapon
	abstract;

var float Recoil;

// Revolvers, Rifles, SMGs and Medic weapons are compatible
static function bool IsUpgradeCompatible( class<KFWeapon> KFW )
{
	if (KFW.default.MagazineCapacity[0] <= 1)
		return false;
	else if (class<KFWeap_PistolBase>(KFW) != none)
		return true;
	else if (class<KFWeap_RifleBase>(KFW) != none)
		return true;
	else if (class<KFWeap_SMGBase>(KFW) != none)
		return true;
	else if (class<KFWeap_ScopedBase>(KFW) != none)
		return true;
	else if (class<KFWeap_MedicBase>(KFW) != none)
		return true;
	else if (class<KFWeap_Rifle_MosinNagant>(KFW) != none)
		return true;
	else if (class<KFWeap_HRG_Nailgun>(KFW) != none)
		return true;

	return false;
}

static simulated function ModifyRecoil( out float InRecoilModifier, float DefaultRecoilModifier, int upgLevel, KFWeapon KFW)
{
	InRecoilModifier -= DefaultRecoilModifier * default.Recoil * upgLevel;
}

defaultproperties
{
	upgradeName="Recoil"
	upgradeDescription(0)="Decrease recoil of this weapon by %x%%"
	WeaponBonus=(baseValue=0, incValue=20, maxValue=95)
	Recoil=0.200000
}
