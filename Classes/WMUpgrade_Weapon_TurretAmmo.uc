class WMUpgrade_Weapon_TurretAmmo extends WMUpgrade_Weapon
	abstract;

var float AmmoSize;

// Only sentinel is compatible for now
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	if (class<KFWeap_AutoTurret>(KFW) != None)
		return True;
	if (class<KFWeap_HRG_Warthog>(KFW) != None)
		return True;

	return False;
}

static simulated function ModifyMagSizeAndNumber(out int InMagazineCapacity, int DefaultMagazineCapacity, int upgLevel, KFWeapon KFW, optional array< class<KFPerk> > WeaponPerkClass, optional bool bSecondary=False, optional name WeaponClassname)
{
	if (KFW != None && !KFW.bCanBeReloaded && DefaultMagazineCapacity > 0)
		InMagazineCapacity += Round(float(DefaultMagazineCapacity) * default.AmmoSize * upgLevel);
}

static simulated function ModifySpareAmmoAmount(out int InSpareAmmo, int DefaultSpareAmmo, int upgLevel, KFWeapon KFW, optional const out STraderItem TraderItem, optional bool bSecondary=False)
{
	if (KFW != None && KFW.bCanBeReloaded && DefaultSpareAmmo > 0)
		InSpareAmmo += Round(float(DefaultSpareAmmo) * default.AmmoSize * upgLevel);
}

defaultproperties
{
	AmmoSize=0.3f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Weapon_TurretAmmo"
	WeaponBonus=(baseValue=0, incValue=30, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_TurretAmmo"
}
