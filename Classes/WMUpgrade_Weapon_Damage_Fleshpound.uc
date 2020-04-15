Class WMUpgrade_Weapon_Damage_Fleshpound extends WMUpgrade_Weapon
	abstract;

var float Damage;

// Only demolitionist weapons and microwavegun are compatible
static function bool IsUpgradeCompatible( class<KFWeapon> KFW )
{
	if (class<KFWeap_GrenadeLauncher_Base>(KFW) != none)
		return true;
	else if (class<KFWeap_Beam_Microwave>(KFW) != none)
		return true;
	else if (class<KFWeap_AssaultRifle_M16M203>(KFW) != none)
		return true;
	else if (class<KFWeap_Thrown_C4>(KFW) != none)
		return true;
	
	return false;
}

static function ModifyDamageGiven( out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (MyKFPM != none && KFPawn_ZedFleshpound(MyKFPM) != none)
		InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);
}


defaultproperties
{
	upgradeName="Damage against fleshpound"
	upgradeDescription(0)="Increase damage with this weapon %x%% against fleshpound"
	WeaponBonus=(baseValue=0, incValue=20, maxValue=-1)
	Damage=0.200000
}