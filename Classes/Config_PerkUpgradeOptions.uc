class Config_PerkUpgradeOptions extends Config_Common
	config(ZedternalReborn_Upgrades);

var config int MODEVERSION;

var config int PerkUpgrade_AvailablePerks;
var config array<int> PerkUpgrade_Price;

static function UpdateConfig()
{
	if (default.MODEVERSION < 1)
	{
		default.PerkUpgrade_AvailablePerks = 10;

		default.PerkUpgrade_Price[0] = 500;
		default.PerkUpgrade_Price[1] = 600;
		default.PerkUpgrade_Price[2] = 750;
		default.PerkUpgrade_Price[3] = 1000;
		default.PerkUpgrade_Price[4] = 1250;
		default.PerkUpgrade_Price[5] = 1500;
	}

	if (default.MODEVERSION < class'ZedternalReborn.Config_Base'.const.CurrentVersion)
	{
		default.MODEVERSION = class'ZedternalReborn.Config_Base'.const.CurrentVersion;
		static.StaticSaveConfig();
	}
}

static function CheckBasicConfigValues()
{
	local int i;

	if (default.PerkUpgrade_AvailablePerks < 0)
	{
		LogBadConfigMessage("PerkUpgrade_AvailablePerks",
			string(default.PerkUpgrade_AvailablePerks),
			"0", "0 perks, all perks disabled", "value >= 0");
		default.PerkUpgrade_AvailablePerks = 0;
	}

	for (i = 0; i < default.PerkUpgrade_Price.Length; ++i)
	{
		if (default.PerkUpgrade_Price[i] < 0)
		{
			LogBadConfigMessage("PerkUpgrade_Price - Line" @ string(i + 1),
				string(default.PerkUpgrade_Price[i]),
				"0", "0 dosh, free", "value >= 0");
			default.PerkUpgrade_Price[i] = 0;
		}
	}
}

defaultproperties
{
	Name="Default__Config_PerkUpgradeOptions"
}
