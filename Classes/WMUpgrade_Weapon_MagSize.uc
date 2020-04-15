Class WMUpgrade_Weapon_MagSize extends WMUpgrade_Weapon
	abstract;

var float MagSize;

// large cliped weapons and revolver are compatible
static function bool IsUpgradeCompatible( class<KFWeapon> KFW )
{
	if (KFW.default.MagazineCapacity[0] >= 10)
		return true;
	
	return false;
}

static simulated function ModifyMagSizeAndNumber( out int InMagazineCapacity, int DefaultMagazineCapacity, int upgLevel, KFWeapon KFW, optional array< Class<KFPerk> > WeaponPerkClass, optional bool bSecondary=false, optional name WeaponClassname )
{
	InMagazineCapacity += Round(float(DefaultMagazineCapacity) * default.MagSize * upgLevel);
}


defaultproperties
{
	upgradeName="Magazine Size"
	upgradeDescription(0)="Increase magazine capacity of this weapon %x%%"
	WeaponBonus=(baseValue=0, incValue=15, maxValue=-1)
	MagSize=0.150000
}