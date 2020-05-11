Class WMUpgrade_Weapon_StunPower extends WMUpgrade_Weapon
	abstract;

var float StunPower;

// weapons with stun effect are compatible
static function bool IsUpgradeCompatible( class<KFWeapon> KFW )
{
	local class<KFDamageType> KFDT;

	KFDT = class<KFDamageType>(KFW.default.InstantHitDamageTypes[0]);
	if (KFDT != none && KFDT.default.StunPower > 0)
		return true;

	return false;
}

static function ModifyStunPower( out float InStunPower, float DefaultStunPower, int upgLevel, optional class<DamageType> DamageType, optional byte HitZoneIdx)
{
	InStunPower += DefaultStunPower * default.StunPower * upgLevel;
}

defaultproperties
{
	upgradeName="Stun Effect"
	upgradeDescription(0)="Increase stun power of this weapon %x%%"
	WeaponBonus=(baseValue=0, incValue=25, maxValue=-1)
	StunPower=0.250000
}
