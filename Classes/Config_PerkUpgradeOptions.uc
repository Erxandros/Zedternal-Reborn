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

	for (i = 0; i < default.PerkUpgrade_Price.Length; ++i)
	{
		if (default.PerkUpgrade_Price[i] < 0)
		{
			`log("ZR Config: PerkUpgrade_Price for perk level" @ (i + 1) @ "is set to" @ default.PerkUpgrade_Price[i]
				@"which is not supported. Setting the price to 0 (free) temporarily."
				@"Please change the value in the config to a value greater than or equal to 0.");
			default.PerkUpgrade_Price[i] = 0;
		}
	}

	if (default.PerkUpgrade_AvailablePerks < 0)
	{
		`log("ZR Config: PerkUpgrade_AvailablePerks is set to" @ default.PerkUpgrade_AvailablePerks
			@"which is not supported. Setting the number to 0 (no perks) temporarily."
			@"Please change the value in the config to a value greater than or equal to 0.");
		default.PerkUpgrade_AvailablePerks = 0;
	}
}

defaultproperties
{
	Name="Default__Config_PerkUpgradeOptions"
}
