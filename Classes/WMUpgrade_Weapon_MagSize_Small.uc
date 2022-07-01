class WMUpgrade_Weapon_MagSize_Small extends WMUpgrade_Weapon
	abstract;

var int MagSize;

// Small clipped weapons are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	if (KFW.default.MagazineCapacity[0] > 1 && KFW.default.MagazineCapacity[0] < 10)
		return True;

	return False;
}

static simulated function ModifyMagSizeAndNumber(out int InMagazineCapacity, int DefaultMagazineCapacity, int upgLevel, KFWeapon KFW, optional array< class<KFPerk> > WeaponPerkClass, optional bool bSecondary=False, optional name WeaponClassname)
{
	InMagazineCapacity += default.MagSize * upgLevel;
}

defaultproperties
{
	MagSize=1

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Weapon_MagSize_Small"
	WeaponBonus=(baseValue=0, incValue=1, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_MagSize_Small"
}
