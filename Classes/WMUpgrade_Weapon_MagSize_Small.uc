class WMUpgrade_Weapon_MagSize_Small extends WMUpgrade_Weapon
	abstract;

var int MagSize;

// small clipped weapons are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	if (KFW.default.MagazineCapacity[0] >= 5 && KFW.default.MagazineCapacity[0] < 10)
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

	UpgradeName="Magazine Size"
	UpgradeDescription(0)="Increase magazine capacity of this weapon by %x% round(s)"
	WeaponBonus=(baseValue=0, incValue=1, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_MagSize_Small"
}
