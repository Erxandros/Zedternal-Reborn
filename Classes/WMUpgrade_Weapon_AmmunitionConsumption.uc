class WMUpgrade_Weapon_AmmunitionConsumption extends WMUpgrade_Weapon
	abstract;

var float RateOfFire;

// Flame/Freeze thrower weapons are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	if (class<KFWeap_AssaultRifle_LazerCutter>(KFW) != None)
		return False;
	else if (class<KFWeap_FlameBase>(KFW) != None)
		return True;

	return False;
}

static simulated function ModifyRateOfFire(out float InRate, float DefaultRate, int upgLevel, KFWeapon KFW)
{
	InRate = DefaultRate / (DefaultRate / InRate - default.RateOfFire * upgLevel);
}

defaultproperties
{
	RateOfFire=0.1f

	upgradeName="Ammo Consumption"
	upgradeDescription(0)="Decrease ammo consumption rate of this weapon by %x%%"
	WeaponBonus=(baseValue=0, incValue=10, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_AmmunitionConsumption"
}
