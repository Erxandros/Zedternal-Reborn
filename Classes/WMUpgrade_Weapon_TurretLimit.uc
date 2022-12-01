class WMUpgrade_Weapon_TurretLimit extends WMUpgrade_Weapon
	abstract;

// Only sentinel is compatible for now
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	return class<KFWeap_AutoTurret>(KFW) != None;
}

static simulated function ModifyMaxDeployed(out int InMaxDeployed, int DefaultMaxDeployed, int upgLevel, KFWeapon KFW)
{
	InMaxDeployed += upgLevel;
}

defaultproperties
{
	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Weapon_TurretLimit"
	WeaponBonus=(baseValue=0, incValue=1, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_TurretLimit"
}
