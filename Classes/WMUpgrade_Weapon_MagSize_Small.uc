Class WMUpgrade_Weapon_MagSize_Small extends WMUpgrade_Weapon
	abstract;

var int MagSize;

// small cliped weapons are compatible
static function bool IsUpgradeCompatible( class<KFWeapon> KFW )
{
	if (KFW.default.MagazineCapacity[0] >= 5 && KFW.default.MagazineCapacity[0] < 10)
		return true;
	
	return false;
}

static simulated function ModifyMagSizeAndNumber( out int InMagazineCapacity, int DefaultMagazineCapacity, int upgLevel, KFWeapon KFW, optional array< Class<KFPerk> > WeaponPerkClass, optional bool bSecondary=false, optional name WeaponClassname )
{
	InMagazineCapacity += default.MagSize * upgLevel;
}


defaultproperties
{
	upgradeName="Magazine Size"
	upgradeDescription(0)="Increase magazine capacity of this weapon by %x% round(s)"
	WeaponBonus=(baseValue=0, incValue=1, maxValue=-1)
	MagSize=1
}