class WMUpgrade_Weapon_StunPower extends WMUpgrade_Weapon
	abstract;

var float StunPower;

// Weapons with stun effect are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	local class<KFDamageType> KFDT;

	if ((KFW.default.InstantHitDamageTypes.Length - 1) >= KFW.const.DEFAULT_FIREMODE)
	{
		KFDT = class<KFDamageType>(KFW.default.InstantHitDamageTypes[KFW.const.DEFAULT_FIREMODE]);
		if (KFDT != None && KFDT.default.StunPower > 0)
			return True;
	}

	if ((KFW.default.InstantHitDamageTypes.Length - 1) >= KFW.const.ALTFIRE_FIREMODE)
	{
		KFDT = class<KFDamageType>(KFW.default.InstantHitDamageTypes[KFW.const.ALTFIRE_FIREMODE]);
		if (KFDT != None && KFDT.default.StunPower > 0)
			return True;
	}

	if ((KFW.default.InstantHitDamageTypes.Length - 1) >= KFW.const.CUSTOM_FIREMODE)
	{
		KFDT = class<KFDamageType>(KFW.default.InstantHitDamageTypes[KFW.const.CUSTOM_FIREMODE]);
		if (KFDT != None && KFDT.default.StunPower > 0)
			return True;
	}

	return False;
}

static function ModifyStunPower(out float InStunPower, float DefaultStunPower, int upgLevel, optional class<DamageType> DamageType, optional byte HitZoneIdx)
{
	InStunPower += DefaultStunPower * default.StunPower * upgLevel;
}

defaultproperties
{
	StunPower=0.25f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Weapon_StunPower"
	WeaponBonus=(baseValue=0, incValue=25, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_StunPower"
}
