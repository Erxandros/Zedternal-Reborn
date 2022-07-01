class WMUpgrade_Weapon_Damage_Headshot extends WMUpgrade_Weapon
	abstract;

var float Damage;

// Commando, Gunslinger, Sharpshooter, and SWAT are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	local array< class<KFPerk> > KFPArray;

	if (class<KFWeap_ThrownBase>(KFW) != None)
		return False;
	if (KFW.default.bIsBackupWeapon)
		return True;

	KFPArray = KFW.static.GetAssociatedPerkClasses();
	if (KFPArray.Find(class'KFGame.KFPerk_Commando') != INDEX_NONE)
		return True;
	if (KFPArray.Find(class'KFGame.KFPerk_Gunslinger') != INDEX_NONE)
		return True;
	if (KFPArray.Find(class'KFGame.KFPerk_Sharpshooter') != INDEX_NONE)
		return True;
	if (KFPArray.Find(class'KFGame.KFPerk_SWAT') != INDEX_NONE)
		return True;

	return False;
}

static function ModifyDamageGiven(out int InDamage, int DefaultDamage, int upgLevel, optional Actor DamageCauser, optional KFPawn_Monster MyKFPM, optional KFPlayerController DamageInstigator, optional class<KFDamageType> DamageType, optional int HitZoneIdx, optional KFWeapon MyKFW)
{
	if (HitZoneIdx == HZI_HEAD)
		InDamage += Round(float(DefaultDamage) * default.Damage * upgLevel);
}

defaultproperties
{
	Damage=0.15f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Weapon_Damage_Headshot"
	WeaponBonus=(baseValue=0, incValue=15, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_Damage_Headshot"
}
