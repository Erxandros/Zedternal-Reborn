class WMUpgrade_Weapon_SwitchSpeed extends WMUpgrade_Weapon
	abstract;

var float Speed;

// Medic and Gunslinger weapons are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	if (class<KFWeap_Pistol_Blunderbuss>(KFW) != None)
		return False;
	else if (class<KFWeap_MedicBase>(KFW) != None)
		return True;
	else if (class<KFWeap_HRG_Healthrower>(KFW) != None)
		return True;
	else if (class<KFWeap_Rifle_HRGIncision>(KFW) != None)
		return True;
	else if (class<KFWeap_Blunt_MedicBat>(KFW) != None)
		return True;
	else if (class<KFWeap_PistolBase>(KFW) != None)
		return True;
	else if (class<KFWeap_Rifle_Winchester1894>(KFW) != None)
		return True;
	else if (class<KFWeap_GrenadeLauncher_HX25>(KFW) != None)
		return True;
	else if (class<KFWeap_Rifle_CenterfireMB464>(KFW) != None)
		return True;

	return False;
}

static simulated function ModifyWeaponSwitchTime(out float InSwitchTime, float DefaultSwitchTime, int upgLevel, KFWeapon KFW)
{
	InSwitchTime = DefaultSwitchTime / (DefaultSwitchTime / InSwitchTime + default.Speed * upgLevel);
}

defaultproperties
{
	Speed=0.5f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Weapon_SwitchSpeed"
	WeaponBonus=(baseValue=0, incValue=50, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_SwitchSpeed"
}
