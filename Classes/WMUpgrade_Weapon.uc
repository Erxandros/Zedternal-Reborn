class WMUpgrade_Weapon extends WMUpgrade
	abstract;

struct SWeaponBonus
{
	var int baseValue;
	var int incValue;
	var int maxValue;
};
var SWeaponBonus WeaponBonus;

// return if this upgrade is compatible with a weapon
static function bool IsUpgradeCompatible(class<KFWeapon> KFW)
{
	return True;
}

// return bonus for description
static function string GetBonusValue(int Level)
{
	if (default.WeaponBonus.maxValue == -1)
		return string(default.WeaponBonus.baseValue + default.WeaponBonus.incValue * Level);
	else
		return string(Min(default.WeaponBonus.baseValue + default.WeaponBonus.incValue * Level, default.WeaponBonus.maxValue));
}

defaultproperties
{
	upgradeName="default"
	upgradeDescription(0)="default"
	upgradeIcon(0)=Texture2D'CHR_Cosmetics_Item_TEX.3DGlasses.3DGlasses_Color02'

	Name="Default__WMUpgrade_Weapon"
}
