Class WMUpgrade_Weapon_MeleeAttackSpeed extends WMUpgrade_Weapon
	abstract;

var float MeleeAttackSpeed;

// Only Melee weapons are compatible
static function bool IsUpgradeCompatible( class<KFWeapon> KFW )
{
	if (class<KFWeap_MeleeBase>(KFW) != none)
		return true;
	else if (class<KFWeap_Bow_CompoundBow>(KFW) != none)
		return true;

	return false;
}

static simulated function ModifyMeleeAttackSpeed( out float InDuration, float DefaultDuration, int upgLevel, KFWeapon KFW)
{
	InDuration = DefaultDuration / (DefaultDuration/InDuration + default.MeleeAttackSpeed * upgLevel);
}

defaultproperties
{
	upgradeName="Melee Attack Speed"
	upgradeDescription(0)="Attack %x%% faster with this weapon"
	WeaponBonus=(baseValue=0, incValue=15, maxValue=-1)
	MeleeAttackSpeed=0.150000
}
