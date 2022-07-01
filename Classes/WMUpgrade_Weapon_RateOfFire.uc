class WMUpgrade_Weapon_RateOfFire extends WMUpgrade_Weapon
	abstract;

var float RateOfFire;

// Commando, Medic, Gunslinger, Sharpshooter, Support, and SWAT weapons are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	local array< class<KFPerk> > KFPArray;

	if (KFW.default.bIsBackupWeapon)
		return True;

	KFPArray = KFW.static.GetAssociatedPerkClasses();
	if (KFPArray.Find(class'KFGame.KFPerk_Commando') != INDEX_NONE)
		return True;
	if (KFPArray.Find(class'KFGame.KFPerk_FieldMedic') != INDEX_NONE)
		return True;
	if (KFPArray.Find(class'KFGame.KFPerk_Gunslinger') != INDEX_NONE)
		return True;
	if (KFPArray.Find(class'KFGame.KFPerk_Sharpshooter') != INDEX_NONE)
		return True;
	if (KFPArray.Find(class'KFGame.KFPerk_Support') != INDEX_NONE)
		return True;
	if (KFPArray.Find(class'KFGame.KFPerk_SWAT') != INDEX_NONE)
		return True;

	return False;
}

static simulated function ModifyRateOfFire(out float InRate, float DefaultRate, int upgLevel, KFWeapon KFW)
{
	InRate = DefaultRate / (DefaultRate / InRate + default.RateOfFire * upgLevel);
}

defaultproperties
{
	RateOfFire=0.15f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Weapon_RateOfFire"
	WeaponBonus=(baseValue=0, incValue=15, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_RateOfFire"
}
