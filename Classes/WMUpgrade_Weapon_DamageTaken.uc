class WMUpgrade_Weapon_DamageTaken extends WMUpgrade_Weapon
	abstract;

var float Damage;

// Only melee weapons are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	if (KFW.default.bMeleeWeapon)
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

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Weapon_DamageTaken"
	WeaponBonus=(baseValue=0, incValue=4, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_DamageTaken"
}
