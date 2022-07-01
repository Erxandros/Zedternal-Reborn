class WMUpgrade_Weapon_ReloadSpeed extends WMUpgrade_Weapon
	abstract;

var float ReloadRate;

// Melee and thrown weapons are not compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	if (KFW.default.FiringStatesArray[KFW.const.RELOAD_FIREMODE] == 'Reloading' && class<KFWeap_ThrownBase>(KFW) == None)
		return True;

	return False;
}

static simulated function GetReloadRateScale(out float InReloadRateScale, int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	InReloadRateScale = 1.0f / (1.0f / InReloadRateScale + default.ReloadRate * upgLevel);
}

defaultproperties
{
	ReloadRate=0.15f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Weapon_ReloadSpeed"
	WeaponBonus=(baseValue=0, incValue=15, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_ReloadSpeed"
}
