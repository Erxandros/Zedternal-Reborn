class WMUpgrade_Weapon_TurretLimit extends WMUpgrade_Weapon
	abstract;

// Only sentinel is compatible for now
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	if (class<KFWeap_AutoTurret>(KFW) != None)
		return True;
	if (class<KFWeap_HRG_Warthog>(KFW) != None)
		return True;
	if (WMTurret_Interface(KFW) != None)
		return True;

	return False;
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
