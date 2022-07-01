class WMUpgrade_Weapon_SwitchSpeed extends WMUpgrade_Weapon
	abstract;

var float Speed;

// Medic and Gunslinger weapons are compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	local array< class<KFPerk> > KFPArray;

	KFPArray = KFW.static.GetAssociatedPerkClasses();
	if (KFPArray.Find(class'KFGame.KFPerk_FieldMedic') != INDEX_NONE)
		return True;
	if (KFPArray.Find(class'KFGame.KFPerk_Gunslinger') != INDEX_NONE)
		return True;

	return False;
}

static simulated function ModifyWeaponSwitchTime(out float InSwitchTime, float DefaultSwitchTime, int upgLevel, KFWeapon KFW)
{
	InSwitchTime = DefaultSwitchTime / (DefaultSwitchTime / InSwitchTime + default.Speed * upgLevel);
}

defaultproperties
{
	Speed=0.5f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Weapon_SwitchSpeed"
	WeaponBonus=(baseValue=0, incValue=50, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_SwitchSpeed"
}
