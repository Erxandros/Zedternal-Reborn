class WMUpgrade_Weapon_KnockdownPower extends WMUpgrade_Weapon
	abstract;

var float KnockdownPower;

// Weapons with knockdown effect are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	local class<KFDamageType> KFDT;

	if ((KFW.default.InstantHitDamageTypes.Length - 1) >= KFW.const.DEFAULT_FIREMODE)
	{
		KFDT = class<KFDamageType>(KFW.default.InstantHitDamageTypes[KFW.const.DEFAULT_FIREMODE]);
		if (KFDT != None && KFDT.default.KnockdownPower > 0)
			return True;
	}

	if ((KFW.default.InstantHitDamageTypes.Length - 1) >= KFW.const.ALTFIRE_FIREMODE)
	{
		KFDT = class<KFDamageType>(KFW.default.InstantHitDamageTypes[KFW.const.ALTFIRE_FIREMODE]);
		if (KFDT != None && KFDT.default.KnockdownPower > 0)
			return True;
	}

	if ((KFW.default.InstantHitDamageTypes.Length - 1) >= KFW.const.CUSTOM_FIREMODE)
	{
		KFDT = class<KFDamageType>(KFW.default.InstantHitDamageTypes[KFW.const.CUSTOM_FIREMODE]);
		if (KFDT != None && KFDT.default.KnockdownPower > 0)
			return True;
	}

	return False;
}

static function ModifyKnockdownPower(out float InKnockdownPower, float DefaultKnockdownPower, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional byte BodyPart, optional bool bIsSprinting=False)
{
	InKnockdownPower += DefaultKnockdownPower * default.KnockdownPower * upgLevel;
}

defaultproperties
{
	KnockdownPower=0.15f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Weapon_KnockdownPower"
	WeaponBonus=(baseValue=0, incValue=15, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_KnockdownPower"
}
