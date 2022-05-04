class WMUpgrade_Weapon_StunPower extends WMUpgrade_Weapon
	abstract;

var float StunPower;

// weapons with stun effect are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	local class<KFDamageType> KFDT;

	KFDT = class<KFDamageType>(KFW.default.InstantHitDamageTypes[0]);
	if (KFDT != None && KFDT.default.StunPower > 0)
		return True;

	return False;
}

static function ModifyStunPower(out float InStunPower, float DefaultStunPower, int upgLevel, optional class<DamageType> DamageType, optional byte HitZoneIdx)
{
	InStunPower += DefaultStunPower * default.StunPower * upgLevel;
}

defaultproperties
{
	StunPower=0.25f

	UpgradeName="Stun Effect"
	UpgradeDescription(0)="Increase stun power of this weapon by %x%%"
	WeaponBonus=(baseValue=0, incValue=25, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_StunPower"
}
