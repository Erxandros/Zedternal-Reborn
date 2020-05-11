Class WMUpgrade_Weapon_Damage_GroundFire extends WMUpgrade_Weapon
	abstract;

var float Damage;

// all weapons are compatible
static function bool IsUpgradeCompatible( class<KFWeapon> KFW )
{
	if (class<KFWeap_HRG_Healthrower>(KFW) != none)
		return false;
	else if (class<KFWeap_AssaultRifle_LazerCutter>(KFW) != none)
		return false;
	else if (class<KFWeap_FlameBase>(KFW) != none)
		return true;

	return false;
}

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (class<KFDT_Fire_Ground>(DamageType) != none || class<KFDT_Freeze_Ground>(DamageType) != none)
		InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);
}

defaultproperties
{
	upgradeName="Ground Fire Damage"
	upgradeDescription(0)="Increase ground fire damage dealt with this weapon by %x%%"
	WeaponBonus=(baseValue=0, incValue=15, maxValue=-1)
	Damage=0.150000
}
