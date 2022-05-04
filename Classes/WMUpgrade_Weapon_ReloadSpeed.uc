class WMUpgrade_Weapon_ReloadSpeed extends WMUpgrade_Weapon
	abstract;

var float ReloadRate;

// melee and thrown weapons are not compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	if (class<KFWeap_Rifle_MosinNagant>(KFW) != None)
		return True;
	else if (class<KFWeap_MeleeBase>(KFW) != None)
		return False;
	else if (class<KFWeap_ThrownBase>(KFW) != None)
		return False;

	return True;
}

static simulated function GetReloadRateScale(out float InReloadRateScale, int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	InReloadRateScale = 1.0f / (1.0f / InReloadRateScale + default.ReloadRate * upgLevel);
}

defaultproperties
{
	ReloadRate=0.15f

	UpgradeName="Reload Speed"
	UpgradeDescription(0)="Increase reload speed of this weapon by %x%%"
	WeaponBonus=(baseValue=0, incValue=15, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_ReloadSpeed"
}
