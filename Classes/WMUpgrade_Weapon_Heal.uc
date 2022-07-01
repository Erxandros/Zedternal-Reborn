class WMUpgrade_Weapon_Heal extends WMUpgrade_Weapon
	abstract;

var float Heal;

// Only Medic weapons are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	local array< class<KFPerk> > KFPArray;

	KFPArray = KFW.static.GetAssociatedPerkClasses();
	if (KFPArray.Find(class'KFGame.KFPerk_FieldMedic') != INDEX_NONE)
		return True;

	return False;
}

static function ModifyHealAmount(out float InHealAmount, float DefaultHealAmount, int upgLevel)
{
	InHealAmount += DefaultHealAmount * default.Heal * upgLevel;
}

defaultproperties
{
	Heal=0.2f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Weapon_Heal"
	WeaponBonus=(baseValue=0, incValue=20, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_Heal"
}
