Class WMUpgrade_Weapon_ReloadSpeed extends WMUpgrade_Weapon
	abstract;

var float ReloadRate;

// melee and thrown weapons are not compatible
static function bool IsUpgradeCompatible( class<KFWeapon> KFW )
{
	if (class<KFWeap_Rifle_MosinNagant>(KFW) != none)
		return true;
	else if (class<KFWeap_MeleeBase>(KFW) != none)
		return false;
	else if (class<KFWeap_ThrownBase>(KFW) != none)
		return false;

	return true;
}

static simulated function GetReloadRateScale( out float InReloadRateScale, int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	InReloadRateScale = 1.f / (1.f/InReloadRateScale + default.ReloadRate * upgLevel);
}

defaultproperties
{
	upgradeName="Reload Speed"
	upgradeDescription(0)="Increase reload speed of this weapon by %x%%"
	WeaponBonus=(baseValue=0, incValue=15, maxValue=-1)
	ReloadRate=0.150000
}
