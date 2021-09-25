class Config_WeaponUpgradeOptions extends Config_Common
	config(ZedternalReborn_Upgrades);

var config int MODEVERSION;

var config int WeaponUpgrade_PriceUnit;
var config float WeaponUpgrade_PriceFactor;
var config int WeaponUpgrade_NumberUpgradePerWeapon;
var config int WeaponUpgrade_MaxLevel;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.WeaponUpgrade_PriceUnit = 50;
		default.WeaponUpgrade_PriceFactor = 0.15f;
		default.WeaponUpgrade_NumberUpgradePerWeapon = 3;
		default.WeaponUpgrade_MaxLevel = 3;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

static function CheckBasicConfigValues()
{
	if (default.WeaponUpgrade_PriceUnit < 0)
	{
		LogBadConfigMessage("WeaponUpgrade_PriceUnit",
			string(default.WeaponUpgrade_PriceUnit),
			"0", "0 dosh, free", "value >= 0");
		default.WeaponUpgrade_PriceUnit = 0;
	}

	if (default.WeaponUpgrade_PriceFactor < 0.0f)
	{
		LogBadConfigMessage("WeaponUpgrade_PriceFactor",
			string(default.WeaponUpgrade_PriceFactor),
			"0.0", "0% of base weapon price", "value >= 0.0");
		default.WeaponUpgrade_PriceFactor = 0.0f;
	}

	if (default.WeaponUpgrade_NumberUpgradePerWeapon < 0)
	{
		LogBadConfigMessage("WeaponUpgrade_NumberUpgradePerWeapon",
			string(default.WeaponUpgrade_NumberUpgradePerWeapon),
			"0", "0 upgrades, disabled", "value >= 0");
		default.WeaponUpgrade_NumberUpgradePerWeapon = 0;
	}

	if (default.WeaponUpgrade_MaxLevel < 1)
	{
		LogBadConfigMessage("WeaponUpgrade_MaxLevel",
			string(default.WeaponUpgrade_MaxLevel),
			"1", "1 level", "value >= 1");
		default.WeaponUpgrade_MaxLevel = 1;
	}
}

defaultproperties
{
	Name="Default__Config_WeaponUpgradeOptions"
}
