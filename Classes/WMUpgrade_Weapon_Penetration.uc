class WMUpgrade_Weapon_Penetration extends WMUpgrade_Weapon
	abstract;

var float Penetration;

// Weapons with penetration power are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	if ((KFW.default.PenetrationPower.Length - 1) >= KFW.const.DEFAULT_FIREMODE && KFW.default.PenetrationPower[KFW.const.DEFAULT_FIREMODE] > 0)
		return True;
	if ((KFW.default.PenetrationPower.Length - 1) >= KFW.const.ALTFIRE_FIREMODE && KFW.default.PenetrationPower[KFW.const.ALTFIRE_FIREMODE] > 0)
		return True;
	if ((KFW.default.PenetrationPower.Length - 1) >= KFW.const.CUSTOM_FIREMODE && KFW.default.PenetrationPower[KFW.const.CUSTOM_FIREMODE] > 0)
		return True;

	return False;
}

static simulated function ModifyPenetration(out float InPenetration, float DefaultPenetration, int upgLevel, class<KFDamageType> DamageType, KFPawn OwnerPawn, optional bool bForce)
{
	InPenetration += DefaultPenetration * default.Penetration * upgLevel;
}

defaultproperties
{
	Penetration=0.5f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Weapon_Penetration"
	WeaponBonus=(baseValue=0, incValue=50, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_Penetration"
}
