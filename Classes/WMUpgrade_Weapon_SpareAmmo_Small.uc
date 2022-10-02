class WMUpgrade_Weapon_SpareAmmo_Small extends WMUpgrade_Weapon
	abstract;

var int SpareAmmo;

// Small spare ammo weapons are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	if (KFW.default.SpareAmmoCapacity[0] > 0 && KFW.default.SpareAmmoCapacity[0] < 8)
		return True;

	return False;
}

static simulated function ModifySpareAmmoAmount(out int InSpareAmmo, int DefaultSpareAmmo, int upgLevel, KFWeapon KFW, optional const out STraderItem TraderItem, optional bool bSecondary=False)
{
	InSpareAmmo += default.SpareAmmo * upgLevel;
}

defaultproperties
{
	SpareAmmo=2

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Weapon_SpareAmmo_Small"
	WeaponBonus=(baseValue=0, incValue=2, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_SpareAmmo_Small"
}
