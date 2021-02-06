class WMUpgrade_Weapon_KnockdownPower extends WMUpgrade_Weapon
	abstract;

var float KnockdownPower;

// weapons with stun effect are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	local class<KFDamageType> KFDT;

	KFDT = class<KFDamageType>(KFW.default.InstantHitDamageTypes[0]);
	if (KFDT != None && KFDT.default.KnockdownPower > 0)
		return True;

	return False;
}

static function ModifyKnockdownPower(out float InKnockdownPower, float DefaultKnockdownPower, int upgLevel, KFPawn OwnerPawn, optional class<DamageType> DamageType, optional byte BodyPart, optional bool bIsSprinting=False)
{
	InKnockdownPower += DefaultKnockdownPower * default.KnockdownPower * upgLevel;
}

defaultproperties
{
	KnockdownPower=0.25f

	upgradeName="Knockdown Effect"
	upgradeDescription(0)="Increase knockdown power of this weapon by %x%%"
	WeaponBonus=(baseValue=0, incValue=25, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_KnockdownPower"
}
