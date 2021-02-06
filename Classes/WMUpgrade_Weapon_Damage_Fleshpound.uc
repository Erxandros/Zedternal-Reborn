class WMUpgrade_Weapon_Damage_Fleshpound extends WMUpgrade_Weapon
	abstract;

var float Damage;

// Only demo weapons and microwave gun are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	if (class<KFWeap_GrenadeLauncher_Base>(KFW) != None)
		return True;
	else if (class<KFWeap_Pistol_Blunderbuss>(KFW) != None)
		return True;
	else if (class<KFWeap_Beam_Microwave>(KFW) != None)
		return True;
	else if (class<KFWeap_AssaultRifle_M16M203>(KFW) != None)
		return True;
	else if (class<KFWeap_Thrown_C4>(KFW) != None)
		return True;

	return False;
}

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (MyKFPM != None && KFPawn_ZedFleshpound(MyKFPM) != None)
		InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);
}

defaultproperties
{
	Damage=0.2f

	upgradeName="Damage Against Fleshpounds"
	upgradeDescription(0)="Increase damage dealt against fleshpounds with this weapon by %x%%"
	WeaponBonus=(baseValue=0, incValue=20, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_Damage_Fleshpound"
}
