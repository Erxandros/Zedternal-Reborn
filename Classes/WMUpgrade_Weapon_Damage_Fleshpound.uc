class WMUpgrade_Weapon_Damage_Fleshpound extends WMUpgrade_Weapon
	abstract;

var float Damage;

// Only Demolitionist weapons and microwave gun are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	local array< class<KFPerk> > KFPArray;

	KFPArray = KFW.static.GetAssociatedPerkClasses();
	if (KFPArray.Find(class'KFGame.KFPerk_Demolitionist') != INDEX_NONE)
		return True;
	if (class<KFWeap_Beam_Microwave>(KFW) != None)
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

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Weapon_Damage_Fleshpound"
	WeaponBonus=(baseValue=0, incValue=20, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_Damage_Fleshpound"
}
