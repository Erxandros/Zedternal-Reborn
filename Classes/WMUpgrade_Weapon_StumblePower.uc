class WMUpgrade_Weapon_StumblePower extends WMUpgrade_Weapon
	abstract;

var float StumblePower;

// weapons with stumble effect (and without stun/knockdown effect) are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	local float Stumble;
	local class<KFDamageType> KFDT;

	KFDT = class<KFDamageType>(KFW.default.InstantHitDamageTypes[0]);

	if (KFDT != None)
		Stumble = KFDT.default.StumblePower;
	else
		return False;

	if (Stumble > 0 && KFDT.default.StunPower == 0.0f && KFDT.default.KnockdownPower == 0.0f)
		return True;

	return False;
}

static function ModifyStumblePower(out float InStumblePower, float DefaultStumblePower, int upgLevel, optional KFPawn KFP, optional class<KFDamageType> DamageType, optional out float CooldownModifier, optional byte BodyPart, optional KFPawn OwnerPawn)
{
	InStumblePower += DefaultStumblePower * default.StumblePower * upgLevel;
}

defaultproperties
{
	StumblePower=0.25f

	upgradeName="Stumble Effect"
	upgradeDescription(0)="Increase stumble effect of this weapon by %x%%"
	WeaponBonus=(baseValue=0, incValue=25, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_StumblePower"
}
