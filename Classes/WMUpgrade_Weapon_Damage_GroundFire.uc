class WMUpgrade_Weapon_Damage_GroundFire extends WMUpgrade_Weapon
	abstract;

var float Damage;

// all weapons are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	if (class<KFWeap_HRG_Healthrower>(KFW) != None)
		return False;
	else if (class<KFWeap_AssaultRifle_LazerCutter>(KFW) != None)
		return False;
	else if (class<KFWeap_ShrinkRayGun>(KFW) != None)
		return False;
	else if (class<KFWeap_FlameBase>(KFW) != None)
		return True;

	return False;
}

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (ClassIsChildOf(DamageType, class'KFDT_Fire_Ground') || ClassIsChildOf(DamageType, class'KFDT_Freeze_Ground'))
		InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);
}

defaultproperties
{
	Damage=0.15f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Weapon_Damage_GroundFire"
	WeaponBonus=(baseValue=0, incValue=15, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_Damage_GroundFire"
}
