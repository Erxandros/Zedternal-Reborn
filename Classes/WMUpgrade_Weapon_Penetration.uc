Class WMUpgrade_Weapon_Penetration extends WMUpgrade_Weapon
	abstract;

var float Penetration;

// weapons with penetration power are compatible
static function bool IsUpgradeCompatible( class<KFWeapon> KFW )
{
	if (KFW.default.PenetrationPower[0] > 0)
		return true;

	return false;
}

static simulated function ModifyPenetration( out float InPenetration, float DefaultPenetration, int upgLevel, class<KFDamageType> DamageType, KFPawn OwnerPawn, optional bool bForce)
{
	InPenetration += DefaultPenetration * default.Penetration * upgLevel;
}

defaultproperties
{
	upgradeName="Penetration"
	upgradeDescription(0)="Increase penetration power of this weapon by %x%%"
	WeaponBonus=(baseValue=0, incValue=50, maxValue=-1)
	Penetration=0.500000
}
