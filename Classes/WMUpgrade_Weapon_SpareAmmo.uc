Class WMUpgrade_Weapon_SpareAmmo extends WMUpgrade_Weapon
	abstract;

var float SpareAmmo;

// large spare ammo weapons are compatible
static function bool IsUpgradeCompatible( class<KFWeapon> KFW )
{
	if (KFW.default.SpareAmmoCapacity[0] >= 7)
		return true;

	return false;
}

static simulated function ModifySpareAmmoAmount( out int InSpareAmmo, int DefaultSpareAmmo, int upgLevel, KFWeapon KFW, optional const out STraderItem TraderItem, optional bool bSecondary=false )
{
	if (!bSecondary)
		InSpareAmmo += Round(float(DefaultSpareAmmo) * default.SpareAmmo * upgLevel);
}

defaultproperties
{
	upgradeName="Spare Ammo"
	upgradeDescription(0)="Carry up to %x%% more ammo for this weapon"
	WeaponBonus=(baseValue=0, incValue=15, maxValue=-1)
	SpareAmmo=0.150000
}
