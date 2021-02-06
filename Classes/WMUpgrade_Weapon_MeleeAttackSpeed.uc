class WMUpgrade_Weapon_MeleeAttackSpeed extends WMUpgrade_Weapon
	abstract;

var float MeleeAttackSpeed;

// Only Melee weapons are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	if (class<KFWeap_MeleeBase>(KFW) != None)
		return True;
	else if (class<KFWeap_Bow_CompoundBow>(KFW) != None)
		return True;

	return False;
}

static simulated function ModifyMeleeAttackSpeed(out float InDuration, float DefaultDuration, int upgLevel, KFWeapon KFW)
{
	InDuration = DefaultDuration / (DefaultDuration / InDuration + default.MeleeAttackSpeed * upgLevel);
}

defaultproperties
{
	MeleeAttackSpeed=0.15f

	upgradeName="Melee Attack Speed"
	upgradeDescription(0)="Attack %x%% faster with this weapon"
	WeaponBonus=(baseValue=0, incValue=15, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_MeleeAttackSpeed"
}
