class WMUpgrade_Weapon_MagSize extends WMUpgrade_Weapon
	abstract;

var float MagSize;

// large clipped weapons and revolver are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	if (KFW.default.MagazineCapacity[0] >= 10)
		return True;

	return False;
}

static simulated function ModifyMagSizeAndNumber(out int InMagazineCapacity, int DefaultMagazineCapacity, int upgLevel, KFWeapon KFW, optional array< class<KFPerk> > WeaponPerkClass, optional bool bSecondary=False, optional name WeaponClassname)
{
	InMagazineCapacity += Round(float(DefaultMagazineCapacity) * default.MagSize * upgLevel);
}

defaultproperties
{
	MagSize=0.15f

	upgradeName="Magazine Size"
	upgradeDescription(0)="Increase magazine capacity of this weapon by %x%%"
	WeaponBonus=(baseValue=0, incValue=15, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_MagSize"
}
