class WMUpgrade_Weapon_StumblePower extends WMUpgrade_Weapon
	abstract;

var float StumblePower;

// Weapons with stumble effect (and without stun/knockdown effect) are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	local class<KFDamageType> KFDT;

	if ((KFW.default.InstantHitDamageTypes.Length - 1) >= KFW.const.DEFAULT_FIREMODE)
	{
		KFDT = class<KFDamageType>(KFW.default.InstantHitDamageTypes[KFW.const.DEFAULT_FIREMODE]);
		if (KFDT != None && KFDT.default.StumblePower > 0 && KFDT.default.StunPower == 0.0f && KFDT.default.KnockdownPower == 0.0f)
			return True;
	}

	if ((KFW.default.InstantHitDamageTypes.Length - 1) >= KFW.const.ALTFIRE_FIREMODE)
	{
		KFDT = class<KFDamageType>(KFW.default.InstantHitDamageTypes[KFW.const.ALTFIRE_FIREMODE]);
		if (KFDT != None && KFDT.default.StumblePower > 0 && KFDT.default.StunPower == 0.0f && KFDT.default.KnockdownPower == 0.0f)
			return True;
	}

	if ((KFW.default.InstantHitDamageTypes.Length - 1) >= KFW.const.CUSTOM_FIREMODE)
	{
		KFDT = class<KFDamageType>(KFW.default.InstantHitDamageTypes[KFW.const.CUSTOM_FIREMODE]);
		if (KFDT != None && KFDT.default.StumblePower > 0 && KFDT.default.StunPower == 0.0f && KFDT.default.KnockdownPower == 0.0f)
			return True;
	}

	return False;
}

static function ModifyStumblePower(out float InStumblePower, float DefaultStumblePower, int upgLevel, optional KFPawn KFP, optional class<KFDamageType> DamageType, optional out float CooldownModifier, optional byte BodyPart, optional KFPawn OwnerPawn)
{
	InStumblePower += DefaultStumblePower * default.StumblePower * upgLevel;
}

defaultproperties
{
	StumblePower=0.25f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Weapon_StumblePower"
	WeaponBonus=(baseValue=0, incValue=25, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_StumblePower"
}
