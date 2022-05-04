class WMUpgrade_Weapon_Recoil extends WMUpgrade_Weapon
	abstract;

var float Recoil;

// Revolvers, Rifles, SMGs and Medic weapons are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	if (KFW.default.MagazineCapacity[0] <= 1)
		return False;
	else if (class<KFWeap_Pistol_Blunderbuss>(KFW) != None)
		return False;
	else if (class<KFWeap_PistolBase>(KFW) != None)
		return True;
	else if (class<KFWeap_RifleBase>(KFW) != None)
		return True;
	else if (class<KFWeap_SMGBase>(KFW) != None)
		return True;
	else if (class<KFWeap_ScopedBase>(KFW) != None)
		return True;
	else if (class<KFWeap_MedicBase>(KFW) != None)
		return True;
	else if (class<KFWeap_Rifle_MosinNagant>(KFW) != None)
		return True;
	else if (class<KFWeap_HRG_Nailgun>(KFW) != None)
		return True;

	return False;
}

static simulated function ModifyRecoil(out float InRecoilModifier, float DefaultRecoilModifier, int upgLevel, KFWeapon KFW)
{
	InRecoilModifier -= DefaultRecoilModifier * default.Recoil * upgLevel;
}

defaultproperties
{
	Recoil=0.2f

	UpgradeName="Recoil"
	UpgradeDescription(0)="Decrease recoil of this weapon by %x%%"
	WeaponBonus=(baseValue=0, incValue=20, maxValue=95)

	Name="Default__WMUpgrade_Weapon_Recoil"
}
