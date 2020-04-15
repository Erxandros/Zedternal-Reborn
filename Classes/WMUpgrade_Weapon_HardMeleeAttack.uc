Class WMUpgrade_Weapon_HardMeleeAttack extends WMUpgrade_Weapon
	abstract;

var float Damage;

// Only Melee weapons are compatible
static function bool IsUpgradeCompatible( class<KFWeapon> KFW )
{
	if (class<KFWeap_MeleeBase>(KFW) != none)
		return true;

	return false;
}

static function ModifyHardAttackDamage( out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn)
{
	InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);
}


defaultproperties
{
	upgradeName="Hard Melee Attack Damage"
	upgradeDescription(0)="Increase hard melee attack damage dealt with this weapon by %x%%"
	WeaponBonus=(baseValue=0, incValue=15, maxValue=-1)
	Damage=0.150000
}