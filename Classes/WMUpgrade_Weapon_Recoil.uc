class WMUpgrade_Weapon_Recoil extends WMUpgrade_Weapon
	abstract;

var float Recoil;

// Commando, Medic, Gunslinger, Sharpshooter, and SWAT weapons are compatible
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
	if (KFPArray.Find(class'KFGame.KFPerk_FieldMedic') != INDEX_NONE)
		return True;
	if (KFPArray.Find(class'KFGame.KFPerk_Gunslinger') != INDEX_NONE)
		return True;
	if (KFPArray.Find(class'KFGame.KFPerk_Sharpshooter') != INDEX_NONE)
		return True;
	if (KFPArray.Find(class'KFGame.KFPerk_SWAT') != INDEX_NONE)
		return True;

	return False;
}

static simulated function ModifyRecoil(out float InRecoilModifier, float DefaultRecoilModifier, int upgLevel, KFWeapon KFW)
{
	InRecoilModifier -= DefaultRecoilModifier * default.Recoil * upgLevel;
}

defaultproperties
{
	Recoil=0.2f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Weapon_Recoil"
	WeaponBonus=(baseValue=0, incValue=20, maxValue=95)

	Name="Default__WMUpgrade_Weapon_Recoil"
}
