class WMUpgrade_Weapon_DamageTaken extends WMUpgrade_Weapon
	abstract;

var float Damage;

// Only Melee weapons are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	if (class<KFWeap_MeleeBase>(KFW) != None)
		return True;
	else if (class<KFWeap_Bow_CompoundBow>(KFW) != None)
		return True;
	else if (class<KFWeap_SMG_G18>(KFW) != None)
		return True;

	return False;
}

static function ModifyDamageTaken(out int InDamage, int DefaultDamage, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional Controller InstigatedBy, optional KFWeapon MyKFW)
{
	InDamage -= Round(float(DefaultDamage) * default.Damage * upgLevel);
}

defaultproperties
{
	Damage=0.04f

	UpgradeName="Damage Taken"
	UpgradeDescription(0)="Increase damage resistance by %x%% while holding this weapon"
	WeaponBonus=(baseValue=0, incValue=4, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_DamageTaken"
}
