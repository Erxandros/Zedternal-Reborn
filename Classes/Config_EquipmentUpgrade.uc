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
		default.EquipmentUpgrade_EquipmentUpgrades.length = 3;

		default.EquipmentUpgrade_EquipmentUpgrades[0].EquipmentPath = "ZedternalReborn.WMUpgrade_Equipment_FallCompensatorBoots";
		default.EquipmentUpgrade_EquipmentUpgrades[0].BasePrice = 400;
		default.EquipmentUpgrade_EquipmentUpgrades[0].MaxPrice = 800;
		default.EquipmentUpgrade_EquipmentUpgrades[0].MaxLevel = 2;

		default.EquipmentUpgrade_EquipmentUpgrades[1].EquipmentPath = "ZedternalReborn.WMUpgrade_Equipment_GasMask";
		default.EquipmentUpgrade_EquipmentUpgrades[1].BasePrice = 1250;
		default.EquipmentUpgrade_EquipmentUpgrades[1].MaxPrice = 0;
		default.EquipmentUpgrade_EquipmentUpgrades[1].MaxLevel = 1;

		default.EquipmentUpgrade_EquipmentUpgrades[2].EquipmentPath = "ZedternalReborn.WMUpgrade_Equipment_NightVision";
		default.EquipmentUpgrade_EquipmentUpgrades[2].BasePrice = 250;
		default.EquipmentUpgrade_EquipmentUpgrades[2].MaxPrice = 0;
		default.EquipmentUpgrade_EquipmentUpgrades[2].MaxLevel = 1;
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