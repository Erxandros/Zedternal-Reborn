class Config_WeaponUpgradeOptions extends Config_Common
	config(ZedternalReborn_Upgrades);

var config int MODEVERSION;

var config int WeaponUpgrade_NumberUpgradePerWeapon;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.WeaponUpgrade_NumberUpgradePerWeapon = 3;
	}

	if (default.MODEVERSION < 15)
	{
		if (default.WeaponUpgrade_NumberUpgradePerWeapon == 3)
			default.WeaponUpgrade_NumberUpgradePerWeapon = 5;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

static function CheckBasicConfigValues()
{
	if (default.WeaponUpgrade_NumberUpgradePerWeapon < 0)
	{
		LogBadConfigMessage("WeaponUpgrade_NumberUpgradePerWeapon",
			string(default.WeaponUpgrade_NumberUpgradePerWeapon),
			"0", "0 upgrades, disabled", "value >= 0");
		default.WeaponUpgrade_NumberUpgradePerWeapon = 0;
	}
}

defaultproperties
{
	Name="Default__Config_WeaponUpgradeOptions"
}
