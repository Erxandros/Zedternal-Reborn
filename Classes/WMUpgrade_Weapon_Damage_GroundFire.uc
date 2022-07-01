class WMUpgrade_Weapon_Damage_GroundFire extends WMUpgrade_Weapon
	abstract;

var float Damage;

// Weapons with ground fire are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	if (class<KFWeap_AssaultRifle_HRGIncendiaryRifle>(KFW) != None)
		return True;
	if (class<KFWeap_Beam_Microwave>(KFW) != None)
		return True;
	if (class<KFWeap_Flame_CaulkBurn>(KFW) != None)
		return True;
	if (class<KFWeap_Flame_Flamethrower>(KFW) != None)
		return True;
	if (class<KFWeap_HuskCannon>(KFW) != None)
		return True;
	if (class<KFWeap_Ice_FreezeThrower>(KFW) != None)
		return True;
	if (class<KFWeap_Pistol_Flare>(KFW) != None)
		return True;
	if (class<KFWeap_Pistol_HRGScorcher>(KFW) != None)
		return True;
	if (class<KFWeap_Shotgun_DragonsBreath>(KFW) != None)
		return True;
	if (class<KFWeap_RocketLauncher_ThermiteBore>(KFW) != None)
		return True;

	return False;
}

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (ClassIsChildOf(DamageType, class'KFDT_Fire_Ground') || ClassIsChildOf(DamageType, class'KFDT_Freeze_Ground'))
		InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);
}

defaultproperties
{
	Damage=0.15f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Weapon_Damage_GroundFire"
	WeaponBonus=(baseValue=0, incValue=15, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_Damage_GroundFire"
}
