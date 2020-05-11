Class WMUpgrade_Weapon_SwitchSpeed extends WMUpgrade_Weapon
	abstract;

var float Speed;

// Medic and Gunslinger weapons are compatible
static function bool IsUpgradeCompatible( class<KFWeapon> KFW )
{
	if (class<KFWeap_MedicBase>(KFW) != none)
		return true;
	else if (class<KFWeap_PistolBase>(KFW) != none)
		return true;
	else if (class<KFWeap_Rifle_M14EBR>(KFW) != none)
		return true;
	else if (class<KFWeap_Rifle_RailGun>(KFW) != none)
		return true;

	return false;
}

static simulated function ModifyWeaponSwitchTime(out float InSwitchTime, float DefaultSwitchTime, int upgLevel, KFWeapon KFW)
{
	InSwitchTime = DefaultSwitchTime / (DefaultSwitchTime/InSwitchTime + default.Speed * upgLevel);
}

defaultproperties
{
	upgradeName="Switch Speed"
	upgradeDescription(0)="Increase switch speed of this weapon by %x%%"
	WeaponBonus=(baseValue=0, incValue=50, maxValue=-1)
	Speed=0.500000
}
