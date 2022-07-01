class WMUpgrade_Weapon_TightChoke extends WMUpgrade_Weapon
	abstract;

var float Spread;

// Any weapon with more than one pellet per shot is compatible
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	if (KFW.default.NumPellets[KFW.const.DEFAULT_FIREMODE] > 1)
		return True;
	if (KFW.default.NumPellets[KFW.const.ALTFIRE_FIREMODE] > 1)
		return True;
	if (KFW.default.NumPellets[KFW.const.CUSTOM_FIREMODE] > 1)
		return True;

	return False;
}

static simulated function ModifyTightChoke(out float InTight, float DefaultTight, int upgLevel, KFWeapon KFW, KFPawn OwnerPawn)
{
	InTight -= default.Spread * upgLevel;
}

defaultproperties
{
	Spread=0.2f

	bShouldLocalize=True
	UpgradeName="ZedternalReborn.WMUpgrade_Weapon_TightChoke"
	WeaponBonus=(baseValue=0, incValue=20, maxValue=-1)

	Name="Default__WMUpgrade_Weapon_TightChoke"
}
