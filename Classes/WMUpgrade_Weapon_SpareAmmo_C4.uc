Class WMUpgrade_Weapon_SpareAmmo_C4 extends WMUpgrade_Weapon
	abstract;

var int SpareAmmo;

// Only C4 are compatible
static function bool IsUpgradeCompatible( class<KFWeapon> KFW )
{
	if (class<KFWeap_Thrown_C4>(KFW) != none)
		return true;
	
	return false;
}

static simulated function ModifySpareAmmoAmount( out int InSpareAmmo, int DefaultSpareAmmo, int upgLevel, KFWeapon KFW, optional const out STraderItem TraderItem, optional bool bSecondary=false )
{
	InSpareAmmo += default.SpareAmmo * upgLevel;
}


defaultproperties
{
	upgradeName="Spare Ammo"
	upgradeDescription(0)="Increase max ammo of this weapon by %x% rounds"
	WeaponBonus=(baseValue=0, incValue=2, maxValue=-1)
	SpareAmmo=2
}