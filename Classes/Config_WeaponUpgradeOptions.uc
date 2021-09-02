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
		`log("ZR Config: WeaponUpgrade_PriceUnit is set to" @ default.WeaponUpgrade_PriceUnit
			@"which is not supported. Setting the price unit to 0 (free) temporarily."
			@"Please change the value in the config to a value greater than or equal to 0.");
		default.WeaponUpgrade_PriceUnit = 0;
	}

	if (default.WeaponUpgrade_PriceFactor < 0.0f)
	{
		`log("ZR Config: WeaponUpgrade_PriceFactor is set to" @ default.WeaponUpgrade_PriceFactor
			@"which is not supported. Setting the price factor to 0.0 (0% increase) temporarily."
			@"Please change the value in the config to a value greater than or equal to 0.0.");
		default.WeaponUpgrade_PriceFactor = 0.0f;
	}

	if (default.WeaponUpgrade_NumberUpgradePerWeapon < 0)
	{
		`log("ZR Config: WeaponUpgrade_NumberUpgradePerWeapon is set to" @ default.WeaponUpgrade_NumberUpgradePerWeapon
			@"which is not supported. Setting the number of upgrades to 0 (no upgrades) temporarily."
			@"Please change the value in the config to a value greater than or equal to 0.");
		default.WeaponUpgrade_NumberUpgradePerWeapon = 0;
	}

	if (default.WeaponUpgrade_MaxLevel < 1)
	{
		`log("ZR Config: WeaponUpgrade_MaxLevel is set to" @ default.WeaponUpgrade_MaxLevel
			@"which is not supported. Setting the max level to 1 (only one level) temporarily."
			@"Please change the value in the config to a value greater than or equal to 1.");
		default.WeaponUpgrade_MaxLevel = 1;
	}
}

defaultproperties
{
	Name="Default__Config_WeaponUpgradeOptions"
}
