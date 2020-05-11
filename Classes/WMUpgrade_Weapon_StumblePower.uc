Class WMUpgrade_Weapon_StumblePower extends WMUpgrade_Weapon
	abstract;

var float StumblePower;

// weapons with stumble effect (and without stun/knockdown effect) are compatible
static function bool IsUpgradeCompatible( class<KFWeapon> KFW )
{
	local float Stumble;
	local class<KFDamageType> KFDT;

	KFDT = class<KFDamageType>(KFW.default.InstantHitDamageTypes[0]);

	if (KFDT != none)
		Stumble = KFDT.default.StumblePower;
	else
		return false;

	if (Stumble > 0 && KFDT.default.StunPower == 0.000000 && KFDT.default.KnockdownPower == 0.000000)
		return true;

	return false;
}

static function ModifyStumblePower( out float InStumblePower, float DefaultStumblePower, int upgLevel, optional KFPawn KFP, optional class<KFDamageType> DamageType, optional out float CooldownModifier, optional byte BodyPart, optional KFPawn OwnerPawn)
{
	InStumblePower += DefaultStumblePower * default.StumblePower * upgLevel;
}

defaultproperties
{
	upgradeName="Stumble Effect"
	upgradeDescription(0)="Increase stumble effect of this weapon %x%%"
	WeaponBonus=(baseValue=0, incValue=50, maxValue=-1)
	StumblePower=0.500000
}
