class WMUpgrade_Weapon_TurretVision extends WMUpgrade_Weapon
	abstract;

var float Damage;

// Only sentinel is compatible for now
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	if (class<KFWeap_AutoTurret>(KFW) != None)
		return True;
	if (class<KFWeap_HRG_Warthog>(KFW) != None)
		return True;

	return False;
}

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (MyKFPM != None && KFPawn_ZedStalker(MyKFPM) != None)
		InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);
}

static simulated function bool CanSeeCloaked(int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	return True;
}

defaultproperties
{
	Damage=0.3f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Weapon_TurretVision"
	WeaponBonus=(baseValue=0, incValue=30, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_TurretVision"
}
