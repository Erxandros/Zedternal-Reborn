class WMUpgrade_Weapon_Damage_Clot extends WMUpgrade_Weapon
	abstract;

var float Damage;

// Only SWAT weapons are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	local array< class<KFPerk> > KFPArray;

	KFPArray = KFW.static.GetAssociatedPerkClasses();
	if (KFPArray.Find(class'KFGame.KFPerk_SWAT') != INDEX_NONE)
		return True;

	return False;
}

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (MyKFPM != None && KFPawn_ZedClot(MyKFPM) != None)
		InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);
}

defaultproperties
{
	Damage=0.5f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Weapon_Damage_Clot"
	WeaponBonus=(baseValue=0, incValue=50, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_Damage_Clot"
}
