class Config_EquipmentUpgrade extends Config_Base
	config(ZedternalReborn);

var config int MODEVERSION;

struct S_EquipmentUpgrade
{
	var string EquipmentPath;
	var int BasePrice;
	var int MaxPrice;
	var int MaxLevel;
};

var config array<S_EquipmentUpgrade> EquipmentUpgrade_EquipmentUpgrades;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.default.currentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.default.currentVersion;
		static.StaticSaveConfig();
	}
}

defaultproperties
{
}
