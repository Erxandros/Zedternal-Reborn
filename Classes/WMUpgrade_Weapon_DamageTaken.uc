Class WMUpgrade_Weapon_DamageTaken extends WMUpgrade_Weapon
	abstract;

var float Damage;

// Only Melee weapons are compatible
static function bool IsUpgradeCompatible( class<KFWeapon> KFW )
{
	if (class<KFWeap_MeleeBase>(KFW) != none)
		return true;

	return false;
}

static function ModifyDamageTaken( out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	InDamage -= Round(float(DefaultDamage) * default.Damage * upgLevel);
}

defaultproperties
{
	upgradeName="Damage Taken"
	upgradeDescription(0)="Increase damage resistance %x%% while holding this weapon"
	WeaponBonus=(baseValue=0, incValue=4, maxValue=-1)
	Damage=0.040000
}